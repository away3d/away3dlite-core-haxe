package away3dlite.primitives;

import away3dlite.core.base.Object3D;
import away3dlite.materials.Material;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
* Creates a 3d plane primitive.
*/ 
class Plane extends AbstractPrimitive
{
	private var __width:Float;
	private var __height:Float;
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
		
		j = -1;
		while (++j <= _segmentsH)
		{
			i = -1;
			while(++i <= _segmentsW)
			{
				_yUp? _vertices.push3((i/_segmentsW - 0.5)*__width, 0, (j/_segmentsH - 0.5)*__height) : _vertices.push3((i/_segmentsW - 0.5)*__width, (0.5 - j/_segmentsH)*__height, 0);
				_uvtData.push3(i/_segmentsW, 1 - j/_segmentsH, 1);
			}
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
				
				_indices.push4(a,b,c,d);
				_faceLengths.push(4);
			}
		}
	}
	
	/**
	 * Defines the width of the plane. Defaults to 100.
	 */
	private override function get__width():Float
	{
		return __width;
	}
	
	private override function set__width(val:Float):Float
	{
		if (__width == val)
			return val;
		
		__width = val;
		_primitiveDirty = true;
		return val;
	}
	
	/**
	 * Defines the height of the plane. Defaults to 100.
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
	 * Defines the Float of horizontal segments that make up the plane. Defaults to 1.
	 */
	public var segmentsW(get_segmentsW, set_segmentsW):Int;
	private function get_segmentsW():Int
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
	 * Defines the Float of vertical segments that make up the plane. Defaults to 1.
	 */
	public var segmentsH(get_segmentsH, set_segmentsH):Int;
	private function get_segmentsH():Int
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
	 * Defines whether the coordinates of the plane points use a yUp orientation (true) or a zUp orientation (false). Defaults to true.
	 */
	public var yUp(get_yUp, set_yUp):Bool;
	private function get_yUp():Bool
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
	 * Creates a new <code>Plane</code> object.
	 * 
	 * @param	width		Defines the width of the plane.
	 * @param	height		Defines the height of the plane.
	 * @param	segmentsW	Defines the number of horizontal segments that make up the plane.
	 * @param	segmentsH	Defines the number of vertical segments that make up the plane.
	 * @param	yUp			Defines whether the coordinates of the plane points use a yUp orientation (true) or a zUp orientation (false).
	 */
	public function new(?material:Material, ?width:Float = 100, ?height:Float = 100, ?segmentsW:Int = 1, ?segmentsH:Int = 1, ?yUp:Bool = true)
	{
		super(material);
		
		__width = width;
		__height = height;
		_segmentsW = segmentsW;
		_segmentsH = segmentsH;
		_yUp = yUp;
		
		type = "Plane";
		url = "primitive";
	}
			
	/**
	 * Duplicates the plane properties to another <code>Plane</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Plane</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var plane:Plane = (object != null) ? object.downcast(Plane) : new Plane();
		super.clone(plane);
		plane._width = __width;
		plane._height = __height;
		plane.segmentsW = _segmentsW;
		plane.segmentsH = _segmentsH;
		plane.yUp = _yUp;
		plane._primitiveDirty = false;
		
		return plane;
	}
}