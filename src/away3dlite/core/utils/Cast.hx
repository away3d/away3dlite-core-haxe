package away3dlite.core.utils;

import away3dlite.haxeutils.FastStd;
import flash.xml.XML;
import away3dlite.materials.BitmapMaterial;
import away3dlite.materials.ColorMaterial;
import away3dlite.materials.Material;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
#if haxe_206
import flash.errors.Error;
#else
import flash.Error;
#end
import flash.geom.Matrix;
import flash.Lib;
import flash.utils.ByteArray;
import flash.xml.XML;
//import mx.core.BitmapAsset;

using away3dlite.haxeutils.HaxeUtils;
/** Helper class for casting assets to usable objects */
class Cast
{
	public static function string(data:Dynamic):String
	{
		if (FastStd.is(data, Class))
			data = untyped __new__(data);

		if (FastStd.is(data, String))
			return cast data;

		return FastStd.string(data);
	}

	public static function bytearray(data:Dynamic):ByteArray
	{
		//throw new Error(typeof(data));

		if (FastStd.is(data, Class))
			data = untyped __new__(data);

		if (FastStd.is(data, ByteArray))
			return cast data;

		return data.downcast(ByteArray);
	}

	public static function xml(data:Dynamic):XML
	{
		if (FastStd.is(data, Class))
			data = untyped __new__(data);

		if (FastStd.is(data, XML))
			return cast data;
			
		if (FastStd.is(data, XML))
			return new XML(data);

		return new XML(new XML(data));
	}
	
	private static var hexchars:String = "0123456789abcdefABCDEF";

	private static function hexstring(string:String):Bool
	{
		var _length:Int = string.length;
		var i:Int = -1;
		while (++i < _length)
		{
			if (hexchars.indexOf(string.charAt(i)) == -1)
				return false;
		}

		return true;
	}

	public static function color(data:Dynamic):UInt
	{
		if (FastStd.is(data, UInt))
			return cast data;

		if (FastStd.is(data, Int))
			return cast data;

		if (FastStd.is(data, String))
		{
			var datastr : String = cast data;
			//var datastr = Lib.as(data,String);
			if (datastr == "random")
				return Std.int(Math.random()*0x1000000);
		
			if ((datastr.length == 6) && hexstring(datastr))
				return FastStd.parseInt("0x"+datastr);
		}

		return 0xFFFFFF;                                  
	}
	
	public static function bitmap(data:Dynamic):BitmapData
	{
		if (data == null)
			return null;

		if (FastStd.is(data, String))
			data = tryclass(data);

		if (FastStd.is(data, Class))
		{
			try
			{
				data = untyped __new__(data);
			}
			catch (bitmaperror:Dynamic)
			{
				data = untyped __new__(data,0,0);
			}
		}

		if (FastStd.is(data, BitmapData))
			return cast data;
		
		if (FastStd.is(data, Bitmap))
		{
			untyped {
				var dataBit : Bitmap = cast data;
				if (dataBit.hasOwnProperty("bitmapData")) // if (data is BitmapAsset)
					return dataBit.bitmapData;
			}
		}

		if (FastStd.is(data, DisplayObject))
		{
			var ds:DisplayObject = data.downcast(DisplayObject);
			var bmd:BitmapData = new BitmapData(Std.int(ds.width), Std.int(ds.height), true, 0x00FFFFFF);
			var mat:Matrix = ds.transform.matrix.clone();
			mat.tx = 0;
			mat.ty = 0;
			bmd.draw(ds, mat, ds.transform.colorTransform, ds.blendMode, bmd.rect, true);
			return bmd;
		}

		throw new Error("Can't cast to bitmap: " + data);
		return null;
	}

	private static var notclasses:Hash<Bool> = new Hash<Bool>();
	private static var classes:Hash<Class<Dynamic>> = new Hash<Class<Dynamic>>();

	public static function tryclass(name:String):Dynamic
	{
		
		if (notclasses.get(name))
			return name;

		var result = classes.get(name);

		if (result != null)
			return result;

		try
		{
			result = untyped __as__(__global__["flash.utils.getDefinitionByName"](name),Class);
			classes.set(name, result);
			return result;
		}
		catch (error:Dynamic) {}

		notclasses.set(name, true);
		return name;
	}

	public static function material(data:Dynamic):Material
	{
		if (data == null)
			return null;

		if (FastStd.is(data, String))
			data = tryclass(data);

		if (FastStd.is(data, Class))
		{
			try
			{
				data = untyped __new__(data);
			}
			catch (materialerror:Dynamic)
			{
				data = untyped __new__(data,0,0);
			}
		}

		if (FastStd.is(data, Material))
			return data;

		if (FastStd.is(data, Int)) 
			return (new ColorMaterial(data));

		//if (data is MovieClip) 
		//    return new MovieMaterial(data);

		if (FastStd.is(data, String))
		{
			if (data == "")
				return null;
		}

		try
		{
			var bmd:BitmapData = Cast.bitmap(data);
			return new BitmapMaterial(bmd);
		}
		catch (error:Dynamic) {}

		throw new Error("Can't cast to material: "+data);
	}
}