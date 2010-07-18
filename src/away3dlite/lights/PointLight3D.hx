package away3dlite.lights;

/**
 * @author robbateman
 */
class PointLight3D extends AbstractLight3D
{
	
	private var _ambient:Float;
	private var _diffuse:Float;
	private var _specular:Float;
	
	private var _x:Float;
	private var _y:Float;
	private var _z:Float;
	
	
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
	public var x(get_x, set_x):Float;
	private inline function get_x():Float
	{
		return _x;
	}
	
	private inline function set_x(val:Float):Float
	{
		return _x = val;
	}
	
	/**
	 * 
	 */
	public var y(get_y, set_y):Float;
	private inline function get_y():Float
	{
		return _y;
	}
	
	private inline function set_y(val:Float):Float
	{
		return _y = val;
	}
	
	/**
	 * 
	 */
	public var z(get_z, set_z):Float;
	private inline function get_z():Float
	{
		return _z;
	}
	
	private inline function set_z(val:Float):Float
	{
		return _z = val;
	}
	
	
	/**
	 * 
	 */
	public function new()
	{
		super();
	}
}