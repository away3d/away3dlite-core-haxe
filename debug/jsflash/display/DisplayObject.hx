/**
 * ...
 * @author waneck
 */

package jsflash.display;
import jsflash.events.EventDispatcher;
import jsflash.geom.Transform;
import jsflash.geom.Matrix3D;
import jsflash.events.Event;

class DisplayObject extends EventDispatcher, implements IBitmapDrawable
{
	private static var count:Int;
	
	public var visible(default, set_visible) : Bool;
	
	public var width(get_width, set_width) : Float;
	public var height(get_height, set_height) : Float;
	
	public var x(get_x, set_x) : Float;
	public var y(get_y, set_y) : Float;
	public var z(get_z, set_z) : Float;
	
	public var root(default, null) : DisplayObject;
	public var stage(default, null) : Stage;
	
	public var scaleX(get_scaleX, set_scaleX) : Float;
	public var scaleY(get_scaleY, set_scaleY) : Float;
	public var scaleZ(get_scaleZ, set_scaleZ) : Float;
	
	public var rotationX(get_rotationX, set_rotationX) : Float;
	public var rotationY(get_rotationY, set_rotationY) : Float;
	public var rotationZ(get_rotationZ, set_rotationZ) : Float;
	
	public var transform(default, null) : jsflash.geom.Transform;
	
	public var parent(default, null):DisplayObjectContainer;
	
	public var name:String;
	
	private var matrix:Matrix3D;
	
	public function new() 
	{
		super();
		transform = new Transform(this);
		this.name = "instance" + count++;
	}
	
	public inline function Internal():InternalDisplayObject
	{
		return cast this;
	}
	
	private function get_width():Float
	{
		return width;
	}

	private function set_width(val:Float):Float 
	{
		return width = val;
	}
	
	private function get_height():Float
	{
		return height;
	}

	private function set_height(val:Float):Float
	{
		return height = val;
	}
	
	private function set_visible(val)
	{
		return visible = val;
	}
	
	
	private function get_x()
	{
		return matrix.TX;
	}
	
	private function set_x(val)
	{
		return matrix.TX = val;
	}
	
	private function get_y()
	{
		return matrix.TY;
	}
	
	private function set_y(val)
	{
		return matrix.TY = val;
	}
	
	private function get_z()
	{
		return matrix.TZ;
	}
	
	private function set_z(val)
	{
		return matrix.TZ = val;
	}
	
	private function get_scaleX()
	{
		return matrix.scale.x;
	}
	
	private function set_scaleX(val)
	{
		return matrix.scale.x = val;
	}
	
	private function get_scaleY()
	{
		return matrix.scale.y;
	}
	
	private function set_scaleY(val)
	{
		return matrix.scale.y = val;
	}
	
	private function get_scaleZ()
	{
		return matrix.scale.z;
	}
	
	private function set_scaleZ(val)
	{
		return matrix.scale.z = val;
	}
	
	private function get_rotationX()
	{
		return matrix.rotation.x;
	}
	
	private function set_rotationX(val)
	{
		return matrix.rotation.x = val;
	}
	
	private function get_rotationY()
	{
		return matrix.rotation.y;
	}
	
	private function set_rotationY(val)
	{
		return matrix.rotation.y = val;
	}
	
	private function get_rotationZ()
	{
		return matrix.rotation.z;
	}
	
	private function set_rotationZ(val)
	{
		return matrix.rotation.z = val;
	}
	
	private function set_stage(val)
	{
		stage = val;
		if (stage != null && val == null && hasEventListener(Event.REMOVED_FROM_STAGE))
			dispatchEvent(new Event(Event.REMOVED_FROM_STAGE, false));
		else if(stage == null && val != null && hasEventListener(Event.ADDED_TO_STAGE))
			dispatchEvent(new Event(Event.ADDED_TO_STAGE, false));
		
		return val;
	}
	
	private function set_root(val:DisplayObject)
	{
		return root = val;
	}
	
}

private typedef InternalDisplayObject =
{
	var matrix:Matrix3D;
	var root(default, set_root):DisplayObject;
	var stage(default, set_stage):Stage;
	var parent:DisplayObject;
}