/**
 * Faster platform-dependent (flash10) standard library
 */

package away3dlite.haxeutils;

class FastStd 
{

	public static inline function parseInt( str:String ):Int
	{
		return untyped __global__["parseInt"](str);
	}
	
	public static inline function parseIntRadix( str:String, radix:Int ):Int
	{
		return untyped __global__["parseInt"](str, radix);
	}
	
	public static inline function parseFloat( str:String ):Float
	{
		return untyped __global__["parseFloat"](str);
	}
	
}