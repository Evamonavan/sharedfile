package com.lhyx.utils
{
	import flash.filesystem.File;

	public final class FilePathEnum
	{
		/**
		 * This const value is application context XML configuration file path.
		 */		
		public static const APP_CONTEXT_FILE_PATH:String = "config-files" + File.separator +"applicationContext.xml";
		
		/**
		 * This const value is tree menu XML configuration file path.
		 */		
		public static const TREE_MENU_FILE_PATH:String = "config-files" + File.separator + "menuConfig.xml";
		
		public function FilePathEnum()
		{
		}
	}
}