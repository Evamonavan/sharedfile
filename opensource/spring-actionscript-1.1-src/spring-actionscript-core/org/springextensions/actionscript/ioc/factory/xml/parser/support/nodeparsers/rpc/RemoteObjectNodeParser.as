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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.rpc {
	
	import mx.rpc.remoting.RemoteObject;
	
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * RemoteObject node parser.
	 * @docref xml-schema-based-configuration.html#the_rpc_schema
	 * @author Christophe Herreman
	 */
	public class RemoteObjectNodeParser extends AbstractServiceNodeParser {
		
		public static const CONCURRENCY_ATTR:String = "concurrency";
		
		public static const ENDPOINT_ATTR:String = "endpoint";
		
		public static const MAKE_OBJECTS_BINDABLE_ATTR:String = "make-objects-bindable";
		
		public static const SHOW_BUSY_CURSOR_ATTR:String = "show-busy-cursor";
		
		public static const SOURCE_ATTR:String = "source";
		
		/**
		 * Creates a new RemoteObjectNodeParser
		 */
		public function RemoteObjectNodeParser() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = IObjectDefinition(super.parseInternal(node, context));
			
			result.className = ClassUtils.getFullyQualifiedName(RemoteObject, true);
			
			ParsingUtils.mapProperties(result, node, CONCURRENCY_ATTR, ENDPOINT_ATTR, MAKE_OBJECTS_BINDABLE_ATTR, SHOW_BUSY_CURSOR_ATTR, SOURCE_ATTR);
			
			return result;
		}
	}
}