package com.lhyx.presentermanager
{
	import com.lhyx.components.OperationArea;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.TextArea;

	public class OperationAreaPM
	{
		private var _operationArea:OperationArea;
		private var _fileBrowserPM:FileBrowserPM;
		
		public function OperationAreaPM()
		{
		}

		public function get operationArea():OperationArea
		{
			return _operationArea;
		}

		public function set operationArea(value:OperationArea):void
		{
			_operationArea = value;
			this._operationArea.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
		}

		public function set fileBrowserPM(value:FileBrowserPM):void
		{
			_fileBrowserPM = value;
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			try
			{
				if (this._fileBrowserPM && this._fileBrowserPM.fileBrowser) 
				{
					this._operationArea.addElement(this._fileBrowserPM.fileBrowser);
				}
				
				if (this._operationArea.logLabel) 
				{
					this._operationArea.addElement(this._operationArea.logLabel);
				}
				
				if (this._operationArea.logTextArea) 
				{
					this._operationArea.addElement(this._operationArea.logTextArea);
				}
				this.initViewEvent();
			} 
			catch(error:Error) 
			{
				Alert.show(error.toString());
			}
		}
		
		private function initViewEvent():void
		{
			this._fileBrowserPM.fileBrowser.clearButton.addEventListener(MouseEvent.CLICK,function(clearEvent:MouseEvent):void
			{
				_fileBrowserPM.fileBrowser.inputTextInput.text = "";
				_fileBrowserPM.fileBrowser.outputTextInput.text = "";
				_operationArea.logTextArea.text += "清除文件输入、输出框内容！\n";
				_operationArea.logTextArea.validateNow();
				_operationArea.logTextArea.scroller.verticalScrollBar.value = _operationArea.logTextArea.scroller.verticalScrollBar.maximum;
			});
		}
	}
}