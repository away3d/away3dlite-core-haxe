package away3dlite.loaders;
import away3dlite.core.base.Object3D;
import away3dlite.core.utils.Cast;
import away3dlite.events.ParserEvent;
import away3dlite.haxeutils.FastStd;
import away3dlite.loaders.data.MaterialData;
import away3dlite.loaders.utils.GeometryLibrary;
import away3dlite.loaders.utils.MaterialLibrary;
import away3dlite.materials.BitmapMaterial;
import away3dlite.materials.ColorMaterial;
import away3dlite.materials.Material;
import away3dlite.materials.WireframeMaterial;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.Lib;


//use namespace arcane;
using away3dlite.namespace.Arcane;

 /**
 * Dispatched when the 3d object parser completes a file parse successfully.
 * 
 * @eventType away3dlite.events.ParserEvent
 */
//[Event(name="parseSuccess",type="away3dlite.events.ParserEvent")]
			
 /**
 * Dispatched when the 3d object parser fails to parse a file.
 * 
 * @eventType away3dlite.events.ParserEvent
 */
//[Event(name="parseError",type="away3dlite.events.ParserEvent")]
				
 /**
 * Dispatched when the 3d object parser progresses by one chunk.
 * 
 * @eventType away3dlite.events.ParserEvent
 */
//[Event(name="parseProgress",type="away3dlite.events.ParserEvent")]

/**
* Abstract parsing object used as a base class for all loaders to extend from.
*/
class AbstractParser extends EventDispatcher
{
	/** @private */
	/*arcane*/ private var _container:Object3D;
	/** @private */
	/*arcane*/ private var binary:Bool;
	/** @private */
	/*arcane*/ private var _totalChunks:Int;
	/** @private */
	/*arcane*/ private var _parsedChunks:Int;
	/** @private */
	/*arcane*/ private var _parsesuccess:ParserEvent;
	/** @private */
	/*arcane*/ private var _parseerror:ParserEvent;
	/** @private */
	/*arcane*/ private var _parseprogress:ParserEvent;
	/** @private */
	/*arcane*/ private function notifyProgress():Void
	{
		_parseTime = Lib.getTimer() - _parseStart;
		
		if (_parseTime < parseTimeout) {
			parseNext();
		}else {
			_parseStart = Lib.getTimer();
			
			if (_parseprogress == null)
				_parseprogress = new ParserEvent(ParserEvent.PARSE_PROGRESS, this, container);
			
			dispatchEvent(_parseprogress);
		}
	}
	/** @private */
	/*arcane*/ private function notifySuccess():Void
	{
		_broadcaster.removeEventListener(Event.ENTER_FRAME, update);
		
		if (_parsesuccess == null)
			_parsesuccess = new ParserEvent(ParserEvent.PARSE_SUCCESS, this, container);
		
		dispatchEvent(_parsesuccess);
	}
	/** @private */
	/*arcane*/ private function notifyError():Void
	{
		_broadcaster.removeEventListener(Event.ENTER_FRAME, update);
		
		if (_parseerror == null)
			_parseerror = new ParserEvent(ParserEvent.PARSE_ERROR, this, container);
		
		dispatchEvent(_parseerror);
	}
	/** @private */
	/*arcane*/ private function prepareData(data:Dynamic):Void
	{
	}
	/** @private */
	/*arcane*/ private function parseNext():Void
	{
		notifySuccess();
	}
	
	private var _broadcaster:Sprite;
	private var _parseStart:Int;
	private var _parseTime:Int;
	private var _materials:Dynamic;
	
	private function update(event:Event):Void
	{
		parseNext();
	}
	
	/** @private */
	private var _materialLibrary:MaterialLibrary;
	
	
	/** @private */	
	private var _geometryLibrary:GeometryLibrary;
	
	/** @private */
	private function buildMaterials():Void
	{
		for (_materialData in _materialLibrary)
		{
			//overridden by the material property in constructor
			if (material != null)
				_materialData.material = material;
			
			//overridden by materials passed in contructor
			if (_materialData.material != null)
				continue;
			
			switch (_materialData.materialType)
			{
				case MaterialData.TEXTURE_MATERIAL:
					_materialLibrary.loadRequired = true;
				case MaterialData.COLOR_MATERIAL:
					_materialData.material = new ColorMaterial(_materialData.diffuseColor, _materialData.alpha);
				//case MaterialData.SHADING_MATERIAL:
				//	_materialData.material = new ShadingColorMaterial({ambient:_materialData.ambientColor, diffuse:_materialData.diffuseColor, specular:_materialData.specularColor});
				case MaterialData.WIREFRAME_MATERIAL:
					_materialData.material = new WireframeMaterial();
			}
		}
	}
	/**
	 * Defines a timeout period for file parsing (in milliseconds).
	 */
	public var parseTimeout:Int;

	/**
	 * Overrides all materials in the model.
	 */
	public var material:Material;
	
	/**
	 * Overides materials in the model using name:value pairs.
	 */
	public var materials(get_materials, set_materials):Dynamic;
	private inline function get_materials():Dynamic
	{
		return _materials;
	}
	
	private function set_materials(val:Dynamic):Dynamic
	{
		_materials = val;
		
		//organise the materials
		var _materialData:MaterialData;
		for (name in Reflect.fields(_materials)) {
			_materialData = materialLibrary.addMaterial(name);
			_materialData.material = Cast.material(Reflect.field(_materials,name));
			
			//determine material type
			if (FastStd.is(_materialData.material, BitmapMaterial))
				_materialData.materialType = MaterialData.TEXTURE_MATERIAL;
			else if (FastStd.is(_materialData.material, ColorMaterial))
				_materialData.materialType = MaterialData.COLOR_MATERIAL;
			//else if (_materialData.material is ShadingColorMaterial)
			//	_materialData.materialType = MaterialData.SHADING_MATERIAL;
			else if (FastStd.is(_materialData.material, WireframeMaterial))
				_materialData.materialType = MaterialData.WIREFRAME_MATERIAL;
		}
	}
	
	/**
	 * Returns the total number of data chunks parsed
	 */
	public var parsedChunks(get_parsedChunks, null):Int;
	private inline function get_parsedChunks():Int
	{
		return _parsedChunks;
	}
	
	/**
	 * Returns the total number of data chunks available
	 */
	public var totalChunks(get_totalChunks, null):Int;
	private inline function get_totalChunks():Int
	{
		return _totalChunks;
	}
	
	/**
	* Retuns a materialLibrary object used for storing the parsed material objects.
	*/
	public var materialLibrary(get_materialLibrary, null):MaterialLibrary;
	private inline function get_materialLibrary():MaterialLibrary
	{
		return _materialLibrary;
	}
	
	/**
	* Retuns a geometryLibrary object used for storing the parsed geometry data.
	*/
	public var geometryLibrary(get_geometryLibrary, null):GeometryLibrary;
	private inline function get_geometryLibrary():GeometryLibrary
	{
		return _geometryLibrary;
	}
	
	/**
	* Retuns a 3d container object used for storing the parsed 3d object.
	*/
	public var container(get_container, null):Object3D;
	private inline function get_container():Object3D
	{
		return _container;
	}
	
	/**
	 * Creates a new <code>AbstractParser</code> object.
	 *
	 * @param	init	[optional]	An initialisation object for specifying default instance properties.
	 */
	public function new()
	{
		_totalChunks = 0;
		_parsedChunks = 0;
		_broadcaster = new Sprite();
		parseTimeout = 10000;
		super();
		
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
	public function parseGeometry(data:Dynamic):Object3D
	{
		_broadcaster.addEventListener(Event.ENTER_FRAME, update);
		
		prepareData(data);
		
		//start parsing
		_parseStart = Lib.getTimer();
		parseNext();
		
		return container;
	}
	
	/**
	 * Default method for adding a parseSuccess event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function addOnSuccess(listener:Dynamic -> Void):Void
	{
		addEventListener(ParserEvent.PARSE_SUCCESS, listener, false, 0, true);
	}
	
	/**
	 * Default method for removing a parseSuccess event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function removeOnSuccess(listener:Dynamic -> Void):Void
	{
		removeEventListener(ParserEvent.PARSE_SUCCESS, listener, false);
	}
	
	/**
	 * Default method for adding a parseError event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function addOnError(listener:Dynamic -> Void):Void
	{
		addEventListener(ParserEvent.PARSE_ERROR, listener, false, 0, true);
	}
	
	/**
	 * Default method for removing a parseError event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function removeOnError(listener:Dynamic -> Void):Void
	{
		removeEventListener(ParserEvent.PARSE_ERROR, listener, false);
	}
	
	/**
	 * Default method for adding a parseProgress event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function addOnProgress(listener:Dynamic -> Void):Void
	{
		addEventListener(ParserEvent.PARSE_PROGRESS, listener, false, 0, true);
	}
	
	/**
	 * Default method for removing a parseProgress event listener
	 * 
	 * @param	listener		The listener function
	 */
	public inline function removeOnProgress(listener:Dynamic -> Void):Void
	{
		removeEventListener(ParserEvent.PARSE_PROGRESS, listener, false);
	}
}