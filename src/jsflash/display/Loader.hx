package jsflash.display;

import jsflash.net.URLRequest;
import jsflash.display.DisplayObject;
import jsflash.display.BitmapData;
import jsflash.display.LoaderInfo;
import jsflash.events.Event;
import jsflash.events.IOErrorEvent;

/**
* @author	Hugh Sanderson
* @author	Niel Drummond
* @author	Russell Weir
* @todo init, open, progress, unload (?) events
* @todo Complete LoaderInfo initialization
**/
class Loader extends jsflash.display.DisplayObjectContainer
{
	public var content(default,null) : DisplayObject;
	public var contentLoaderInfo(default,null) : LoaderInfo;
	var mImage:BitmapData;

	public function new()
	{
		super();
		contentLoaderInfo = LoaderInfo.create(this);
	}

	// No "loader context" in jsflash
	public function load(request:URLRequest)
	{
		// get the file extension for the content type
		var parts = request.url.split(".");
		var extension : String = if(parts.length == 0) "" else parts[parts.length-1].toLowerCase();

		var transparent = true;
		// set properties on the LoaderInfo object
		untyped {
			contentLoaderInfo.url = request.url;
			contentLoaderInfo.contentType = switch(extension) {
			case "swf": "application/x-shockwave-flash";
			case "jpg","jpeg": transparent = false; "image/jpeg";
			case "png": "image/gif";
			case "gif": "image/png";
			default:
				throw "Unrecognized file " + request.url;
			}
		}

		mImage = new BitmapData();

		try {
			mImage = BitmapData.ofFile(request.url);
			//content = new Bitmap(mImage);
			untyped contentLoaderInfo.content = this.content;
		} catch(e:Dynamic) {
			trace("Error " + e);
			contentLoaderInfo.DispatchIOErrorEvent();
			return;
		}

		contentLoaderInfo.DispatchCompleteEvent();
	}

}

