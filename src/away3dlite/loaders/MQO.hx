package away3dlite.loaders;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Mesh;
import away3dlite.core.utils.Cast;
import away3dlite.core.utils.Debug;
import away3dlite.loaders.data.GeometryData;
import away3dlite.loaders.data.MaterialData;
import away3dlite.loaders.data.MeshData;
import flash.geom.Vector3D;
import flash.utils.ByteArray;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;
using away3dlite.haxeutils.FastStd;

/**
 * Metasequoia
 * @author katopz@sleepydesign.com
 */
class MQO extends AbstractParser
{
	/** @private */
	/*arcane*/ private override function prepareData(data:Dynamic):Void
	{
		mqo = Cast.bytearray(data);

		var lines:Array<String> = mqo.readMultiByte(mqo.length, charset).split("\r\n");
		var l:Int = 0;
		
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
	private var _moveVector:Vector3D;
	private var _materialNames:Array<MaterialData>;
	
	/**
	 * Array of mesh data objects used for storing the parsed 3ds data structure.
	 */
	private var meshDataList:Array<MeshData>;

	private function getMaterialChunkLine(lines:Array<String>, ?startLine:Int = 0):Int
	{
		var len = lines.length;
		var i:UInt = startLine;
		
		while(++i < len)
			if (lines[i].indexOf("Material") == 0)
	             			return Std.int(i);
		
		return -1;
	}

	private function parseMaterialChunk(lines:Array<String>, startLine:Int):Int
	{
		var l:Int = getMaterialChunkLine(lines, startLine);
		
		if (l == -1)
			return -1;

		var line:String = lines[l];

		var num:Float = (line.substr(9).parseInt());
		
		if (Math.isNaN(num))
			return -1;
		
		++l;
		
		var endLine:Int = l + Std.int(num);
		
		while (l < endLine) 
		{
			line = lines[l];

			var nameBeginIndex:Int = line.indexOf("\"");
			var nameEndIndex:Int = line.indexOf("\"", nameBeginIndex + 1);
			
			_materialData = _materialLibrary.addMaterial(line.substring(nameBeginIndex + 1, nameEndIndex));
			_materialNames.push(_materialData);
			
			var tex:String = getParam(line, "tex");

			if (tex != null)
			{
				_materialData.materialType = MaterialData.TEXTURE_MATERIAL;
				
				tex = tex.substr(1, tex.length - 2);
				
				
				if (~/\.tga$/gim.match(tex) || ~/\.bmp$/gim.match(tex))
				{
					//TODO : someone really need TGA, BMP on web?
					//_material = loadTGAMaterial(path + tex);

					Debug.trace(" ! Error : TGA, BMP not support.");
					Debug.trace(" < Try : .png with same name...");
					
					tex = ~/\.tga$/.replace(tex, ".png");
					tex = ~/\.bmp$/.replace(tex, ".png");
				}
				
				_materialData.textureFileName = tex;
				
			}
			else
			{
				var colorstr:String = getParam(line, "col");
				
				if (colorstr != null)
				{
					
					var color:Array<String> = colorstr.match(~/\d+\.\d+/gim);
					var r:Int = Std.int((color[0]).parseFloat() * 255);
					var g:Int = Std.int((color[1]).parseFloat() * 255);
					var b:Int = Std.int((color[2]).parseFloat() * 255);
					var a:Float = (color[3]).parseFloat();
					
					if (shading)
						_materialData.materialType = MaterialData.SHADING_MATERIAL;
					else
						_materialData.materialType = MaterialData.COLOR_MATERIAL;
					
					_materialData.diffuseColor = (r << 16) | (g << 8) | b;
					_materialData.alpha = a;
				}
				else
					_materialData.materialType = MaterialData.WIREFRAME_MATERIAL;
			}
			
			++l;
		}

		return endLine;
	}

	private function getObjectChunkLine(lines:Array<String>, ?startLine:Int = 0):Int
	{
		var i:Int = startLine;
		var len:Int = lines.length;
		while (i < len)
		{
			if (lines[i].indexOf("Object") == 0)
			{
				return Std.int(i);
			}
			i++;
		}
		return -1;
	}

	private function parseObjectChunk(lines:Array<String>, startLine:Int):Int
	{
		n = -1;
		
		var vertices:Array<Vector3D> = [];
		
		var l:Int = getObjectChunkLine(lines, startLine);
		
		if (l == -1)
			return -1;

		var line:String = lines[l];
		
		var name:String = line.substring(8, line.indexOf("\"", 8));
		
		++l;

		var vline:Int = getChunkLine(lines, "vertex", l);
		
		if (vline == -1)
			return -1;

		var properties:Hash<String> = new Hash<String>();
		
		while (l < vline)
		{
			line = lines[l];
			//var props:Array = RegExp(/^\s*([\w]+)\s+(.*)$/).exec(line);
			var props = line.match(~/^\s*([\w]+)\s+(.*)$/);
			properties.set(props[1], props[2]);
			++l;
		}

		line = lines[l];
		l = vline + 1;

		var numVertices:Int = (line.substr(line.indexOf("vertex") + 7).parseInt());
		var vertexEndLine:Int = l + numVertices;
		var firstVertexIndex:Int = vertices.length;

		while (l < vertexEndLine)
		{
			line = lines[l];
			var coords:Array<String> = line.match(~/(-?\d+\.\d+)/g);
			var x:Float = (coords[0]).parseFloat() * scaling;
			var y:Float = (coords[1]).parseFloat() * scaling;
			var z:Float = -(coords[2]).parseFloat() * scaling;
			vertices.push(new Vector3D(x, y, z));
			++l;
		}

		l = getChunkLine(lines, "face", l);
		
		if (l == -1)
			return -1;
		
		line = lines[l++];
		
		var numFaces:Int = (line.substr(line.indexOf("face") + 5).parseInt());
		var faceEndLine:Int = l + numFaces;
		
		_meshData = new MeshData();
		_meshData.name = name;
		
		_geometryData = _meshData.geometry = _geometryLibrary.addGeometry(_meshData.name);
		
		while (l < faceEndLine)
		{
			if (properties.get("visible") == "15")
			{
				_meshData.material = parseFace(lines[l], vertices, firstVertexIndex, properties);
			}
			++l;
		}
		
		//ignore bone data
		if (_meshData.material != null)
			meshDataList.push(_meshData);
			
		//TODO : do we need this?
		/*
		   // Resolve parent-child relationship.
		   var depth:Int;
		   try {
		   depth = parseInt(properties["depth"]);
		   } catch (e:Error) {
		   depth = 0;
		   }
		   var parentMesh:ObjectContainer3D = _prevMesh;
		   if (depth <= 0) {
		   parentMesh = this;
		   depth = 0;
		   } else {
		   while (depth <= _prevDepth) {
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

	private function parseFace(line:String, vertices:Array<Vector3D>, vertexOffset:Int, properties:Hash<String>):MaterialData
	{
		var vstr:String = getParam(line, "V");
		var mstr:String = getParam(line, "M");
		var uvstr:String = getParam(line, "UV");

		var v:Array<String> = (vstr != null) ? vstr.match(~/\d+/g) : [];
		var uv:Array<String> = (uvstr != null) ? uvstr.match(~/-?\d+\.\d+/g) : [];
		var a:Vector3D = null;
		var b:Vector3D = null;
		var c:Vector3D = null;
		var d:Vector3D = null;
		var _material:MaterialData = null;
		var uvA:Vector3D = null;
		var uvB:Vector3D = null;
		var uvC:Vector3D = null;
		var uvD:Vector3D = null;
		var mirrorAxis:Int;
		if (v.length == 3)
		{
			c = vertices[(v[0]).parseInt() + vertexOffset];
			b = vertices[(v[1]).parseInt() + vertexOffset];
			a = vertices[(v[2]).parseInt() + vertexOffset];

			if (mstr != null)
				_material = _materialNames[(mstr).parseInt()];

			if (uv.length != 0)
			{
				uvC = new Vector3D((uv[0]).parseFloat(),  (uv[1]).parseFloat());
				uvB = new Vector3D((uv[2]).parseFloat(),  (uv[3]).parseFloat());
				uvA = new Vector3D((uv[4]).parseFloat(),  (uv[5]).parseFloat());
				addFace(a, b, c, uvA, uvB, uvC);
			}
			else
			{
				addFace(a, b, c, new Vector3D(0, 0), new Vector3D(1, 0), new Vector3D(0, 1));
			}


			if (properties.get("mirror") == "1")
			{
				mirrorAxis = (properties.get("mirror_axis").parseInt());
				a = mirrorVertex(a, mirrorAxis);
				b = mirrorVertex(b, mirrorAxis);
				c = mirrorVertex(c, mirrorAxis);
				vertices.push(a);
				vertices.push(b);
				vertices.push(c);
				addFace(c, b, a, uvC, uvB, uvA);
			}
		} else if (v.length == 4)
		{
			d = vertices[(v[0]).parseInt() + vertexOffset];
			c = vertices[(v[1]).parseInt() + vertexOffset];
			b = vertices[(v[2]).parseInt() + vertexOffset];
			a = vertices[(v[3]).parseInt() + vertexOffset];

			if (mstr != null)
				_material = _materialNames[(mstr).parseInt()];

			if (uv.length != 0)
			{
				uvD = new Vector3D((uv[0]).parseFloat(),  (uv[1]).parseFloat());
				uvC = new Vector3D((uv[2]).parseFloat(),  (uv[3]).parseFloat());
				uvB = new Vector3D((uv[4]).parseFloat(),  (uv[5]).parseFloat());
				uvA = new Vector3D((uv[6]).parseFloat(),  (uv[7]).parseFloat());
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
			
			if (properties.get("mirror") == "1")
			{
				mirrorAxis = (properties.get("mirror_axis").parseInt());
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

	private static function mirrorVertex(v:Vector3D, axis:Int):Vector3D
	{
		return new Vector3D(((axis & 1) != 0) ? -v.x : v.x, ((axis & 2) != 0) ? -v.y : v.y, ((axis & 4) != 0) ? -v.z : v.z);
	}

	private static function getChunkLine(lines:Array<String>, chunkName:String, ?startLine:Int = 0):Int
	{
		var i:Int = startLine;
		var len:Int = lines.length;
		while (i < len)
		{
			if (lines[i].indexOf(chunkName) != -1)
			{
				return Std.int(i);
			}
			i++;
		}
		return -1;
	}
	
	private static function getParam(line:String, paramName:String):String
	{
		var prefix:String = paramName + "(";
		var prefixLen:Int = prefix.length;

		var begin:Int = line.indexOf(prefix, 0);
		
		if (begin == -1)
			return null;
		
		var end:Int = line.indexOf(")", begin + prefixLen);
		
		if (end == -1)
			return null;
		
		return line.substring(begin + prefixLen, end);
	}
	
	private var n:Int;

	private function addFace(v0:Vector3D, v1:Vector3D, v2:Vector3D, uv0:Vector3D, uv1:Vector3D, uv2:Vector3D):Void
	{
		_geometryData.vertices.push3( -v0.x, -v0.y, v0.z);
		_geometryData.vertices.push3( -v1.x, -v1.y, v1.z);
		_geometryData.vertices.push3( -v2.x, -v2.y, v2.z);
		_geometryData.uvtData.push3(uv0.x, uv0.y, 1);
		_geometryData.uvtData.push3(uv1.x, uv1.y, 1);
		_geometryData.uvtData.push3(uv2.x, uv2.y, 1);
		
		n += 3;
		
		_geometryData.indices.push3(n, n - 1, n - 2);
		_geometryData.faceLengths.push(3);
	}
	
	private function buildMeshes():Void
	{
		
		for (_meshData in meshDataList)
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
					for each (var _faceListIndex:Int in _meshMaterialData.faceList) {
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
			mesh.arcaneNS()._vertices = _geometryData.vertices;
			mesh.arcaneNS()._uvtData = _geometryData.uvtData;
			mesh.arcaneNS()._indices = _geometryData.indices;
			mesh.arcaneNS()._faceLengths = _geometryData.faceLengths;
			
			mesh.arcaneNS().buildFaces();
			
			//center vertex points in mesh for better bounding radius calulations
			
			if (centerMeshes) 
			{
				var i:Int = Std.int( mesh.arcaneNS()._vertices.length/3);
				_moveVector.x = (_geometryData.maxX + _geometryData.minX)/2;
				_moveVector.y = (_geometryData.maxY + _geometryData.minY)/2;
				_moveVector.z = (_geometryData.maxZ + _geometryData.minZ)/2;
				while (i-- > 0)
				{
					mesh.arcaneNS()._vertices[i*3] -= _moveVector.x;
					mesh.arcaneNS()._vertices[i*3+1] -= _moveVector.y;
					mesh.arcaneNS()._vertices[i * 3 + 2] -= _moveVector.z;
				}
				_moveVector = mesh.transform.matrix3D.transformVector(_moveVector);
				mesh.transform.matrix3D.position = _moveVector.clone();
			}
			
			mesh.type = ".mqo";
			_container.downcast(ObjectContainer3D).addChild(mesh);
		}
	}
	
	
	public var charset:String;
	
	/**
	 * Controls the use of shading materials when color textures are encountered. Defaults to false.
	 */
	public var shading:Bool;
	
	/**
	 * A scaling factor for all geometry in the model. Defaults to 1.
	 */
	public var scaling:Float;
	
	/**
	 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values.
	 */
	public var centerMeshes:Bool;
	
	/**
	 * Creates a new <code>MQO</code> object.
	 */
	public function new()
	{
		super();
		_moveVector = new Vector3D();
		_materialNames = [];
		meshDataList = [];
		n = -1;
		charset = "shift_jis";
		shading = false;
		scaling = 1.0;
		
		_container = new ObjectContainer3D();
		_container.name = "mqo";
		
		_container.materialLibrary = _materialLibrary;
		_container.geometryLibrary = _geometryLibrary;
		
		binary = true;
	}
}
