package away3dlite.cameras;

import away3dlite.cameras.lenses.AbstractLens;
import away3dlite.cameras.lenses.ZoomFocusLens;
import away3dlite.containers.View3D;
import away3dlite.core.base.Object3D;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Utils3D;
import flash.geom.Vector3D;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * Basic camera used to resolve a view.
 * 
 * @see	away3dlite.containers.View3D
 */
class Camera3D extends Object3D
{
	/** @private */
	/*arcane*/ private var _view:View3D;
	/** @private */
	/*arcane*/ private var _lens:AbstractLens;
	/*arcane*/ private var _invSceneMatrix3D:Matrix3D;
	/*arcane*/ private var _projectionMatrix3D:Matrix3D;
	/*arcane*/ private var _screenMatrix3D:Matrix3D;
	/** @private */
	/*arcane*/ private function update():Void
	{
		if(_lensDirty) {
			_lensDirty = false;
			_lens.arcaneNS()._update();
			_projectionMatrix3D = _lens.arcaneNS()._projectionMatrix3D;
		}
		
		_invSceneMatrix3D.rawData = _sceneMatrix3D.rawData = transform.matrix3D.rawData;
		_invSceneMatrix3D.invert();
		
		_screenMatrix3D.rawData = _invSceneMatrix3D.rawData;
		_screenMatrix3D.append(_projectionMatrix3D);
	}
	
	private var _focus:Float;
	private var _zoom:Float;
	private var _lensDirty:Bool;
	
	private static inline var toRADIANS:Float = Math.PI/180;
	private static inline var toDEGREES:Float = 180/Math.PI;
	
	/**
	 * Defines the distance from the focal point of the camera to the viewing plane.
	 */
	public var focus(get_focus, set_focus):Float;
	private function get_focus():Float
	{
		return _focus;
	}
	private function set_focus(val:Float):Float
	{
		_focus = val;
		
		_lensDirty = true;
		return val;
	}
	
	/**
	 * Defines the overall scale value of the view.
	 */
	public var zoom(get_zoom, set_zoom):Float;
	private function get_zoom():Float
	{
		return _zoom;
	}
	
	private function set_zoom(val:Float):Float
	{
		_zoom = val;
		
		_lensDirty = true;
		return val;
	}
	
	/**
	 * Returns the 3d matrix representing the camera inverse scene transform for the view.
	 */
	public var invSceneMatrix3D(get_invSceneMatrix3D, null):Matrix3D;
	private function get_invSceneMatrix3D():Matrix3D
	{
		return _invSceneMatrix3D;
	}
		
	/**
	 * Returns the 3d matrix representing the camera projection for the view.
	 * 
	 **/
	public var projectionMatrix3D(get_projectionMatrix3D, null):Matrix3D;
	private function get_projectionMatrix3D():Matrix3D
	{
		return _projectionMatrix3D;
	}
	
	/**
	 * Returns the 3d matrix used in resolving screen space for the render loop.
	 * 
	 * @see away3dlite.containers.View3D#render()
	 */
	public var screenMatrix3D(get_screenMatrix3D, null):Matrix3D;
	private function get_screenMatrix3D():Matrix3D
	{
		return _screenMatrix3D;
	}
	
	public var lens(get_lens, set_lens):AbstractLens;
	private function get_lens():AbstractLens
	{
		return _lens;
	}
	
	private function set_lens(val:AbstractLens):AbstractLens
	{
		if (_lens == val)
		{
			return val;
		}
		else
		{		
			if (_lens != null)
				_lens.arcaneNS()._camera = null;
			
			_lens = val;
			
			if (_lens != null)
				_lens.arcaneNS()._camera = this;
			else
				throw "Camera cannot have lens set to null";
			
			_lensDirty = true;
			return val;
		}
	}
	
	/**
	 * Creates a new <code>Camera3D</code> object.
	 * 
	 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
	 * @param zoom		Defines the overall scale value of the view.
	 */
	public function new(?zoom:Float = 10, ?focus:Float = 100, ?lens:AbstractLens = null)
	{
		super();
		
		_screenMatrix3D = new Matrix3D();
		_invSceneMatrix3D = new Matrix3D();
		
		this.lens = (lens != null) ? lens : new ZoomFocusLens();
		this.zoom = zoom;
		this.focus = focus;
		
		//set default z position
		z = -1000;
	}
	
	/**
	 * Rotates the <code>Camera3D</code> object around an axis by a defined degrees.
	 *
	 * @param	degrees		The degree of the rotation.
	 * @param	axis		The axis or direction of rotation. The usual axes are the X_AXIS (Vector3D(1,0,0)), Y_AXIS (Vector3D(0,1,0)), and Z_AXIS (Vector3D(0,0,1)).
	 * @param	pivotPoint	A point that determines the center of an object's rotation. The default pivot point for an object is its registration point.
	 */
	override public function rotate(degrees:Float, axis:Vector3D, pivotPoint:Vector3D = null):Void
	{
		axis.normalize();
		var _matrix3D:Matrix3D = transform.matrix3D;
		// keep current position
		var _position:Vector3D = _matrix3D.position.clone();
		// need only rotation matrix
		_matrix3D.position = new Vector3D();
		// rotate
		_matrix3D.appendRotation(degrees, _matrix3D.deltaTransformVector(axis), pivotPoint);
		// restore current position
		_matrix3D.position = _position;
	}

	/**
   	 * Returns a <code>Vector3D</code> object describing the resolved x and y position of the given 3d vertex position.
   	 * 
   	 * @param	vertex	The vertex to be resolved.
   	 */
	public function screen(vertex:Vector3D):Vector3D
	{
		update();
		
		return Utils3D.projectVector(_screenMatrix3D, vertex);
	}
}

