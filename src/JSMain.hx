/**
 * ...
 * @author waneck
 */

package ;
//import away3dlite.core.base.Object3D;

import away3dlite.containers.View3D;
import away3dlite.materials.BitmapMaterial;
import away3dlite.primitives.Cube6;
import away3dlite.primitives.Sphere;
import haxe.Stack;
import js.Lib;
import jsflash.display.BitmapData;
import jsflash.events.Event;
import jsflash.Manager;
import webgl.WebGLArray;
class JSMain 
{
	static var vezes:Int;
	static private var view:View3D;
	static private var cube:CubeTest;
	static private var cube1:Cube6;
	static private var sphere:Sphere;
	
	
	static function main()
	{
		Manager.init(cast Lib.document.getElementById("mycanvas"),500,500);
		Manager.setupWebGL();
		
		view = new View3D();
		var stage = Manager.stage;
		stage.addChild(view);
		
		cube1 = new Cube6();
		cube1.z = 0;
		cube1.scaleX = cube1.scaleY = cube1.scaleZ = 0.1;
		//cube1.width = 1000;
		//cube1.height = 1000;
		//view.scene.addChild(cube1);
		
		cube = new CubeTest();
		cube.x = 3;
		cube.z = -8;
		view.scene.addChild(cube);
		view.camera.x = view.camera.y = view.camera.z = 0;
		
		sphere = new Sphere(new BitmapMaterial(BitmapData.ofFile("earth.jpg")), 100, 18, 18 );
		view.scene.addChild(sphere);
		view.camera.z = 1000;
		
		cube1.vertices;
		sphere.vertices;
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private static function onEnterFrame(ev:Event)
	{
		sphere.rotationX += 1;
		sphere.rotationY += 1;
		sphere.rotationZ += 1;
		cube.rotationY += 1;
		view.render();
		view.camera.z += 0.06;
	}
	
	public function new() 
	{
		
	}
	
}