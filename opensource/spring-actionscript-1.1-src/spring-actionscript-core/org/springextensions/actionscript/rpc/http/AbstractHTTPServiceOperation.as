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
package org.springextensions.actionscript.rpc.http {
	
	import mx.rpc.http.HTTPMultiService;
	import mx.rpc.http.HTTPService;
	
	import org.springextensions.actionscript.rpc.AbstractRPC;

	public class AbstractHTTPServiceOperation extends AbstractRPC {
		
		protected var httpService:HTTPMultiService;
		
		public function AbstractHTTPServiceOperation(httpService:HTTPMultiService,methodName:String, parameters:Array=null) {
			super(methodName, parameters);
			this.httpService = httpService;
		}
	}
}