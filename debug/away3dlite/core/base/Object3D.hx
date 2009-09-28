//OK

package away3dlite.core.base;
import away3dlite.containers.Scene3D;
import away3dlite.loaders.utils.AnimationLibrary;
import away3dlite.loaders.utils.GeometryLibrary;
import away3dlite.loaders.utils.MaterialLibrary;
import flash.display.Sprite;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;

//use namespace arcane;

/**
 * Dispatched when a user moves the cursor while it is over the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="mouseMove",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user presses the left hand mouse button while the cursor is over the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="mouseDown",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user releases the left hand mouse button while the cursor is over the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="mouseUp",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user moves the cursor over the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="mouseOver",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user moves the cursor away from the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="mouseOut",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user rolls over the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="rollOver",type="away3dlite.events.MouseEvent3D")]

/**
 * Dispatched when a user rolls out of the 3d object.
 * 
 * @eventType away3dlite.events.MouseEvent3D
 */
//[Event(name="rollOut",type="away3dlite.events.MouseEvent3D")]

/**
 * The base class for all 3d objects.
 */
class Object3D extends Sprite
{
	/** @private */
	/*arcane*/ private var _screenZ:Float;
	/** @private */
	/*arcane*/ private var _scene:Scene3D;
	/** @private */
	/*arcane*/ private var _viewMatrix3D:Matrix3D;
	/** @private */
	/*arcane*/ private var _sceneMatrix3D:Matrix3D;
	/** @private */
	/*arcane*/ private var _mouseEnabled:Bool;
	/** @private */
	/*arcane*/ private function updateScene(val:Scene3D):Void
	{
	}
	/** @private */
	/*arcane*/ private function project(projectionMatrix3D:Matrix3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		_sceneMatrix3D = transform.matrix3D.clone();
		
		if (parentSceneMatrix3D != null)
			_sceneMatrix3D.append(parentSceneMatrix3D);
			
		_viewMatrix3D = _sceneMatrix3D.clone();
		_viewMatrix3D.append(projectionMatrix3D);
		
		_screenZ = _viewMatrix3D.position.z;
	}
	
	/**
	 * An optional layer sprite used to draw into inseatd of the default view.
	 */
	public var layer:Sprite;
	
	/**
	 * Used in loaders to store all parsed materials contained in the model.
	 */
	public var materialLibrary:MaterialLibrary;
	
	/**
	 * Used in loaders to store all parsed geometry data contained in the model.
	 */
	public var geometryLibrary:GeometryLibrary;
	
	/**
	 * Used in the loaders to store all parsed animation data contained in the model.
	 */
	public var animationLibrary:AnimationLibrary;
	
	/**
	 * Returns the type of 3d object.
	 */
	public var type:String;
	
	/**
	 * Returns the source url of the 3d object, or the name of the family of generative geometry objects if not loaded from an external source.
	 */
	public var url:String;
	
	/**
	 * <i>haXe specific</i> : Height property must be called as _height, due to haXe limitation.
	 */
	public var _height(get__height, set__height):Float;
	private function get__height():Float { return height; }
	private function set__height(val:Float):Float { return this.height = val;}
	
	/**
	 * <i>haXe specific</i> : Width property must be called as _width, due to haXe limitation.
	 */
	public var _width(get__width, set__width):Float;
	private function get__width():Float { return width; }
	private function set__width(val:Float):Float { return this.width = val; }
	
	/**
	 * Returns the scene to which the 3d object belongs
	 */
	public var scene(get_scene, null):Scene3D;
	private function get_scene():Scene3D
	{
		return _scene;
	}
	
	/**
	 * Returns the z-sorting position of the 3d object.
	 */
	public var screenZ(get_screenZ, null):Float;
	private inline function get_screenZ():Float
	{
		return _screenZ;
	}
	
	/**
	 * Returns a 3d matrix representing the absolute transformation of the 3d object in the view.
	 */
	public var viewMatrix3D(get_viewMatrix3D, null):Matrix3D;
	private function get_viewMatrix3D():Matrix3D
	{
		return _viewMatrix3D;
	}
	
	/**
	 * Returns a 3d matrix representing the absolute transformation of the 3d object in the scene.
	 */
	public var sceneMatrix3D(get_sceneMatrix3D, null):Matrix3D;
	private function get_sceneMatrix3D():Matrix3D
	{
		return _sceneMatrix3D;
	}
			
	/**
	 * Returns a 3d vector representing the local position of the 3d object.
	 */
	public var position(get_position, null):Vector3D;
	private function get_position():Vector3D
	{
		return transform.matrix3D.position;
	}
	
	/**
	 * Creates a new <code>Object3D</code> object.
	 */
	public function new()
	{
		super();
		
		_screenZ = 0;
		materialLibrary = new MaterialLibrary();
		geometryLibrary = new GeometryLibrary();
		animationLibrary = new AnimationLibrary();
		
		//enable for 3d calculations
		transform.matrix3D = new Matrix3D();
	}
	
	/**
	 * Rotates the 3d object around to face a point defined relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
	 * 
	 * @param	target		The vector defining the point to be looked at
	 * @param	upAxis		An optional vector used to define the desired up orientation of the 3d object after rotation has occurred
	 */
	public function lookAt(target:Vector3D, ?upAxis:Vector3D):Void
	{
		//HAXE
		//OPTIMIZE
		var tmp = (upAxis != null) ? upAxis : new Vector3D(0, -1, 0);
		transform.matrix3D.pointAt(target, Vector3D.Z_AXIS, tmp);
	}
	
	/**
	 * Duplicates the 3d object's properties to another <code>Object3D</code> object
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied
	 * @return						The new object instance with duplicated properties applied
	 */
	 public function clone(?object:Object3D):Object3D
	 {
		var object3D:Object3D = (object != null) ? object : new Object3D();
		
		object3D.transform.matrix3D = transform.matrix3D.clone();
		object3D.name = name;
		object3D.filters = filters.concat([]);
		object3D.blendMode = blendMode;
		object3D.alpha = alpha;
		object3D.visible = visible;
		object3D.mouseEnabled = mouseEnabled;
		object3D.useHandCursor = useHandCursor;
		
		return object3D;
	}
}
