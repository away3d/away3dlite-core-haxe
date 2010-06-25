/*

Basic scene setup example in Away3dLite

Demonstrates:

How to setup your own camera and scene, and apply it to a view.
How to add 3d objects to a scene.
How to update the view every frame.

Code by Rob Bateman & Katopz
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
katopz@sleepydesign.com
http://sleepydesign.com/

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
import haxe.Timer;
import jsflash.geom.PerspectiveProjection;
import jsflash.display.Stage;
import away3dlite.containers.View3D;
import away3dlite.core.base.Mesh;
import away3dlite.materials.BitmapMaterial;
import away3dlite.materials.Material;
import away3dlite.primitives.Sphere;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import jsflash.display.BitmapData;
import jsflash.Manager;
import js.Dom;


//[SWF(backgroundColor="#000000", frameRate="30", quality="MEDIUM", width="800", height="600")]

/**
 * FastTemplate example testing the maximum amount of faces rendered in a frame at 30fps
 */
class ExSphereCubeTest
{
	//signature swf
	//[Embed(source="assets/signature_lite_katopz.swf", symbol="Signature")]
	//private static var SignatureSwf:away3dlite.haxeutils.ResourceLoader<Sprite> = new away3dlite.haxeutils.ResourceLoader<Sprite>("Signature", Sprite);
	
	//signature variables
	
	private var material:Material;
	private var view:View3D;
	private var stage:Stage;
	private var fpsCounter:HtmlDom;
	private var textCount:HtmlDom;
	private var currTime:Float;
	private var frameCount:Int;
	
	var persp:PerspectiveProjection;
	static function main()
	{
		//ResourceLoader.onComplete = function() { Lib.current.addChild(new ExSphereSpeedTest()); };
		//ResourceLoader.init();
		Manager.init(cast js.Lib.document.getElementById("mycanvas"),600,600);
		Manager.setupWebGL();
		new ExSphereCubeTest();
	}
	
	public function new()
	{
		fpsCounter = js.Lib.document.getElementById("fps");
		textCount = js.Lib.document.getElementById("count");
		stage = Manager.stage;
		stage.frameRate = 200;
		persp = stage.transform.perspectiveProjection;
		persp.Zfar = 1000;
			onInit();
		frameCount = 0;
	}
	
	private function onEnterFrame(event:Event):Void
	{
		onPreRender();
		
		view.render();

		//onPostRender();
	}
	
	/**
	 * @inheritDoc
	 */
	private function onInit(?e):Void
	{
		material = new BitmapMaterial(BitmapData.ofFile("earth.jpg"));
		view = new View3D();
		stage.addChild(view);
		//title += " : Sphere speed test."; 
		
		//camera.zoom = 15;
		//camera.focus = 50;
		view.camera.z = 1000;
		
		//renderer.sortObjects = false;
		var amount:Int = 5;
		var gap:Int = 100;
		var i:Int;
		var j:Int;
		var k:Int;
		
		for( i in 0...amount ) {
			for( j in 0...amount ) {
				for( k in 0...amount ) {
					var sphere:Sphere = new Sphere();
					sphere.radius = 40;
					sphere.segmentsH = 20;
					sphere.segmentsW = 20;
					sphere.material = material;
					sphere.sortFaces = false;

					view.scene.addChild(sphere);
					
					sphere.x = gap*i - (amount-1)*gap/2;
					sphere.y = gap*j - (amount-1)*gap/2;
					sphere.z = gap*k - (amount-1)*gap/2;
					
				}
			}
		}
		
		//add signature
		/*Signature = SignatureSwf.content;
		SignatureBitmap = new Bitmap(new BitmapData(Std.int(Signature.width), Std.int(Signature.height), true, 0));
		SignatureBitmap.y = stage.stageHeight - Signature.height;
		stage.quality = StageQuality.HIGH;
		SignatureBitmap.bitmapData.draw(Signature);
		stage.quality = StageQuality.MEDIUM;
		addChild(SignatureBitmap);*/
		
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//stage.addEventListener(MouseEvent.CLICK, onMouseUp);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/**
	 * @inheritDoc
	 */
	private function onPreRender():Void
	{
		if (currTime == null)
		{
			currTime = Timer.stamp();
		} else {
			var lastTime = currTime;
			if (frameCount++ > 20)
			{
				fpsCounter.innerHTML = "FPS: " + (1 / ((currTime = Timer.stamp()) - lastTime));
				frameCount = 0;
			} else {
				currTime = Timer.stamp();
			}
		}
		//view.scene.z -= ((stage.height + view.scene.children.length*200) + view.scene.z) / 25;
		view.scene.rotationX++;
		view.scene.rotationY++;
		
		persp.Znear = (view.scene.children.length/10);
		persp.Zfar = (view.scene.children.length*view.scene.children.length*100);
		
		for (mesh in view.scene.children) {
			mesh.rotationX++;
			mesh.rotationY++;
			mesh.rotationZ++;
		}
	}
	
	/**
	 * Listener function for mouse up event
	 */
	private function onMouseUp(?event:MouseEvent)
	{
		var sphere:Sphere = new Sphere();
		sphere.radius = 100;
		sphere.segmentsH = 20;
		sphere.segmentsW = 20;
		sphere.material = material;
		sphere.sortFaces = false;
		
		view.scene.addChild(sphere);

		var numChildren:Int = view.scene.children.length;

		var i:Int = 0;
		for (_mesh in view.scene.children) {
			var mesh:Mesh = Lib.as(_mesh, Mesh);
			mesh.material.debug = false;
			mesh.x = numChildren*50*Math.sin(2*Math.PI*i/numChildren);
			mesh.y = numChildren*50*Math.cos(2*Math.PI*i/numChildren);
			i++;
		}
		
		var face = Std.int(sphere.vertices.length / 3);
		
		textCount.innerHTML = "Faces: " + face * numChildren + " Objects: " + numChildren;
	}
	
	/**
	 * Listener function for mouse down event
	 */
	private function onMouseDown(?event:MouseEvent)
	{
		for (_mesh in view.scene.children) {
			var mesh:Mesh = Lib.as(_mesh, Mesh);
			mesh.material.debug = true;
		}
	}
}