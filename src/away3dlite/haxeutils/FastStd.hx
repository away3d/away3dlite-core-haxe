/**
 * Faster platform-dependent (flash10) standard library
 */

package away3dlite.haxeutils;

/*#if haxe_205 extern #end*/ class FastStd 
{

	public static inline function parseInt( str:String ):Int
	{
		#if flash9
		return untyped __global__["parseInt"](str);
	
		#elseif js
		return untyped __js__("parseInt")(str);
		
		#end
	}
	
	public static inline function parseIntRadix( str:String, radix:Int ):Int
	{
		#if flash9
		return untyped __global__["parseInt"](str, radix);
		
		#elseif js
		return untyped __js__("parseInt")(str, radix);
		
		#end
	}
	
	public static inline function parseFloat( str:String ):Float
	{
		#if flash9
		return untyped __global__["parseFloat"](str);
		
		#elseif js
		return untyped __js__("parseFloat")(str);
		
		#end
	}
	
	public static inline function parseFloatRadix( str:String, radix:Int ):Float
	{
		#if flash9
		return untyped __global__["parseFloat"](str, radix);
		
		#elseif js
		return untyped __js__("parseFloat")(str, radix);
		
		#end
	}
	
	public static inline function is( v : Dynamic, t : Dynamic ) : Bool
	{
		#if flash9
		return untyped __is__(v, t);
		
		#elseif js
		return untyped js.Boot.__instanceof(v, t);
		
		#end
	}
	
	public static inline function string( s : Dynamic ) : String 
	{
		return new String(s);
	}
}