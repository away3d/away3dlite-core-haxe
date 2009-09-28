package away3dlite.core.utils
{
    /**
     * Class for emmiting debuging messages, warnings and errors.
     */
    public class Debug
    {
    	/**
    	 * Determines whether debug mode is active. Defaults to false.
    	 */
        public static var active:Boolean = false;
        
        /**
         * Determines whether warning messages are treated as errors. Defaults to false.
         */
        public static var warningsAsErrors:Boolean = false;
		
		/**
		 * Traces a message to the output window.
		 * 
		 * @param message	The message to trace.
		 */
        public static function trace(message:Object):void
        {
        	if (active)
           		dotrace(message);
        }
		
		/**
		 * Traces a warning message to the output window. If the warningsAsErrors property is set to true, a runtime error is thrown.
		 * 
		 * @see #warningsAsErrors
		 * 
		 * @param message	The warning message to trace.
		 */
        public static function warning(message:Object):void
        {
            if (warningsAsErrors)
            {
                error(message);
                return;
            }
            trace("WARNING: "+message);
        }
		
		/**
		 * Traces an error message to the output window and throws a runtime error.
		 * 
		 * @param message	The error message to trace.
		 */
        public static function error(message:Object):void
        {
            trace("ERROR: "+message);
            throw new Error(message);
        }
    }
}

/**
 * @private
 */
function dotrace(message:Object):void
{
    trace(message);
}

