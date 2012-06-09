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
package org.springextensions.actionscript.objects.propertyeditors {

  /**
   * Converts boolean string values (true or false) to a typed
   * Boolean value.
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class BooleanPropertyEditor extends AbstractPropertyEditor {

    private static const VALUE_TRUE:String = "true";
    private static const VALUE_FALSE:String = "false";

    /**
     * Creates a new BooleanPropertyEditor.
     */
    public function BooleanPropertyEditor() {
      super(this);
    }

    /**
     * @private
     */
    override public function set text(value:String):void {
      if (value.toLowerCase() == VALUE_TRUE) {
        this.value = true;
      }
      else if (value.toLowerCase() == VALUE_FALSE) {
        this.value = false;
      }
    }
  }
}
