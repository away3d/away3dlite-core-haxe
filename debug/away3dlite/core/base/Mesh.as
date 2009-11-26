package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	import away3dlite.materials.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Basic geometry object
	 */
	public class Mesh extends Object3D
	{
		/** @private */
		arcane var _materialsDirty:Boolean;
		/** @private */
		arcane var _materialsCacheList:Vector.<Material> = new Vector.<Material>();
		/** @private */
		arcane var _vertexId:int;
		/** @private */
		arcane var _screenVertices:Vector.<Number>;
		/** @private */
		arcane var _uvtData:Vector.<Number>;
		/** @private */
		arcane var _indices:Vector.<int>;
		/** @private */
		arcane var _indicesTotal:int;
		/** @private */
		arcane var _culling:String;
		/** @private */
		arcane var _faces:Vector.<Face> = new Vector.<Face>();
		/** @private */
		arcane var _faceLengths:Vector.<int> = new Vector.<int>();
		/** @private */
		arcane var _sort:Vector.<int> = new Vector.<int>();
		/** @private */
		arcane var _vertices:Vector.<Number> = new Vector.<Number>();
		/** @private */
		arcane var _faceMaterials:Vector.<Material> = new Vector.<Material>();
		/** @private */
		arcane override function updateScene(val:Scene3D):void
		{
			if (scene == val)
				return;
			
			if (_scene)
				buildMaterials(true);
			
			_scene = val;
			
			if (_scene)
				buildMaterials();
		}
		/** @private */
		arcane override function project(camera:Camera3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(camera, parentSceneMatrix3D);
			// project the normals
			//if (material is IShader)
			//	_triangles.uvtData = IShader(material).getUVData(transform.matrix3D.clone());
			
			//DO NOT CHANGE vertices getter!!!!!!!
			Utils3D.projectVectors(_viewMatrix3D, vertices, _screenVertices, _uvtData);
			
			if (_materialsDirty)
				buildMaterials();
			
			var i:int = _materialsCacheList.length;
			var mat:Material;
			while (i--) {
				if ((mat = _materialsCacheList[i])) {
					//update rendering faces in the scene
					_scene._materialsNextList[i] = mat;
					
					//update material if material is a shader
				}
			}
		}
		/** @private */	
		arcane function buildFaces():void
		{
			_faces.fixed = _sort.fixed = false;
			_indicesTotal = _faces.length = _sort.length = 0;
			
			var i:int = _faces.length = _sort.length = _faceLengths.length;
			var index:int = _indices.length;
			var faceLength:int;
			
			while (i--) {
				faceLength = _faceLengths[i];
				
				if (faceLength == 3)
					_indicesTotal += 3;
				else if (faceLength == 4)
					_indicesTotal += 6;
				_faces[i] = new Face(this, i, index -= faceLength, faceLength);
			}
			
			// speed up
			_vertices.fixed = _uvtData.fixed = _indices.fixed = _faceLengths.fixed = _faces.fixed = _sort.fixed = true;
 			
 			updateSortType();
 			
 			_materialsDirty = true;
		}
		
		protected var _vertexNormals:Vector.<Number>;
		
		private var _material:Material;
		private var _bothsides:Boolean;
		private var _sortType:String;
		
		private function removeMaterial(mat:Material):void
		{
			var i:uint = mat._id[_scene._id];
			
			_materialsCacheList[mat._id[_scene._id]] = null;
			
			if (_materialsCacheList.length == i + 1)
				_materialsCacheList.length--;
		}
		
		private function addMaterial(mat:Material):void
		{
			var i:uint = mat._id[_scene._id];
			
			if (_materialsCacheList.length <= i)
				_materialsCacheList.length = i + 1;
			
			_materialsCacheList[i] = mat;
		}
		
		private function buildMaterials(clear:Boolean = false):void
		{
			_materialsDirty = false;
			
			if (_scene) {
				var oldMaterial:Material;
				var newMaterial:Material;
				
				//update face materials
				_faceMaterials.fixed = false;
				_faceMaterials.length = _faceLengths.length;
				
				var i:int = _faces.length;
				while (i--) {
					oldMaterial = _faces[i].material;
					
					if (!clear)
						newMaterial = _faceMaterials[i] || _material;
					
					//reset face materials
					if (oldMaterial != newMaterial) {
						//remove old material from lists
						if (oldMaterial) {
							_scene.removeSceneMaterial(oldMaterial);
							removeMaterial(oldMaterial);
						}
						
						//add new material to lists
						if (newMaterial) {
							_scene.addSceneMaterial(newMaterial);
							addMaterial(newMaterial);
						}
						
						//set face material
						_faces[i].material = newMaterial;
					}
					
				}
			}
			
			_faceMaterials.fixed = true;
		}
		
		private function updateSortType():void
		{
			
			var face:Face;
			switch (_sortType) {
				case SortType.CENTER:
					for each (face in _faces)
						face.calculateScreenZ = face.calculateAverageZ;
					break;
				case SortType.FRONT:
					for each (face in _faces)
						face.calculateScreenZ = face.calculateNearestZ;
					break;
				case SortType.BACK:
					for each (face in _faces)
						face.calculateScreenZ = face.calculateFurthestZ;
					break;
				default:
			}
		}
		
		/**
		 * Determines if the faces in the mesh are sorted. Used in the <code>FastRenderer</code> class.
		 * 
		 * @see away3dlite.core.render.FastRenderer
		 */
		public var sortFaces:Boolean = true;
		
		/**
		 * Returns the 3d vertices used in the mesh.
		 */
		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}
		
		/**
		 * Returns the faces used in the mesh.
		 */
		public function get faces():Vector.<Face>
		{
			return _faces;
		}

		
		/**
		 * Determines the global material used on the faces in the mesh.
		 */
		public function get material():Material
		{
			return _material;
		}
		public function set material(val:Material):void
		{
			val = val || new WireColorMaterial();
			
			if (_material == val)
				return;
			
			_material = val;
			
			_materialsDirty = true;
		}
		
		/**
		 * Determines whether the faces in teh mesh are visible on both sides (true) or just the front side (false).
		 * The front side of a face is determined by the side that has it's vertices arranged in a counter-clockwise order.
		 */
		public function get bothsides():Boolean
		{
			return _bothsides;
		}
		
		public function set bothsides(val:Boolean):void
		{
			_bothsides = val;
			
			if (_bothsides) {
				_culling = TriangleCulling.NONE;
			} else {
				_culling = TriangleCulling.POSITIVE;
			}
		}
		
		/**
		 * Determines by which mechanism vertices are sorted. Uses the values given by the <code>MeshSortType</code> class. Options are CENTER, FRONT and BACK. Defaults to CENTER.
		 * 
		 * @see away3dlite.core.base.MeshSortType
		 */
		public function get sortType():String
		{
			return _sortType;
		}
		
		public function set sortType(val:String):void
		{
			if (_sortType == val)
				return;
			
			_sortType = val;
			
			updateSortType();
		}
		
		/**
		 * Creates a new <code>Mesh</code> object.
		 * 
		 * @param material		Determines the global material used on the faces in the mesh.
		 */
		public function Mesh(material:Material = null)
		{
			super();
			
			// private use
			_screenVertices = new Vector.<Number>();
			_uvtData = new Vector.<Number>();
			_indices = new Vector.<int>();
			
			//setup default values
			this.material = material;
			this.bothsides = false;
			this.sortType = SortType.CENTER;
		}
		
		/**
		 * Duplicates the mesh properties to another <code>Mesh</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Mesh</code>.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var mesh:Mesh = (object as Mesh) || new Mesh();
            super.clone(mesh);
            mesh.type = type;
            mesh.material = material;
            mesh.sortType = sortType;
            mesh.bothsides = bothsides;
			mesh._vertices = vertices;
			mesh._uvtData = _uvtData.concat();
			mesh._faceMaterials = _faceMaterials;
			mesh._indices = _indices.concat();
			mesh._faceLengths = _faceLengths;
			mesh.buildFaces();
			mesh.buildMaterials();
			
			return mesh;
        }
	}
}
