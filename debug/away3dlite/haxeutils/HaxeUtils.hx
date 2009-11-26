/**
 * Helper class for as3 compatibility
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
	public static inline function push4<T>(arr:Vector<T>, a1:T, a2:T, a3:T, a4:T)
	{
		arr.push(a1);
		arr.push(a2);
		arr.push(a3);
		arr.push(a4);
	}
	
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
	
	public static inline function push4<T>(arr:Array<T>, a1:T, a2:T, a3:T, a4:T)
	{
		arr.push(a1);
		arr.push(a2);
		arr.push(a3);
		arr.push(a4);
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

//Helper class for fast, non-cross-platform operations on flash

class StringUtils
{
	public static function match(str:String, regex:EReg):Array<String>
	{
		return untyped str.match(regex.r);
	}
	
	public static inline function substring(str:String, startIndex:Int, endIndex:Int):String
	{
		return str.substr(startIndex, endIndex - startIndex);
	}
	
	public static inline function charCode(str:String, at:Int):Int
	{
		return untyped str.cca(at);
	}
	
}