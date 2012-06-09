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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.messaging {
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.AbstractObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.AttributeToPropertyMapping;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.ParsingUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 */
	public class ChannelNodeParser extends AbstractObjectDefinitionParser {
		
		public static const CONNECT_TIMEOUT_ATTR:String = "connect-timeout";
		
		public static const FAILOVER_URIS_ATTR:AttributeToPropertyMapping = new AttributeToPropertyMapping("failover-uris", "failoverURIs");
		
		public static const ID_ATTR:String = "id";
		
		public static const REQUEST_TIMEOUT_ATTR:String = "request-timeout";
		
		public static const URI_ATTR:String = "uri";
		
		/**
		 * Creates a new <code>ChannelNodeParser</code> instance.
		 */
		public function ChannelNodeParser() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			var result:IObjectDefinition = new ObjectDefinition("");
			
			mapProperties(result, node);
			
			return result;
		}
		
		protected function mapProperties(objectDefinition:IObjectDefinition, node:XML):void {
			ParsingUtils.mapProperties(objectDefinition, node, CONNECT_TIMEOUT_ATTR, ID_ATTR, REQUEST_TIMEOUT_ATTR, URI_ATTR);
			ParsingUtils.mapPropertiesArrays(objectDefinition, node, FAILOVER_URIS_ATTR);
		}
	}
}