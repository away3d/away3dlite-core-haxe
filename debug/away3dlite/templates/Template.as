package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	
	import net.hires.debug.Stats;

	use namespace arcane;
	
	/**
	 * Base template class.
	 */
	public class Template extends Sprite
	{
		/** @private */
		arcane function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			//init scene
			scene = new Scene3D();
			
			//init camera
			camera = new Camera3D();
			camera.z = -1000;
			
			//init view
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			
			//center view to stage
			view.x = stage.stageWidth/2;
			view.y = stage.stageHeight/2;
			
			//add view to the displaylist
			addChild(view);
			
			//init stats panel
			stats = new Stats();
			
			//add stats to the displaylist
			addChild(stats);
			
			//init debug textfield
			debugText = new TextField();
			debugText.selectable = false;
			debugText.mouseEnabled = false;
			debugText.mouseWheelEnabled = false;
			debugText.defaultTextFormat = new TextFormat("Tahoma", 12, 0x000000);
			debugText.autoSize = "left";
			debugText.x = 80;
			debugText.textColor = 0xFFFFFF;
			debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];
			
			//add debug textfield to the displaylist
			addChild(debugText);
			
			//set default debug
			debug = true;
			
			//set default title
			title = "Away3DLite";
			
			//add enterframe listener
			start();
			
			//trigger onInit method
			onInit();
		}
		
		private var stats:Stats;
		private var debugText:TextField;
		private var _title:String;
		private var _debug:Boolean;
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function onEnterFrame(event:Event):void
		{
			onPreRender();
			
			view.render();
			
			if (_debug) {
				debugText.text = _title + " Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
				onDebug();
			}
			
			onPostRender();
		}
		
		/**
		 * Fired on instantiation of the template.
		 */
		protected function onInit():void
		{
			// override me
		}
		
		/**
		 * Fired at the beginning of a render loop.
		 */
		protected function onPreRender():void
		{
			// override me
		}
		
		/**
		 * Fired if debug is set to true.
		 * 
		 * @see #debug
		 */
		protected function onDebug():void
		{
			// override me
		}
		
		/**
		 * Fired at the end of a render loop.
		 */
		protected function onPostRender():void
		{
			// override me
		}
		
		/**
		 * Defines the text appearing in the template title.
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(val:String):void
		{
			if (_title == val)
				return;
			
			_title = val;
			
			debugText.text = _title + ", Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
		}
		
		/**
		 * Defines if the template is run in debug mode.
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
			
			debugText.visible = _debug;
			stats.visible = _debug;
		}
		
		/**
		 * The scene object used in the template.
		 */
		public var scene:Scene3D;
		
		/**
		 * The camera object used in the template.
		 */
		public var camera:Camera3D;
		
		/**
		 * The view object used in the template.
		 */
		public var view:View3D;
        
		/**
		 * Creates a new <code>Template</code> object.
		 */
		public function Template()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Starts the view rendering.
		 */
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Stops the view rendering.
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}