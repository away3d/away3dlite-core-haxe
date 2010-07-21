package away3dlite.primitives;
import away3dlite.haxeutils.MathUtils;
import away3dlite.core.base.Object3D;
import away3dlite.materials.Material;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* Creates a 3d cone primitive.
*/ 
class Cone extends AbstractPrimitive
{
	private var jMin:Int;
	private var _radius:Float;
	private var __height:Float;
	private var _segmentsW:Int;
	private var _segmentsH:Int;
	private var _openEnded:Bool;
	private var _yUp:Bool;
	
	/**
	 * @inheritDoc
	 */
	private override function buildPrimitive():Void
	{
		super.buildPrimitive();
		
		var i:Int;
		var j:Int;
		
		__height /= 2;
		
		if (!_openEnded) {
			jMin = 1;
			_segmentsH += 1;
			
			i = -1;
			while (++i < _segmentsW)
			{
				_yUp ? _vertices.push3(0, __height, 0) : _vertices.push3(0, 0, -__height);
				_uvtData.push3(i/_segmentsW, 1, 1);
			}
		} else {
			jMin = 0;
		}
		
		j = jMin;
		while (j < _segmentsH)
		{
			var z:Float = -__height + 2*__height*(j - jMin)/(_segmentsH - jMin);
			
			i = -1;
			while (++i <= _segmentsW)
			{
				var verangle:Float = 2*MathUtils.PI*i/_segmentsW;
				var ringradius:Float = _radius*(_segmentsH - j)/(_segmentsH - jMin);
				var x:Float = ringradius*Math.cos(verangle);
				var y:Float = ringradius*Math.sin(verangle);
				
				_yUp? _vertices.push3(x, -z, y) : _vertices.push3(x, y, z);
				
				_uvtData.push3(i/_segmentsW, 1 - j/_segmentsH, 1);
			}
			j++;
		}
		
		i = -1;
		while (++i <= _segmentsW)
		{
			_yUp? _vertices.push3(0, -__height, 0) : _vertices.push3(0, 0, __height);
			_uvtData.push3(i/_segmentsW, 0, 1);
		}
		
		j = 0;
		while (++j <= _segmentsH)
		{
			i = 0;
			while (++i <= _segmentsW)
			{
				var a:Int = (_segmentsW + 1)*j + i;
				var b:Int = (_segmentsW + 1)*j + i - 1;
				var c:Int = (_segmentsW + 1)*(j - 1) + i - 1;
				var d:Int = (_segmentsW + 1)*(j - 1) + i;
				
				if (j == _segmentsH) {
					_indices.push3(a, c, d);
					_faceLengths.push(3);
				} else if (j == jMin) {
					_indices.push3(a, b, c);
					_faceLengths.push(3);
				} else {
					_indices.push3(a, b, c);
					_indices.push(d);
					_faceLengths.push(4);
				}
			}
		}
		
		if (!_openEnded)
			_segmentsH -= 1;
		
		__height *=2;
	}
	
	/**
	 * Defines the radius of the cone base. Defaults to 100.
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
	 * Defines the height of the cone. Defaults to 200.
	 * 
	 * <b>haXe specific</b> : Variable is called _height, due to haXe limitation.
	 */
	 
	private override function get__height():Float
	{
		return __height;
	}
	
	private override function set__height(val:Float):Float
	{
		if (__height == val)
			return val;
		
		__height = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the Float of horizontal segments that make up the cone. Defaults to 8.
	 */
	public var segmentsW(get_segmentsW, set_segmentsW):Int;
	 
	private inline function get_segmentsW():Int
	{
		return _segmentsW;
	}
	
	private function set_segmentsW(val:Int):Int
	{
		if (_segmentsW == val)
			return val;
		
		_segmentsW = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the Float of vertical segments that make up the cone. Defaults to 1.
	 */
	public var segmentsH(get_segmentsH, set_segmentsH):Int;
	 
	private inline function get_segmentsH():Int
	{
		return _segmentsH;
	}
	
	private function set_segmentsH(val:Int):Int
	{
		if (_segmentsH == val)
			return val;
		
		_segmentsH = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines whether the end of the cone is left open (true) or closed (false). Defaults to false.
	 */
	public var openEnded(get_openEnded, set_openEnded):Bool;
	 
	private inline function get_openEnded():Bool
	{
		return _openEnded;
	}
	
	private function set_openEnded(val:Bool):Bool
	{
		if (_openEnded == val)
			return val;
		
		_openEnded = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines whether the coordinates of the cone points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
	 * Creates a new <code>Cone</code> object.
	 * 
	 * @param	material	Defines the global material used on the faces in the cone.
	 * @param	radius		Defines the radius of the cone base.
	 * @param	height		Defines the height of the cone.
	 * @param	segmentsW	Defines the number of horizontal segments that make up the cone.
	 * @param	segmentsH	Defines the number of vertical segments that make up the cone.
	 * @param	openEnded	Defines whether the end of the cone is left open (true) or closed (false).
	 * @param	yUp			Defines whether the coordinates of the cone points use a yUp orientation (true) or a zUp orientation (false).
	 */
	public function new(?material:Material, ?radius:Float = 100.0, ?height:Float = 200.0, ?segmentsW:Int = 8, ?segmentsH:Int = 1, ?openEnded:Bool = true, ?yUp:Bool = true)
	{
		super(material);
		
		_radius = radius;
		__height = height;
		_segmentsW = segmentsW;
		_segmentsH = segmentsH;
		_openEnded = openEnded;
		_yUp = yUp;
		
		type = "Cone";
		url = "primitive";
	}
			
	/**
	 * Duplicates the cone properties to another <code>Cone</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Cone</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var cone:Cone = (object != null) ? (object.downcast(Cone)) : new Cone();
		super.clone(cone);
		cone.radius = _radius;
		cone._height = __height;
		cone.segmentsW = _segmentsW;
		cone.segmentsH = _segmentsH;
		cone.openEnded = _openEnded;
		cone.yUp = _yUp;
		cone._primitiveDirty = false;
		
		return cone;
	}
}