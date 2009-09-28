package away3dlite.materials
{
	import away3dlite.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	 /**
	 * Dispatched when the material completes a file load successfully.
	 * 
	 * @eventType away3dlite.events.MaterialEvent
	 */
	[Event(name="loadSuccess",type="away3d.events.MaterialEvent")]
    			
	 /**
	 * Dispatched when the material fails to load a file.
	 * 
	 * @eventType away3dlite.events.MaterialEvent
	 */
	[Event(name="loadError",type="away3d.events.MaterialEvent")]
    			
	 /**
	 * Dispatched every frame the material is loading.
	 * 
	 * @eventType away3dlite.events.MaterialEvent
	 */
	[Event(name="loadProgress",type="away3d.events.MaterialEvent")]
	
    /**
    * Bitmap material that loads it's texture from an external bitmapasset file.
    */
    public class BitmapFileMaterial extends BitmapMaterial
    {
		private var _loader:Loader;
		private var _materialloaderror:MaterialEvent;
		private var _materialloadprogress:MaterialEvent;
		private var _materialloadsuccess:MaterialEvent;
		
		private function onError(e:IOErrorEvent):void
		{			
			if (!_materialloaderror)
				_materialloaderror = new MaterialEvent(MaterialEvent.LOAD_ERROR, this);
			
            dispatchEvent(_materialloaderror);
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			if (!_materialloadprogress)
				_materialloadprogress = new MaterialEvent(MaterialEvent.LOAD_PROGRESS, this);
			
            dispatchEvent(_materialloadprogress);
		}
		
		private function onComplete(e:Event):void
		{
			bitmap = Bitmap(_loader.content).bitmapData;
			
			if (!_materialloadsuccess)
				_materialloadsuccess = new MaterialEvent(MaterialEvent.LOAD_SUCCESS, this);
			
            dispatchEvent(_materialloadsuccess);
		}
    	
		/**
		 * Creates a new <code>BitmapFileMaterial</code> object.
		 *
		 * @param	url					The location of the bitmapasset to load.
		 */
		public function BitmapFileMaterial(url:String="")
        {
            super(new BitmapData(100,100));
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.load(new URLRequest(url));
        }
    }
}