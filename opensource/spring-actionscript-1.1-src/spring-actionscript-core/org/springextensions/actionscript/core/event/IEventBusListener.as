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
package org.springextensions.actionscript.core.event {
	
	import flash.events.Event;

	/**
	 * Interface to be implemented by all objects that want to register themselves as
	 * listeners to all events dispatched from the event bus.
	 * 
	 * @author Christophe Herreman
	 * @docref the_eventbus.html#eventbus_listening
	 */
	public interface IEventBusListener {
		
		/**
		 * Handles an <code>Event</code> received from the event bus.
		 * @param the specified <code>Event</code> received from the event bus.
		 */
		function onEvent(event:Event):void;
	
	}
}