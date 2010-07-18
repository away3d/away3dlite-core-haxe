//OK

package away3dlite.core.clip;
import away3dlite.containers.View3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.events.ClippingEvent;
import away3dlite.haxeutils.FastStd;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.Vector;
import flash.display.StageScaleMode;
import flash.display.StageAlign;

/**
 * Dispatched when the clipping properties of a clipping object update.
 * 
 * @eventType away3dlite.events.ClipEvent
 * 
 * @see #maxX
 * @see #minX
 * @see #maxY
 * @see #minY
 * @see #maxZ
 * @see #minZ
 */
//[Event(name="clippingUpdated",type="away3dlite.events.ClippingEvent")]

/**
 * Dispatched when the clipping properties of a screenClipping object update.
 * 
 * @eventType away3dlite.events.ClipEvent
 * 
 * @see #maxX
 * @see #minX
 * @see #maxY
 * @see #minY
 * @see #maxZ
 * @see #minZ
 */
//[Event(name="screenUpdated",type="away3dlite.events.ClippingEvent")]

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* Base clipping class for no clipping.
*/
class Clipping extends EventDispatcher
{
	/** @private */
	/*arcane*/ private function setView(view:View3D):Void
	{
		_view = view;
	}
	/** @private */
	/*arcane*/ private function collectFaces(mesh:Mesh, faces:Vector<Face>):Void
	{
		_faces = mesh.arcaneNS()._faces;
		_screenVertices = mesh.arcaneNS()._screenVertices;
		
		for (_face in _faces)
			if (mesh.bothsides || _screenVertices[_face.x0]*(_screenVertices[_face.y2] - _screenVertices[_face.y1]) + _screenVertices[_face.x1]*(_screenVertices[_face.y0] - _screenVertices[_face.y2]) + _screenVertices[_face.x2]*(_screenVertices[_face.y1] - _screenVertices[_face.y0]) > 0)
				faces[faces.length] = _face;
	}
	/** @private */
	/*arcane*/ private function screen(container:Sprite, _loaderWidth:Float, _loaderHeight:Float):Clipping
	{
		if (_clippingClone == null) {
			_clippingClone = clone();
			_clippingClone.addEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdate);
		}
		
		_stage = container.stage;
		
		if (_stage.scaleMode == StageScaleMode.NO_SCALE) {
			_stageWidth = _stage.stageWidth;
			_stageHeight = _stage.stageHeight;
		} else if (_stage.scaleMode == StageScaleMode.EXACT_FIT) {
			_stageWidth = _loaderWidth;
			_stageHeight = _loaderHeight;
		} else if (_stage.scaleMode == StageScaleMode.SHOW_ALL) {
			if (_stage.stageWidth/_loaderWidth < _stage.stageHeight/_loaderHeight) {
				_stageWidth = _loaderWidth;
				_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
			} else {
				_stageHeight = _loaderHeight;
				_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
			}
		} else if (_stage.scaleMode == StageScaleMode.NO_BORDER) {
			if (_stage.stageWidth/_loaderWidth > _stage.stageHeight/_loaderHeight) {
				_stageWidth = _loaderWidth;
				_stageHeight = _stage.stageHeight*_stageWidth/_stage.stageWidth;
			} else {
				_stageHeight = _loaderHeight;
				_stageWidth = _stage.stageWidth*_stageHeight/_stage.stageHeight;
			}
		}
		
		if(_stage.align == StageAlign.TOP_LEFT) {
			
			_localPointTL.x = 0;
			_localPointTL.y = 0;
			
			_localPointBR.x = _stageWidth;
			_localPointBR.y = _stageHeight;
			
		} else if(_stage.align == StageAlign.TOP_RIGHT) {
			
			_localPointTL.x = _loaderWidth - _stageWidth;
			_localPointTL.y = 0;
			
			_localPointBR.x = _loaderWidth;
			_localPointBR.y = _stageHeight;
			
		} else if(_stage.align==StageAlign.BOTTOM_LEFT) {
			
			_localPointTL.x = 0;
			_localPointTL.y = _loaderHeight - _stageHeight;
			
			_localPointBR.x = _stageWidth;
			_localPointBR.y = _loaderHeight;
			
		} else if(_stage.align==StageAlign.BOTTOM_RIGHT) {
			
			_localPointTL.x = _loaderWidth - _stageWidth;
			_localPointTL.y = _loaderHeight - _stageHeight;
			
			_localPointBR.x = _loaderWidth;
			_localPointBR.y = _loaderHeight;
			
		} else if(_stage.align == StageAlign.TOP) {
			
			_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
			_localPointTL.y = 0;
			
			_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
			_localPointBR.y = _stageHeight;
			
		} else if(_stage.align==StageAlign.BOTTOM) {
			
			_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
			_localPointTL.y = _loaderHeight - _stageHeight;
			
			_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
			_localPointBR.y = _loaderHeight;
			
		} else if(_stage.align==StageAlign.LEFT) {
			
			_localPointTL.x = 0;
			_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
			
			_localPointBR.x = _stageWidth;
			_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
			
		} else if(_stage.align==StageAlign.RIGHT) {
			
			_localPointTL.x = _loaderWidth - _stageWidth;
			_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
			
			_localPointBR.x = _loaderWidth;
			_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
			
		} else {
			
			_localPointTL.x = _loaderWidth/2 - _stageWidth/2;
			_localPointTL.y = _loaderHeight/2 - _stageHeight/2;
			
			_localPointBR.x = _loaderWidth/2 + _stageWidth/2;
			_localPointBR.y = _loaderHeight/2 + _stageHeight/2;
		}
		
		_globalPointTL = container.globalToLocal(_localPointTL);
		_globalPointBR = container.globalToLocal(_localPointBR);
		
		_miX = _globalPointTL.x;
		_miY = _globalPointTL.y;
		_maX = _globalPointBR.x;
		_maY = _globalPointBR.y;
		
		if (_minX > _miX)
			_clippingClone.minX = _minX;
		else
			_clippingClone.minX = _miX;
		
		if (_maxX < _maX)
			_clippingClone.maxX = _maxX;
		else
			_clippingClone.maxX = _maX;
		
		if (_minY > _miY)
			_clippingClone.minY = _minY;
		else
			_clippingClone.minY = _miY;
		
		if (_maxY < _maY)
			_clippingClone.maxY = _maxY;
		else
			_clippingClone.maxY = _maY;
		
		_clippingClone.minZ = _minZ;
		_clippingClone.maxZ = _maxZ;
		
		return _clippingClone;
	}
	
	private var _clippingClone:Clipping;
	private var _stage:Stage;
	private var _stageWidth:Float;
	private var _stageHeight:Float;
	private var _localPointTL:Point;
	private var _localPointBR:Point;
	private var _globalPointTL:Point;
	private var _globalPointBR:Point;
	private var _miX:Float;
	private var _miY:Float;
	private var _maX:Float;
	private var _maY:Float;
	private var _clippingupdated:ClippingEvent;
	private var _screenupdated:ClippingEvent;
	
	private var _view:View3D;
	private var _face:Face;
	private var _faces:Vector<Face>;
	private var _screenVertices:Vector<Float>;
	private var _uvtData:Vector<Float>;
	private var _index:Int;
	private var _indexX:Int;
	private var _indexY:Int;
	private var _indexZ:Int;
	private var _screenVerticesCull:Vector<Int>;
	private var _cullCount:Int;
	private var _cullTotal:Int;
	private var _minX:Float;
	private var _minY:Float;
	private var _minZ:Float;
	private var _maxX:Float;
	private var _maxY:Float;
	private var _maxZ:Float;
	
	private function onScreenUpdate(event:ClippingEvent):Void
	{
		notifyScreenUpdate();
	}
	
	private function notifyClippingUpdate():Void
	{
		if (!hasEventListener(ClippingEvent.CLIPPING_UPDATED))
			return;
		
		if (_clippingupdated == null)
			_clippingupdated = new ClippingEvent(ClippingEvent.CLIPPING_UPDATED, this);
			
		dispatchEvent(_clippingupdated);
	}
	
	private function notifyScreenUpdate():Void
	{
		if (!hasEventListener(ClippingEvent.SCREEN_UPDATED))
			return;
		
		if (_screenupdated == null)
			_screenupdated = new ClippingEvent(ClippingEvent.SCREEN_UPDATED, this);
			
		dispatchEvent(_screenupdated);
	}
	
	/**
	 * Minimum allowed x value for primitives.
	 */
	public var minX(get_minX, set_minX):Float;
	private function get_minX():Float
	{
		return _minX;
	}
	
	private function set_minX(value:Float):Float
	{
		if (_minX == value)
			return value;
		
		_minX = value;
		
		notifyClippingUpdate();
		return value;
	}
	
	/**
	 * Maximum allowed x value for primitives
	 */
	public var maxX(get_maxX, set_maxX):Float;
	private function get_maxX():Float
	{
		return _maxX;
	}
	
	private function set_maxX(value:Float):Float
	{
		if (_maxX == value)
			return value;
		
		_maxX = value;
		
		notifyClippingUpdate();
		return value;
	}
	
	/**
	 * Minimum allowed y value for primitives
	 */
	public var minY(get_minY, set_minY):Float;
	private function get_minY():Float
	{
		return _minY;
	}
	
	private function set_minY(value:Float):Float
	{
		if (_minY == value)
			return value;
		
		_minY = value;
		
		notifyClippingUpdate();
		return value;
	}
			
	/**
	 * Maximum allowed y value for primitives
	 */
	public var maxY(get_maxY, set_maxY):Float;
	private function get_maxY():Float
	{
		return _maxY;
	}
	
	private function set_maxY(value:Float):Float
	{
		if (_maxY == value)
			return value;
		
		_maxY = value;
		
		notifyClippingUpdate();
		return value;
	}
	
	/**
	 * Minimum allowed z value for primitives
	 */
	public var minZ(get_minZ, set_minZ):Float;
	private function get_minZ():Float
	{
		return _minZ;
	}
	
	private function set_minZ(value:Float):Float
	{
		if (_minZ == value)
			return value;
		
		_minZ = value;
		
		notifyClippingUpdate();
		return value;
	}
	
	/**
	 * Maximum allowed z value for primitives
	 */
	public var maxZ(get_maxZ, set_maxZ):Float;
	private function get_maxZ():Float
	{
		return _maxZ;
	}
	
	private function set_maxZ(value:Float):Float
	{
		if (_maxZ == value)
			return value;
		
		_maxZ = value;
		
		notifyClippingUpdate();
		return value;
	}
	
	/**
	 * Creates a new <code>Clipping</code> object.
	 * 
	 * @param minX	Minimum allowed x value for primitives.
	 * @param maxX	Maximum allowed x value for primitives.
	 * @param minY	Minimum allowed y value for primitives.
	 * @param maxY	Maximum allowed y value for primitives.
	 * @param minZ	Minimum allowed z value for primitives.
	 * @param maxZ	Maximum allowed z value for primitives.
	 */
	public function new(minX:Float = -10000, maxX:Float = 10000, minY:Float = -10000, maxY:Float = 10000, minZ:Float = -10000, maxZ:Float = 10000)
	{
		super();
		
		_localPointTL = new Point(0, 0);
		_localPointBR = new Point(0, 0);
		_globalPointTL = new Point(0, 0);
		_globalPointBR = new Point(0, 0);
		_screenVerticesCull = new Vector<Int>();
	
		_minX = minX;
		_maxX = maxX;
		_minY = minY;
		_maxY = maxY;
		_minZ = minZ;
		_maxZ = maxZ;
	}
	
	/**
	 * Duplicates the clipping object's properties to another <code>Clipping</code> object
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Clipping</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public function clone(?object:Clipping):Clipping
	{
		var clipping:Clipping = (object != null) ? object : new Clipping();
		
		clipping.minX = minX;
		clipping.minY = minY;
		clipping.minZ = minZ;
		clipping.maxX = maxX;
		clipping.maxY = maxY;
		clipping.maxZ = maxZ;
		
		return clipping;
	}
	
	/**
	 * Used to trace the values of a clipping object.
	 * 
	 * @return		A string representation of the clipping object.
	 */
	public override function toString():String
	{
		return "{minX:" + minX + " maxX:" + maxX + " minY:" + minY + " maxY:" + maxY + " minZ:" + minZ + " maxZ:" + maxZ + "}";
	}
}