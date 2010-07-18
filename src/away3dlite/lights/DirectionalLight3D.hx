package away3dlite.lights;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;


//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * @author robbateman
 */
class DirectionalLight3D extends AbstractLight3D
{
	private static inline var _TO_DEGREES:Float = 180/Math.PI;
	private var _ambient:Float;
	private var _diffuse:Float;
	private var _specular:Float;
	
	private var _direction:Vector3D;
	private var _diffuseTransform:Matrix3D;
	private var _specularTransform:Matrix3D;
	private var _diffuseTransformDirty:Bool;
	
	/**
	 * 
	 */
	public var ambient(get_ambient, set_ambient):Float;
	private inline function get_ambient():Float
	{
		return _ambient;
	}
	
	private inline function set_ambient(val:Float):Float
	{
		return _ambient = val;
	}
	
	/**
	 * 
	 */
	public var diffuse(get_diffuse, set_diffuse):Float;
	private inline function get_diffuse():Float
	{
		return _diffuse;
	}
	
	private inline function set_diffuse(val:Float):Float
	{
		return _diffuse = val;
	}
	
	/**
	 * 
	 */
	public var specular(get_specular, set_specular):Float;
	private inline function get_specular():Float
	{
		return _specular;
	}
	
	private inline function set_specular(val:Float):Float
	{
		return _specular = val;
	}
	
	/**
	 * 
	 */
	public var direction(get_direction, set_direction):Vector3D;
	private inline function get_direction():Vector3D
	{
		return _direction;
	}
	
	private inline function set_direction(val:Vector3D):Vector3D
	{
		if (_direction == val)
			return val;
		else 
		{
			_diffuseTransformDirty = true;
			return _direction = val;
		}
	}
	
	public var diffuseTransform(get_diffuseTransform, never):Matrix3D;
	private function get_diffuseTransform():Matrix3D
	{
		if (_diffuseTransformDirty) {
			
			_diffuseTransformDirty = false;
			
			_direction.normalize();
			
			var nx:Float = _direction.x;
			var ny:Float = _direction.y;
			var mod:Float = Math.sqrt(nx*nx + ny*ny);
			
			_diffuseTransform.identity();
			
			if (mod != 0)
				_diffuseTransform.prependRotation(-Math.acos(-_direction.z)*_TO_DEGREES, new Vector3D(ny/mod, -nx/mod, 0));
			else
				_diffuseTransform.prependRotation(-Math.acos(-_direction.z)*_TO_DEGREES, new Vector3D(0, 1, 0));
		}
		
		return _diffuseTransform;
	}
	
	public var specularTransform(get_specularTransform, never):Matrix3D;
	private function get_specularTransform():Matrix3D
	{
		var halfVector:Vector3D = new Vector3D(_camera.sceneMatrix3D.rawData[8], _camera.sceneMatrix3D.rawData[9], _camera.sceneMatrix3D.rawData[10]);
		halfVector = halfVector.add(_direction);
		halfVector.normalize();
		
		var nx:Float = halfVector.x;
		var ny:Float = halfVector.y;
		var mod:Float = Math.sqrt(nx*nx + ny*ny);
		
		_specularTransform.identity();
		_specularTransform.prependRotation(Math.acos(-halfVector.z)*_TO_DEGREES, new Vector3D(-ny/mod, nx/mod, 0));
		
		return _specularTransform;
	}
	/**
	 * 
	 */
	public function new()
	{
		super();
		ambient = 0.5;
		diffuse = 0.5;
		specular = 1;
		
		_diffuseTransform = new Matrix3D();
		_specularTransform = new Matrix3D();
	}
}