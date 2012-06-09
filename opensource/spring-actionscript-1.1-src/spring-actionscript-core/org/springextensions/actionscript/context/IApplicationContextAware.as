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
package org.springextensions.actionscript.context {

  /**
   * Interface to be implemented by any object that wishes to be notified
   * of the IApplicationContext that it runs in.
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   * @see org.springextensions.actionscript.context.support.ApplicationContextAwareProcessor ApplicationContextAwareProcessor
   * @docref container-documentation.html#knowing_who_you_are
   */
  public interface IApplicationContextAware {
	
	/**
	 * @private
	 */
	function get applicationContext():IApplicationContext;
    /**
     * Sets the IApplicationContext that this object runs in.
     * @param value the IApplicationContext that this object runs in
     */
    function set applicationContext(value:IApplicationContext):void;
  }
}
