package away3dlite.materials
{
	import flash.events.*;
	import flash.display.*;
	
	/**
	 * Base material class.
	 */	
	public class Material extends EventDispatcher
	{
		private const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
		private var _debug:Boolean = false;
		/** @private */
		protected var _graphicsStroke:GraphicsStroke = new GraphicsStroke();
		/** @private */
		protected var _graphicsBitmapFill:GraphicsBitmapFill = new GraphicsBitmapFill();
		/** @private */
		protected var _graphicsEndFill:GraphicsEndFill = new GraphicsEndFill();
		/** @private */
		protected var _triangles:GraphicsTrianglePath;
		/** @private */
		public var graphicsData:Vector.<IGraphicsData>;
		/** @private */
		public var trianglesIndex:int;
		
		/**
		 * Switches on the debug outlines around each face drawn with the material. Defaults to false.
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		public function set debug(val:Boolean):void
		{
			if (_debug == val)
				return;
				
			_debug = val;
			
			graphicsData.fixed = false;
			
			if(_debug) {
				graphicsData.shift();
				graphicsData.unshift(DEBUG_STROKE);
			} else {
				graphicsData.shift();
				graphicsData.unshift(_graphicsStroke);
			}
			
			graphicsData.fixed = true;
		}
        
		/**
		 * Creates a new <code>Material</code> object.
		 */
		public function Material() 
		{
		}
	}
}