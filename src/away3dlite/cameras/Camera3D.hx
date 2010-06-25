package away3dlite.cameras;

import away3dlite.containers.View3D;
import away3dlite.core.base.Object3D;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;

//use namespace arcane;

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
	/*arcane*/ private function update():Void
	{
		_projection = root.transform.perspectiveProjection;
		
		/*if(_fieldOfViewDirty) {
			_fieldOfViewDirty = false;
			//_projection.fieldOfView = 360*Math.atan2(stage.stageWidth, 2*_zoom*_focus)/Math.PI;
			_projection.focalLength = _zoom * _focus;
		}*/
		
		_projectionMatrix3D = _projection.toMatrix3D();
		
		_invSceneMatrix3D = transform.matrix3D.clone();
		_invSceneMatrix3D.prependTranslation(0, 0, -_focus);
		_invSceneMatrix3D.invert();
		
		_screenMatrix3D = _invSceneMatrix3D.clone();
		_screenMatrix3D.append(_projectionMatrix3D);
	}
	
	private var _focus:Float;
	private var _zoom:Float;
	private var _projection:PerspectiveProjection;
	private var _projectionMatrix3D:Matrix3D;
	private var _screenMatrix3D:Matrix3D;
	private var _invSceneMatrix3D:Matrix3D;
	private var _fieldOfViewDirty:Bool;
	
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
		
		_fieldOfViewDirty = true;
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
		
		_fieldOfViewDirty = true;
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
	
	/**
	 * Creates a new <code>Camera3D</code> object.
	 * 
	 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
	 * @param zoom		Defines the overall scale value of the view.
	 */
	public function new(?zoom:Float = 10, ?focus:Float = 10)
	{
		super();
		
		_screenMatrix3D = new Matrix3D();
		_invSceneMatrix3D = new Matrix3D();
		_fieldOfViewDirty = true;
		
		this.zoom = zoom;
		this.focus = focus;
		
		//set default z position
		#if flash9
		z = -1000;
		
		#else
		z = 1000;
		
		#end
	}
}

