package com.clementdauvent.admin.utils
{
	import flash.external.ExternalInterface;
	
	/**
	 * <p>Logger tracing output in consoles both in Flash and in the browser.</p>
	 */
	public class Logger
	{
		/**
		 * @public	Prints output.
		 * @param	parameters (rest)	Params to print.
		 * @return	void
		 */
		public static function print(...parameters):void
		{
			if (parameters) {
				trace(parameters);
				if (ExternalInterface.available) {
					var output:String = parameters.join();
					ExternalInterface.call('console.log', output);
				}
			}
		}
	}
}