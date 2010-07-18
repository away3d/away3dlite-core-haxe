/**
 * 
 */

package away3dlite.haxeutils;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.io.Bytes;
import haxe.Resource;

class ResourceLoader<T>
{
	public var name(default, null):String;
	public var content:T;
	private var loader:Loader;
	private var type:String;
	
	public function new(name:String, type:Class<T>) 
	{
		this.name = name;
		var types = Type.getClassName(type).split(".");
		this.type = types[types.length -1];
		stack.push(this);
	}
	
	private function loaderComplete(e:Event)
	{
		this.content = e.target.content;
		loader.contentLoaderInfo.removeEventListener("complete", loaderComplete);
		loader = null;
		toLoad--;
	}
	
	private static var stack:Array<ResourceLoader<Dynamic>> = [];
	private static var toLoad:Int = 0;
	
	public static function init()
	{
		Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	static private function onEnterFrame(e:Event):Void 
	{
		var current = stack.pop();
		if (current == null)
		{
			if (toLoad <= 0)
			{
				Lib.current.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				onComplete();
			}
		} else {
			if ((current.type == "DisplayObject") || (current.type == "Sprite") || (current.type == "MovieClip") || (current.type == "Bitmap"))
			{
				toLoad++;
				var ld = current.loader = new Loader();
				ld.contentLoaderInfo.addEventListener("complete", current.loaderComplete);
				ld.loadBytes(Resource.getBytes(current.name).getData());
			} else if (current.type == "String") {
				current.content = Resource.getString(current.name);
			} else if ( (current.type == "BytesData") || (current.type == "ByteArray") ) {
				current.content = Resource.getBytes(current.name).getData();
			} else {
				throw "Not recognized resource content type!";
			}
		}
	}
	
	public static var onComplete:Void->Void;
	
}