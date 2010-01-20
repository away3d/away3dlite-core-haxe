package away3dlite.primitives;

import away3dlite.haxeutils.MathUtils;
import away3dlite.core.base.Object3D;
import away3dlite.materials.Material;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* Creates a 3d cylinder primitive.
*/ 
class Cylinder extends AbstractPrimitive
{
	
	private var jMin:Int;
	private var jMax:Int;
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
			_segmentsH += 2;
			jMin = 1;
			jMax = _segmentsH - 1;
			
			i = -1;
			while (++i <= _segmentsW)
			{
				_yUp ? _vertices.push3(0, __height, 0) : _vertices.push3(0, 0, -__height);
				_uvtData.push3(i/_segmentsW, 1, 1);
			}
		} else {
			jMin = 0;
			jMax = _segmentsH;
		}
		
		j = jMin;
		while (j <= jMax)
		{
			var z:Float = -__height + 2*__height*(j - jMin)/(jMax - jMin);
			
			i = -1;
			while (++i <= _segmentsW)
			{
				var verangle:Float = 2*MathUtils.PI*i/_segmentsW;
				var x:Float = _radius*Math.cos(verangle);
				var y:Float = _radius*Math.sin(verangle);
				
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
				
				if (j <= jMax)
					_indices.push3(a,b,c);
				if (j > jMin)
					_indices.push3(a,c,d);
			}
		}
		
		if (!_openEnded)
			_segmentsH -= 2;
		
		__height *= 2;
	}
	
	/**
	 * Defines the radius of the cylinder. Defaults to 100.
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
	 * Defines the height of the cylinder. Defaults to 200.
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
	 * Defines the number of horizontal segments that make up the cylinder. Defaults to 8.
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
	 * Defines the number of vertical segments that make up the cylinder. Defaults to 1.
	 */
	public var segmentsH(get_segmentsH, set_segmentsH):Int
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
	 * Defines whether the ends of the cylinder are left open (true) or closed (false). Defaults to false.
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
	 * Defines whether the coordinates of the cylinder points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
	 * Creates a new <code>Cylinder</code> object.
	 * 
	 * @param	material	Defines the global material used on the faces in the cylinder.
	 * @param	radius		Defines the radius of the cylinder base.
	 * @param	height		Defines the height of the cylinder.
	 * @param	segmentsW	Defines the number of horizontal segments that make up the cylinder.
	 * @param	segmentsH	Defines the number of vertical segments that make up the cylinder.
	 * @param	openEnded	Defines whether the end of the cylinder is left open (true) or closed (false).
	 * @param	yUp			Defines whether the coordinates of the cylinder points use a yUp orientation (true) or a zUp orientation (false).
	 */
	public function new(?material:Material, ?radius:Float = 100, ?height:Float = 200, ?segmentsW:Int = 8, ?segmentsH:Int = 1, ?openEnded:Bool = true, ?yUp:Bool = true)
	{
		super(material);
		
		_radius = radius;
		__height = height;
		_segmentsW = segmentsW;
		_segmentsH = segmentsH;
		_openEnded = openEnded;
		_yUp = yUp;
		
		type = "Cylinder";
		url = "primitive";
	}
			
	/**
	 * Duplicates the cylinder properties to another <code>Cylinder</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Cylinder</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var cylinder:Cylinder = (object != null) ? (object.downcast(Cylinder)) : new Cylinder();
		super.clone(cylinder);
		cylinder.radius = _radius;
		cylinder._height = __height;
		cylinder.segmentsW = _segmentsW;
		cylinder.segmentsH = _segmentsH;
		cylinder.openEnded = _openEnded;
		cylinder.yUp = _yUp;
		cylinder._primitiveDirty = false;

		return cylinder;
	}
}