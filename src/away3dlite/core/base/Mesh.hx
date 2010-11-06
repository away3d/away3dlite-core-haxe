package away3dlite.core.base;	

import away3dlite.cameras.Camera3D;
import away3dlite.containers.Scene3D;
import away3dlite.haxeutils.MathUtils;
import away3dlite.materials.Material;
import away3dlite.materials.WireColorMaterial;
import flash.display.GraphicsTrianglePath;
import flash.display.TriangleCulling;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Utils3D;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;

/**
 * Basic geometry object
 */
class Mesh extends Object3D
{
	/** @private */
	/*arcane*/ private var _materialsDirty:Bool;
	/** @private */
	/*arcane*/ private var _materialsCacheList:Vector<Material>;
	/** @private */
	/*arcane*/ private var _vertexId:Int;
	/** @private */
	/*arcane*/ private var _screenVertices:Vector<Float>;
	/** @private */
	/*arcane*/ private var _uvtData:Vector<Float>;
	/** @private */
	/*arcane*/ private var _indices:Vector<Int>;
	/** @private */
	/*arcane*/ private var _indicesTotal:Int;
	/** @private */
	/*arcane*/ private var _culling:TriangleCulling;
	/** @private */
	/*arcane*/ private var _faces:Vector<Face>;
	/** @private */
	/*arcane*/ private var _faceLengths:Vector<Int>;
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
		
		if (_scene != null)
			buildMaterials(true);
		
		_scene = val;
		
		if (_scene != null)
			buildMaterials();
	}
	/** @private */
	/*arcane*/ private override function project(camera:Camera3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		super.project(camera, parentSceneMatrix3D);
		
		// project the normals
		//if (material is IShader)
		//	_triangles.uvtData = IShader(material).getUVData(transform.matrix3D.clone());
		
		if (!_perspCulling)
		{
			//DO NOT CHANGE vertices getter!!!!!!!
			Utils3D.projectVectors(_viewMatrix3D, vertices, _screenVertices, _uvtData);
			
			if (_materialsDirty)
				buildMaterials();
			
			var i:Int = _materialsCacheList.length;
			var mat:Material;
			while (i-- != 0) {
				if ((mat = _materialsCacheList[i]) != null) {
					//update rendering faces in the scene
					untyped _scene._materialsNextList[i] = mat;
					
					//update material for this object
					mat.arcaneNS().updateMaterial(this, camera);
				}
			}
		}
	}
	/** @private */	
	/*arcane*/ private function buildFaces():Void
	{
		_faces.fixed = _sort.fixed = false;
		_indicesTotal = _faces.length = _sort.length = 0;
		
		var i:Int = _faces.length = _sort.length = _faceLengths.length;
		var index:Int = _indices.length;
		var faceLength:Int;
		
		while (i-- != 0) {
			faceLength = _faceLengths[i];
			
			if (faceLength == 3)
				_indicesTotal += 3;
			else if (faceLength == 4)
				_indicesTotal += 6;
			_faces[i] = new Face(this, i, index -= faceLength, faceLength);
		}
		
		// speed up
		_vertices.fixed = _uvtData.fixed = _indices.fixed = _faceLengths.fixed = _faces.fixed = _sort.fixed = true;
		
		_screenVertices.length = 0;
		
		updateSortType();
		
		_materialsDirty = true;
	}
	
	private var _vertexNormals:Vector<Float>;
	
	private var _material:Material;
	private var _bothsides:Bool;
	private var _sortType:String;
	
	private function removeMaterial(mat:Material):Void
	{
		//HAXE :
		//Avoiding recursive inline bug
		var sid:UInt = untyped _scene._id;
		var i:UInt = mat.arcaneNS()._id[sid];
		
		_materialsCacheList[mat.arcaneNS()._id[sid]] = null;
		
		var i_1:UInt = i + 1;
		if (_materialsCacheList.length == (i_1))
			_materialsCacheList.length--;
	}
	
	private function addMaterial(mat:Material):Void
	{
		var sid:UInt = untyped _scene._id;
		var i:UInt = mat.arcaneNS()._id[sid];
		
		if (_materialsCacheList.length <= i)
			_materialsCacheList.length = i + 1;
		
		_materialsCacheList[i] = mat;
	}
	
	private function buildMaterials(?clear:Bool = false):Void
	{
		_materialsDirty = false;
		
		if (_scene != null) {
			var oldMaterial:Material = null;
			var newMaterial:Material = null;
			
			//update face materials
			_faceMaterials.fixed = false;
			_faceMaterials.length = _faceLengths.length;
			
			var i:Int = _faces.length;
			while (i-- > 0) {
				oldMaterial = _faces[i].material;
				
				if (!clear)
					newMaterial = (_faceMaterials[i] != null) ? _faceMaterials[i] : _material;
				
				//reset face materials
				if (oldMaterial != newMaterial) {
					//remove old material from lists
					if (oldMaterial != null) {
						untyped _scene.removeSceneMaterial(oldMaterial);
						removeMaterial(oldMaterial);
					}
					
					//add new material to lists
					if (newMaterial != null) {
						untyped _scene.addSceneMaterial(newMaterial);
						addMaterial(newMaterial);
					}
					
					//set face material
					_faces[i].material = newMaterial;
				}
				
			}
		}
		
		_faceMaterials.fixed = true;
	}
	
	private function updateSortType():Void
	{
		
		var face:Face;
		switch (_sortType) {
			case SortType.CENTER:
				for (face in _faces)
					face.calculateScreenZ = face.calculateAverageZ;
			case SortType.FRONT:
				for (face in _faces)
					face.calculateScreenZ = face.calculateNearestZ;
			case SortType.BACK:
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
		val = (val != null) ? val : new WireColorMaterial();
		
		if (_material == val)
			return val;
		
		_materialsDirty = true;
		return _material = val;
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
			_culling = TriangleCulling.NONE;
		} else {
			_culling = TriangleCulling.POSITIVE;
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
		
		_materialsCacheList = new flash.Vector<Material>();
		_faceLengths = new Vector<Int>();
		_faces = new Vector<Face>();
		_sort = new Vector<Int>();
		_vertices = new Vector<Float>();
		_faceMaterials = new Vector<Material>();
		
		sortFaces = true;
		
		// private use
		_screenVertices = new Vector<Float>();
		_uvtData = new Vector<Float>();
		_indices = new Vector<Int>();
		
		//setup default values
		this.material = material;
		this.bothsides = false;
		this.sortType = SortType.CENTER;
	}
	
	public function addFace(vs:Vector<Vector3D>,uvs:Vector<Point>):Void
	{
	 var q:Int = IntUtils.min(vs.length, uvs.length);
	 var i = -1;
	 while (++i < q)
	 {
	   pushV3D(vs[i],uvs[i]);
	 }
	 _faceLengths.push(q);
	}
	
	public function pushV3D(v:Vector3D,uv:Point):Void
	{
	 _vertices.push3(v.x,v.y,v.z);
	 _uvtData.push3(uv.x,uv.y,1);
	 _indices.push(this._indicesTotal++);
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
		mesh.arcaneNS()._vertices = vertices;
		mesh._uvtData = _uvtData.concat(Lib.vectorOfArray([]));
		mesh._faceMaterials = _faceMaterials;
		mesh._indices = _indices.concat(Lib.vectorOfArray([]));
		mesh._faceLengths = _faceLengths;
		mesh.buildFaces();
		mesh.buildMaterials();
		
		return mesh;
	}
}