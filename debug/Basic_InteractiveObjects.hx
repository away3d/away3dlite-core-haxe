/*

Object interaction example in away3dlite using the mouse

Demonstrates:

How to use the MouseEvent3D listeners.
How to use the fog filter to provide depth shading on a mesh.

Code by Rob Bateman & Alexander Zadorozhny
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c)  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package;
import away3dlite.cameras.Camera3D;
import away3dlite.cameras.HoverCamera3D;
import away3dlite.containers.Scene3D;
import away3dlite.containers.View3D;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.SortType;
import away3dlite.core.render.BasicRenderer;
import jsflash.Manager;
//import away3dlite.core.render.FastRenderer;
import away3dlite.core.render.Renderer;
import away3dlite.events.MouseEvent3D;
import away3dlite.materials.WireColorMaterial;
import away3dlite.primitives.Cube6;
import away3dlite.primitives.Plane;
import away3dlite.primitives.Sphere;
import away3dlite.primitives.Torus;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
//import flash.display.StageQuality;


//[SWF(backgroundColor="#000000", frameRate="60", quality="LOW", width="800", height="600")]

class Basic_InteractiveObjects extends Sprite
{
	//signature swf
	//[Embed(source="assets/signature_lite.swf", symbol="Signature")]
	//private var SignatureSwf:Class;
	
	//engine variables
	private var scene:Scene3D;
	private var camera:Camera3D;
	private var renderer:Renderer;
	private var view:View3D;
	
	//scene objects
	private var plane:Plane;
	private var sphere:Sphere;
	private var cube:Cube6;
	private var torus:Torus;
	
	//navigation variables
	private var move:Bool;
	private var lastPanAngle:Float;
	private var lastTiltAngle:Float;
	private var lastMouseX:Float;
	private var lastMouseY:Float;
	
	public static function main()
	{
		Manager.init(cast js.Lib.document.getElementById("mycanvas"),500,500);
		Manager.setupWebGL();
		Lib.current.addChild(new Basic_InteractiveObjects());
	}
	
	public function new()
	{
		super();
		
		move = false;
		
		if (stage != null) init();
		addEventListener(Event.ADDED_TO_STAGE, init);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	
	
	private function init(?e:Event):Void
	{
		initEngine();
		initObjects();
		initListeners();
	}
	
	private function initEngine():Void
	{
		scene = new Scene3D();
		
		camera = new Camera3D();
		//camera.focus = 50;
		//camera.distance = 1000;
		//camera.minTiltAngle = 0;
		//camera.maxTiltAngle = 90;
		
		//camera.panAngle = 45;
		//camera.tiltAngle = 20;
		//camera.hover(true);
		
		renderer = new BasicRenderer();
		//renderer = new FastRenderer();
		
		view = new View3D();
		view.scene = scene;
		view.camera = camera;
		view.renderer = renderer;
		//view.clipping = clipping = new StubClipping();
		
		//view.addSourceURL("srcview/index.html");
		addChild(view);
		
		//add signature
		//Signature = Sprite(new SignatureSwf());
		//SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
		//stage.quality = StageQuality.HIGH;
		//SignatureBitmap.bitmapData.draw(Signature);
		//stage.quality = StageQuality.LOW;
		//addChild(SignatureBitmap);
		
		//addChild(new Stats());
	}
	
	private function initObjects():Void
	{
		plane = new Plane();
		plane.y = -20;
		plane._width = 1000;
		plane._height = 1000;
		plane.sortType = SortType.BACK;
		plane.segmentsW = 20;
		plane.segmentsH = 20;
		scene.addChild(plane);
		
		sphere = new Sphere();
		sphere.x = 300;
		sphere.y = -160;
		sphere.z = 300;
		sphere.radius = 150;
		sphere.segmentsW = 12;
		sphere.segmentsH = 10;
		
		scene.addChild(sphere);
		
		cube = new Cube6();
		cube.x = 300;
		cube.y = -160;
		cube.z = -80;
		cube._width = 200;
		cube._height = 200;
		cube.depth = 200;
		
		scene.addChild(cube);
		
		torus = new Torus();
		torus.x = -250;
		torus.y = -160;
		torus.z = -250;
		torus.radius = 150;
		torus.tube = 60;
		torus.segmentsR = 12;
		torus.segmentsT = 10;
		
		scene.addChild(torus);
		
	}
	
	/**
	 * Initialise the listeners
	 */
	private function initListeners():Void
	{
		scene.addEventListener(MouseEvent3D.MOUSE_UP, onSceneMouseUp);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(Event.RESIZE, onResize);
		onResize();
	}
	
	/**
	 * Mouse up listener for the 3d scene
	 */
	private function onSceneMouseUp(e:MouseEvent3D):Void
	{
		if (Std.is(e.object, Mesh)) {
			var mesh:Mesh = Lib.as(e.object, Mesh);
			mesh.material = new WireColorMaterial();
		}
	}
	
	/**
	 * Navigation and render loop
	 */
	private function onEnterFrame(event:Event):Void
	{
		if (move) {
			//camera.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
			//camera.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			trace("A");
		}
		
		//camera.hover();  
		view.render();
	}
	
	/**
	 * Mouse down listener for navigation
	 */
	private function onMouseDown(event:MouseEvent):Void
	{
		//lastPanAngle = camera.panAngle;
		//lastTiltAngle = camera.tiltAngle;
		lastMouseX = stage.mouseX;
		lastMouseY = stage.mouseY;
		move = true;
		stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	/**
	 * Mouse up listener for navigation
	 */
	private function onMouseUp(event:MouseEvent):Void
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
	}
	
	/**
	 * Mouse stage leave listener for navigation
	 */
	private function onStageMouseLeave(event:Event):Void
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
	}
	
	/**
	 * Stage listener for resize events
	 */
	private function onResize(?event:Event):Void
	{
		view.x = stage.stageWidth / 2;
		view.y = stage.stageHeight / 2;
		//SignatureBitmap.y = stage.stageHeight - Signature.height;
	}
}