package away3dlite.loaders.utils;

import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.LoaderContext;

/**
 * Used to store the name and loader reference of an external texture image.
 */
class TextureLoader extends Loader
{
	public function new()
	{
		super();
	}
	
	public var filename(default, null):String;
	
	override public function load(request:URLRequest, ?context:LoaderContext):Void
	{
		filename = request.url;
		super.load(request, context);
	}
}