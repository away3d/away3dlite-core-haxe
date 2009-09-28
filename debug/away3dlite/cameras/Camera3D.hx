//OK

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
		
		if(_fieldOfViewDirty) {
			_fieldOfViewDirty = false;
			_projection.fieldOfView = 360*Math.atan2(stage.stageWidth, 2*_zoom*_focus)/Math.PI;
		}
		
		_projectionMatrix3D = transform.matrix3D.clone();
		_projectionMatrix3D.prependTranslation(0, 0, -_focus);
		_projectionMatrix3D.invert();
		_projectionMatrix3D.append(_projection.toMatrix3D());
	}
	
	private var _focus:Float;
	private var _zoom:Float;
	private var _projection:PerspectiveProjection;
	private var _projectionMatrix3D:Matrix3D;
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
	 * Returns the 3d matrix representing the camera projection for the view.
	 * 
	 * @see away3dlite.containers.View3D#render()
	 */
	public var projectionMatrix3D(get_projectionMatrix3D, null):Matrix3D;
	private function get_projectionMatrix3D():Matrix3D
	{
		return _projectionMatrix3D;
	}
	
	/**
	 * Creates a new <code>Camera3D</code> object.
	 * 
	 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
	 * @param zoom		Defines the overall scale value of the view.
	 */
	public function new(?zoom:Float = 10, ?focus:Float = 100)
	{
		super();
		
		_projectionMatrix3D = new Matrix3D();
		_fieldOfViewDirty = true;
		
		this.zoom = zoom;
		this.focus = focus;
	}
}

