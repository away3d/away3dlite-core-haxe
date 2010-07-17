package away3dlite.loaders
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	import away3dlite.core.utils.*;
	import away3dlite.events.*;
	import away3dlite.loaders.data.*;
	import away3dlite.loaders.utils.*;
	import away3dlite.materials.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	use namespace arcane;
    
	 /**
	 * Dispatched when the 3d object parser completes a file parse successfully.
	 * 
	 * @eventType away3dlite.events.ParserEvent
	 */
	[Event(name="parseSuccess",type="away3dlite.events.ParserEvent")]
    			
	 /**
	 * Dispatched when the 3d object parser fails to parse a file.
	 * 
	 * @eventType away3dlite.events.ParserEvent
	 */
	[Event(name="parseError",type="away3dlite.events.ParserEvent")]
	    			
	 /**
	 * Dispatched when the 3d object parser progresses by one chunk.
	 * 
	 * @eventType away3dlite.events.ParserEvent
	 */
	[Event(name="parseProgress",type="away3dlite.events.ParserEvent")]
	
    /**
    * Abstract parsing object used as a base class for all loaders to extend from.
    */
	public class AbstractParser extends EventDispatcher
	{
		/** @private */
    	arcane var _container:Object3D;
		/** @private */
    	arcane var binary:Boolean;
		/** @private */
    	arcane var _totalChunks:int = 0;
        /** @private */
    	arcane var _parsedChunks:int = 0;
		/** @private */
    	arcane var _parsesuccess:ParserEvent;
		/** @private */
    	arcane var _parseerror:ParserEvent;
		/** @private */
    	arcane var _parseprogress:ParserEvent;
		/** @private */
    	arcane function notifyProgress():void
		{
        	_parseTime = getTimer() - _parseStart;
        	
        	if (_parseTime < parseTimeout) {
        		parseNext();
        	}else {
        		_parseStart = getTimer();
	        	
				if (!_parseprogress)
	        		_parseprogress = new ParserEvent(ParserEvent.PARSE_PROGRESS, this, container);
	        	
	        	dispatchEvent(_parseprogress);
        	}
		}
		/** @private */
    	arcane function notifySuccess():void
		{
			_broadcaster.removeEventListener(Event.ENTER_FRAME, update);
			
			if (!_parsesuccess)
        		_parsesuccess = new ParserEvent(ParserEvent.PARSE_SUCCESS, this, container);
        	
        	dispatchEvent(_parsesuccess);
		}
		/** @private */
    	arcane function notifyError():void
		{
			_broadcaster.removeEventListener(Event.ENTER_FRAME, update);
			
			if (!_parseerror)
        		_parseerror = new ParserEvent(ParserEvent.PARSE_ERROR, this, container);
        	
        	dispatchEvent(_parseerror);
		}
        /** @private */
		arcane function prepareData(data:*):void
        {
        }
        /** @private */
		arcane function parseNext():void
        {
        	notifySuccess();
        }
        
        private var _broadcaster:Sprite = new Sprite();
        private var _parseStart:int;
        private var _parseTime:int;
        private var _materials:Object;
        
        private function update(event:Event):void
        {
        	parseNext();
        }
        
		/** @private */
		protected var _materialLibrary:MaterialLibrary;
		
		/** @private */
        protected var _geometryLibrary:GeometryLibrary;
        
		/** @private */
		protected function buildMaterials():void
		{
			for each (var _materialData:MaterialData in _materialLibrary)
			{
				Debug.trace(" + Build Material : " + _materialData.name);
				
				//overridden by the material property in constructor
				if (material)
					_materialData.material = material;
				
				//overridden by materials passed in contructor
				if (_materialData.material)
					continue;
				
				switch (_materialData.materialType)
				{
					case MaterialData.TEXTURE_MATERIAL:
						_materialLibrary.loadRequired = true;
						break;
					case MaterialData.COLOR_MATERIAL:
						_materialData.material = new ColorMaterial(_materialData.diffuseColor, _materialData.alpha);
						break;
					//case MaterialData.SHADING_MATERIAL:
					//	_materialData.material = new ShadingColorMaterial({ambient:_materialData.ambientColor, diffuse:_materialData.diffuseColor, specular:_materialData.specularColor});
					//	break;
					case MaterialData.WIREFRAME_MATERIAL:
						_materialData.material = new WireframeMaterial();
						break;
				}
			}
		}
		/**
		 * Defines a timeout period for file parsing (in milliseconds).
		 */
		public var parseTimeout:int = 40000;

    	/**
    	 * Overrides all materials in the model.
    	 */
        public var material:Material;
        
    	/**
    	 * Overides materials in the model using name:value pairs.
    	 */
        public function get materials():Object
        {
        	return _materials;
        }
		
		public function set materials(val:Object):void
		{
			_materials = val;
			
			//organise the materials
			var _materialData:MaterialData;
            for (var name:String in _materials) {
                _materialData = materialLibrary.addMaterial(name);
                _materialData.material = Cast.material(_materials[name]);
				
                //determine material type
                if (_materialData.material is BitmapMaterial)
                	_materialData.materialType = MaterialData.TEXTURE_MATERIAL;
                else if (_materialData.material is ColorMaterial)
                	_materialData.materialType = MaterialData.COLOR_MATERIAL;
                //else if (_materialData.material is ShadingColorMaterial)
                //	_materialData.materialType = MaterialData.SHADING_MATERIAL;
                else if (_materialData.material is WireframeMaterial)
                	_materialData.materialType = MaterialData.WIREFRAME_MATERIAL;
   			}
		}
		
    	/**
    	 * Returns the total number of data chunks parsed
    	 */
		public function get parsedChunks():int
		{
			return _parsedChunks;
		}
    	
    	/**
    	 * Returns the total number of data chunks available
    	 */
		public function get totalChunks():int
		{
			return _totalChunks;
		}
		
        /**
        * Retuns a materialLibrary object used for storing the parsed material objects.
        */
		public function get materialLibrary():MaterialLibrary
		{
			return _materialLibrary;
		}
		
        /**
        * Retuns a geometryLibrary object used for storing the parsed geometry data.
        */
		public function get geometryLibrary():GeometryLibrary
		{
			return _geometryLibrary;
		}
		
        /**
        * Retuns a 3d container object used for storing the parsed 3d object.
        */
		public function get container():Object3D
		{
			return _container;
		}
		
		/**
		 * Creates a new <code>AbstractParser</code> object.
		 *
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function AbstractParser()
        {
        	//setup default libs
        	_materialLibrary = new MaterialLibrary();
			_geometryLibrary = new GeometryLibrary();
        }
        
		/**
         * Parses 3d file data.
         * 
		 * @param	data		The file data to be parsed. Can be in text or binary form.
		 * 
         * @return				The parsed 3d object.
         */
        public function parseGeometry(data:*):Object3D
        {
        	_broadcaster.addEventListener(Event.ENTER_FRAME, update);
        	
        	prepareData(data);
        	
        	//start parsing
        	_parseStart = getTimer();
        	parseNext();
        	
        	return container;
        }
        
		/**
		 * Default method for adding a parseSuccess event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnSuccess(listener:Function):void
        {
            addEventListener(ParserEvent.PARSE_SUCCESS, listener, false, 0, true);
        }
		
		/**
		 * Default method for removing a parseSuccess event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnSuccess(listener:Function):void
        {
            removeEventListener(ParserEvent.PARSE_SUCCESS, listener, false);
        }
		
		/**
		 * Default method for adding a parseError event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnError(listener:Function):void
        {
            addEventListener(ParserEvent.PARSE_ERROR, listener, false, 0, true);
        }
		
		/**
		 * Default method for removing a parseError event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnError(listener:Function):void
        {
            removeEventListener(ParserEvent.PARSE_ERROR, listener, false);
        }
        
		/**
		 * Default method for adding a parseProgress event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnProgress(listener:Function):void
        {
            addEventListener(ParserEvent.PARSE_PROGRESS, listener, false, 0, true);
        }
		
		/**
		 * Default method for removing a parseProgress event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnProgress(listener:Function):void
        {
            removeEventListener(ParserEvent.PARSE_PROGRESS, listener, false);
        }
	}
}