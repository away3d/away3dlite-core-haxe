/**
 * Helper class for as3 compatibility
 * @author waneck
 */

package away3dlite.haxeutils;

import flash.Lib;
import flash.Vector;
import flash.xml.XML;

class HaxeUtils 
{
	public static inline function downcast<T>(object:Dynamic, cl:Class<T>):T
	{
		return cast object;
	}
	
	public static inline function asString(object:Dynamic):String
	{
		return Std.string(object);
	}
	
	public static inline function asFloat(object:Dynamic):Float
	{
		return Std.parseFloat(object.asString());
	}
	
	public static inline function asInt(object:Dynamic):Int
	{
		return Std.parseInt(object.asString());
	}
}

class VectorUtils
{
	public static inline function xyzpush<T>(arr:Vector<T>, a1:T, a2:T, a3:T)
	{
		arr.push(a1);
		arr.push(a2);
		arr.push(a3);
	}
}

class ArrayUtils
{
	public static inline function indexOf<T>(arr:Array<T>, needle:T):Int
	{
		var len:Int = arr.length;
		var i:Int = -2;
		while (++i < len)
		{
			if ((i >= 0) && (arr[i] == needle))
				break;
		}
		return i;
	}
	
	public static inline function xyzpush<T>(arr:Array<T>, a1:T, a2:T, a3:T)
	{
		arr.push(a1);
		arr.push(a2);
		arr.push(a3);
	}
	
	public static inline function xypush<T>(arr:Array<T>, a1:T, a2:T)
	{
		arr.push(a1);
		arr.push(a2);
	}
}

class StringUtils
{
	//TODO: Clean up, look for a more efficient way to use EReg without risking to have an error throwing (!)
	public static function match(str:String, regex:EReg):Array<String>
	{
		//regex.match(str);
		return untyped regex.r.exec(str);
		/*var retval = [];
		regex.match(str);
		regex.customReplace(str, function(_ereg:EReg)
		{
			var a = _ereg.matched(0);
			retval.push(a);
			return a;
		});
		return retval;*/
	}
	
	public static inline function substring(str:String, startIndex:Int, endIndex:Int):String
	{
		return str.substr(startIndex, endIndex - startIndex);
	}
	
	public static inline function parseInt( str:String ):Int
	{
		return untyped __global__["parseInt"](str);
	}
	
	public static inline function parseFloat( str:String ):Float
	{
		return untyped __global__["parseFloat"](str);
	}
	
	
}