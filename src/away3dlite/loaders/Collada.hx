package away3dlite.loaders;
import away3dlite.animators.bones.Bone;
import away3dlite.animators.bones.Channel;
import away3dlite.animators.bones.SkinController;
import away3dlite.animators.bones.SkinVertex;
import away3dlite.animators.BonesAnimator;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Mesh;
import away3dlite.core.base.Object3D;
import away3dlite.core.utils.Cast;
import away3dlite.core.utils.Debug;
import away3dlite.haxeutils.FastStd;
import away3dlite.loaders.data.AnimationData;
import away3dlite.loaders.data.BoneData;
import away3dlite.loaders.data.ChannelData;
import away3dlite.loaders.data.ContainerData;
import away3dlite.loaders.data.FaceData;
import away3dlite.loaders.data.GeometryData;
import away3dlite.loaders.data.MaterialData;
import away3dlite.loaders.data.MeshData;
import away3dlite.loaders.data.MeshMaterialData;
import away3dlite.loaders.data.ObjectData;
import away3dlite.loaders.utils.AnimationLibrary;
import away3dlite.loaders.utils.ChannelLibrary;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.Lib;
import flash.utils.Dictionary;
import flash.Vector;
import flash.xml.XML;
import flash.xml.XMLList;

//use namespace arcane;
using away3dlite.namespace.Arcane;
using away3dlite.haxeutils.HaxeUtils;
using away3dlite.haxeutils.xml.E4X;

/**
* File loader for the Collada file format with animation.
*/
class Collada extends AbstractParser
{
	private var collada:XML;
	private var animationLibrary:AnimationLibrary;
	private var channelLibrary:ChannelLibrary;
	private var symbolLibrary:Hash<MaterialData>;
	private var yUp:Bool;
	private var _face:Face;
	private var _moveVector:Vector3D;
	private var _geometryArray:Array<GeometryData>;
	private var _geometryArrayLength:Int;
	private var _channelArray:Array<ChannelData>;
	private var _channelArrayLength:Int;
	private var _defaultAnimationClip:AnimationData;
	private var _haveClips:Bool;
	private var _containers:Hash<Object3D>;
	private var _skinControllers:Vector<SkinController>;
	private var _skinController:SkinController;
	
	public var bothsides:Bool;
	public var useIDAsName:Bool;
	
	private function buildContainers(containerData:ContainerData, parent:ObjectContainer3D, depth:Int):Void
	{
		var spaces = "";
		for (s in 0...depth)
			spaces += " ";
		
		Debug.trace(" + Build Container : " + spaces + containerData.name);
		
		for (_objectData in containerData.children) {
			if (FastStd.is(_objectData, BoneData)) {
				var _boneData:BoneData = Lib.as(_objectData, BoneData);
				var bone:Bone = new Bone();
				bone.name = _boneData.name;
				_boneData.container = Lib.as(bone, ObjectContainer3D);
				
				_containers.set(bone.name, bone);
				
				//ColladaMaya 3.05B
				bone.boneId = _boneData.id;
				
				bone.transform.matrix3D = _boneData.transform;
				
				bone.joint.transform.matrix3D = _boneData.jointTransform;
				
				buildContainers(_boneData, bone.joint, depth+1);
				
				parent.addChild(bone);
				
			} else if (FastStd.is(_objectData, ContainerData)) {
				var _containerData:ContainerData = Lib.as(_objectData, ContainerData);
				var objectContainer:ObjectContainer3D = _containerData.container = new ObjectContainer3D();
				objectContainer.name = _containerData.name;
				
				objectContainer.transform.matrix3D = _objectData.transform;
				
				if (_objectData.downcast(ContainerData).geometry != null)
				{
					fillMesh(Lib.as(objectContainer, Mesh), Lib.as(_objectData, MeshData), parent);
					_containers.set(_objectData.name, objectContainer);
				}
				
				buildContainers(_containerData, objectContainer, depth+1);
				
				//TODO: set bounding values (max/min) on _containerData objects
				if (centerMeshes && objectContainer.children.length != 0) {
					//center children in container for better bounding radius calulations
					var i:Int = objectContainer.children.length;
					_moveVector.x = (_containerData.maxX + _containerData.minX)/2;
					_moveVector.y = (_containerData.maxY + _containerData.minY)/2;
					_moveVector.z = (_containerData.maxZ + _containerData.minZ)/2;
					while (i-- != 0) {
						objectContainer.children[i].x -= _moveVector.x;
						objectContainer.children[i].y -= _moveVector.y;
						objectContainer.children[i].z -= _moveVector.z;
					}
					//_moveVector = objectContainer.transform.matrix3D.transformVector(_moveVector);
					//objectContainer.x += _moveVector.x;
					//objectContainer.y += _moveVector.y;
					//objectContainer.z += _moveVector.z;
				}
				
				parent.addChild(objectContainer);
				
			} else if (Std.is(_objectData, MeshData))
			{
				var mesh:Mesh = buildMesh(Lib.as(_objectData, MeshData), parent, depth + 1);
				_containers.set(_objectData.name, mesh);
				
				parent.addChild(mesh);
			}
		}
	}
	
	private function buildMesh(_meshData:MeshData, parent:ObjectContainer3D, depth:Int):Mesh
	{
		var spaces = "";
		for (s in 0...depth)
			spaces += " ";
		
		Debug.trace(" + Build Mesh : "+ spaces +_meshData.name);
		
		var mesh:Mesh = new Mesh();
		fillMesh(mesh, _meshData, parent);
		return mesh;
	}
	
	private function fillMesh(mesh:Mesh, _meshData:MeshData, parent:ObjectContainer3D):Void
	{
		mesh.name = _meshData.name;
		mesh.transform.matrix3D = _meshData.transform;
		mesh.bothsides = _meshData.geometry.bothsides;
		
		var _geometryData:GeometryData = _meshData.geometry;
		
		//set materialdata for each face
		var _faceData:FaceData;
		for (_meshMaterialData in _geometryData.materials) {
			for (_faceListIndex in _meshMaterialData.faceList) {
				_faceData = Lib.as(_geometryData.faces[_faceListIndex], FaceData);
				_faceData.materialData = symbolLibrary.get(_meshMaterialData.symbol);
			}
		}
		
		//set skincontrollers parent value
		for (_skinController in _geometryData.skinControllers)
			_skinController.parent = parent;
		
		var _materialData:MaterialData = null;
		var i:Int = 0;
		var i0:Int;
		var i1:Int;
		var i2:Int;
		var vertices:Vector<Float> = _geometryData.vertices;
		var uvtData:Vector<Float> = _geometryData.uvtData;
		
		for (_faceData in _geometryData.faces) {
			//set face materials
			_materialData = _faceData.materialData;
			mesh.arcaneNS()._faceMaterials.push(_materialData.material);
			
			//set vertices
			i0 = _faceData.v0*3;
			i1 = _faceData.v1*3;
			i2 = _faceData.v2*3;
			mesh.arcaneNS()._vertices.push3(vertices[i0], vertices[i0+1], vertices[i0+2]);
			buildSkinVertices(_geometryData, _faceData.v0, mesh.arcaneNS()._vertices);
			mesh.arcaneNS()._vertices.push3(vertices[i1], vertices[i1+1], vertices[i1+2]);
			buildSkinVertices(_geometryData, _faceData.v1, mesh.arcaneNS()._vertices);
			mesh.arcaneNS()._vertices.push3(vertices[i2], vertices[i2+1], vertices[i2+2]);
			buildSkinVertices(_geometryData, _faceData.v2, mesh.arcaneNS()._vertices);
			
			//set uvData
			i0 = _faceData.uv0*3;
			i1 = _faceData.uv1*3;
			i2 = _faceData.uv2*3;
			mesh.arcaneNS()._uvtData.push3(uvtData[i0], uvtData[i0 + 1], uvtData[i0 + 2]);
			mesh.arcaneNS()._uvtData.push3(uvtData[i1], uvtData[i1 + 1], uvtData[i1 + 2]);
			mesh.arcaneNS()._uvtData.push3(uvtData[i2], uvtData[i2 + 1], uvtData[i2 + 2]);
			
			//set indices
			mesh.arcaneNS()._indices.push3(i++, i++, i++);
			
			//set facelengths
			mesh.arcaneNS()._faceLengths.push(3);
		}
		
		//store mesh material reference for later setting by the materialLibrary
		if (_materialData != null)
			_materialData.meshes.push(mesh);
		
		mesh.arcaneNS().buildFaces();
		
		//store element material reference for later setting by the materialLibrary
		for (_face in mesh.arcaneNS()._faces)
			if ((_materialData = _geometryData.faces[_face.faceIndex].materialData) != null)
				_materialData.faces.push(_face);
				
		if (centerMeshes) {
			var k:Int = Std.int( mesh.arcaneNS()._vertices.length/3 );
			_moveVector.x = (_geometryData.maxX + _geometryData.minX)/2;
			_moveVector.y = (_geometryData.maxY + _geometryData.minY)/2;
			_moveVector.z = (_geometryData.maxZ + _geometryData.minZ)/2;
			while (k-- != 0) {
				mesh.arcaneNS()._vertices[k*3] -= _moveVector.x;
				mesh.arcaneNS()._vertices[k*3+1] -= _moveVector.y;
				mesh.arcaneNS()._vertices[k*3+2] -= _moveVector.z;
			}
			mesh.transform.matrix3D.appendTranslation(_moveVector.x, _moveVector.y, _moveVector.z);
		}
		
		mesh.type = ".Collada";
	}
	
	private function buildSkinVertices(geometryData:GeometryData, i:Int, vertices:Vector<Float>):Void
	{
		if (geometryData.skinVertices.length == 0)
			return;
		
		var skinController:SkinController;
		var skinVertex:SkinVertex = geometryData.skinVertices[i].clone();
		
		skinVertex.updateVertices(vertices.length - 3, vertices);
		
		for (skinController in geometryData.skinControllers)
			skinController.skinVertices.push(skinVertex);
	}
	
	private function buildAnimations():Void
	{
		var bone:Bone;
		
		//hook up bones to skincontrollers
		for (_skinController in _skinControllers) {
			bone = Lib.as(container, ObjectContainer3D).getBoneByName(_skinController.name);
			if (bone != null) {
				_skinController.joint = bone.joint;
				_skinController.update();
			} else
				Debug.warning("no joint found for " + _skinController.name);
		}
		
		//process animations
		for (_animationData in animationLibrary)
		{
			switch (_animationData.animationType)
			{
				case AnimationData.SKIN_ANIMATION:
					var animation:BonesAnimator = new BonesAnimator();
					
					for (_skinController in _skinControllers)
						animation.addSkinController(_skinController);
					
					var param:Array<Dynamic>;
					var rX:String;
					var rY:String;
					var rZ:String;
					var sX:String;
					var sY:String;
					var sZ:String;
					
					for (channelData in _animationData.channels) {
						var channel:Channel = channelData.channel;
						
						channel.target = _containers.get(channel.name);
						animation.addChannel(channel);
						
						var times:Array<Float> = channel.times;
						
						if (_animationData.start > times[0])
							_animationData.start = times[0];
						
						if (_animationData.end < times[Std.int(times.length) - 1])
							_animationData.end = Std.int(times[Std.int(times.length) - 1]);
						
						if (FastStd.is(channel.target, Bone)) {
							rX = "jointRotationX";
							rY = "jointRotationY";
							rZ = "jointRotationZ";
							sX = "jointScaleX";
							sY = "jointScaleY";
							sZ = "jointScaleZ";
						} else {
							rX = "rotationX";
							rY = "rotationY";
							rZ = "rotationZ";
							sX = "scaleX";
							sY = "scaleY";
							sZ = "scaleZ";
						}
						
						switch(channelData.type)
						{
							case "translateX",
							"translationX",
							"transform(3)(0)":
								channel.type = ["x"];
								if (yUp) {
									for (param in channel.param)
										param[0] *= -scaling;
								} else {
									for (param in channel.param)
										param[0] *= scaling;
								}
							case "translateY",
							"translationY",
							"transform(3)(1)":
								if (yUp)
									channel.type = ["y"];
								else
									channel.type = ["z"];
								
								for (param in channel.param)
									param[0] *= -scaling;
							case "translateZ",
							"translationZ",
							"transform(3)(2)":
								if (yUp)
									channel.type = ["z"];
								else
									channel.type = ["y"];
								
								for (param in channel.param)
									param[0] *= scaling;
							case "jointOrientX",
							"rotateXANGLE",
							"rotateX",
							"RotX":
								channel.type = [rX];
								
								for (param in channel.param)
										param[0] *= -1;
							case "jointOrientY",
							"rotateYANGLE",
							"rotateY",
							"RotY":
								if (yUp)
									channel.type = [rY];
								else
									channel.type = [rZ];
								
								for (param in channel.param)
									param[0] *= -1;
							case "jointOrientZ",
							"rotateZANGLE",
							"rotateZ",
							"RotZ":
								if (yUp)
									channel.type = [rZ];
								else
									channel.type = [rY];
							case "scaleX",
							"transform(0)(0)":
								channel.type = [sX];
							case "scaleY",
							"transform(1)(1)":
								if (yUp)
									channel.type = [sY];
								else
									channel.type = [sZ];
							case "scaleZ",
							"transform(2)(2)":
								if (yUp)
									channel.type = [sZ];
								else
									channel.type = [sY];
							case "translate",
							"translation":
								if (yUp) {
									channel.type = ["x", "y", "z"];
									for (param in channel.param) {
										param[0] *= -scaling;
										param[1] *= -scaling;
										param[2] *= scaling;
									}
								} else {
									channel.type = ["x", "z", "y"];
									for (param in channel.param) {
										param[0] *= scaling;
										param[1] *= -scaling;
										param[2] *= scaling;
									}
								}
							case "scale":
								if (yUp)
									channel.type = [sX, sY, sZ];
								else
									channel.type = [sX, sZ, sY];
							case "rotate":
								if (yUp)
									channel.type = [rX, rY, rZ];
								else
									channel.type = [rX, rZ, rY];
								
								for (param in channel.param)
									param[0] *= -1;
							case "transform":
								channel.type = ["transform"];
							
							case "visibility":
								channel.type = ["visibility"];
						}
					}
					
					animation.start = _animationData.start;
					animation.length = _animationData.end - _animationData.start;
					
					_animationData.animation = animation;
				case AnimationData.VERTEX_ANIMATION:
			}
		}
	}
	
	private function getArray(spaced:String):Array<Float>
	{
		spaced = spaced.split("\r\n").join(" ");
		var strings:Array<String> = spaced.split(" ");
		var numbers:Array<Float> = [];
		
		var totalStrings:Float = strings.length;
		
		var i = -1;
		while (++i < totalStrings)
			if (strings[i] != "")
				numbers.push(FastStd.parseFloat(strings[i]));

		return numbers;
	}

	private function getId(url:Dynamic):String
	{
		return FastStd.string(url).split("#")[1];
	}
	
	/**
	 * A scaling factor for all geometry in the model. Defaults to 1.
	 */
	public var scaling:Float;
	
	/**
	 * Controls the use of shading materials when color textures are encountered. Defaults to false.
	 */
	public var shading:Bool;
	
	/**
	 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values. Defaults to false.
	 */
	public var centerMeshes:Bool;
	
	/**
	 * Container data object used for storing the parsed collada data structure.
	 */
	public var containerData:ContainerData;
	
	/**
	 * Creates a new <code>Collada</code> object.
	 */
	public function new()
	{
		super();
		_moveVector = new Vector3D();
		_haveClips = false;
		_containers = new Hash<Object3D>();
			untyped _containers.h = new Dictionary(true);
		_skinControllers = new Vector<SkinController>();
		useIDAsName = true;
		bothsides = true;
		
		scaling = 1;
		
		//create the container
		_container = new ObjectContainer3D();
		_container.name = "collada";
		
		_container.materialLibrary = _materialLibrary;
		_container.geometryLibrary = _geometryLibrary;
		
		animationLibrary = container.animationLibrary = new AnimationLibrary();
		channelLibrary = new ChannelLibrary();
		symbolLibrary = new Hash<MaterialData>();
		untyped symbolLibrary.h = new Dictionary(true);
		
		binary = false;
	}
	
	/** @private */
	/*arcane*/ private override function prepareData(data:Dynamic):Void
	{
		try
		{
			collada = Cast.xml(data);
		} catch (e:Dynamic)
		{
			Debug.warning("Junk byte!?");
			var _pos = data.downcast(String).indexOf("</COLLADA>");
			collada = new XML(Std.string(data).substr(0, _pos + "</COLLADA>".length));
		}
		
		//default xml namespace = collada.namespace();
		collada = collada.removeNamespaces();
		Debug.trace(" ! ------------- Begin Parse Collada -------------");

		// Get up axis
		yUp = (collada._("asset")._("up_axis").toString() == "Y_UP")||( collada._("asset")._("up_axis").toString() == "");
		
		parseScene();
		
		parseAnimationClips();
	}
	/** @private */
	/*arcane*/ private override function parseNext():Void
	{
		if (_parsedChunks < _geometryArrayLength)
			parseMesh(_geometryArray[_parsedChunks]);
		else
			parseChannel(_channelArray[-_geometryArrayLength + _parsedChunks]);
		
		_parsedChunks++;
		
		if (_parsedChunks == _totalChunks) {
			//build materials
			buildMaterials();
			
			//build the containers
			buildContainers(containerData, Lib.as(container, ObjectContainer3D), 0 );
			
			//build animations
			buildAnimations();
			
			notifySuccess();
		} else {
			notifyProgress();
		}
	}
			
	/**
	 * Converts the scene heirarchy to an away3dlite data structure
	 */
	private function parseScene():Void
	{
		var scene:XML = collada._("library_visual_scenes")._("visual_scene")._filter_eq("@id", getId(collada._("scene")._("instance_visual_scene")._("@url")))[0];
		
		if (scene == null) {
			Debug.trace(" ! ------------- No scene to parse -------------");
			return;
		}
		
		Debug.trace(" ! ------------- Begin Parse Scene -------------");
		
		containerData = new ContainerData();
		
		for (node in scene._("node"))
			parseNode(node, containerData);
		
		Debug.trace(" ! ------------- End Parse Scene -------------");
		_geometryArray = geometryLibrary.getGeometryArray();
		_geometryArrayLength = _geometryArray.length;
		_totalChunks += _geometryArrayLength;
	}
	
	/**
	 * Converts a single scene node to a BoneData ContainerData or MeshData object.
	 * 
	 * @see away3dlite.loaders.data.BoneData
	 * @see away3dlite.loaders.data.ContainerData
	 * @see away3dlite.loaders.data.MeshData
	 */
	private function parseNode(node:XML, parent:ContainerData):Void
	{	
		var _transform:Matrix3D;
		var _objectData:ObjectData;
		
		if ((node._("instance_light")._("@url").toString()) != "" || (node._("instance_camera")._("@url").toString()) != "")
			return;
		
		
		if ((node._("instance_controller").toString()) == "" && (node._("instance_geometry").toString()) == "")
		{
			
			if ((node._("@type").toString()) == "JOINT")
				_objectData = new BoneData();
			else {
				if ((node._("instance_node")._("@url").toString()) == "" && ((node._("node").toString()) == ""))
					return;
				_objectData = new ContainerData();
			}
		}else{
			_objectData = new MeshData();
		}
		
		//ColladaMaya 3.05B
		if ((node._("@type").toString()) == "JOINT")
			_objectData.id = node._("@sid").toString();
		else
			_objectData.id = node._("@id").toString();
		
		/*Deprecrated for ColladaMaya 3.02
		if((node._("@name").toString()) != "")
		{
			_objectData.name = (node._("@name").toString());
		}else{
			_objectData.name = (node._("@id").toString());
		}*/
		
		_objectData.name = node._("@id").toString();
		
		_transform = _objectData.transform;
		
		Debug.trace(" + Parse Node : " + _objectData.id + " : " + _objectData.name);
		
		var nodeName:String;
		var geo:XML;
		var ctrlr:XML;
		var sid:String;
		var instance_material:XML;
		var arrayChild:Array<Float>;
		var boneData:BoneData = Lib.as(_objectData, BoneData);
		
		for (childNode in node.children())
		{
			nodeName = (childNode.name().localName);
			switch(nodeName)
			{
				case "translate":
					arrayChild = getArray(childNode.toString());
					if (yUp)
						_transform.prependTranslation(-arrayChild[0]*scaling, -arrayChild[1]*scaling, arrayChild[2]*scaling);
					else
						_transform.prependTranslation(arrayChild[0]*scaling, -arrayChild[2]*scaling, arrayChild[1]*scaling);

				case "rotate":
					arrayChild = getArray(childNode.toString());
					sid = childNode._("@sid").toString();
					if (FastStd.is(_objectData, BoneData) && (sid == "rotateX" || sid == "rotateY" || sid == "rotateZ" || sid == "rotX" || sid == "rotY" || sid == "rotZ")) {
						if (yUp) {
							boneData.jointTransform.prependRotation(-arrayChild[3], new Vector3D(arrayChild[0], arrayChild[1], -arrayChild[2]));
						} else {
							boneData.jointTransform.prependRotation(arrayChild[3], new Vector3D(arrayChild[0], -arrayChild[2], arrayChild[1]));
						}
					} else {
						if (yUp) {
							_transform.prependRotation(-arrayChild[3], new Vector3D(arrayChild[0], arrayChild[1], -arrayChild[2]));
						} else {
							_transform.prependRotation(arrayChild[3], new Vector3D(arrayChild[0], -arrayChild[2], arrayChild[1]));
						}
					}
					
				case "scale":
					arrayChild = getArray(childNode.toString());
					if (arrayChild[0] == 0)	arrayChild[0] = 1;
					if (arrayChild[1] == 0)	arrayChild[1] = 1;
					if (arrayChild[2] == 0)	arrayChild[2] = 1;
					
					if ( FastStd.is(_objectData, BoneData) ) {
						if (yUp)
							boneData.jointTransform.prependScale(arrayChild[0], arrayChild[1], arrayChild[2]);
						else
							boneData.jointTransform.prependScale(arrayChild[0], arrayChild[2], arrayChild[1]);
					} else {
						if (yUp)
							_transform.prependScale(arrayChild[0], arrayChild[1], arrayChild[2]);
						else
							_transform.prependScale(arrayChild[0], arrayChild[2], arrayChild[1]);
					}
					
				// Baked transform matrix
				case "matrix":
					arrayChild = getArray(childNode.toString());
					var m:Matrix3D = new Matrix3D();
					m.rawData = array2matrix(arrayChild, yUp, scaling);
					_transform.prepend(m);
					
				case "node":
					//3dsMax 11 - Feeling ColladaMax v3.05B
					//<node><node/></node>
					if(FastStd.is(_objectData, MeshData) && !(FastStd.is(_objectData, ContainerData)))
					{
						//parseNode(childNode, Lib.as(parent, ContainerData));
						//WRONG: parseNode(childNode, parent as ContainerData);
						
						// _objectData is a Mesh but ALSO a container!!!
						// WE MUST preserve the hierarchy because if animation is applied onto the mesh _objectData
						// then its children must apply this animation too.
						// We could use the fact that an ObjectContainer3D is also a Mesh, but on the loader side
						// ContainerData doesn't derive from MeshData.
						// So I have added this missing derivative to ContainerData class.
						var fooContainer:ContainerData = new ContainerData();
						_objectData.clone(Lib.as(fooContainer, MeshData));
						_objectData = fooContainer;
					}else{
						parseNode(childNode, Lib.as(_objectData, ContainerData));
					}
					
				case "instance_node":
					parseNode(collada._("library_nodes")._("node")._filter_eq("@id", getId(childNode._("@url")))[0], Lib.as(_objectData, ContainerData));

				case "instance_geometry":
					if((childNode.toString()).indexOf("lines") == -1) {
						
						//add materials to materialLibrary
						for (instance_material in childNode.__("instance_material"))
							parseMaterial(instance_material._("@symbol").toString(), getId(instance_material._("@target")));
						
						geo = collada._("library_geometries")._("geometry")._filter_eq("@id", getId(childNode._("@url")))[0];
						
						Lib.as(_objectData, MeshData).geometry = geometryLibrary.addGeometry(geo._("@id").toString(), geo);
					}
				
				case "instance_controller":
					
					//add materials to materialLibrary
					for (instance_material in childNode.__("instance_material"))
						parseMaterial(instance_material._("@symbol").toString(), getId(instance_material._("@target")));
					
					ctrlr = collada._("library_controllers")._("controller")._filter_eq("@id", getId(childNode._("@url")))[0];
					geo = collada._("library_geometries")._("geometry")._filter_eq("@id", getId(ctrlr._("skin")[0]._("@source")))[0];
					
					Lib.as(_objectData, MeshData).geometry = geometryLibrary.addGeometry(geo._("@id").toString(), geo, ctrlr);
					
					Lib.as(_objectData, MeshData).skeleton = getId(childNode._("skeleton"));
			}
		}
		
		parent.children.push(_objectData);
	}
	
	/**
	 * Converts a material definition to a MaterialData object
	 * 
	 * @see away3dlite.loaders.data.MaterialData
	 */
	private function parseMaterial(symbol:String, materialName:String):Void
	{
		var _materialData:MaterialData = materialLibrary.addMaterial(materialName);
		symbolLibrary.set(symbol, _materialData);
		if(symbol == "FrontColorNoCulling") {
			_materialData.materialType = MaterialData.SHADING_MATERIAL;
		} else {
			_materialData.textureFileName = getTextureFileName(materialName);
			
			if (_materialData.textureFileName != "") {
				_materialData.materialType = MaterialData.TEXTURE_MATERIAL;
			} else {
				if (shading)
					_materialData.materialType = MaterialData.SHADING_MATERIAL;
				else
					_materialData.materialType = MaterialData.COLOR_MATERIAL;
				
				parseColorMaterial(materialName, _materialData);
			}
		}
	}
	
	/**
	 * Parses geometry data.
	 * 
	 * @see away3dlite.loaders.data.GeometryData
	 */
	private function parseMesh(geometryData:GeometryData):Void
	{
		Debug.trace(" + Parse Geometry : "+ geometryData.name);
		
		// Triangles
		var trianglesXMLList:XMLList = geometryData.geoXML._("mesh")._("triangles");
		
		// C4D
		var isC4D:Bool = (trianglesXMLList.length()==0 && geometryData.geoXML._("mesh")._("polylist").length()>0);
		if(isC4D)
			trianglesXMLList = geometryData.geoXML._("mesh")._("polylist");
		
		for (triangles in trianglesXMLList)
		{
			// Input
			var field:Array<String> = [];
			
			for (input in triangles._("input")) {
				var semantic:String = input._("@semantic").toString();
				switch(semantic) {
					case "VERTEX":
						deserialize(input, geometryData.geoXML, "Vertex", geometryData.vertices);
					case "TEXCOORD":
						deserialize(input, geometryData.geoXML, "UV", geometryData.uvtData);
					default:
				}
				field.push(input._("@semantic").toString());
			}
			
			var data     :Array<String>  = triangles._("p").toString().split(' ');
			var len      :Float = triangles._("@count").toFloat();
			var symbol :String = triangles._("@material").toString();
			
			Debug.trace(" + Parse MeshMaterialData");
			var _meshMaterialData:MeshMaterialData = new MeshMaterialData();
			_meshMaterialData.symbol = symbol;
			geometryData.materials.push(_meshMaterialData);
			
			//if (!materialLibrary[material])
			//	parseMaterial(material, material);
				
			var j = -1;
			while(++j < len)
			{
				var _faceData:FaceData = new FaceData();

				var vn:Float = -1;
				while (++vn < 3)
				{
					for (fld in field)
					{
						switch(fld)
						{
							case "VERTEX":
								Reflect.setField(_faceData,"v" + vn, data.shift());
							case "TEXCOORD":
								Reflect.setField(_faceData,"uv" + vn, data.shift());
							default:
								data.shift();
						}
					}
				}
				
				_meshMaterialData.faceList.push(geometryData.faces.length);
				geometryData.faces.push(_faceData);
			}
		}
		
		//center vertex points in mesh for better bounding radius calulations
		//TODO: discount vertices that are not used in faces
		if (centerMeshes) {
			geometryData.maxX = Math.NEGATIVE_INFINITY;
			geometryData.minX = Math.POSITIVE_INFINITY;
			geometryData.maxY = Math.NEGATIVE_INFINITY;
			geometryData.minY = Math.POSITIVE_INFINITY;
			geometryData.maxZ = Math.NEGATIVE_INFINITY;
			geometryData.minZ = Math.POSITIVE_INFINITY;
			var k:Int = Std.int( geometryData.vertices.length/3 );
			var vertexX:Float;
			var vertexY:Float;
			var vertexZ:Float;
			while (k-- != 0) {
				vertexX = geometryData.vertices[k*3];
				vertexY = geometryData.vertices[k*3+1];
				vertexZ = geometryData.vertices[k*3+2];
				if (geometryData.maxX < vertexX)
					geometryData.maxX = vertexX;
				if (geometryData.minX > vertexX)
					geometryData.minX = vertexX;
				if (geometryData.maxY < vertexY)
					geometryData.maxY = vertexY;
				if (geometryData.minY > vertexY)
					geometryData.minY = vertexY;
				if (geometryData.maxZ < vertexZ)
					geometryData.maxZ = vertexZ;
				if (geometryData.minZ > vertexZ)
					geometryData.minZ = vertexZ;
			}
		}
		
		// Double Side
		if ((geometryData.geoXML._("extra")._("technique")._("double_sided").toString()) != "")
			geometryData.bothsides = (geometryData.geoXML._("extra")._("technique")._("double_sided")[0].toString() == "1");
		else
			geometryData.bothsides = false;
			
		// force bothsides by script
		geometryData.bothsides = geometryData.bothsides && bothsides;
		
		//parse controller
		if (geometryData.ctrlXML == null)
			return;
		
		var skin:XML = geometryData.ctrlXML._("skin")[0];
		
		var tr:Dynamic = Lib.trace;
		
		var jointId:String = getId(skin._("joints")._("input")._filter_eq("@semantic", "JOINT")[0]._("@source"));
		var tmp:String = skin._("source")._filter_eq("@id", jointId)._("Name_array").toString();
		//Blender?
		if (tmp == null) tmp = skin._("source")._filter_eq("@id", jointId)._("IDREF_array").toString();
		tmp = tmp.split("\n").join(" ");
		var nameArray:Array<String> = tmp.split(" ");
		
		var bind_shape:Matrix3D = new Matrix3D();
		bind_shape.rawData = array2matrix(getArray(skin._("bind_shape_matrix")[0].toString()), yUp, scaling);
		
		var bindMatrixId:String = getId(skin._("joints")._("input")._filter_eq("@semantic", "INV_BIND_MATRIX")._("@source"));
		var float_array:Array<Float> = getArray(skin._("source")._filter_eq("@id", bindMatrixId)[0]._("float_array").toString());
		
		var v:Array<String>;
		var matrix:Matrix3D;
		var name:String;
		var skinController:SkinController;
		var i:Int = 0;
		
		while (i < float_array.length)
		{
			name = nameArray[Std.int(i / 16)];
			matrix = new Matrix3D();
			matrix.rawData = array2matrix(float_array.slice(i, i+16), yUp, scaling);
			matrix.prepend(bind_shape);
			
			geometryData.skinControllers.push(skinController = new SkinController());
			skinController.name = name;
			skinController.bindMatrix = matrix;
			_skinControllers.push(skinController);
			i = i + 16;
		}
		
		Debug.trace(" + SkinWeight");

		tmp = skin._("vertex_weights")[0]._("@count").toString();
		var weightsId:String = getId(skin._("vertex_weights")._("input")._filter_eq("@semantic", "WEIGHT")[0]._("@source"));
		
		tmp = skin._("source")._filter_eq("@id", weightsId)._("float_array").toString();
		var weights:Array<String> = tmp.split(" ");
		
		tmp = skin._("vertex_weights")._("vcount").toString();
		var vcount:Array<String> = tmp.split(" ");
		
		tmp = skin._("vertex_weights")._("v").toString();
		v = tmp.split(" ");
		
		var skinVertex	:SkinVertex;
		var c			:Int;
		var count		:Int = 0;
		
		i = 0;
		var leng = geometryData.vertices.length / 3;
		while (i < leng) {
			c = FastStd.parseInt(vcount[i]);
			geometryData.skinVertices.push(skinVertex = new SkinVertex());
			var j=0;
			while (j < c) {
				skinVertex.controllers.push(geometryData.skinControllers[FastStd.parseInt(v[count])]);
				count++;
				skinVertex.weights.push(FastStd.parseFloat(weights[FastStd.parseInt(v[count])]));
				count++;
				++j;
			}
			++i;
		}
	}
	
	/**
	 * Detects and parses all animation clips
	 */ 
	private function parseAnimationClips() : Void
	{
		
		//Check for animations
		var anims:XML = collada._("library_animations")[0];
		
		if (anims == null) {
			Debug.trace(" ! ------------- No animations to parse -------------");
			return;
		}
		
		//Check to see if animation clips exist
		var clips:XML = collada._("library_animation_clips")[0];
		
		Debug.trace(" ! Animation Clips Exist : " + _haveClips);
		
		Debug.trace(" ! ------------- Begin Parse Animation -------------");
		
		var _channel_id:UInt = 0;
		
		//loop through all animations and for each through all its channels
		var _channelName:String;
		var _channels:XMLList;
		var channelIndex:Int;
		var id:String;
		var type:String;
		if (anims._("animation")._("animation").length() == 0)
		{
			for (animation in anims._("animation"))
			{
				if((animation._("@id").toString()).length>0)
				{
					_channelName = animation._("@id").toString();
				}else{
					// COLLADAMax NextGen;  Version: 1.1.0;  Platform: Win32;  Configuration: Release Max2009
					// issue#1 : missing channel.@id -> use automatic id instead
					Debug.trace(" ! COLLADAMax2009 id : _"+_channel_id);
					_channelName = "_"+FastStd.string(_channel_id++);
				}
				
				
				_channels = animation._("channel");
				if (_channels.length() == 1)
					channelLibrary.addChannel(_channelName, animation, 0);
				else
				{
					for (channelIndex in 0..._channels.length())
					{
						id = _channels[channelIndex]._("@target").toString();
						type = id.split("/")[1];
						
						channelLibrary.addChannel(_channelName + "_subAnim_" + type, animation, channelIndex);
					}
				}
			}
		}

		// C4D 
		// issue#1 : animation -> animation.animation
		// issue#2 : missing channel.@id -> use automatic id instead
		for (animation in anims._("animation")._("animation"))
		{
			if((animation._("@id").toString()).length > 0)
			{
				_channelName = animation._("@id").toString();
			}else{
				Debug.trace(" ! C4D id : _"+_channel_id);
				_channelName = "_" + FastStd.string(_channel_id++);
			}
			
			_channels = animation._("channel");
			if (_channels.length() == 1)
				channelLibrary.addChannel(_channelName, animation, 0);
			else
			{
				for (channelIndex in 0..._channels.length())
				{
					id = _channels[channelIndex]._("@target").toString();
					type = id.split("/")[1];
					
					channelLibrary.addChannel(_channelName + "_subAnim_" + type, animation, channelIndex);
				}
			}
		}
				
		if (clips != null) {
			//loop through all animation clips
			for(clip in clips._("animation_clip"))
				parseAnimationClip(clip);
		}
		
		//create default animation clip
		_defaultAnimationClip = animationLibrary.addAnimation("default");
		
		for (channelData in channelLibrary)
			_defaultAnimationClip.channels.set(channelData.name, channelData);
		
		Debug.trace(" ! ------------- End Parse Animation -------------");
		_channelArray = channelLibrary.getChannelArray();
		_channelArrayLength = _channelArray.length;
		_totalChunks += _channelArrayLength;
	}
	
	private function parseAnimationClip(clip:XML) : Void
	{
		var animationClip:AnimationData = animationLibrary.addAnimation(clip._("@id").toString());
		
		//TODO: Is there a need to handle case where there is multiple channels inside an animation channel (_subAnim_) ?
		for (channel in clip._("instance_animation"))
			animationClip.channels.set(getId(channel._("@url")), channelLibrary.get(getId(channel._("@url")) ));
	}
	
	private function parseChannel(channelData:ChannelData) : Void
	{
		var node:XML = channelData.xml;
		var channels:XMLList = node._("channel");
		var channelChunk:XML = channels[channelData.channelIndex];
		var id:String =  channelChunk._("@target").toString();
		var name:String = id.split("/")[0];
		var type:String = id.split("/")[1];
		
		if (type == null) {
			Debug.trace(" ! No animation type detected");
			return;
		}
		
		// C4D : didn't have @id, Maya 7 exporter has X/Y/Z split on translate
		if ((node._("@id").toString()).length > 0 && (type.split(".").length == 1 || type.split(".")[1].length > 1)) {
			type = type.split(".")[0];
			
			if ((type == "image" || node._("@id").toString().split(".")[1] == "frameExtension")) {
				//TODO : Material Animation
				Debug.trace(" ! Material animation not yet implemented");
				return;
			}
			
		} else {
			type = type.split(".").join("");
		}
		
		var channel:Channel = channelData.channel = new Channel(name);
		var i:Int;
		var j:Int;
		
		_defaultAnimationClip.channels.set(channelData.name, channelData);
		
		Debug.trace(" ! channelType : " + type);
		
		var sourceName:String = getId(channelChunk._("@source"));
		var sampler:XML = node._("sampler")._filter_eq("@id", sourceName)[0];
		
		for (input in sampler._("input"))
		{
			var src:XML = node._("source")._filter_eq("@id", getId(input._("@source")))[0];
			var strlist:Array<String> = (src._("float_array").toString()).split(" ");
			var list:Array<Float> = [];
			var len:Int = FastStd.parseInt(src._("technique_common")._("accessor")._("@count").toString());
			var stride:Int = FastStd.parseInt(src._("technique_common")._("accessor")._("@stride").toString());
			var semantic:String = input._("@semantic").toString();
			
			for (val in strlist)
				list.push(FastStd.parseFloat(val));
			
			//C4D : no stride defined
			if (stride == 0)
				stride=1;
			
			var p:String;
			
			switch(semantic) {
				case "INPUT":
					for (pf in list)
						channel.times.push(pf);
					
					if (_defaultAnimationClip.start > channel.times[0])
						_defaultAnimationClip.start = channel.times[0];
					
					if (_defaultAnimationClip.end < channel.times[channel.times.length-1])
						_defaultAnimationClip.end = channel.times[channel.times.length-1];
					
				case "OUTPUT":
					i=0;
					while (i < len) {
					   channel.param[i] = [];
						
						if (stride == 16) {
							var m:Matrix3D = new Matrix3D();
							//HAXE_WARNING
							m.rawData = array2matrix(list.slice(i*stride, i*stride + 16), yUp, scaling);
							channel.param[i].push(m);
						} else {
							j = 0;
							while (j < stride) {
								channel.param[i].push(list[i*stride + j]);
								++j;
							}
						}
						++i;
					}
					
				case "INTERPOLATION":
					for (pf in list)
					{
						channel.interpolations.push(pf);
					}
					
				case "IN_TANGENT":
					i=0;
					while (i < len)
					{
						channel.inTangent[i] = [];
						j = 0;
						while (j < stride) {
							channel.inTangent[i].push(list[stride * i + j]);
							channel.inTangent[i].push(list[stride * i + j + 1]);
							++j;
						}
						++i;
					}
					
				case "OUT_TANGENT":
					i=0;
					while (i < len)
					{
						channel.outTangent[i] = [];
						j = 0;
						while (j < stride) {
							channel.outTangent[i].push(list[stride * i + j]);
							channel.outTangent[i].push(list[stride * i + j + 1]);
							++j;
						}
						++i;
					}
					
			}
		}
		
		channelData.type = type;
	}
	
	/**
	 * Retrieves the filename of a material
	 */
	private function getTextureFileName( materialName:String ):String
	{
		var filename :String = null;
		var material:XML = collada._("library_materials")._("material")._filter_eq("@id", materialName)[0];

		if( material != null )
		{
			var effectId:String = getId( material._("instance_effect")._("@url") );
			var effect:XML = collada._("library_effects")._("effect")._filter_eq("@id", effectId)[0];

			if (effect.__("texture").length() == 0) return null;

			var textureId:String = effect.__("texture")[0]._("@texture").toString();

			var sampler:XML =  effect.__("newparam")._filter_eq("@sid", textureId)[0];

			// Blender
			var imageId:String = textureId;

			// Not Blender
			if( sampler != null )
			{
				var sourceId:String = sampler.__("source")[0].toString();
				var source:XML =  effect.__("newparam")._filter_eq("@sid", sourceId)[0];

				imageId = source.__("init_from")[0].toString();
			}

			var image:XML = collada._("library_images")._("image")._filter_eq("@id", imageId)[0];

			//3dsMax 11 - Feeling ColladaMax v3.05B.
				if(image == null)
					filename = collada._("library_images")._("image")._("init_from").text().toString();
				else
					filename = image._("init_from").toString();

			if (filename.substr(0, 2) == "./")
			{
				filename = filename.substr( 2 );
			}
		}
		return filename;
	}
	
	/**
	 * Fills the 3d matrix object with values from an array with 3d matrix values
	 * ordered from right to left and up to down.
	 */
	public function array2matrix(ar:Array<Float>, yUp:Bool, scaling:Float):Vector<Float>
	{
		var rawData:Vector<Float> = new Vector<Float>(16);
		
		if (yUp) {
			
			rawData[0] = ar[0];
			rawData[4] = ar[1];
			rawData[8] = -ar[2];
			rawData[12] = -ar[3]*scaling;
			rawData[1] = ar[4];
			rawData[5] = ar[5];
			rawData[9] = -ar[6];
			rawData[13] = -ar[7]*scaling;
			rawData[2] = -ar[8];
			rawData[6] = -ar[9];
			rawData[10] = ar[10];
			rawData[14] = ar[11]*scaling;
		} else {
			rawData[0] = ar[0];
			rawData[4] = -ar[2];
			rawData[8] = ar[1];
			rawData[12] = ar[3]*scaling;
			rawData[1] = -ar[8];
			rawData[5] = ar[10];
			rawData[9] = -ar[9];
			rawData[13] = -ar[11]*scaling;
			rawData[2] = ar[4];
			rawData[6] = -ar[6];
			rawData[10] = ar[5];
			rawData[14] = ar[7]*scaling;
		}
					 
		rawData[3] = ar[12];
		rawData[7] = ar[13];
		rawData[11] = ar[14];
		rawData[15] =  ar[15];
		
		return rawData;
	}
	
	/**
	 * Retrieves the color of a material
	 */
	private function parseColorMaterial(colorName:String, materialData:MaterialData):Void
	{
		var material:XML = collada._("library_materials")._("material")._filter_eq("@id", colorName)[0];
		
		if (material != null) {
			var effectId:String = getId( material._("instance_effect")._("@url") );
			var effect:XML = collada._("library_effects")._("effect")._filter_eq("@id", effectId)[0];
			
			materialData.ambientColor = getColorValue(effect.__("ambient")[0]);
			materialData.diffuseColor = getColorValue(effect.__("diffuse")[0]);
			materialData.specularColor = getColorValue(effect.__("specular")[0]);
			materialData.shininess = FastStd.parseFloat(effect.__("shininess")._("float")[0].toString());
		}
	}
	
	private function getColorValue(colorXML:XML):UInt
	{
		if (colorXML == null || colorXML.length() == 0)
			return 0xFFFFFF;
		
		if(colorXML._("color") == null || colorXML._("color").length() == 0)
			return 0xFFFFFF;
		
		var colorArray:Array<String> = colorXML._("color").toString().split(" ");
		if(colorArray.length <= 0)
			return 0xFFFFFF;
		
		return (FastStd.parseInt(colorArray[0])*255 << 16) | (FastStd.parseInt(colorArray[1])*255 << 8) | (FastStd.parseInt(colorArray[2])*255);
	}
	
	/**
	 * Converts a data string to an array of objects. Handles vertex and uv objects
	 */
	private function deserialize(input:XML, geo:XML, type:String, output:Vector<Float>):Void
	{
		var id:String = input._("@source").toString().split("#")[1];

		// Source?
		var acc:XMLList = geo.__("source")._filter_eq("@id", id)._("technique_common")._("accessor");

		if (acc != new XMLList())
		{
			// Build source floats array
			var floId:String  = acc._("@source").toString().split("#")[1];
			var floXML:XMLList = collada.__("float_array")._filter_eq("@id", floId);
			var floStr:String  = floXML.toString();
			var floats:Array<Float> = getArray(floStr);
			var float:Float;
			// Build params array
			var params:Array<String> = [];
			var param:String;
			
			for (par in acc._("param"))
				params.push(par._("@name").toString());

			// Build output array
			var len:Int = floats.length;
			var i:Int = 0;
			while (i < len)
			{
				var value:Vector3D = new Vector3D();
				switch (type) {
					case "Vertex":
						for (param in params) {
							float = floats[i];
							switch (param) {
								case "X":
									if (yUp)
										value.x = -float*scaling;
									else
										value.x = float*scaling;
								case "Y":
									if (yUp)
										value.y = -float*scaling;
									else
										value.z = float * scaling;
									//HAXE_WARNING
									//break;
								case "Z":
									if (yUp)
										value.z = float*scaling;
									else
										value.y = -float*scaling;
									//break;
								default:
							}
							++i;
						}
					case "UV":
						for (param in params) {
							float = floats[i];
							switch (param) {
								case "S":
									value.x = float;
								case "T":
									value.y = 1 - float;
								default:
							}
							++i;
						}
					default:
				}
				output.push3(value.x, value.y, value.z);
			}
		}
		else
		{
			// Store indexes if no source
			var recursive :XMLList = geo.__("vertices")._filter_eq("@id", id)._("input");

			deserialize(recursive[0], geo, type, output);
		}
	}
}