package away3dlite.primitives;
import away3dlite.core.base.Object3D;
import away3dlite.materials.Material;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* Creates a 3d torus primitive.
*/ 
class Torus extends AbstractPrimitive
{
	private var _radius:Float;
	private var _tube:Float;
	private var _segmentsR:Int;
	private var _segmentsT:Int;
	private var _yUp:Bool;
	
	/**
	 * @inheritDoc
	 */
	private override function buildPrimitive():Void
	{
		super.buildPrimitive();
		
		var i:Int;
		var j:Int;

		j = -1;
		while (++j <= _segmentsR)
		{
			i = -1;
			while (++i <= _segmentsT)
			{
				var u:Float = i / _segmentsT * 2 * Math.PI;
				var v:Float = j / _segmentsR * 2 * Math.PI;
				var x:Float = (_radius + _tube*Math.cos(v))*Math.cos(u);
				var y:Float = (_radius + _tube*Math.cos(v))*Math.sin(u);
				var z:Float = _tube*Math.sin(v);
				
				_yUp? _vertices.push3(x, -z, y) : _vertices.push3(x, y, z);
				
				_uvtData.push3(i/_segmentsT, 1 - j/_segmentsR, 1);
			}
		}

		
		j = 0;
		while (++j <= _segmentsR)
		{
			i = 0;
			while (++i <= _segmentsT)
			{
				var a:Int = (_segmentsT + 1)*j + i;
				var b:Int = (_segmentsT + 1)*j + i - 1;
				var c:Int = (_segmentsT + 1)*(j - 1) + i - 1;
				var d:Int = (_segmentsT + 1)*(j - 1) + i;
				
					_indices.push4(a,b,c,d);
					_faceLengths.push(4);
			}
		}
	}
	
	/**
	 * Defines the overall radius of the torus. Defaults to 100.
	 */
	public var radius(get_radius, set_radius):Float;
	private inline function get_radius():Float
	{
		return _radius;
	}
	
	private function set_radius(val:Float):Float
	{
		if (_radius == val)
			return val;
		
		_radius = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the tube radius of the torus. Defaults to 40.
	 */
	public var tube(get_tube, set_tube):Float;
	private inline function get_tube():Float
	{
		return _tube;
	}
	
	private function set_tube(val:Float):Float
	{
		if (_tube == val)
			return val;
		
		_tube = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the number of radial segments that make up the torus. Defaults to 8.
	 */
	public var segmentsR(get_segmentsR, set_segmentsR):Float;
	private inline function get_segmentsR():Float
	{
		return _segmentsR;
	}
	
	private function set_segmentsR(val:Float):Float
	{
		if (_segmentsR == Std.int(val))
			return _segmentsR;
		
		_segmentsR = Std.int(val);
		_primitiveDirty = true;
		return _segmentsR;
	}
	
	/**
	 * Defines the number of tubular segments that make up the torus. Defaults to 6.
	 */
	public var segmentsT(get_segmentsT, set_segmentsT):Float;
	private inline function get_segmentsT():Float
	{
		return _segmentsT;
	}
	
	private function set_segmentsT(val:Float):Float
	{
		if (_segmentsT == Std.int(val))
			return _segmentsT;
		
		_segmentsT = Std.int(val);
		_primitiveDirty = true;
		return _segmentsT;
	}
	
	/**
	 * Defines whether the coordinates of the torus points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
	 */
	public var yUp(get_yUp, set_yUp):Bool;
	private inline function get_yUp():Bool
	{
		return _yUp;
	}
	
	private function set_yUp(val:Bool):Bool
	{
		if (_yUp == val)
			return val;
		
		_yUp = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Creates a new <code>Torus</code> object.
	 * 
	 * @param	material	Defines the global material used on the faces in the torus.
	 * @param	radius		Defines the overall radius of the torus.
	 * @param	tube		Defines the tube radius of the torus.
	 * @param	segmentsR	Defines the number of radial segments that make up the torus.
	 * @param	segmentsT	Defines the number of tubular segments that make up the torus.
	 * @param	yUp			Defines whether the coordinates of the torus points use a yUp orientation (true) or a zUp orientation (false).
	 */
	public function new(?material:Material, ?radius:Float = 100, ?tube:Float = 40, ?segmentsR:Int = 8, ?segmentsT:Int = 6, ?yUp:Bool = true)
	{
		super(material);
		
		_radius = radius;
		_tube = tube;
		_segmentsR = segmentsR;
		_segmentsT = segmentsT;
		_yUp = yUp;
		
		type = "Torus";
		url = "primitive";
	}
	
	/**
	 * Duplicates the torus properties to another <code>Torus</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Torus</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var torus:Torus = (object != null) ? object.downcast(Torus) : new Torus();
		super.clone(torus);
		torus.radius = _radius;
		torus.tube = _tube;
		torus.segmentsR = _segmentsR;
		torus.segmentsT = _segmentsT;
		torus.yUp = _yUp;
		torus._primitiveDirty = false;
		
		return torus;
	}
}