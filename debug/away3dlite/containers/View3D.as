package away3dlite.containers {
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.core.base.*;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;
	import away3dlite.events.*;
	import away3dlite.materials.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	
	use namespace arcane;
	
	/**
	 * Sprite container used for storing camera, scene, renderer and clipping references, and resolving mouse events
	 */
	public class View3D extends Sprite
	{
		/** @private */
		arcane var _totalFaces:int;
		/** @private */
		arcane var _totalObjects:int;
		/** @private */
		arcane var _renderedFaces:int;
		/** @private */
		arcane var _renderedObjects:int;
		/** @private */
        arcane function get screenClipping():Clipping
        {
        	if (_screenClippingDirty) {
        		updateScreenClipping();
        		_screenClippingDirty = false;
        		
        		return _screenClipping = _clipping.screen(this, _loaderWidth, _loaderHeight);
        	}
        	
        	return _screenClipping;
        }
        
        private const VERSION:String = "1";
        private const REVISION:String = "0.2";
        private const APPLICATION_NAME:String = "Away3D.com";
        
        private var _customContextMenu:ContextMenu;
        private var _menu0:ContextMenuItem;
        private var _menu1:ContextMenuItem;
        private var _sourceURL:String;
		private var _renderer:Renderer;
		private var _camera:Camera3D;
		private var _scene:Scene3D;
        private var _clipping:Clipping;
        private var _screenClipping:Clipping;
        private var _loaderWidth:Number;
		private var _loaderHeight:Number;
		private var _loaderDirty:Boolean;
        private var _screenClippingDirty:Boolean;
        private var _viewZero:Point = new Point();
		private var _x:Number;
		private var _y:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _mouseIsOverView:Boolean;
        private var _material:Material;
        private var _object:Object3D;
        private var _uvt:Vector3D;
        private var _scenePosition:Vector3D;
        private var _mouseObject:Object3D;
        private var _mouseMaterial:Material;
        private var _lastmove_mouseX:Number;
        private var _lastmove_mouseY:Number;
		private var _face:Face;
        
		private function onClippingUpdated(e:ClippingEvent):void
		{
			_screenClippingDirty = true;
		}
		
		private function onScreenUpdated(e:ClippingEvent):void
		{
			
		}
		
		private function onViewSource(e:ContextMenuEvent):void 
		{
			var request:URLRequest = new URLRequest(_sourceURL);
			try {
				navigateToURL(request, "_blank");
			} catch (error:Error) {
				
			}
		}
		
        private function onVisitWebsite(event:ContextMenuEvent):void
        {
			var url:String = "http://www.away3d.com";
            var request:URLRequest = new URLRequest(url);
            try {
                navigateToURL(request);
            } catch (error:Error) {
                
            }
        }
        
        private function updateContextMenu():void
        {
        	_customContextMenu.customItems = _sourceURL? [_menu0, _menu1] : [_menu1];
        	contextMenu = _customContextMenu;
        }
        
		private function updateScreenClipping():void
		{
        	//check for loaderInfo update
        	try {
        		_loaderWidth = loaderInfo.width;
        		_loaderHeight = loaderInfo.height;
        		if (_loaderDirty) {
        			_loaderDirty = false;
        			_screenClippingDirty = true;
        		}
        	} catch (error:Error) {
        		_loaderDirty = true;
        		_loaderWidth = stage.stageWidth;
        		_loaderHeight = stage.stageHeight;
        	}
        	
			//check for global view movement
        	_viewZero.x = 0;
        	_viewZero.y = 0;
        	_viewZero = localToGlobal(_viewZero);
        	
			if (_x != _viewZero.x || _y != _viewZero.y || stage.scaleMode != StageScaleMode.NO_SCALE && (_stageWidth != stage.stageWidth || _stageHeight != stage.stageHeight)) {
        		_x = _viewZero.x;
        		_y = _viewZero.y;
        		_stageWidth = stage.stageWidth;
        		_stageHeight = stage.stageHeight;
        		_screenClippingDirty = true;
   			}
		}
		
		private function onStageResized(event:Event):void
		{
			_screenClippingDirty = true;
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, onStageResized);
		}
				
        private function onMouseDown(e:MouseEvent):void
        {
            fireMouseEvent(MouseEvent3D.MOUSE_DOWN, e.ctrlKey, e.shiftKey);
        }

        private function onMouseUp(e:MouseEvent):void
        {
            fireMouseEvent(MouseEvent3D.MOUSE_UP, e.ctrlKey, e.shiftKey);
        }

        private function onRollOut(e:MouseEvent):void
        {
        	_mouseIsOverView = false;
        	
        	fireMouseEvent(MouseEvent3D.MOUSE_OUT, e.ctrlKey, e.shiftKey);
        }
        
        private function onRollOver(e:MouseEvent):void
        {
        	_mouseIsOverView = true;
        	
            fireMouseEvent(MouseEvent3D.MOUSE_OVER, e.ctrlKey, e.shiftKey);
        }
        
        private function bubbleMouseEvent(event:MouseEvent3D):Array
        {
            var tar:Object3D = event.object;
            var tarArray:Array = [];
            while (tar != null)
            {
            	tarArray.unshift(tar);
            	
                tar.dispatchEvent(event);
                
                tar = tar.parent as Object3D;
            }
            
            return tarArray;
        }
        
        private function traverseRollEvent(event:MouseEvent3D, array:Array, overFlag:Boolean):void
        {
        	for each (var tar:Object3D in array) {
        		tar.dispatchEvent(event);
        		if (overFlag)
        			buttonMode = buttonMode || tar.useHandCursor;
        		else if (buttonMode && tar.useHandCursor)
        			buttonMode = false;
        	}
        }
        
        private function fireMouseEvent(type:String, ctrlKey:Boolean = false, shiftKey:Boolean = false):void
        {
        	if (!mouseEnabled3D)
        		return;
        	
        	_face = renderer.getFaceUnderPoint(mouseX, mouseY);
        	
        	if (_face) {
	        	_uvt = _face.calculateUVT(mouseX, mouseY);
	        	_material = _face.material;
	        	_object = _face.mesh;
	        	var persp:Number =  _uvt.z/(camera.zoom*camera.focus);
				_scenePosition = new Vector3D(mouseX*persp, mouseY*persp, _uvt.z - camera.focus);
				_scenePosition = camera.transform.matrix3D.transformVector(_scenePosition);
			} else {
        		_uvt = null;
        		_material = null;
            	_object = null;
        	}
        	
            var event:MouseEvent3D = getMouseEvent(type);
            var outArray:Array = [];
            var overArray:Array = [];
            event.ctrlKey = ctrlKey;
            event.shiftKey = shiftKey;
			
			if (type != MouseEvent3D.MOUSE_OUT && type != MouseEvent3D.MOUSE_OVER) {
	            dispatchEvent(event);
	            bubbleMouseEvent(event);
			}
            
            //catch mouseOver/mouseOut rollOver/rollOut object3d events
            if (_mouseObject != _object || _mouseMaterial != _material) {
                if (_mouseObject != null) {
                    event = getMouseEvent(MouseEvent3D.MOUSE_OUT);
                    event.object = _mouseObject;
                    event.material = _mouseMaterial;
                    event.ctrlKey = ctrlKey;
            		event.shiftKey = shiftKey;
                    dispatchEvent(event);
                    outArray = bubbleMouseEvent(event);
                }
                if (_object != null) {
                    event = getMouseEvent(MouseEvent3D.MOUSE_OVER);
                    event.ctrlKey = ctrlKey;
            		event.shiftKey = shiftKey;
                    dispatchEvent(event);
                    overArray = bubbleMouseEvent(event);
                }
                
                if (_mouseObject != _object) {
                	
	                var i:int = 0;
	                
	                while (outArray[i] && outArray[i] == overArray[i])
	                	++i;
	                
	                if (_mouseObject != null) {
	                	event = getMouseEvent(MouseEvent3D.ROLL_OUT);
	                	event.object = _mouseObject;
	                	event.material = _mouseMaterial;
	                	event.ctrlKey = ctrlKey;
	            		event.shiftKey = shiftKey;
		                traverseRollEvent(event, outArray.slice(i), false);
	                }
	                
	                if (_object != null) {
	                	event = getMouseEvent(MouseEvent3D.ROLL_OVER);
	                	event.ctrlKey = ctrlKey;
	            		event.shiftKey = shiftKey;
		                traverseRollEvent(event, overArray.slice(i), true);
	                }
                }
                
                _mouseObject = _object;
                _mouseMaterial = _material;
            }
            
        }
        
        private function getMouseEvent(type:String):MouseEvent3D
        {
            var event:MouseEvent3D = new MouseEvent3D(type);
            event.screenX = mouseX;
            event.screenY = mouseY;
            event.scenePosition = _scenePosition;
            event.view = this;
            event.material = _material;
            event.object = _object;
            event.uvt = _uvt;

            return event;
        }
        
        private function fireMouseMoveEvent(force:Boolean = false):void
        {
        	if(!_mouseIsOverView)
        		return;
        	
            if (!(mouseZeroMove || force))
                if ((mouseX == _lastmove_mouseX) && (mouseY == _lastmove_mouseY))
                    return;

            fireMouseEvent(MouseEvent3D.MOUSE_MOVE);

             _lastmove_mouseX = mouseX;
             _lastmove_mouseY = mouseY;
        }
		
        /**
         * Forces mousemove events to fire even when cursor is static.
         */
        public var mouseZeroMove:Boolean;
		
        /**
         * Specifies whether the view receives 3d mouse events.
         * 
         * @see away3dlite.events.MouseEvent3D
         */
        public var mouseEnabled3D:Boolean = true;
        
		/**
		 * Scene used when rendering.
         * 
         * @see render()
         */
		public function get scene():Scene3D
		{
			return _scene;
		}
		
		public function set scene(val:Scene3D):void
		{
			if (_scene == val)
				return;
			
			if (_scene) {
				removeChild(_scene);
			}
			
			_scene = val;
			
			if (_scene) {
				addChild(_scene);
			}
		}
		
        /**
         * Camera used when rendering.
         * 
         * @see #render()
         */
		public function get camera():Camera3D
		{
			return _camera;
		}
		
		public function set camera(val:Camera3D):void
		{
			if (_camera == val)
				return;
				
			if (_camera) {
				removeChild(_camera);
				_camera._view = null;
			}
			
			_camera = val;
			
			if (_camera) {
				addChild(_camera);
				_camera._view = this;
			}
		}
		
        /**
         * Renderer object used to traverse the scenegraph and output the drawing primitives required to render the scene to the view.
         * 
         * @see #render()
         */
		public function get renderer():Renderer
		{
			return _renderer;
		}
		
		public function set renderer(val:Renderer):void
		{
			if (_renderer == val)
				return;
			
			_renderer = val;
			_renderer.setView(this);
		}
        
		/**
		 * Clipping used when rendering.
         * 
         * @see render()
         */
		public function get clipping():Clipping
		{
			return _clipping;
		}
		
		public function set clipping(val:Clipping):void
		{
			if (_clipping == val)
				return;
			
        	if (_clipping) {
        		_clipping.removeEventListener(ClippingEvent.CLIPPING_UPDATED, onClippingUpdated);
        		_clipping.removeEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdated);
        	}
        	
			_clipping = val;
			_clipping.setView(this);
			
        	if (_clipping) {
        		_clipping.addEventListener(ClippingEvent.CLIPPING_UPDATED, onClippingUpdated);
        		_clipping.addEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdated);
        	} else {
        		throw new Error("View cannot have clipping set to null");
        	}
        	
        	_screenClippingDirty = true;
		}
		
		/**
		 * Returns the total amount of faces processed in the last executed render
		 * 
		 * @see #render()
		 */
		public function get totalFaces():int
		{
			return _totalFaces;
		}
		
		/**
		 * Returns the total amount of 3d objects processed in the last executed render
		 * 
		 * @see #render()
		 */
		public function get totalObjects():int
		{
			return _totalObjects;
		}
		
		/**
		 * Returns the total amount of faces rendered in the last executed render
		 * 
		 * @see #render()
		 */
		public function get renderedFaces():int
		{
			return _renderedFaces;
		}
		
		/**
		 * Returns the total amount of objects rendered in the last executed render
		 * 
		 * @see #render()
		 */
		public function get renderedObjects():int
		{
			
			return _renderedObjects;
		}
		
		/**
		 * Creates a new <code>View3D</code> object.
		 * 
		 * @param	scene		Scene used when rendering.
		 * @param	camera		Camera used when rendering.
		 * @param	renderer	Renderer object used to traverse the scenegraph and output the drawing primitives required to render the scene to the view.
		 * @param	clipping	Clipping used when rendering.
		 */
		public function View3D(scene:Scene3D = null, camera:Camera3D = null, renderer:Renderer = null, clipping:Clipping = null)
		{
			super();
			
			this.scene = scene || new Scene3D();
			this.camera = camera || new Camera3D();
			this.renderer = renderer || new BasicRenderer();
			this.clipping = clipping || new RectangleClipping();
			
            //setup events on view
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.ROLL_OUT, onRollOut);
            addEventListener(MouseEvent.ROLL_OVER, onRollOver);
            
            //setup context menu
			_customContextMenu = new ContextMenu();
			_customContextMenu.hideBuiltInItems();
            _menu0 = new ContextMenuItem("View Source", true, true, true); 
			_menu0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onViewSource);
            _menu1 = new ContextMenuItem(APPLICATION_NAME + "\tv" + VERSION + "." + REVISION, true, true, true);
            _menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onVisitWebsite);
            updateContextMenu();
		}
        
		/**
		 * Defines a source url string that can be accessed though a View Source option in the right-click menu.
		 * 
		 * Requires the stats panel to be enabled.
		 * 
		 * @param	url		The url to the source files.
		 */
		public function addSourceURL(url:String):void
		{
			_sourceURL = url;
			updateContextMenu();
		}
		
        /**
         * Renders a snapshot of the view.
         */
		public function render():void
		{
			_totalFaces = 0;
			_totalObjects = -1;
			_renderedFaces = 0;
			_renderedObjects = -1;
			
			updateScreenClipping();
			
			_camera.update();
			
			_scene.project(camera);
			
			graphics.clear();
			
			renderer.render();
			
			if (mouseEnabled3D)
				fireMouseMoveEvent();
		}
	}
}
