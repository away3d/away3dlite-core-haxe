package away3dlite.core.utils;
import away3dlite.haxeutils.FastReflect;
import away3dlite.haxeutils.FastStd;
#if haxe_206
import flash.errors.Error;
#else
import flash.Error;
#end
import flash.Lib;
import haxe.Log;
import haxe.PosInfos;

/** Class for emmiting debuging messages, warnings and errors */
class Debug
{
	public static var active:Bool = false;
	public static var warningsAsErrors:Bool = false;

	/**
	 * haXe specific: redirect traces to flash native trace?
	 */
	public static var redirectTraces(default, set_redirectTraces):Bool;
	private static var haxeTrace:Dynamic = Log.trace;
	
	private static function set_redirectTraces(val:Bool):Bool
	{
		if (val)
			Log.trace = function(v:Dynamic, ?infos:PosInfos) { 
				var str:String = "";
				if (FastStd.is(v, Float) || FastStd.is(v, String) || FastStd.is(v, Bool))
					Lib.trace(v);
				else
				{
					if (FastReflect.hasField(v, "toString"))
						flash.Lib.trace(v.toString());
					else
					{
						var arr = [];
						for (field in Reflect.fields(v))
						{
							arr.push(field);
						}
						flash.Lib.trace("( "+ arr.join(", ") + " )");
					}
						
					
				}
			};
		else
			Log.trace = haxeTrace;
		return val;
	}
	 
	public static function clear():Void
	{
	}
	
	public static function delimiter():Void
	{
	}
	
	public static function trace(message:Dynamic, ?pos: PosInfos):Void
	{
		if (active)
			dotrace(message,pos);
	}
	
	public static function warning(message:Dynamic, ?pos: PosInfos):Void
	{
		if (warningsAsErrors)
		{
			error(message,pos);
			return;
		}
		trace("WARNING: "+message,pos);
	}
	
	public static function error(message:Dynamic, ?pos: PosInfos):Void
	{
		trace("ERROR: "+message,pos);
		throw new Error(message);
	}
	
	private static inline function dotrace(message:Dynamic,?pos:PosInfos):Void
	{
		trace(pos.className + " at " + pos.fileName + " : " + pos.lineNumber + " :: " + message);
	}
}