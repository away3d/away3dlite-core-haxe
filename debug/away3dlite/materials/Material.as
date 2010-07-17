package away3dlite.materials
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.events.*;

	import flash.events.*;
	import flash.display.*;
	
	use namespace arcane;
    			
	 /**
	 * Dispatched when the material becomes visible in a view.
	 * 
	 * @eventType away3dlite.events.MaterialEvent
	 */
	[Event(name="materialActivated",type="away3dlite.events.MaterialEvent")]
    			
	 /**
	 * Dispatched when the material becomes invisible in a view.
	 * 
	 * @eventType away3dlite.events.MaterialEvent
	 */
	[Event(name="materialDeactivated",type="away3dlite.events.MaterialEvent")]
	
	/**
	 * Base material class.
	 */	
	public class Material extends EventDispatcher
	{
		/** @private */
		arcane var _id:Vector.<uint> = new Vector.<uint>();
		/** @private */
		arcane var _faceCount:Vector.<uint> = new Vector.<uint>();
		/** @private */
		arcane function notifyActivate(scene:Scene3D):void
		{
			if (!hasEventListener(MaterialEvent.MATERIAL_ACTIVATED))
                return;
			
            if (_materialactivated == null)
                _materialactivated = new MaterialEvent(MaterialEvent.MATERIAL_ACTIVATED, this);
                
            dispatchEvent(_materialactivated);
		}
		/** @private */
		arcane function notifyDeactivate(scene:Scene3D):void
		{
			if (!hasEventListener(MaterialEvent.MATERIAL_DEACTIVATED))
                return;
			
            if (_materialdeactivated == null)
                _materialdeactivated = new MaterialEvent(MaterialEvent.MATERIAL_DEACTIVATED, this);
                
            dispatchEvent(_materialdeactivated);
		}
		
		private const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
		private var _debug:Boolean = false;
		private var _materialactivated:MaterialEvent;
		private var _materialdeactivated:MaterialEvent;
		
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