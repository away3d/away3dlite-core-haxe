package away3dlite.materials;

import away3dlite.cameras.Camera3D;
import away3dlite.containers.Scene3D;
import away3dlite.core.base.Mesh;
import away3dlite.events.MaterialEvent;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.GraphicsTrianglePath;
import flash.display.IGraphicsData;
import flash.events.EventDispatcher;
import flash.Vector;

using away3dlite.namespace.Arcane;

/**
 * Dispatched when the material becomes visible in a view.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="materialActivated",type="away3dlite.events.MaterialEvent")]
			
/**
 * Dispatched when the material becomes invisible in a view.
 * 
 * @eventType away3dlite.events.MaterialEvent
 */
//[Event(name="materialDeactivated",type="away3dlite.events.MaterialEvent")]


/**
 * Base material class.
 */	
class Material extends EventDispatcher
{
	/** @private */
	/*arcane*/ private var _id:Vector<UInt>;
	/** @private */
	/*arcane*/ private var _faceCount:Vector<UInt>;
	/** @private */
	/*arcane*/ private function notifyActivate(scene:Scene3D):Void
	{
		if (!hasEventListener(MaterialEvent.MATERIAL_ACTIVATED))
			return;
		
		if (_materialactivated == null)
			_materialactivated = new MaterialEvent(MaterialEvent.MATERIAL_ACTIVATED, this);
			
		dispatchEvent(_materialactivated);
	}
	/** @private */
	/*arcane*/ private function notifyDeactivate(scene:Scene3D):Void
	{
		if (!hasEventListener(MaterialEvent.MATERIAL_DEACTIVATED))
			return;
		
		if (_materialdeactivated == null)
			_materialdeactivated = new MaterialEvent(MaterialEvent.MATERIAL_DEACTIVATED, this);
			
		dispatchEvent(_materialdeactivated);
	}
	/** @private */
	/*arcane*/ private function updateMaterial(source:Mesh, camera:Camera3D):Void
	{
		
	}
	
	private static var DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF));
	private var _debug:Bool;
	private var _materialactivated:MaterialEvent;
	private var _materialdeactivated:MaterialEvent;
	
	/** @private */
	private var _graphicsStroke:GraphicsStroke;
	/** @private */
	private var _graphicsBitmapFill:GraphicsBitmapFill;
	/** @private */
	private var _graphicsEndFill:GraphicsEndFill;
	/** @private */
	private var _triangles:GraphicsTrianglePath;
	/** @private */
	public var graphicsData:Vector<IGraphicsData>;
	/** @private */
	public var trianglesIndex:Int;
	
	/**
	 * Creates a new <code>Material</code> object.
	 */
	public function new() 
	{
		super();
		
		_id = new Vector<UInt>();
		_faceCount = new Vector<UInt>();
		
		_debug = false;
		_graphicsStroke = new GraphicsStroke();
		_graphicsBitmapFill = new GraphicsBitmapFill();
		_graphicsEndFill = new GraphicsEndFill();
	}
	
	/**
	 * Switches on the debug outlines around each face drawn with the material. Defaults to false.
	 */
	public var debug(get_debug, set_debug):Bool;
	private function get_debug():Bool
	{
		return _debug;
	}
	private function set_debug(val:Bool):Bool
	{
		if (_debug == val)
			return val;
			
		_debug = val;
		
		graphicsData.fixed = false;
		
		if(_debug) {
			graphicsData.shift();
			graphicsData.unshift(DEBUG_STROKE);
		} else {
			graphicsData.shift();
			graphicsData.unshift(_graphicsStroke);
		}
		
		graphicsData.fixed = true;
		return val;
	}
}