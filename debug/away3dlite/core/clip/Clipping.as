package away3dlite.core.clip
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * Dispatched when the clipping properties of a clipping object update.
	 * 
	 * @eventType away3dlite.events.ClipEvent
	 * 
	 * @see #maxX
	 * @see #minX
	 * @see #maxY
	 * @see #minY
	 * @see #maxZ
	 * @see #minZ
	 */
	[Event(name="clippingUpdated",type="away3dlite.events.ClippingEvent")]
	
	/**
	 * Dispatched when the clipping properties of a screenClipping object update.
	 * 
	 * @eventType away3dlite.events.ClipEvent
	 * 
	 * @see #maxX
	 * @see #minX
	 * @see #maxY
	 * @see #minY
	 * @see #maxZ
	 * @see #minZ
	 */
	[Event(name="screenUpdated",type="away3dlite.events.ClippingEvent")]
	
	use namespace arcane;
	
    /**
    * Base clipping class for no clipping.
    */
    public class Clipping extends EventDispatcher
    {
    	/** @private */
		arcane function setView(view:View3D):void
		{
			_view = view;
		}
    	/** @private */
		arcane function collectFaces(mesh:Mesh, faces:Vector.<Face>):void
        {
        	_faces = mesh._faces;
        	_screenVertices = mesh._screenVertices;
        	
        	var i:int = -1;
        	for each(_face in _faces)
        	    if (mesh.bothsides || _screenVertices[_face.x0]*(_screenVertices[_face.y2] - _screenVertices[_face.y1]) + _screenVertices[_face.x1]*(_screenVertices[_face.y0] - _screenVertices[_face.y2]) + _screenVertices[_face.x2]*(_screenVertices[_face.y1] - _screenVertices[_face.y0]) > 0)
        			faces[int(++i)] = _face;
        }
    	/** @private */
        arcane function screen(container:Sprite, _loaderWidth:Number, _loaderHeight:Number):Clipping
        {
        	if (!_clippingClone) {
        		_clippingClone = clone();
        		_clippingClone.addEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdate);
        	}
        	
			_stage = container.stage;
			
        	if (_stage.scaleMode == StageScaleMode.NO_SCALE) {
        		_stageWidth = _stage.stageWidth;
        		_stageHeight = _stage.stageHeight;
        	} else if (_stage.scaleMode == StageScaleMode.EXACT_FIT) {
        		_stageWidth = _loaderWidth;
        		_stageHeight = _loaderHeight;
        	} else if (_stage.scaleMode == StageScaleMode.SHOW_ALL) {
        		if (_stage.stageWidth/_loaderWidth < _stage.stageHeight/_loaderHeight) {
        			_stageWidth = _loaderWidth;
        			_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
        		} else {
        			_stageHeight = _loaderHeight;
        			_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
        		}
        	} else if (_stage.scaleMode == StageScaleMode.NO_BORDER) {
        		if (_stage.stageWidth/_loaderWidth > _stage.stageHeight/_loaderHeight) {
        			_stageWidth = _loaderWidth;
        			_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
        		} else {
        			_stageHeight = _loaderHeight;
        			_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
        		}
        	}
        	
        	if(_stage.align == StageAlign.TOP_LEFT) {
        		
            	_localPointTL.x = 0;
            	_localPointTL.y = 0;
                
                _localPointBR.x = _stageWidth;
            	_localPointBR.y = _stageHeight;
                
	        } else if(_stage.align == StageAlign.TOP_RIGHT) {
	        	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
            	_localPointTL.y = 0;
            	
            	_localPointBR.x = _loaderWidth;
            	_localPointBR.y = _stageHeight;
                
	        } else if(_stage.align==StageAlign.BOTTOM_LEFT) {
	        	
	        	_localPointTL.x = 0;
            	_localPointTL.y = _loaderHeight - _stageHeight;
            	
            	_localPointBR.x = _stageWidth;
            	_localPointBR.y = _loaderHeight;
            	
	        } else if(_stage.align==StageAlign.BOTTOM_RIGHT) {
	        	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
	        	_localPointTL.y = _loaderHeight - _stageHeight;
	        	
	        	_localPointBR.x = _loaderWidth;
	        	_localPointBR.y = _loaderHeight;
	        	
	        } else if(_stage.align == StageAlign.TOP) {
	        	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = 0;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _stageHeight;
            	
	        } else if(_stage.align==StageAlign.BOTTOM) {
            	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = _loaderHeight - _stageHeight;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _loaderHeight;
            	
	        } else if(_stage.align==StageAlign.LEFT) {
	        	
	        	_localPointTL.x = 0;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _stageWidth;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
            	
	        } else if(_stage.align==StageAlign.RIGHT) {
            	
	        	_localPointTL.x = _loaderWidth - _stageWidth;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _loaderWidth;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
            	
	        } else {
            	
	        	_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
            	_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
            	
            	_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
            	_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
        	}
        	
        	_globalPointTL = container.globalToLocal(_localPointTL);
        	_globalPointBR = container.globalToLocal(_localPointBR);
        	
			_miX = _globalPointTL.x;
            _miY = _globalPointTL.y;
            _maX = _globalPointBR.x;
            _maY = _globalPointBR.y;
            
            if (_minX > _miX)
            	_clippingClone.minX = _minX;
            else
            	_clippingClone.minX = _miX;
            
            if (_maxX < _maX)
            	_clippingClone.maxX = _maxX;
            else
            	_clippingClone.maxX = _maX;
            
            if (_minY > _miY)
            	_clippingClone.minY = _minY;
            else
            	_clippingClone.minY = _miY;
            
            if (_maxY < _maY)
            	_clippingClone.maxY = _maxY;
            else
            	_clippingClone.maxY = _maY;
            
            _clippingClone.minZ = _minZ;
            _clippingClone.maxZ = _maxZ;
            
            return _clippingClone;
        }
        
    	private var _clippingClone:Clipping;
    	private var _stage:Stage;
    	private var _stageWidth:Number;
    	private var _stageHeight:Number;
    	private var _localPointTL:Point = new Point(0, 0);
    	private var _localPointBR:Point = new Point(0, 0);
		private var _globalPointTL:Point = new Point(0, 0);
		private var _globalPointBR:Point = new Point(0, 0);
		private var _miX:Number;
		private var _miY:Number;
		private var _maX:Number;
		private var _maY:Number;
		private var _clippingupdated:ClippingEvent;
		private var _screenupdated:ClippingEvent;
        
    	protected var _view:View3D;
        protected var _face:Face;
        protected var _faces:Vector.<Face>;
        protected var _screenVertices:Vector.<Number>;
        protected var _uvtData:Vector.<Number>;
        protected var _index:int;
    	protected var _indexX:int;
    	protected var _indexY:int;
    	protected var _indexZ:int;
        protected var _screenVerticesCull:Vector.<int> = new Vector.<int>();
        protected var _cullCount:int;
		protected var _minX:Number = -100000;
		protected var _minY:Number = -100000;
		protected var _minZ:Number = -100000;
		protected var _maxX:Number = 100000;
		protected var _maxY:Number = 100000;
		protected var _maxZ:Number = 100000;
        
		private function onScreenUpdate(event:ClippingEvent):void
		{
			notifyScreenUpdate();
		}
		
        private function notifyClippingUpdate():void
        {
            if (!hasEventListener(ClippingEvent.CLIPPING_UPDATED))
                return;
			
            if (_clippingupdated == null)
                _clippingupdated = new ClippingEvent(ClippingEvent.CLIPPING_UPDATED, this);
                
            dispatchEvent(_clippingupdated);
        }
		
        private function notifyScreenUpdate():void
        {
            if (!hasEventListener(ClippingEvent.SCREEN_UPDATED))
                return;
			
            if (_screenupdated == null)
                _screenupdated = new ClippingEvent(ClippingEvent.SCREEN_UPDATED, this);
                
            dispatchEvent(_screenupdated);
        }
		
    	/**
    	 * Minimum allowed x value for primitives.
    	 */
    	public function get minX():Number
		{
			return _minX;
		}
		
		public function set minX(value:Number):void
		{
			if (_minX == value)
				return;
			
			_minX = value;
			
			notifyClippingUpdate();
		}
        
    	/**
    	 * Maximum allowed x value for primitives
    	 */
        public function get maxX():Number
		{
			return _maxX;
		}
		
		public function set maxX(value:Number):void
		{
			if (_maxX == value)
				return;
			
			_maxX = value;
			
			notifyClippingUpdate();
		}
		
    	/**
    	 * Minimum allowed y value for primitives
    	 */
        public function get minY():Number
		{
			return _minY;
		}
		
		public function set minY(value:Number):void
		{
			if (_minY == value)
				return;
			
			_minY = value;
			
			notifyClippingUpdate();
		}
    	    	
    	/**
    	 * Maximum allowed y value for primitives
    	 */
        public function get maxY():Number
		{
			return _maxY;
		}
		
		public function set maxY(value:Number):void
		{
			if (_maxY == value)
				return;
			
			_maxY = value;
			
			notifyClippingUpdate();
		}
		
    	/**
    	 * Minimum allowed z value for primitives
    	 */
        public function get minZ():Number
		{
			return _minZ;
		}
		
		public function set minZ(value:Number):void
		{
			if (_minZ == value)
				return;
			
			_minZ = value;
			
			notifyClippingUpdate();
		}
    	
    	/**
    	 * Maximum allowed z value for primitives
    	 */
        public function get maxZ():Number
		{
			return _maxZ;
		}
		
		public function set maxZ(value:Number):void
		{
			if (_maxZ == value)
				return;
			
			_maxZ = value;
			
			notifyClippingUpdate();
		}
        
		/**
		 * Creates a new <code>Clipping</code> object.
		 * 
		 * @param minX	Minimum allowed x value for primitives.
		 * @param maxX	Maximum allowed x value for primitives.
		 * @param minY	Minimum allowed y value for primitives.
		 * @param maxY	Maximum allowed y value for primitives.
		 * @param minZ	Minimum allowed z value for primitives.
		 * @param maxZ	Maximum allowed z value for primitives.
		 */
        public function Clipping(minX:Number = -10000, maxX:Number = 10000, minY:Number = -10000, maxY:Number = 10000, minZ:Number = -10000, maxZ:Number = 10000)
        {
        	super();
        	
        	_minX = minX;
        	_maxX = maxX;
        	_minY = minY;
        	_maxY = maxY;
        	_minZ = minZ;
        	_maxZ = maxZ;
        }
		
		/**
		 * Duplicates the clipping object's properties to another <code>Clipping</code> object
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Clipping</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
		public function clone(object:Clipping = null):Clipping
        {
        	var clipping:Clipping = object || new Clipping();
        	
        	clipping.minX = minX;
        	clipping.minY = minY;
        	clipping.minZ = minZ;
        	clipping.maxX = maxX;
        	clipping.maxY = maxY;
        	clipping.maxZ = maxZ;
        	
        	return clipping;
        }
        
        /**
		 * Used to trace the values of a clipping object.
		 * 
		 * @return		A string representation of the clipping object.
		 */
        public override function toString():String
        {
        	return "{minX:" + minX + " maxX:" + maxX + " minY:" + minY + " maxY:" + maxY + " minZ:" + minZ + " maxZ:" + maxZ + "}";
        }
    }
}