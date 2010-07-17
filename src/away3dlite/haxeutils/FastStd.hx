/**
 * Faster platform-dependent (flash10) standard library
 */

package away3dlite.haxeutils;

#if haxe_205 extern #end class FastStd 
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
	
	public static inline function parseFloatRadix( str:String, radix:Int ):Float
	{
		return untyped __global__["parseFloat"](str, radix);
	}
	
	public static inline function is( v : Dynamic, t : Dynamic ) : Bool
	{
		return untyped __is__(v,t);
	}
	
	public static inline function string( s : Dynamic ) : String 
	{
		return new String(s);
	}
}