package away3dlite.sprites;

import away3dlite.haxeutils.FastStd;
import away3dlite.materials.BitmapMaterial;
import away3dlite.materials.Material;
import away3dlite.materials.WireColorMaterial;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
 * Single billboard object (one that always faces the camera).
 * Draws 2d objects inline with z-sorted triangles in a scene.
 */
class Sprite3D
{
	/** @private */
	/*arcane*/ private var index:Int;
	/** @private */
	/*arcane*/ private var indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var uvtData:Vector<Float>;
	
	private var _scale:Float;
	private var _width:Float;
	private var _height:Float;
	private var _vertices:Vector<Float>;
	private var _verticesDirty:Bool;
	private var _material:Material;
	private var _position:Vector3D;
	
	private function updateVertices():Void
	{
		_verticesDirty = false;
		#if flash9
		_vertices.fixed = false;
		_vertices.length = 0;
		
		#end
		_vertices.push3(-_width*_scale/2, -_height*_scale/2, 0);
		_vertices.push3(-_width*_scale/2, _height*_scale/2, 0);
		_vertices.push3(_width*_scale/2, _height*_scale/2, 0);
		_vertices.push3(_width * _scale / 2, -_height * _scale / 2, 0);
		#if flash9
		_vertices.fixed = true;
		
		#end
	}

	/**
	 * Defines the x position of the Sprite3D object. Defaults to 0.
	 */
	public var x:Float;
	
	/**
	 * Defines the y position of the Sprite3D object. Defaults to 0.
	 */
	public var y:Float;
	
	/**
	 * Defines the z position of the Sprite3D object. Defaults to 0.
	 */
	public var z:Float;
	
	/**
	 * Defines the way the sprite aligns its plane to face the viewer. Allowed values are "viewplane" or "viewpoint". Defaults to "viewplane".
	 * 
	 * @see away3dlite.sprites.AlignmentType
	 */
	public var alignmentType:String;
	
	/**
	 * Defines the overall scale of the Sprite3D object. Defaults to 1.
	 */
	public var scale(get_scale, set_scale):Float;
	private function get_scale():Float
	{
		return _scale;
	}
	
	private function set_scale(val:Float):Float
	{
		if (_scale == val)
			return val;
		
		_scale = val;
		_verticesDirty = true;
		return val;
	}
	
	/**
	 * Defines the width of the Sprite3D object. Defaults to the material width if BitmapMaterial, otherwise 100.
	 */
	public var width(get_width, set_width):Float;
	private function get_width():Float
	{
		if (Math.isNaN(_width))
			return 100;
		
		return _width;
	}
	
	private function set_width(val:Float):Float
	{
		if (_width == val)
			return val;
		
		_width = val;
		_verticesDirty = true;
		return val;
	}
	
	/**
	 * Defines the height of the Sprite3D object. Defaults to the material height if BitmapMaterial, otherwise 100.
	 */
	public var height(get_height, set_height):Float;
	private function get_height():Float
	{
		if (Math.isNaN(_height))
			return 100;
		
		return _height;
	}
	
	private function set_height(val:Float):Float
	{
		if (_height == val)
			return val;
		
		_height = val;
		_verticesDirty = true;
		return val;
	}
	
	/**
	 * @inheritDoc
	 */
	public var vertices(get_vertices, null):Vector<Float>;
	private function get_vertices():Vector<Float>
	{
		if (_verticesDirty)
			updateVertices();
		
		return _vertices;
	}
	
	/**
	 * Determines the material used on the sprite.
	 */
	public var material(get_material, set_material):Material;
	private function get_material():Material
	{
		return _material;
	}
	private function set_material(val:Material):Material
	{
		val = (val != null) ? val : new WireColorMaterial();
		
		if (_material == val)
			return val;
		
		_material = val;
		
		if (FastStd.is(_material, BitmapMaterial)) {
			var bitmapMaterial:BitmapMaterial = Lib.as(_material, BitmapMaterial);
			
			if (Math.isNaN(_width))
				width = bitmapMaterial.width;
			if (Math.isNaN(_height))
				height = bitmapMaterial.height;
		}
		return val;
	}
	
	/**
	 * Returns a 3d vector representing the local position of the 3d sprite.
	 */
	public var position(get_position, null):Vector3D;
	private function get_position():Vector3D
	{
		_position.x = x;
		_position.y = y;
		_position.z = z;
		
		return _position;
	}
	
	/**
	 * Creates a new <code>Sprite3D</code> object.
	 * 
	 * @param material		Determines the material used on the faces in the <code>Sprite3D</code> object.
	 */
	public function new(?material:Material, ?scale:Float = 1.0)
	{
		indices = new Vector<Int>();
		uvtData = new Vector<Float>();
		
		_vertices = new Vector<Float>();
		_position = new Vector3D();
		
		x = y = z = 0;
		
		this.material = material;
		this.scale = scale;
		this.alignmentType = AlignmentType.VIEWPLANE;
		
		//create indices for sprite
		indices.push3(0, 1, 2);
		indices.push(3);
		
		//create uvtData for sprite
		uvtData.push3(0, 0, 0);
		uvtData.push3(0, 1, 0);
		uvtData.push3(1, 1, 0);
		uvtData.push3(1, 0, 0);
		
		//create faces
		updateVertices();
	}

	
	/**
	 * Duplicates the sprite3d properties to another <code>Sprite3D</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Sprite3D</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public function clone(?object:Sprite3D):Sprite3D
	{
		var sprite3D:Sprite3D = (Lib.as(object, Sprite3D));
		if (sprite3D == null)
			sprite3D = new Sprite3D();
		sprite3D.x = x;
		sprite3D.y = y;
		sprite3D.z = z;
		sprite3D.scale = scale;
		sprite3D.width = _width;
		sprite3D.height = _height;
		sprite3D.material = material;
		
		return sprite3D;
	}
}