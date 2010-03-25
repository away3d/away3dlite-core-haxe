/**
 * ...
 * @author waneck
 */

package jsflash.display;

import haxe.Timer;
import html5.HTMLCanvasElement;
import jsflash.display.DisplayObject;
import jsflash.events.Event;
import jsflash.events.MouseEvent;
import jsflash.geom.PerspectiveProjection;
#if js
import webgl.wrappers.WebGLRenderingContext;

#else
typedef WebGLRenderingContext = Dynamic;

#end

class Stage extends DisplayObjectContainer
{
	public var frameRate(default, set_frameRate):Float;
	public var stageHeight(get_stageHeight, set_stageHeight):Float;
	public var stageWidth(get_stageWidth, set_stageWidth):Float;
	public var Canvas(default, null):HTMLCanvasElement;
	public var RenderingContext(default, null):WebGLRenderingContext;
	
	public var mouseX(default, null):Float;
	public var mouseY(default, null):Float;
	
	private var fpsTimer:Timer;
	
	public function new(canvas:HTMLCanvasElement) 
	{
		super();
		this.Canvas = canvas;
		this.stage = this;
		this.root = this;
		this.transform.perspectiveProjection = new PerspectiveProjection();
		this.transform.perspectiveProjection.fieldOfView = 45;
		
		frameRate = 30;
		
		#if js
		RenderingContext = webgl.WebGL.init(canvas);
		
		#end
		setupEventHandlers();
	}
	
	private function setupEventHandlers():Void 
	{
		//TODO setup mouse and keyboard handlers here
		//Canvas.onclick = 
		Canvas.onmousemove = mouseMoveHandler;
		Canvas.onclick = mouseClickHandler;
		Canvas.onmousedown = mouseDownHandler;
		Canvas.onmouseup = mouseUpHandler;
	}
	
	private function mouseUpHandler(evt:js.Dom.Event):Void
	{
		dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
	}
	
	private function mouseDownHandler(evt:js.Dom.Event):Void
	{
		dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
	}
	
	private function mouseClickHandler(evt:js.Dom.Event):Void
	{
		dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	
	private function mouseMoveHandler(event:js.Dom.Event) untyped
	{
		if (untyped event.pageX == null)
		{
			// IE case
			var d= (js.Lib.document.documentElement && 
			js.Lib.document.documentElement.scrollLeft != null) ?
			js.Lib.document.documentElement : js.Lib.document.body;
			mouseX= untyped event.clientX + d.scrollLeft;
			mouseY= untyped event.clientY + d.scrollTop;
		}
		else
		{
			// all other browsers
			mouseX= untyped event.pageX;
			mouseY= untyped event.pageY;
		}
		
		dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, mouseX, mouseY));
	}
	
	private function get_stageHeight():Float
	{
		return stageHeight = Canvas.height;
		
	}

	private function set_stageHeight(val:Float):Float
	{
		Canvas.height = Std.int(val);
		return stageHeight = val;
	}
	
	private function get_stageWidth():Float
	{
		return stageWidth = Canvas.width;
		
	}

	private function set_stageWidth(val:Float):Float
	{
		Canvas.width = Std.int(val);
		return stageWidth = val;
	}

	private function set_frameRate(val:Float):Float
	{
		if (fpsTimer != null)
		{
			fpsTimer.stop();
			fpsTimer.run = null;
		}
		
		fpsTimer = new Timer(Std.int(1000 / val));
		fpsTimer.run = callback(enterFrameDispatch, this);
		
		return frameRate = val;
	}
	
	private function enterFrameDispatch(dispObj:DisplayObject):Void 
	{
		if (dispObj.hasEventListener(Event.ENTER_FRAME))
		{
			dispObj.dispatchEvent(new Event(Event.ENTER_FRAME, false, false, false));
		}
		
		if (Std.is(dispObj, DisplayObjectContainer))
		{
			var cont:DisplayObjectContainer = cast dispObj;
			for (child in cont.__children)
			{
				enterFrameDispatch(child);
			}
		}
	}
	
	
}