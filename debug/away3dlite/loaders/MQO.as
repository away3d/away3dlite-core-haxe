package away3dlite.loaders
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.loaders.data.*;

	import flash.geom.*;
	import flash.utils.*;

	use namespace arcane;

	/**
	 * Metasequoia
	 * @author katopz@sleepydesign.com
	 */
	public class MQO extends AbstractParser
	{
		/** @private */
		arcane override function prepareData(data:*):void
		{
			mqo = ByteArray(data);

			var lines:Array = mqo.readMultiByte(mqo.length, charset).split("\r\n");
			var l:int = 0;

			l = parseMaterialChunk(lines, 0);

			while (l != -1)
				l = parseObjectChunk(lines, l);

			//build the meshes
			buildMeshes();

			//build materials
			buildMaterials();
		}

		private var mqo:ByteArray;
		private var _materialData:MaterialData;
		private var _meshData:MeshData;
		private var _geometryData:GeometryData;
		private var _moveVector:Vector3D = new Vector3D();
		private var _materialNames:Array = new Array();

		/**
		 * Array of mesh data objects used for storing the parsed 3ds data structure.
		 */
		private var meshDataList:Array = [];

		private function getMaterialChunkLine(lines:Array, startLine:int = 0):int
		{
			for (var i:uint = startLine; i < lines.length; ++i)
				if (lines[i].indexOf("Material") == 0)
					return int(i);

			return -1;
		}

		private function parseMaterialChunk(lines:Array, startLine:int):int
		{
			var l:int = getMaterialChunkLine(lines, startLine);

			if (l == -1)
				return -1;

			var line:String = lines[l];

			var num:Number = parseInt(line.substr(9));

			if (isNaN(num))
				return -1;

			++l;

			var endLine:int = l + int(num);

			while (l < endLine)
			{
				line = lines[l];

				var nameBeginIndex:int = line.indexOf("\"");
				var nameEndIndex:int = line.indexOf("\"", nameBeginIndex + 1);

				_materialData = _materialLibrary.addMaterial(line.substring(nameBeginIndex + 1, nameEndIndex));
				_materialNames.push(_materialData);

				var tex:String = getParam(line, "tex");

				if (tex)
				{
					_materialData.materialType = MaterialData.TEXTURE_MATERIAL;

					tex = tex.substr(1, tex.length - 2);

					if (tex.toLowerCase().search(/\.tga$/) != -1 || tex.toLowerCase().search(/\.bmp$/) != -1)
					{
						//TODO : someone really need TGA, BMP on web?
						//_material = loadTGAMaterial(path + tex);

						trace(" ! Error : TGA, BMP not support.");
						trace(" < Try : .png with same name...");

						tex = tex.replace(/\.tga$/, ".png");
						tex = tex.replace(/\.bmp$/, ".png");
					}

					_materialData.textureFileName = tex;

				}
				else
				{
					var colorstr:String = getParam(line, "col");

					if (colorstr != null)
					{
						var color:Array = colorstr.match(/\d+\.\d+/g);
						var r:int = parseFloat(color[0]) * 255;
						var g:int = parseFloat(color[1]) * 255;
						var b:int = parseFloat(color[2]) * 255;
						var a:Number = parseFloat(color[3]);

						if (shading)
							_materialData.materialType = MaterialData.SHADING_MATERIAL;
						else
							_materialData.materialType = MaterialData.COLOR_MATERIAL;

						_materialData.diffuseColor = (r << 16) | (g << 8) | b;
						_materialData.alpha = a;
					}
					else
					{
						_materialData.materialType = MaterialData.WIREFRAME_MATERIAL;
					}
				}

				++l;
			}

			return endLine;
		}

		private function getObjectChunkLine(lines:Array, startLine:int = 0):int
		{
			for (var i:uint = startLine; i < lines.length; ++i)
			{
				if (lines[i].indexOf("Object") == 0)
				{
					return int(i);
				}
			}
			return -1;
		}

		private function parseObjectChunk(lines:Array, startLine:int):int
		{
			n = -1;

			var vertices:Array = [];

			var l:int = getObjectChunkLine(lines, startLine);

			if (l == -1)
				return -1;

			var line:String = lines[l];

			var name:String = line.substring(8, line.indexOf("\"", 8));

			++l;

			var vline:int = getChunkLine(lines, "vertex", l);

			if (vline == -1)
				return -1;

			var properties:Dictionary = new Dictionary();

			while (l < vline)
			{
				line = lines[l];
				var props:Array = RegExp(/^\s*([\w]+)\s+(.*)$/).exec(line);
				properties[props[1]] = props[2];
				++l;
			}

			line = lines[l];
			l = vline + 1;

			var numVertices:int = parseInt(line.substring(line.indexOf("vertex") + 7));
			var vertexEndLine:int = l + numVertices;
			var firstVertexIndex:int = vertices.length;

			while (l < vertexEndLine)
			{
				line = lines[l];
				var coords:Array = line.match(/(-?\d+\.\d+)/g);
				var x:Number = parseFloat(coords[0]) * scaling;
				var y:Number = parseFloat(coords[1]) * scaling;
				var z:Number = -parseFloat(coords[2]) * scaling;
				vertices.push(new Vector3D(x, y, z));
				++l;
			}

			l = getChunkLine(lines, "face", l);

			if (l == -1)
				return -1;

			line = lines[l++];

			var numFaces:int = parseInt(line.substring(line.indexOf("face") + 5));
			var faceEndLine:int = l + numFaces;

			_meshData = new MeshData();
			_meshData.name = name;

			_geometryData = _meshData.geometry = _geometryLibrary.addGeometry(_meshData.name);

			while (l < faceEndLine)
			{
				if (properties["visible"] == "15")
				{
					_meshData.material = parseFace(lines[l], vertices, firstVertexIndex, properties);
				}
				++l;
			}

			//ignore bone data
			if (_meshData.material)
				meshDataList.push(_meshData);

			//TODO : do we need this?
			/*
			// Resolve parent-child relationship.
			var depth:int;
			try
			{
				depth = parseInt(properties["depth"]);
			}
			catch (e:Error)
			{
				depth = 0;
			}
			var parentMesh:ObjectContainer3D = _prevMesh;
			if (depth <= 0)
			{
				parentMesh = this;
				depth = 0;
			}
			else
			{
				while (depth <= _prevDepth)
				{
					parentMesh = ObjectContainer3D(parentMesh).parent;
					--_prevDepth;
				}
			}
			parentMesh.addChild(mesh);
			_prevMesh = mesh;
			_prevDepth = depth;
			*/

			return faceEndLine;
		}

		private function parseFace(line:String, vertices:Array, vertexOffset:int, properties:Dictionary):MaterialData
		{
			var vstr:String = getParam(line, "V");
			var mstr:String = getParam(line, "M");
			var uvstr:String = getParam(line, "UV");

			var v:Array = (vstr != null) ? vstr.match(/\d+/g) : [];
			var uv:Array = (uvstr != null) ? uvstr.match(/-?\d+\.\d+/g) : [];
			var a:Vector3D;
			var b:Vector3D;
			var c:Vector3D;
			var d:Vector3D;
			var _material:MaterialData;
			var uvA:Vector3D;
			var uvB:Vector3D;
			var uvC:Vector3D;
			var uvD:Vector3D;
			var mirrorAxis:int;
			if (v.length == 3)
			{
				c = vertices[parseInt(v[0]) + vertexOffset];
				b = vertices[parseInt(v[1]) + vertexOffset];
				a = vertices[parseInt(v[2]) + vertexOffset];

				if (mstr != null)
					_material = _materialNames[parseInt(mstr)];

				if (uv.length != 0)
				{
					uvC = new Vector3D(parseFloat(uv[0]), parseFloat(uv[1]));
					uvB = new Vector3D(parseFloat(uv[2]), parseFloat(uv[3]));
					uvA = new Vector3D(parseFloat(uv[4]), parseFloat(uv[5]));
					addFace(a, b, c, uvA, uvB, uvC);
				}
				else
				{
					addFace(a, b, c, new Vector3D(0, 0), new Vector3D(1, 0), new Vector3D(0, 1));
				}


				if (properties["mirror"] == "1")
				{
					mirrorAxis = parseInt(properties["mirror_axis"]);
					a = mirrorVertex(a, mirrorAxis);
					b = mirrorVertex(b, mirrorAxis);
					c = mirrorVertex(c, mirrorAxis);
					vertices.push(a);
					vertices.push(b);
					vertices.push(c);
					addFace(c, b, a, uvC, uvB, uvA);
				}
			}
			else if (v.length == 4)
			{
				d = vertices[parseInt(v[0]) + vertexOffset];
				c = vertices[parseInt(v[1]) + vertexOffset];
				b = vertices[parseInt(v[2]) + vertexOffset];
				a = vertices[parseInt(v[3]) + vertexOffset];

				if (mstr != null)
					_material = _materialNames[parseInt(mstr)];

				if (uv.length != 0)
				{
					uvD = new Vector3D(parseFloat(uv[0]), parseFloat(uv[1]));
					uvC = new Vector3D(parseFloat(uv[2]), parseFloat(uv[3]));
					uvB = new Vector3D(parseFloat(uv[4]), parseFloat(uv[5]));
					uvA = new Vector3D(parseFloat(uv[6]), parseFloat(uv[7]));
				}
				else
				{
					uvD = new Vector3D(1, 1);
					uvC = new Vector3D(0, 1);
					uvB = new Vector3D(1, 0);
					uvA = new Vector3D(0, 0);
				}

				addFace(a, b, c, uvA, uvB, uvC);
				addFace(c, d, a, uvC, uvD, uvA);

				if (properties["mirror"] == "1")
				{
					mirrorAxis = parseInt(properties["mirror_axis"]);
					a = mirrorVertex(a, mirrorAxis);
					b = mirrorVertex(b, mirrorAxis);
					c = mirrorVertex(c, mirrorAxis);
					d = mirrorVertex(d, mirrorAxis);
					vertices.push(a);
					vertices.push(b);
					vertices.push(c);
					vertices.push(d);
					addFace(c, b, a, uvC, uvB, uvA);
					addFace(a, d, c, uvA, uvD, uvC);
				}
			}

			return _material;
		}

		private static function mirrorVertex(v:Vector3D, axis:int):Vector3D
		{
			return new Vector3D(((axis & 1) != 0) ? -v.x : v.x, ((axis & 2) != 0) ? -v.y : v.y, ((axis & 4) != 0) ? -v.z : v.z);
		}

		private static function getChunkLine(lines:Array, chunkName:String, startLine:int = 0):int
		{
			for (var i:uint = startLine; i < lines.length; ++i)
			{
				if (lines[i].indexOf(chunkName) != -1)
				{
					return int(i);
				}
			}
			return -1;
		}

		private static function getParam(line:String, paramName:String):String
		{
			var prefix:String = paramName + "(";
			var prefixLen:int = prefix.length;

			var begin:int = line.indexOf(prefix, 0);

			if (begin == -1)
				return null;

			var end:int = line.indexOf(")", begin + prefixLen);

			if (end == -1)
				return null;

			return line.substring(begin + prefixLen, end);
		}

		private var n:int = -1;

		private function addFace(v0:Vector3D, v1:Vector3D, v2:Vector3D, uv0:Vector3D, uv1:Vector3D, uv2:Vector3D):void
		{
			_geometryData.vertices.push(-v0.x, -v0.y, v0.z, -v1.x, -v1.y, v1.z, -v2.x, -v2.y, v2.z);
			_geometryData.uvtData.push(uv0.x, uv0.y, 1, uv1.x, uv1.y, 1, uv2.x, uv2.y, 1);

			n += 3;

			_geometryData.indices.push(n, n - 1, n - 2);
		}

		private function buildMeshes():void
		{

			for each (var _meshData:MeshData in meshDataList)
			{
				//create Mesh object
				var mesh:Mesh = new Mesh();
				//mesh.name = _meshData.name;

				_meshData.material.meshes.push(mesh);

				_geometryData = _meshData.geometry;
				/*
				   var geometry:Geometry = _geometryData.geometry;

				   if (!geometry) {
				   geometry = _geometryData.geometry = new Geometry();

				   mesh.geometry = geometry;

				   //set materialdata for each face
				   for each (var _meshMaterialData:MeshMaterialData in _geometryData.materials) {
				   for each (var _faceListIndex:int in _meshMaterialData.faceList) {
				   var _faceData:FaceData = _geometryData.faces[_faceListIndex] as FaceData;
				   _faceData.materialData = materialLibrary[_meshMaterialData.symbol];
				   }
				   }

				   for each(_faceData in _geometryData.faces) {

				   if (_faceData.materialData)
				   _faceMaterial = _faceData.materialData.material as ITriangleMaterial;
				   else
				   _faceMaterial = null;

				   var _face:Face = new Face(_geometryData.vertices[_faceData.v0],
				   _geometryData.vertices[_faceData.v1],
				   _geometryData.vertices[_faceData.v2],
				   _faceMaterial,
				   _geometryData.uvs[_faceData.v0],
				   _geometryData.uvs[_faceData.v1],
				   _geometryData.uvs[_faceData.v2]);
				   geometry.addFace(_face);

				   if (_faceData.materialData)
				   _faceData.materialData.elements.push(_face);
				   }
				   } else {
				   mesh.geometry = geometry;
				   }
				 */
				mesh._vertices = _geometryData.vertices;
				var uvt:Number;
				for each (uvt in _geometryData.uvtData)
					mesh._uvtData.push(uvt);
				var index:int;
				for each (index in _geometryData.indices)
					mesh._indices.push(index);

				mesh.buildFaces();

				//center vertex points in mesh for better bounding radius calulations
				if (centerMeshes)
				{
					var i:int = mesh._vertices.length / 3;
					_moveVector.x = (_geometryData.maxX + _geometryData.minX) / 2;
					_moveVector.y = (_geometryData.maxY + _geometryData.minY) / 2;
					_moveVector.z = (_geometryData.maxZ + _geometryData.minZ) / 2;
					while (i--)
					{
						mesh._vertices[i * 3] -= _moveVector.x;
						mesh._vertices[i * 3 + 1] -= _moveVector.y;
						mesh._vertices[i * 3 + 2] -= _moveVector.z;
					}
					_moveVector = mesh.transform.matrix3D.transformVector(_moveVector);
					mesh.transform.matrix3D.position = _moveVector.clone();
				}

				mesh.type = ".mqo";
				(_container as ObjectContainer3D).addChild(mesh);
			}
		}


		public var charset:String = "shift_jis";

		/**
		 * Controls the use of shading materials when color textures are encountered. Defaults to false.
		 */
		public var shading:Boolean = false;

		/**
		 * A scaling factor for all geometry in the model. Defaults to 1.
		 */
		public var scaling:Number = 1;

		/**
		 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values.
		 */
		public var centerMeshes:Boolean;

		/**
		 * Creates a new <code>MQO</code> object.
		 */
		public function MQO()
		{
			super();

			_container = new ObjectContainer3D();
			_container.name = "mqo";

			_container.materialLibrary = _materialLibrary;
			_container.geometryLibrary = _geometryLibrary;

			binary = true;
		}
	}
}