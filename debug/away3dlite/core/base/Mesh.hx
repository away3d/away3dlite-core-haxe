//OK

package away3dlite.core.base;	
import away3dlite.containers.Scene3D;
import away3dlite.materials.Material;
import away3dlite.materials.WireColorMaterial;
import flash.display.GraphicsTrianglePath;
import flash.display.TriangleCulling;
import flash.geom.Matrix3D;
import flash.geom.Utils3D;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * @author robbateman
 */
class Mesh extends Object3D
{
	/** @private */
	/*arcane*/ private var _vertexId:Int;
	/** @private */
	/*arcane*/ private var _screenVertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _uvtData:Vector<Float>;
	/** @private */
	/*arcane*/ private var _indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var _triangles:GraphicsTrianglePath;
	/** @private */
	/*arcane*/ private var _faces:Vector<Face>;
	/** @private */
	/*arcane*/ private var _sort:Vector<Int>;
	/** @private */
	/*arcane*/ private var _vertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _faceMaterials:Vector<Material>;
	/** @private */
	/*arcane*/ private override function updateScene(val:Scene3D):Void
	{
		if (scene == val)
			return;
		
		_scene = val;
	}
	/** @private */
	/*arcane*/ private override function project(projectionMatrix3D:Matrix3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		super.project(projectionMatrix3D, parentSceneMatrix3D);
		
		// project the normals
		//if (material is IShader)
		//	_triangles.uvtData = IShader(material).getUVData(transform.matrix3D.clone());
		
		//DO NOT CHANGE vertices getter!!!!!!!
		Utils3D.projectVectors(_viewMatrix3D, vertices, _screenVertices, _uvtData);
	}
	/** @private */	
	/*arcane*/ private function buildFaces():Void
	{
		_faceMaterials.fixed = false;
		_faces.length = _sort.length = 0;
		var i:Int = _faces.length = _faceMaterials.length = Std.int(_indices.length/3);
		
		while (i-- != 0)
			_faces[i] = new Face(this, i);
		
		// speed up
		_vertices.fixed = true;
		_uvtData.fixed = true;
		_indices.fixed = true;
		_faceMaterials.fixed = true;
		
		// calculate normals for the shaders
		//if (_material is IShader)
		//	IShader(_material).calculateNormals(_vertices, _indices, _uvtData, _vertexNormals);
		
		if (_scene != null)
			_scene.arcane()._dirtyFaces = true;
		
		updateSortType();
	}
	
	private var _vertexNormals:Vector<Float>;
	
	private var _material:Material;
	private var _bothsides:Bool;
	private var _sortType:String;
	
	private function updateSortType():Void
	{
		
		var face:Face;
		switch (_sortType) {
			case MeshSortType.CENTER:
				for (face in _faces)
					face.calculateScreenZ = face.calculateAverageZ;
			case MeshSortType.FRONT:
				for (face in _faces)
					face.calculateScreenZ = face.calculateNearestZ;
			case MeshSortType.BACK:
				for (face in _faces)
					face.calculateScreenZ = face.calculateFurthestZ;
			default:
		}
	}
	
	/**
	 * Determines if the faces in the mesh are sorted. Used in the <code>FastRenderer</code> class.
	 * 
	 * @see away3dlite.core.render.FastRenderer
	 */
	public var sortFaces:Bool;
	
	/**
	 * Returns the 3d vertices used in the mesh.
	 */
	public var vertices(get_vertices, null):Vector<Float>;
	private function get_vertices():Vector<Float>
	{
		return _vertices;
	}
	
	/**
	 * Returns the faces used in the mesh.
	 */
	public var faces(get_faces, null):Vector<Face>;
	private function get_faces():Vector<Face>
	{
		return _faces;
	}

	
	/**
	 * Determines the global material used on the faces in the mesh.
	 */
	public var material(get_material, set_material):Material;
	private function get_material():Material
	{
		return _material;
	}
	private function set_material(val:Material):Material
	{
		if (_material == val)
			return val;
		
		_material = val;
		
		//update property in faces
		var i:Int = _faces.length;
		while (i-- != 0)
			_faces[i].material = (_faceMaterials[i] != null) ? _faceMaterials[i] : _material;
			
		// calculate normals for the shaders
		//if (_material is IShader)
		//	IShader(_material).calculateNormals(_vertices, _indices, _uvtData, _vertexNormals);
		
		return val;
	}
	
	/**
	 * Determines whether the faces in teh mesh are visible on both sides (true) or just the front side (false).
	 * The front side of a face is determined by the side that has it's vertices arranged in a counter-clockwise order.
	 */
	public var bothsides(get_bothsides, set_bothsides):Bool;
	private function get_bothsides():Bool
	{
		return _bothsides;
	}
	
	private function set_bothsides(val:Bool):Bool
	{
		_bothsides = val;
		
		if (_bothsides) {
			_triangles.culling = TriangleCulling.NONE;
		} else {
			_triangles.culling = TriangleCulling.POSITIVE;
		}
		return val;
	}
	
	/**
	 * Determines by which mechanism vertices are sorted. Uses the values given by the <code>MeshSortType</code> class. Options are CENTER, FRONT and BACK. Defaults to CENTER.
	 * 
	 * @see away3dlite.core.base.MeshSortType
	 */
	public var sortType(get_sortType, set_sortType):String;
	private function get_sortType():String
	{
		return _sortType;
	}
	
	private function set_sortType(val:String):String
	{
		if (_sortType == val)
			return val;
		
		_sortType = val;
		
		updateSortType();
		return val;
	}
	
	/**
	 * Creates a new <code>Mesh</code> object.
	 * 
	 * @param material		Determines the global material used on the faces in the mesh.
	 */
	public function new(?material:Material)
	{
		super();
		
		_triangles = new GraphicsTrianglePath();
		_faces = new Vector<Face>();
		_sort = new Vector<Int>();
		_vertices = new Vector<Float>();
		_faceMaterials = new Vector<Material>();
		
		sortFaces = true;
		
		// private use
		_screenVertices = _triangles.vertices = new Vector<Float>();
		_uvtData = _triangles.uvtData = new Vector<Float>();
		_indices = _triangles.indices = new Vector<Int>();
		
		//setup default values
		this.material = (material != null) ? material : new WireColorMaterial();
		this.bothsides = false;
		this.sortType = MeshSortType.CENTER;
	}
	
	/**
	 * Duplicates the mesh properties to another <code>Mesh</code> object.
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Mesh</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var mesh:Mesh = (object != null) ? Lib.as(object, Mesh) : new Mesh();
		super.clone(mesh);
		mesh.type = type;
		mesh.material = material;
		mesh.sortType = sortType;
		mesh.bothsides = bothsides;
		mesh.arcane()._vertices = vertices;
		mesh._uvtData = mesh._triangles.uvtData = _uvtData.concat(Lib.vectorOfArray([]));
		mesh._faceMaterials = _faceMaterials;
		mesh._indices = _indices.concat(Lib.vectorOfArray([]));
		mesh.buildFaces();
		
		return mesh;
	}
}