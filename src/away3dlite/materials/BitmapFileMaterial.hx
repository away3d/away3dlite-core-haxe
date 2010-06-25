package away3dlite.materials;

import away3dlite.events.MaterialEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;

using away3dlite.haxeutils.HaxeUtils;

/**
 * Dispatched when the material completes a file load successfully.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="loadSuccess",type="away3dlite.events.MaterialEvent")]
			
 /**
 * Dispatched when the material fails to load a file.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="loadError",type="away3dlite.events.MaterialEvent")]
			
 /**
 * Dispatched every frame the material is loading.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="loadProgress",type="away3dlite.events.MaterialEvent")]

/**
* Bitmap material that loads it's texture from an external bitmapasset file.
*/
class BitmapFileMaterial extends BitmapMaterial
{
	private var _loader:Loader;
	private var _materialloaderror:MaterialEvent;
	private var _materialloadprogress:MaterialEvent;
	private var _materialloadsuccess:MaterialEvent;
	
	private function onError(e:IOErrorEvent):Void
	{			
		if (_materialloaderror == null)
			_materialloaderror = new MaterialEvent(MaterialEvent.LOAD_ERROR, this);
		
		dispatchEvent(_materialloaderror);
	}
	
	private function onProgress(e:ProgressEvent):Void
	{
		if (_materialloadprogress == null)
			_materialloadprogress = new MaterialEvent(MaterialEvent.LOAD_PROGRESS, this);
		
		dispatchEvent(_materialloadprogress);
	}
	
	private function onComplete(e:Event):Void
	{
		bitmap = _loader.content.downcast(Bitmap).bitmapData;
		
		if (_materialloadsuccess == null)
			_materialloadsuccess = new MaterialEvent(MaterialEvent.LOAD_SUCCESS, this);
		
		dispatchEvent(_materialloadsuccess);
	}
	
	/**
	 * Creates a new <code>BitmapFileMaterial</code> object.
	 *
	 * @param	url					The location of the bitmapasset to load.
	 */
	public function new(?url:String="")
	{
		super(new BitmapData(100,100));
		
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		_loader.load(new URLRequest(url));
	}
}