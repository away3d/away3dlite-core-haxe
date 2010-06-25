/**
 * ...
 * @author waneck
 */

package jsflash.geom;
import jsflash.FastMath;

class Vector3D 
{

	public static inline var X_AXIS:Vector3D = new Vector3D(1,0,0);
	public static inline var Y_AXIS:Vector3D = new Vector3D(0,1,0);
	public static inline var Z_AXIS:Vector3D = new Vector3D(0,0,1);

	public var x(default, set_x):Float;
	public var y(default, set_y):Float;
	public var z(default, set_z):Float;
	public var w(default, set_w):Float;

	public var lengthSquared(get_lengthSquared,null):Float;
	public var length(get_length, null):Float;
	
	private var dirty(default, set_dirty):Bool;

	public function new( ?ax:Float = 0, ?ay:Float = 0, ?az:Float = 0, ?aw:Float = 0 ):Void
	{
		Internal().x = ax;
		Internal().y = ay;
		Internal().z = az;
		Internal().w = aw;
		
		dirty = true;
	}
	
	private function set_x(val)
	{
		if (val != x)
		{
			x = val;
			dirty = true;
		}
		return val;
	}
	
	private function set_y(val)
	{
		if (val != y)
		{
			y = val;
			dirty = true;
		}
		return val;
	}
	
	private function set_z(val)
	{
		if (val != z)
		{
			z = val;
			dirty = true;
		}
		return val;
	}
	
	private function set_w(val)
	{
		if (val != w)
			dirty = true;
		return w = val;
	}
	
	private function set_dirty(val)
	{
		if (val && OnChange != null)
			OnChange();
		return dirty =val;
	}
	
	
	private function get_length()
	{
		if (dirty)
		{
			dirty = false;
			length = Math.sqrt(x * x + y * y + z * z);
		}
		
		return length;
	}
	
	private function get_lengthSquared()
	{
		return (x * x + y * y + z * z);
	}
	
	
	public inline function Internal():InternalVector3D
	{
		return cast this;
	}
	
	private function Change(x, y, z, w)
	{
		Internal().x = x;
		Internal().y = y;
		Internal().z = z;
		Internal().w = w;
		
		dirty = true;
	}
	
	public function scaleBy( s:Float ):Void
	{
		Internal().x = s * x;
		Internal().y = s * y;
		Internal().z = s * z;
		Internal().w = s * w;
		
		dirty = true;
	}
	
	public function negate():Void
	{
		Internal().x = -x;
		Internal().y = -y;
		Internal().z = -z;
		
		//dirty only affects the length and squareLength properties
		//dirty = true;
	}
	
	public function nearEquals( toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false ):Bool
	{
		return
		
		if	(FastMath.abs(x - toCompare.x) < tolerance &&
			 FastMath.abs(y - toCompare.y) < tolerance &&
			 FastMath.abs(z - toCompare.z) < tolerance )
			if (allFour)
				if (FastMath.abs(w - toCompare.w) < tolerance)
					true;
				else
					false;
			else
				true;
		else
			false;
			
	}
	
	public function decrementBy( a:Vector3D ):Void
	{
		Internal().x = x - a.x;
		Internal().y = y - a.y;
		Internal().z = z - a.z;
		
		dirty = true;
	}
	
	public function normalize():Float
	{
		var l = length;
		
		Internal().x /= l;
		Internal().y /= l;
		Internal().z /= l;
		
		dirty = false;
		length = 1;
		
		return l;
	}
	
	public function crossProduct( a:Vector3D):Vector3D
	{
		return new Vector3D( (y * a.z - z * a.y), (z * a.x - x * a.z), (x * a.y - y * a.x), 1 );
	}
	
	public function subtract( a:Vector3D):Vector3D
	{
		return new Vector3D(x - a.x, y - a.y, z - a.z);
	}
	
	public function project():Void
	{
		Internal().x /= w;
		Internal().y /= w;
		Internal().z /= w;
		
		dirty = true;
	}
	
	public function clone():Vector3D
	{
		return new Vector3D(x, y, z, w);
	}
	
	public function dotProduct( a:Vector3D ):Float
	{
		return x * a.x + y * a.y + z * a.z;
	}
	
	public function add( a:Vector3D ):Vector3D
	{
		return new Vector3D(x + a.x, y + a.y, z + a.z);
	}
	
	public function toString():String
	{
		return "Vector3D(" + x +", " + y + ", " + z + ")";
	}
	
	public function incrementBy( a:Vector3D ):Void
	{
		Internal().x = x + a.x;
		Internal().y = y + a.y;
		Internal().z = z + a.z;
		
		dirty = true;
	}
	
	public function equals( ?toCompare:Vector3D, ?allFour:Bool ):Bool
	{
		return 
		if (x == toCompare.x && y == toCompare.y && z == toCompare.z)
			if (allFour)
				if (w == toCompare.w)
					true;
				else
					false;
			else
				true;
		else
			false;
	}

	public static function angleBetween( a:Vector3D, b:Vector3D ):Float
	{
		return Math.acos( a.dotProduct(b) / (a.length * b.length) );
	}
	
	public static function distance( pt1:Vector3D, pt2:Vector3D ):Float
	{
		var vx = pt1.x - pt2.x;
		var vy = pt1.y - pt2.y;
		var vz = pt1.z - pt2.z;
		return Math.sqrt(vx * vx + vy * vy + vz * vz);
	}
	
	
	private var OnChange:Void->Void;
	
}

private typedef InternalVector3D =
{
	var x:Float;
	var y:Float;
	var z:Float;
	var w:Float;
	
	var dirty:Bool;
	var OnChange:Void->Void;
	
	function Change(x:Float, y:Float, z:Float, w:Float):Void;
}