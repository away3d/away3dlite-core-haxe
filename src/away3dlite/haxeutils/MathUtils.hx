/**
 * Math utils for very fast math operations.
 */

package away3dlite.haxeutils;

class MathUtils
{
	public static inline var PI:Float = 3.141592653589793;
	public static inline var HALF_PI:Float = PI / 2 ;
	public static inline var TWO_PI:Float = PI * 2 ;
	
	
	public static inline var NEGATIVE_INFINITY = Math.NEGATIVE_INFINITY;
	public static inline var POSITIVE_INFINITY = Math.POSITIVE_INFINITY;
	
	public static inline var toRADIANS:Float = PI / 180;
	public static inline var toDEGREES:Float = 180 / PI;
	
	public static inline var B = 4 / PI;
	public static inline var C = -4 / (PI*PI);
	public static inline var P = 0.225;
	
	
	/**
	 * Sine approximation technique.
	 * 
	 * @author Nick from http://www.devmaster.net/forums/showthread.php?t=5784
	 * @param	x
	 */
	public static inline function fastSine(x:Float):Float
	{
		var y = B * x + C * x * abs(x);
		
		return P * (y * abs(y) - y) + y;
	}
	
	public static inline function fastCosine(x:Float):Float
	{
		x = x + HALF_PI;
		if (x > PI)
			x -= TWO_PI;
		var y = B * x + C * x * abs(x);
		
		return P * (y * abs(y) - y) + y;
	}
	
	public static inline function abs(x:Float):Float
	{
		return (x < 0) ? ( -x) : x;
	}
	
	public static inline function min(x:Float, y:Float):Float
	{
		return (x < y) ? x : y;
	}
	
	public static inline function max(x:Float, y:Float):Float
	{
		return (x > y) ? x : y;
	}
	
	/**
	 * sqrt and invsqrt from quake sources, translated to haXe by Nicolas Cannasse
	 * @param	x
	 * @return
	 */
	public static inline function sqrt(x : Float ) : Float
	{
		var half = 0.5 * x;
		flash.Memory.setFloat(0,x);
		var i = flash.Memory.getI32(0);
		i = 0x5f3759df - (i>>1);
		flash.Memory.setI32(0,i);
		x = flash.Memory.getFloat(0);
		x = x * (1.5 - half*x*x);
		return 1/ x;
	}
	
	public static inline function invSqrt( x : Float ) : Float 
	{
		var half = 0.5 * x;
		flash.Memory.setFloat(0,x);
		var i = flash.Memory.getI32(0);
		i = 0x5f375a86 - (i>>1);
		flash.Memory.setI32(0,i);
		x = flash.Memory.getFloat(0);
		x = x * (1.5 - half*x*x);
		return x;
	}
	
}

#if (haxe_205 && flash9) extern #end class IntUtils
{
	//Int operations
	//From polygonal labs
	
	public static inline function flipSign(i:Int):Int
	{
		return (i ^ -1) + 1;
	}
	
	public static inline function min(x:Int, y:Int):Int
	{
		return (x < y) ? x : y;
	}
	
	public static inline function max(x:Int, y:Int):Int
	{
		return (x > y) ? x : y;
	}
	
	public static inline function abs(x:Int):Int
	{
		return (x ^ (x >> 31)) - (x >> 31);
	}
	
	public static inline function isEqual(a:Int, b:Int):Bool
	{
		return a ^ b >= 0;
	}
}