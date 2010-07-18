package away3dlite.templates;

import away3dlite.cameras.Camera3D;
import away3dlite.containers.Scene3D;
import away3dlite.containers.View3D;
import away3dlite.debug.AwayStats;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.display.StageScaleMode;
import flash.display.StageQuality;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

/**
 * SimpleView
 * @author katopz
 */
class Template extends Sprite
{
	private var stats:AwayStats;
	private var debugText:TextField;
	private var _title:String;
	private var _debug:Bool;
	
	private function onAddedToStage(event:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();
	}
	
	private function onEnterFrame(event:Event):Void
	{
		onPreRender();
		
		view.render();
		
		if (_debug) {
			debugText.text = _title + " Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
			onDebug();
		}
		
		onPostRender();
	}
	
	private function init():Void
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
		stats = new AwayStats();
		
		//add stats to the displaylist
		addChild(stats);
		
		//init debug textfield
		debugText = new flash.text.TextField();
		debugText.selectable = false;
		debugText.mouseEnabled = false;
		debugText.mouseWheelEnabled = false;
		debugText.defaultTextFormat = new TextFormat("Tahoma", 12, 0x000000);
		debugText.autoSize = TextFieldAutoSize.LEFT;
		debugText.x = 140;
		debugText.textColor = 0xFFFFFF;
		debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];
		
		debugText.text = "IAJFOIDAJOFDAIJFDA";
		
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
	
	private function onInit():Void
	{
		// override me
	}

	private function onPreRender():Void
	{
		// override me
	}
	
	private function onDebug():Void
	{
		// override me
	}
	
	private function onPostRender():Void
	{
		// override me
	}
	
	public var title(get_title, set_title):String;
	private inline function get_title():String
	{
		return _title;
	}
	private function set_title(val:String):String
	{
		if (_title == val)
			return val;
		
		debugText.text = _title + ", Object3D(s) : " + view.totalObjects + ", Face(s) : " + view.totalFaces;
		
		return _title = val;
	}
	
	public var debug(get_debug, set_debug):Bool;
	private inline function get_debug():Bool
	{
		return _debug;
	}
	
	private function set_debug(val:Bool):Bool
	{
		if (_debug == val)
			return val;
		
		_debug = val;
		debugText.visible = _debug;
		stats.visible = _debug;
		return val;
	}

	public var scene:Scene3D;
	
	public var camera:Camera3D;
	
	public var view:View3D;
	
	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function start():Void
	{
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
}