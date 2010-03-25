/**
 * ...
 * @author waneck
 */

package ;
import flash.geom.Vector3D;
import haxe.Timer;
import away3dlite.containers.View3D;
import away3dlite.cameras.Camera3D;
import away3dlite.containers.Scene3D;
import flash.Boot;
import flash.Lib;
import flash.Vector;

class Main 
{

	static function main()
	{
		new Main();
	}
	
	private var scene:Scene3D;
	private var view:View3D;
	private var camera:Camera3D;
	private var cube:away3dlite.primitives.Cube6;
	
	public function new() 
	{
		//Lib.current.graphics.beginFill(0);
		//Lib.current.graphics.drawRect(0,0,900,900);
		scene = new Scene3D();
		camera = new Camera3D();
		view = new View3D(scene, camera);
		Lib.current.addChild(view);
		
		cube = new away3dlite.primitives.Cube6();
		cube.x = 100;
		cube.y = 100;
		
		var a = new jsflash.display.Sprite();
		var b = new jsflash.display.Sprite();
		var c = new jsflash.display.Sprite();
		var d = new jsflash.display.Sprite();
		var e = new jsflash.display.Sprite();
		var f = new jsflash.display.Sprite();
		var g = new jsflash.display.Sprite();
		var h = new jsflash.display.Sprite();
		
		a.addChild(b);
		b.addChild(c);
		c.addChild(d);
		d.addChild(e);
		e.addChild(f);
		f.addChild(g);
		g.addChild(h);
		
		
		
		a.addEventListener("teste", function(e) trace(e));
		
		h.dispatchEvent(new jsflash.events.Event("teste", true));
		
		scene.addChild(cube);
		
		//var timer = new Timer(Std.int(1000/30));
		//timer.run = fps;
		fps();
		//fps();
	}
	
	public function fps():Void 
	{
		//cube.x -= 2;
		//cube.rotationY += 20;
		//camera.transform.matrix3D.pointAt(cube.transform.matrix3D.position, Vector3D.Z_AXIS, new Vector3D(0, -1, 0));
		var camMat = new jsflash.geom.Matrix3D(convertVector(cube.transform.matrix3D.rawData));

		camMat.scale.x += 14;
		camMat.scale.y += 14;
		camMat.scale.z += 14;
		
		
		cube.transform.matrix3D.rawData = Lib.vectorOfArray(camMat.rawData);
		
		camMat.invert();
		var cm = cube.transform.matrix3D.clone();
		cm.invert();
		trace(cm.rawData);
		trace(camMat.rawData);
		
		//camera.transform.matrix3D.appendRotation(10);
		
		view.render();
	}
	
	private function convertVector(vec:Vector<Float>):Array<Float>
	{
		var ret = [];
		for (v in vec)
		{
			ret.push(v);
		}
		return ret;
	}
	
	
}