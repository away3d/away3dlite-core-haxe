package away3dlite.primitives;

import away3dlite.materials.Material;
import flash.Vector;
import away3dlite.primitives.AbstractPrimitive;
import away3dlite.core.base.Object3D;
import away3dlite.haxeutils.MathUtils;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* Creates a 3d sphere primitive.
*/ 
class Sphere extends AbstractPrimitive
{
	private var _radius:Float;
	private var _arcLength:Float;
	private var _segmentsW:Int;
	private var _segmentsH:Int;
	private var _yUp:Bool;
	
	/**
	 * @inheritDoc
	 */
	private override function buildPrimitive():Void
	{
		super.buildPrimitive();
		
		var i:Int;
		var j:Int;
		var minJ:Int = Std.int(_segmentsH * (1 - _arcLength));
		
		j = minJ-1;
		while (++j <= _segmentsH) { 
			var horangle:Float = MathUtils.PI*j/_segmentsH;
			var z:Float = -_radius*Math.cos(horangle);
			var ringradius:Float = _radius*Math.sin(horangle);
			
			i = -1;
			while (++i <= _segmentsW) { 
				var verangle:Float = 2*MathUtils.PI*i/_segmentsW;
				var x:Float = ringradius*Math.cos(verangle);
				var y:Float = ringradius*Math.sin(verangle);
				
				_yUp ? _vertices.push3(x, -z, y) : _vertices.push3(x, y, z);
				
				_uvtData.push3(i/_segmentsW, 1 - j/_segmentsH, 1);
			}
		}
		j = 0;
		while (++j <= _segmentsH - minJ) {
			i = 0;
			while (++i <= _segmentsW) {
				var a:Int = (_segmentsW + 1)*j + i;
				var b:Int = (_segmentsW + 1)*j + i - 1;
				var c:Int = (_segmentsW + 1)*(j - 1) + i - 1;
				var d:Int = (_segmentsW + 1)*(j - 1) + i;
				
				if (j == _segmentsH - minJ)
				{
					_indices.push3(a, c, d);
					_faceLengths.push(3);
				} else if (j == 1 - minJ) {
					_indices.push3(a, b, c);
					_faceLengths.push(3);
				} else {
					_indices.push4(a, b, c, d);
					_faceLengths.push(4);
				}
			}
		}
	}
	
	/**
	 * Defines the fractional arc of the sphere rendered from the top.
	 */
	public var arcLength(get_arcLength, set_arcLength):Float;
	private inline function get_arcLength():Float
	{
		return _arcLength;
	}
	
	private function set_arcLength(val:Float):Float
	{
		if (_arcLength == val)
			return val;
		
		_arcLength = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the radius of the sphere. Defaults to 100.
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
		
		_primitiveDirty = true;
		return _radius = val;
	}
	
	/**
	 * Defines the number of horizontal segments that make up the sphere. Defaults to 8.
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
		
		_primitiveDirty = true;
		return _segmentsW = val;
	}
	
	/**
	 * Defines the number of vertical segments that make up the sphere. Defaults to 1.
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
		
		_primitiveDirty = true;
		return _segmentsH = val;
	}
	
	/**
	 * Defines whether the coordinates of the sphere points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
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
		
		_primitiveDirty = true;
		return _yUp = val;
	}
	
	/**
	 * Creates a new <code>Sphere</code> object.
	 *
	 * @param	radius		Defines the radius of the sphere base.
	 * @param	segmentsW	Defines the number of horizontal segments that make up the sphere.
	 * @param	segmentsH	Defines the number of vertical segments that make up the sphere.
	 * @param	yUp			Defines whether the coordinates of the sphere points use a yUp orientation (true) or a zUp orientation (false).
	 */
	public function new(?material:Material, ?radius:Float = 100.0, ?segmentsW:Int = 8, ?segmentsH:Int = 6, ?yUp:Bool = true)
	{
		super(material);
		
		//_radius = 100.0;
		//_segmentsW = 8;
		//_segmentsH = 6;
		//_yUp = true;
		_arcLength = 1;
		
		_radius = radius;
		_segmentsW = segmentsW;
		_segmentsH = segmentsH;
		_yUp = yUp;
		
		type = "Sphere";
		url = "primitive";
	}
	
	/**
	 * Duplicates the sphere properties to another <code>Sphere</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Sphere</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var sphere:Sphere = (object != null) ? object.downcast(Sphere) : new Sphere();
		super.clone(sphere);
		sphere.radius = _radius;
		sphere.segmentsW = _segmentsW;
		sphere.segmentsH = _segmentsH;
		sphere.yUp = _yUp;
		sphere._primitiveDirty = false;
		sphere.arcLength = _arcLength;
		
		return sphere;
	}
}