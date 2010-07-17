package away3dlite.loaders.utils;
import away3dlite.haxeutils.FastStd;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;



//[Event(name="complete", type="flash.events.Event")]
//[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
//[Event(name="ioError", type="flash.events.IOErrorEvent")]
//[Event(name="progress", type="flash.events.ProgressEvent")]
//[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

/**
 * Creates a queue of textures that load sequentially
 */	
class TextureLoadQueue extends EventDispatcher
{
	private var _queue:Array<LoaderAndRequest>;
	
	private inline function redispatchEvent(e:Event):Void
	{
		dispatchEvent(e);
	}
	
	private function onItemComplete(e:Event):Void
	{
		cleanUpOldItem(get_currentLoader());
		currentItemIndex++;
		loadNext();
	}
	
	private function loadNext():Void
	{
		if(currentItemIndex >= get_numItems()){
			dispatchEvent(new Event(Event.COMPLETE));
		}else{
			var evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			evt.bytesTotal = 100;
			evt.bytesLoaded = Std.int(get_percentLoaded());
			dispatchEvent(evt);
			if(get_currentLoader().contentLoaderInfo.bytesLoaded > 0 && get_currentLoader().contentLoaderInfo.bytesLoaded == get_currentLoader().contentLoaderInfo.bytesTotal){
				
			}else{
			
				// make it lowest priority so we handle it after the loader handles the event itself. That means that when we
				// re-dispatch the event, the loaders have already processed their data and are ready for use
				get_currentLoader().contentLoaderInfo.addEventListener(Event.COMPLETE, onItemComplete, false, -2147483648, true);
				
				get_currentLoader().contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, redispatchEvent, false, 0, true);
				get_currentLoader().contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, redispatchEvent, false, 0, true);
				get_currentLoader().contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, redispatchEvent, false, 0, true);
				get_currentLoader().contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, redispatchEvent, false, 0, true);
				get_currentLoader().load(get_currentURLRequest());
			}
		}
	}
	
	private function calcProgress():Float
	{
		var baseAmount:Float = currentItemIndex / get_numItems();
		var currentItemFactor:Float = calcCurrentLoaderAmountLoaded() / get_numItems();
		return baseAmount = currentItemFactor;
	}
	
	private function calcCurrentLoaderAmountLoaded():Float
	{
		if(get_currentLoader().contentLoaderInfo.bytesLoaded > 0){
			return get_currentLoader().contentLoaderInfo.bytesLoaded / get_currentLoader().contentLoaderInfo.bytesTotal;
		}else{
			return 0;
		}
	}
	
	private function cleanUpOldItem(item:TextureLoader):Void
	{
		//item;//TODO : FDT Warning
		get_currentLoader().removeEventListener(Event.COMPLETE, onItemComplete, false);
		get_currentLoader().removeEventListener(HTTPStatusEvent.HTTP_STATUS, redispatchEvent, false);
		get_currentLoader().removeEventListener(IOErrorEvent.IO_ERROR, redispatchEvent, false);
		get_currentLoader().removeEventListener(ProgressEvent.PROGRESS, redispatchEvent, false);
		get_currentLoader().removeEventListener(SecurityErrorEvent.SECURITY_ERROR, redispatchEvent, false);	
	}
	
	/**
	 * Returns the Float of items whating in the queue to be loaded.
	 */
	public var numItems(get_numItems, null):Int;
	private inline function get_numItems():Int
	{
		return _queue.length;
	}
	/**
	 * Returns the index of the current texture baing loaded
	 */
	public var currentItemIndex(default, null):Int;
	
	/**
	 * Returns an array of loader objects containing the loaded images
	 */
	public var images(get_images, null):Array<TextureLoader>;
	private function get_images():Array<TextureLoader>
	{
		var items:Array<TextureLoader> = [];
		for (item in _queue)
		{
			items.push(item.loader);
		}
		return items;
	}
	
	/**
	 * Returns the loader object for the current texture being loaded
	 */
	public var currentLoader(get_currentLoader, null):TextureLoader;
	private inline function get_currentLoader():TextureLoader
	{
		return _queue[currentItemIndex].loader;
	}
	
	/**
	 * Returns the url request object for the current texture being loaded
	 */
	public var currentURLRequest(get_currentURLRequest, null):URLRequest;
	private inline function get_currentURLRequest():URLRequest
	{
		return _queue[currentItemIndex].request;
	}
	
	
	/**
	 * Returns the overall progress of the loader queue.
	 * Progress of 0 means that nothing has loaded. Progress of 1 means that all the items are fully loaded
	 */
	public var progress(get_progress, null):Float;
	private inline function get_progress():Float
	{
		return calcProgress();
	}
	
	/**
	 * Returns the overall progress of the loader queue as a percentage.
	 */
	public var percentLoaded(get_percentLoaded, null):Float;
	private inline function get_percentLoaded():Float
	{
		return get_progress() * 100;
	}
	
	/**
	 * Creates a new <code>TextureLoadQueue</code> object.
	 */
	public function new()
	{
		super();
		_queue = [];
		
	}
	
	/**
	 * Adds a new loader and request object to the load queue.
	 * 
	 * @param	loader		The loader object to add to the queue.
	 * @param	request		The url request object to add tp the queue.
	 */
	public function addItem(loader:TextureLoader, request:URLRequest):Void
	{
		//check to stop duplicated loading
		for (_item in _queue) {
			if (_item.request.url == request.url)
				return;
		}
		_queue.push({loader: (loader), request: (request)});
	}
	
	/**
	 * Starts the load queue loading.
	 */
	public function start():Void
	{
		currentItemIndex = 0;
		loadNext();
	}
}

import flash.net.URLRequest;
import away3dlite.loaders.utils.TextureLoader;


typedef LoaderAndRequest = {
	
	public var loader:TextureLoader;
	public var request:URLRequest;
	
}