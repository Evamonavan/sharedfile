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
package org.springextensions.actionscript.module {

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration that determines how an application context treats loaded modules.
	 * @author Roland Zwaga
	 */
	public final class ModulePolicy {

		/**
		 * Modules will be autowired by the application context.
		 */
		public static const AUTOWIRE:ModulePolicy = new ModulePolicy(AUTOWIRE_NAME);
		/**
		 * Modules will be ignored by the application context.
		 */
		public static const IGNORE:ModulePolicy = new ModulePolicy(IGNORE_NAME);

		private static const AUTOWIRE_NAME:String = "autowireModule";
		private static const IGNORE_NAME:String = "ignoreModule";

		private static var _enumCreated:Boolean = false;

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>ModulePolicy</code> instance.
		 * @param name The string representation of the enum
		 */
		public function ModulePolicy(name:String) {
			Assert.state(!_enumCreated, "The ModulePolicy enum has already been created.");
			_name = name;
		}

		/**
		 *
		 */
		public static function fromName(name:String):ModulePolicy {
			var result:ModulePolicy;

			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case AUTOWIRE_NAME:
					result = AUTOWIRE;
					break;
				case IGNORE_NAME:
					result = IGNORE;
					break;
				default:
					result = AUTOWIRE;
			}
			return result;
		}

		/**
		 * Returns the name of the scope.
		 *
		 * @returns the name of the scope
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * Returns a string representation of the current <code>ModulePolicy</code>
		 */
		public function toString():String {
			return _name;
		}

	}
}