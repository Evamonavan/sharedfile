/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.core.task.support {

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.command.CompositeCommand;
	import org.springextensions.actionscript.core.command.CompositeCommandKind;
	import org.springextensions.actionscript.core.command.GenericOperationCommand;
	import org.springextensions.actionscript.core.command.ICommand;
	import org.springextensions.actionscript.core.command.ICompositeCommand;
	import org.springextensions.actionscript.core.command.event.CompositeCommandEvent;
	import org.springextensions.actionscript.core.operation.AbstractOperation;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.OperationEvent;
	import org.springextensions.actionscript.core.task.IConditionProvider;
	import org.springextensions.actionscript.core.task.ICountProvider;
	import org.springextensions.actionscript.core.task.IForBlock;
	import org.springextensions.actionscript.core.task.IIfElseBlock;
	import org.springextensions.actionscript.core.task.IResetable;
	import org.springextensions.actionscript.core.task.ITask;
	import org.springextensions.actionscript.core.task.ITaskBlock;
	import org.springextensions.actionscript.core.task.IWhileBlock;
	import org.springextensions.actionscript.core.task.TaskFlowControlKind;
	import org.springextensions.actionscript.core.task.command.FunctionCommand;
	import org.springextensions.actionscript.core.task.command.PauseCommand;
	import org.springextensions.actionscript.core.task.command.TaskCommand;
	import org.springextensions.actionscript.core.task.command.TaskFlowControlCommand;
	import org.springextensions.actionscript.core.task.event.TaskEvent;
	import org.springextensions.actionscript.core.task.event.TaskFlowControlEvent;
	import org.springextensions.actionscript.ioc.IDisposable;

	/**
	 * @inheritDoc
	 */
	public class Task extends AbstractOperation implements ITask, IDisposable {

		/**
		 * Internal <code>Array</code> of the commands, tasks and controlflow objects that will be executed.
		 */
		protected var commandList:Array;
		/**
		 * Internal <code>Array</code> of the commands, tasks and controlflow objects that have been executed.
		 */
		protected var finishedCommandList:Array;
		/**
		 * The current <code>ICommand</code> instance that is being executed.
		 */
		protected var currentCommand:ICommand;

		private var _parent:ITask;

		private var _context:Object;

		/**
		 * @inheritDoc
		 */
		public function get context():Object {
			return _context;
		}

		/**
		 * @private
		 */
		public function set context(value:Object):void {
			_context = value;
		}

		/**
		 * @return An optional <code>ITask</code> instance whose controlflow the current <code>ITask</code> is part of.
		 */
		public function get parent():ITask {
			return _parent;
		}

		/**
		 * @private
		 */
		public function set parent(value:ITask):void {
			_parent = value;
		}

		/**
		 * Determines if the entire controlflow of the current <code>ITask</code> will be aborted if an error occurs.
		 * @deault true
		 */
		public var failOnFault:Boolean = true;

		/**
		 * Creates a new <code>Task</code> instance.
		 */
		public function Task() {
			super();
			initTask();
		}

		protected function initTask():void {
			commandList = [];
			_context = {};
		}

		/**
		 * Adds the specified <code>ICommand</code> instance to the control flow of the current <code>ITask</code>, if the specified
		 * <code>ICommand</code> is also an implementation of <code>ITask</code>, the current <code>ITask</code> will be set as its parent.
		 * @param command The specified <code>ICommand</code> instance.
		 */
		protected function addToCommandList(command:ICommand):void {
			commandList[commandList.length] = command;
			currentCommand = command;
			var task:ITask = (command as ITask);
			if (task != null) {
				task.parent = this;
			}
		}

		/**
		 * Adds a new <code>TaskCommand</code> with the specified <code>ComposeiteCommandKind</code> to the controlflow of the current <code>ITask</code>.
		 * @param kind The specified <code>ComposeiteCommandKind</code>
		 * @return The newly created <code>TaskCommand</code>
		 */
		protected function addTaskCommand(kind:CompositeCommandKind):CompositeCommand {
			var taskCommand:TaskCommand = new TaskCommand(kind);
			addToCommandList(taskCommand)
			return taskCommand;
		}

		/**
		 * Examines the current <code>ICommand</code> in the controlflow and based on that either adds the specified <code>ICommand</code>
		 * to the current <code>ICommand</code> or creates a new <code>TaskCommand</code> and adds it to this.
		 * @param command The specified <code>ICommand</code>.
		 * @param kind
		 * @return The current <code>ICommand</code> if it is an <code>ITaskBlock</code>, otherwise null.
		 */
		protected function addCommand(command:ICommand, kind:CompositeCommandKind):ITask {
			var compositeCommand:ICompositeCommand;
			var task:ITask;
			if (currentCommand != null) {
				task = currentCommand as ITask;
				if ((task != null) && (task is ITaskBlock) && (!ITaskBlock(task).isClosed)) {
					task.next(command);
					return task;
				} else {
					compositeCommand = currentCommand as ICompositeCommand;
					//the current command is an ICompositeCommand but not of the right kind, in other words
					//the control flow has switched from next() to and() or viceversa
					if ((compositeCommand != null) && (compositeCommand.kind != kind)) {
						compositeCommand = null;
					}
					if (compositeCommand == null) {
						compositeCommand = addTaskCommand(kind);
					}
					compositeCommand.addCommand(command);
				}
			} else {
				compositeCommand = addTaskCommand(kind);
				compositeCommand.addCommand(command);
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function next(item:Object, ... constructorArgs):ITask {
			Assert.notNull(item, "The item argument must not be null");

			var command:ICommand = (item is ICommand) ? ICommand(item) : GenericOperationCommand.createNew(Class(item), constructorArgs);
			var result:ITask = addCommand(command, CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function and(item:Object, ... constructorArgs):ITask {
			Assert.notNull(item, "The item argument must not be null");
			var command:ICommand = (item is ICommand) ? ICommand(item) : GenericOperationCommand.createNew(Class(item), constructorArgs);
			var result:ITask = addCommand(command, CompositeCommandKind.PARALLEL);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function if_(conditionProvider:IConditionProvider = null, ifElseBlock:IIfElseBlock = null):IIfElseBlock {
			ifElseBlock = (ifElseBlock != null) ? ifElseBlock : new IfElseBlock(conditionProvider);
			var cmd:ICommand = commandList[commandList.length - 1];
			if ((cmd is ICompositeCommand) || ((cmd is ITaskBlock) && (ITaskBlock(cmd).isClosed))) {
				addToCommandList(ifElseBlock);
			} else {
				addCommand(ifElseBlock, CompositeCommandKind.SEQUENCE);
			}
			return ifElseBlock;
		}

		/**
		 * @inheritDoc
		 */
		public function else_():IIfElseBlock {
			var result:IIfElseBlock;
			if (commandList.length > 0) {
				var ifElseBlock:IIfElseBlock = commandList[commandList.length - 1] as IIfElseBlock;
				if (ifElseBlock != null) {
					ifElseBlock.switchToElseBlock();
					result = ifElseBlock;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function while_(conditionProvider:IConditionProvider = null, whileBlock:IWhileBlock = null):IWhileBlock {
			whileBlock = (whileBlock != null) ? whileBlock : new WhileBlock(conditionProvider);
			var cmd:ICommand = commandList[commandList.length - 1];
			if ((cmd is ICompositeCommand) || ((cmd is ITaskBlock) && (ITaskBlock(cmd).isClosed))) {
				addToCommandList(whileBlock);
			} else {
				addCommand(whileBlock, CompositeCommandKind.SEQUENCE);
			}
			return whileBlock;
		}

		/**
		 * @inheritDoc
		 */
		public function for_(count:uint, countProvider:ICountProvider = null, forBlock:IForBlock = null):IForBlock {
			countProvider = ((countProvider == null) && (forBlock == null)) ? new CountProvider(count) : countProvider;
			forBlock = (forBlock != null) ? forBlock : new ForBlock(countProvider);
			var cmd:ICommand = (commandList.length > 0) ? commandList[commandList.length - 1] : null;
			if ((cmd is ICompositeCommand) || ((cmd is ITaskBlock) && (ITaskBlock(cmd).isClosed))) {
				addToCommandList(forBlock);
			} else {
				addCommand(forBlock, CompositeCommandKind.SEQUENCE);
			}
			return forBlock;
		}

		/**
		 * @inheritDoc
		 */
		public function end():ITask {
			if (commandList.length > 0) {
				var task:ITask = commandList[commandList.length - 1] as ITask;
				if ((task != null) && (task is ITaskBlock) && (ITaskBlock(task).isClosed == false)) {
					return task.end();
				}
			}
			return (this.parent != null) ? this.parent : this;
		}

		/**
		 * @inheritDoc
		 */
		public function break_():ITask {
			var result:ITask;
			result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.BREAK), CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function continue_():ITask {
			var result:ITask;
			result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.CONTINUE), CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function exit():ITask {
			var result:ITask;
			result = addCommand(new TaskFlowControlCommand(TaskFlowControlKind.EXIT), CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function pause(duration:uint, pauseCommand:ICommand = null):ITask {
			var result:ITask;
			pauseCommand = (pauseCommand == null) ? new PauseCommand(duration) : pauseCommand;
			result = addCommand(pauseCommand, CompositeCommandKind.SEQUENCE);
			return (result != null) ? result : this;
		}

		/**
		 * @inheritDoc
		 */
		public function execute():* {
			finishedCommandList = [];
			executeNextCommand();
		}

		protected function executeCommand(command:ICommand):void {
			currentCommand = command;
			if (command) {
				var async:IOperation = command as IOperation;
				addCommandListeners(async);
				dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, command);
				command.execute();
				if (async == null) {
					dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, command);
					executeNextCommand();
				}
			} else {
				completeExecution();
			}
		}

		protected function executeNextCommand():void {
			var cmd:ICommand = commandList.shift() as ICommand;
			if (cmd != null) {
				finishedCommandList[finishedCommandList.length] = cmd;
			}
			executeCommand(cmd);
		}

		protected function completeExecution():void {
			dispatchTaskEvent(TaskEvent.TASK_COMPLETE);
			dispatchCompleteEvent(null);
		}

		/**
		 * @inheritDoc
		 */
		public function reset(doHardReset:Boolean = false):ITask {
			if (doHardReset) {
				resetCommandList();
			} else {
				commandList[commandList.length] = new FunctionCommand(this.resetCommandList);
			}
			return this;
		}

		protected function resetCommandList():void {
			if (finishedCommandList != null) {
				for each (var cmd:ICommand in finishedCommandList) {
					if (cmd is IResetable) {
						IResetable(cmd).reset();
					} else if (cmd is ITask) {
						ITask(cmd).reset(true);
					}
				}
				commandList = finishedCommandList.concat(commandList);
			}
		}

		protected function onCommandResult(event:OperationEvent):void {
			if (event.target === currentCommand) {
				removeCommandListeners(event.target as IOperation);
				dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, event.target as ICommand);
				executeNextCommand();
			}
		}

		protected function onCommandFault(event:OperationEvent):void {
			if (event.target === currentCommand) {
				removeCommandListeners(event.target as IOperation);
				dispatchErrorEvent(event.target as ICommand);
				dispatchTaskEvent(TaskEvent.TASK_ERROR, event.target as ICommand);
				if (!failOnFault) {
					executeNextCommand();
				} else {
					currentCommand = null;
				}
			}
		}

		protected function addCommandListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.addCompleteListener(onCommandResult);
				asyncCommand.addErrorListener(onCommandFault);
				asyncCommand.addEventListener(TaskFlowControlEvent.BREAK, TaskFlowControlEvent_handler);
				asyncCommand.addEventListener(TaskFlowControlEvent.CONTINUE, TaskFlowControlEvent_handler);
				asyncCommand.addEventListener(TaskFlowControlEvent.EXIT, exit_handler);

				var compositeCommand:CompositeCommand = (asyncCommand as CompositeCommand);
				if (compositeCommand != null) {
					compositeCommand.addEventListener(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, redispatchCompositeCommand);
					compositeCommand.addEventListener(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, redispatchCompositeCommand);
				}

				var task:ITask = (asyncCommand as ITask);
				if (task != null) {
					task.addEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatchTaskEvent);
					task.addEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatchTaskEvent);
				}
			}
		}

		protected function removeCommandListeners(asyncCommand:IOperation):void {
			if (asyncCommand != null) {
				asyncCommand.removeCompleteListener(onCommandResult);
				asyncCommand.removeErrorListener(onCommandFault);
				asyncCommand.removeEventListener(TaskFlowControlEvent.BREAK, TaskFlowControlEvent_handler);
				asyncCommand.removeEventListener(TaskFlowControlEvent.CONTINUE, TaskFlowControlEvent_handler);
				asyncCommand.removeEventListener(TaskFlowControlEvent.EXIT, exit_handler);

				var compositeCommand:CompositeCommand = (asyncCommand as CompositeCommand);
				if (compositeCommand != null) {
					compositeCommand.removeEventListener(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, redispatchCompositeCommand);
					compositeCommand.removeEventListener(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, redispatchCompositeCommand);
				}

				var task:ITask = (asyncCommand as ITask);
				if (task != null) {
					task.removeEventListener(TaskEvent.BEFORE_EXECUTE_COMMAND, redispatchTaskEvent);
					task.removeEventListener(TaskEvent.AFTER_EXECUTE_COMMAND, redispatchTaskEvent);
				}
			}
		}

		protected function redispatchTaskEvent(event:TaskEvent):void {
			dispatchEvent(event.clone());
		}

		protected function TaskFlowControlEvent_handler(event:TaskFlowControlEvent):void {
			dispatchEvent(event.clone());
		}

		protected function exit_handler(event:TaskFlowControlEvent):void {
			TaskFlowControlEvent_handler(event);
			dispatchTaskEvent(TaskEvent.TASK_ABORTED);
		}

		protected function redispatchCompositeCommand(event:CompositeCommandEvent):void {
			switch (event.type) {
				case CompositeCommandEvent.BEFORE_EXECUTE_COMMAND:
					dispatchTaskEvent(TaskEvent.BEFORE_EXECUTE_COMMAND, event.command);
					break;
				case CompositeCommandEvent.AFTER_EXECUTE_COMMAND:
					dispatchTaskEvent(TaskEvent.AFTER_EXECUTE_COMMAND, event.command);
					break;
				default:
					break;
			}
		}

		protected function dispatchTaskEvent(eventType:String, command:ICommand = null):void {
			dispatchEvent(new TaskEvent(eventType, this, command));
		}

		private var _isDisposed:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				commandList = null;
				_context = null;
				finishedCommandList = null;
				_parent = null;
				_isDisposed = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}

	}
}