/**
 * ...
 * @author waneck
 */

package jsflash.display;
import html5.ImageData;
import js.Dom;

class BitmapData 
{
	//in the future
	//var data:ImageData;
	
	public var data:Image;
	public var loaded:Bool;

	public function new() 
	{
		
	}
	
	public static function ofFile(src:String)
	{
		var bd = new BitmapData();
		bd.data = untyped __new__("Image");
		bd.data.onload = bd.onload;
		bd.data.src = src;
		
		return bd;
	}
	
	private function onload(ev:js.Dom.Event):Void
	{
		this.loaded = true;
	}
	
}