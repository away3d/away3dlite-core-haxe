package away3dlite.loaders
{
	import away3dlite.animators.*;
	import away3dlite.animators.bones.*;
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	import away3dlite.core.utils.*;
	import away3dlite.loaders.data.*;
	import away3dlite.loaders.utils.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
	use namespace arcane;
	
    /**
    * File loader for the Collada file format with animation.
    */
    public class Collada extends AbstractParser
    {
        private var collada:XML;
        private var animationLibrary:AnimationLibrary;
        private var channelLibrary:ChannelLibrary;
        private var symbolLibrary:Dictionary;
        private var yUp:Boolean;
    	private var _face:Face;
    	private var _moveVector:Vector3D = new Vector3D();
		private var _geometryArray:Array;
		private var _geometryArrayLength:int;
		private var _channelArray:Array;
		private var _channelArrayLength:int;
		private var _defaultAnimationClip:AnimationData;
		private var _haveClips:Boolean = false;
		private var _containers:Dictionary = new Dictionary(true);
		private var _skinControllers:Dictionary = new Dictionary(true);
		private var _skinController:SkinController;
		
		private function buildContainers(containerData:ContainerData, parent:ObjectContainer3D):void
		{
			Debug.trace(" + Build Container : " + containerData.name);
			
			for each (var _objectData:ObjectData in containerData.children) {
				if (_objectData is MeshData) {
					var mesh:Mesh = buildMesh(_objectData as MeshData, parent);
					_containers[_objectData.name] = mesh;
				} else if (_objectData is BoneData) {
					var _boneData:BoneData = _objectData as BoneData;
					var bone:Bone = new Bone();
					bone.name = _boneData.name;
					_boneData.container = bone as ObjectContainer3D;
					
					_containers[bone.name] = bone;
					
					//ColladaMaya 3.05B
					bone.boneId = _boneData.id;
					
					bone.transform.matrix3D = _boneData.transform;
					
					bone.joint.transform.matrix3D = _boneData.jointTransform;
					
					buildContainers(_boneData, bone.joint);
					
					parent.addChild(bone);
					
				} else if (_objectData is ContainerData) {
					var _containerData:ContainerData = _objectData as ContainerData;
					var objectContainer:ObjectContainer3D = _containerData.container = new ObjectContainer3D();
					objectContainer.name = _containerData.name;
					
					_containers[objectContainer.name] = objectContainer;
					
					objectContainer.transform.matrix3D = _objectData.transform;
					
					buildContainers(_containerData, objectContainer);
					
					//TODO: set bounding values (max/min) on _containerData objects
					if (centerMeshes && objectContainer.children.length) {
						//center children in container for better bounding radius calulations
						var i:int = objectContainer.children.length;
						_moveVector.x = (_containerData.maxX + _containerData.minX)/2;
						_moveVector.y = (_containerData.maxY + _containerData.minY)/2;
						_moveVector.z = (_containerData.maxZ + _containerData.minZ)/2;
		                while (i--) {
		                	objectContainer.children[i].x -= _moveVector.x;
		                	objectContainer.children[i].y -= _moveVector.y;
							objectContainer.children[i].z -= _moveVector.z;
		                }
						_moveVector = objectContainer.transform.matrix3D.transformVector(_moveVector);
						objectContainer.x += _moveVector.x;
						objectContainer.y += _moveVector.y;
						objectContainer.z += _moveVector.z;
					}
					
					parent.addChild(objectContainer);
					
				}
			}
		}
		
		private function buildMesh(_meshData:MeshData, parent:ObjectContainer3D):Mesh
		{
			Debug.trace(" + Build Mesh : "+_meshData.name);
			
			var mesh:Mesh = new Mesh();
			mesh.name = _meshData.name;
			mesh.transform.matrix3D = _meshData.transform;
			mesh.bothsides = _meshData.geometry.bothsides;
			
			var _geometryData:GeometryData = _meshData.geometry;
			
			//set materialdata for each face
			var _faceData:FaceData;
			for each (var _meshMaterialData:MeshMaterialData in _geometryData.materials) {
				for each (var _faceListIndex:int in _meshMaterialData.faceList) {
					_faceData = _geometryData.faces[_faceListIndex] as FaceData;
					_faceData.materialData = symbolLibrary[_meshMaterialData.symbol];
				}
			}
			
			//set skincontrollers parent value
			for each (var _skinController:SkinController in _geometryData.skinControllers)
		    	_skinController.parent = parent;
			
			var _materialData:MaterialData;
			var i:int = 0;
			var i0:int;
			var i1:int;
			var i2:int;
			var vertices:Vector.<Number> = _geometryData.vertices;
			var uvtData:Vector.<Number> = _geometryData.uvtData;
			
			for each(_faceData in _geometryData.faces) {
				//set face materials
				_materialData = _faceData.materialData;
				mesh._faceMaterials.push(_materialData.material);
				
				//set vertices
				i0 = _faceData.v0*3;
				i1 = _faceData.v1*3;
				i2 = _faceData.v2*3;
				mesh._vertices.push(vertices[i0], vertices[i0+1], vertices[i0+2]);
				buildSkinVertices(_geometryData, _faceData.v0, mesh._vertices);
				mesh._vertices.push(vertices[i1], vertices[i1+1], vertices[i1+2]);
				buildSkinVertices(_geometryData, _faceData.v1, mesh._vertices);
				mesh._vertices.push(vertices[i2], vertices[i2+1], vertices[i2+2]);
				buildSkinVertices(_geometryData, _faceData.v2, mesh._vertices);
				
				//set uvData
				i0 = _faceData.uv0*3;
				i1 = _faceData.uv1*3;
				i2 = _faceData.uv2*3;
				mesh._uvtData.push(uvtData[i0], uvtData[i0+1], uvtData[i0+2], uvtData[i1], uvtData[i1+1], uvtData[i1+2], uvtData[i2], uvtData[i2+1], uvtData[i2+2]);
				
				//set indices
				mesh._indices.push(i++, i++, i++);
				
				//set facelengths
				mesh._faceLengths.push(3);
			}
			
			//store mesh material reference for later setting by the materialLibrary
			if (_materialData)
				_materialData.meshes.push(mesh);
			
			mesh.buildFaces();
			
			//store element material reference for later setting by the materialLibrary
			for each (_face in mesh._faces)
				if ((_materialData = _geometryData.faces[_face.faceIndex].materialData))
					_materialData.faces.push(_face);
					
			if (centerMeshes) {
				var k:int = mesh._vertices.length/3;
				_moveVector.x = (_geometryData.maxX + _geometryData.minX)/2;
				_moveVector.y = (_geometryData.maxY + _geometryData.minY)/2;
				_moveVector.z = (_geometryData.maxZ + _geometryData.minZ)/2;
                while (k--) {
                	mesh._vertices[k*3] -= _moveVector.x;
                	mesh._vertices[k*3+1] -= _moveVector.y;
					mesh._vertices[k*3+2] -= _moveVector.z;
                }
                _moveVector = mesh.transform.matrix3D.transformVector(_moveVector);
				mesh.x += _moveVector.x;
				mesh.y += _moveVector.y;
				mesh.z += _moveVector.z;
			}
			
			mesh.type = ".Collada";
			parent.addChild(mesh);
			return mesh;
		}
		
		private function buildSkinVertices(geometryData:GeometryData, i:int, vertices:Vector.<Number>):void
		{
			if (!geometryData.skinVertices.length)
				return;
			
			var skinController:SkinController;
			var skinVertex:SkinVertex = geometryData.skinVertices[i].clone();
			
			skinVertex.updateVertices(vertices.length - 3, vertices);
			
			for each (skinController in geometryData.skinControllers)
				skinController.skinVertices.push(skinVertex);
		}
		
		private function buildAnimations():void
		{
			var bone:Bone;
			
			//hook up bones to skincontrollers
			for each (_skinController in _skinControllers) {
				bone = (container as ObjectContainer3D).getBoneByName(_skinController.name);
                if (bone) {
                    _skinController.joint = bone.joint;
                    _skinController.update();
                } else
                	Debug.warning("no joint found for " + _skinController.name);
   			}
		   	
		   	//process animations
			for each (var _animationData:AnimationData in animationLibrary)
			{
				switch (_animationData.animationType)
				{
					case AnimationData.SKIN_ANIMATION:
						var animation:BonesAnimator = new BonesAnimator();
						
						for each (_skinController in _skinControllers)
							animation.addSkinController(_skinController);
						
						var param:Array;
			            var rX:String;
			            var rY:String;
			            var rZ:String;
			            var sX:String;
			            var sY:String;
			            var sZ:String;
						
						for each (var channelData:ChannelData in _animationData.channels) {
							var channel:Channel = channelData.channel;
							
							channel.target = _containers[channel.name];
							animation.addChannel(channel);
							
							var times:Array = channel.times;
							
							if (_animationData.start > times[0])
								_animationData.start = times[0];
							
							if (_animationData.end < times[times.length - 1])
								_animationData.end = times[times.length - 1];
							
				            if (channel.target is Bone) {
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
				                case "translateX":
				                case "translationX":
								case "transform(3)(0)":
				                	channel.type = ["x"];
									if (yUp) {
										for each (param in channel.param)
											param[0] *= -scaling;
									} else {
										for each (param in channel.param)
											param[0] *= scaling;
									}
				                	break;
								case "translateY":
								case "translationY":
								case "transform(3)(1)":
									if (yUp)
										channel.type = ["y"];
									else
										channel.type = ["z"];
									
									for each (param in channel.param)
										param[0] *= -scaling;
				     				break;
								case "translateZ":
								case "translationZ":
								case "transform(3)(2)":
									if (yUp)
										channel.type = ["z"];
									else
										channel.type = ["y"];
									
									for each (param in channel.param)
										param[0] *= scaling;
				     				break;
				     			case "jointOrientX":
								case "rotateXANGLE":
								case "rotateX":
								case "RotX":
				     				channel.type = [rX];
				     				
				     				for each (param in channel.param)
											param[0] *= -1;
				     				break;
				     			case "jointOrientY":
								case "rotateYANGLE":
								case "rotateY":
								case "RotY":
									if (yUp)
										channel.type = [rY];
									else
										channel.type = [rZ];
									
									for each (param in channel.param)
										param[0] *= -1;
				     				break;
				     			case "jointOrientZ":
								case "rotateZANGLE":
								case "rotateZ":
								case "RotZ":
									if (yUp)
										channel.type = [rZ];
									else
										channel.type = [rY];
				            		break;
								case "scaleX":
								case "transform(0)(0)":
									channel.type = [sX];
				            		break;
								case "scaleY":
								case "transform(1)(1)":
									if (yUp)
										channel.type = [sY];
									else
										channel.type = [sZ];
				     				break;
								case "scaleZ":
								case "transform(2)(2)":
									if (yUp)
										channel.type = [sZ];
									else
										channel.type = [sY];
				     				break;
								case "translate":
								case "translation":
									if (yUp) {
										channel.type = ["x", "y", "z"];
										for each (param in channel.param) {
											param[0] *= -scaling;
											param[1] *= -scaling;
											param[2] *= scaling;
										}
				     				} else {
				     					channel.type = ["x", "z", "y"];
				     					for each (param in channel.param) {
				     						param[0] *= scaling;
				     						param[1] *= -scaling;
											param[2] *= scaling;
										}
				     				}
									break;
								case "scale":
									if (yUp)
										channel.type = [sX, sY, sZ];
									else
										channel.type = [sX, sZ, sY];
				     				break;
								case "rotate":
									if (yUp)
										channel.type = [rX, rY, rZ];
				     				else
										channel.type = [rX, rZ, rY];
				     				
									for each (param in channel.param)
										param[0] *= -1;
									break;
								case "transform":
									channel.type = ["transform"];
									break;
								
								case "visibility":
									channel.type = ["visibility"];
									break;
				            }
						}
						
						animation.start = _animationData.start;
						animation.length = _animationData.end - _animationData.start;
						
						_animationData.animation = animation;
						break;
					case AnimationData.VERTEX_ANIMATION:
						break;
				}
			}
		}
		
        private function getArray(spaced:String):Array
        {
        	spaced = spaced.split("\r\n").join(" ");
            var strings:Array = spaced.split(" ");
            var numbers:Array = [];
			
            var totalStrings:Number = strings.length;
			
            for (var i:Number = 0; i < totalStrings; ++i)
            	if (strings[i] != "")
                	numbers.push(Number(strings[i]));

            return numbers;
        }

        private function getId(url:String):String
        {
            return url.split("#")[1];
        }
        
    	/**
    	 * A scaling factor for all geometry in the model. Defaults to 1.
    	 */
        public var scaling:Number;
        
    	/**
    	 * Controls the use of shading materials when color textures are encountered. Defaults to false.
    	 */
        public var shading:Boolean;
        
    	/**
    	 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values. Defaults to false.
    	 */
        public var centerMeshes:Boolean;
        
    	/**
    	 * Container data object used for storing the parsed collada data structure.
    	 */
        public var containerData:ContainerData;
		
		/**
		 * Creates a new <code>Collada</code> object.
		 */
        public function Collada()
        {
            super();
			
			scaling = 1;
			
			//create the container
            _container = new ObjectContainer3D();
			_container.name = "collada";
			
			_container.materialLibrary = _materialLibrary;
			_container.geometryLibrary = _geometryLibrary;
			
			animationLibrary = container.animationLibrary = new AnimationLibrary();
			channelLibrary = new ChannelLibrary();
			symbolLibrary = new Dictionary(true);
			
			binary = false;
        }
        
        /** @private */
        arcane override function prepareData(data:*):void
        {
        	collada = Cast.xml(data);
        	
			default xml namespace = collada.namespace();
			Debug.trace(" ! ------------- Begin Parse Collada -------------");

            // Get up axis
            yUp = (collada["asset"].up_axis == "Y_UP")||(String(collada["asset"].up_axis) == "");
			
            parseScene();
			
			parseAnimationClips();
        }
    	/** @private */
        arcane override function parseNext():void
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
				buildContainers(containerData, container as ObjectContainer3D);
				
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
        private function parseScene():void
        {
        	var scene:XML = collada["library_visual_scenes"].visual_scene.(@id == getId(collada["scene"].instance_visual_scene.@url))[0];
        	
        	if (scene == null) {
        		Debug.trace(" ! ------------- No scene to parse -------------");
        		return;
        	}
        	
			Debug.trace(" ! ------------- Begin Parse Scene -------------");
			
			containerData = new ContainerData();
			
            for each (var node:XML in scene["node"])
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
        private function parseNode(node:XML, parent:ContainerData):void
        {	
			var _transform:Matrix3D;
	    	var _objectData:ObjectData;
	    	
        	if (String(node["instance_light"].@url) != "" || String(node["instance_camera"].@url) != "")
        		return;
	    	
	    	
			if (String(node["instance_controller"]) == "" && String(node["instance_geometry"]) == "")
			{
				
				if (String(node.@type) == "JOINT")
					_objectData = new BoneData();
				else {
					if (String(node["instance_node"].@url) == "" && (String(node["node"]) == "" || parent is BoneData))
						return;
					_objectData = new ContainerData();
				}
			}else{
				_objectData = new MeshData();
			}
			
			parent.children.push(_objectData);
			
			//ColladaMaya 3.05B
			if (String(node.@type) == "JOINT")
				_objectData.id = node.@sid;
			else
				_objectData.id = node.@id;
			
			//ColladaMaya 3.02
			if(String(node.@name) != "")
			{
            	_objectData.name = String(node.@name);
   			}else{
   				_objectData.name = String(node.@id);
   			}
   
            _transform = _objectData.transform;
			
			Debug.trace(" + Parse Node : " + _objectData.id + " : " + _objectData.name);
			
			var nodeName:String;
           	var geo:XML;
           	var ctrlr:XML;
           	var sid:String;
			var instance_material:XML;
			var arrayChild:Array;
			var boneData:BoneData = (_objectData as BoneData);
			
            for each (var childNode:XML in node.children())
            {
                arrayChild = getArray(childNode);
                nodeName = String(childNode.name()["localName"]);
				switch(nodeName)
                {
					case "translate":
						if (yUp)
			                _transform.prependTranslation(-arrayChild[0]*scaling, -arrayChild[1]*scaling, arrayChild[2]*scaling);
			            else
			                _transform.prependTranslation(arrayChild[0]*scaling, -arrayChild[2]*scaling, arrayChild[1]*scaling);
                        
                        break;

                    case "rotate":
                    	sid = childNode.@sid;
                        if (_objectData is BoneData && (sid == "rotateX" || sid == "rotateY" || sid == "rotateZ" || sid == "rotX" || sid == "rotY" || sid == "rotZ")) {
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
	                    
                        break;
						
                    case "scale":
                        if (_objectData is BoneData) {
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
						
                        break;
						
                    // Baked transform matrix
                    case "matrix":
                    	var m:Matrix3D = new Matrix3D();
                    	m.rawData = array2matrix(arrayChild, yUp, scaling);
                        _transform.prepend(m);
						break;
						
                    case "node":
                    	//3dsMax 11 - Feeling ColladaMax v3.05B
                    	//<node><node/></node>
                    	if(_objectData is MeshData)
                    	{
							parseNode(childNode, parent as ContainerData);
                    	}else{
                    		parseNode(childNode, _objectData as ContainerData);
                    	}
                        
                        break;

    				case "instance_node":
    					parseNode(collada["library_nodes"].node.(@id == getId(childNode.@url))[0], _objectData as ContainerData);
    					
    					break;

                    case "instance_geometry":
                    	if(String(childNode).indexOf("lines") == -1) {
							
							//add materials to materialLibrary
	                        for each (instance_material in childNode..instance_material)
	                        	parseMaterial(instance_material.@symbol, getId(instance_material.@target));
							
							geo = collada["library_geometries"].geometry.(@id == getId(childNode.@url))[0];
							
	                        (_objectData as MeshData).geometry = geometryLibrary.addGeometry(geo.@id, geo);
	                    }
	                    
                        break;
					
                    case "instance_controller":
						
						//add materials to materialLibrary
						for each (instance_material in childNode..instance_material)
							parseMaterial(instance_material.@symbol, getId(instance_material.@target));
						
						ctrlr = collada["library_controllers"].controller.(@id == getId(childNode.@url))[0];
						geo = collada["library_geometries"].geometry.(@id == getId(ctrlr["skin"][0].@source))[0];
						
	                    (_objectData as MeshData).geometry = geometryLibrary.addGeometry(geo.@id, geo, ctrlr);
						
						(_objectData as MeshData).skeleton = getId(childNode["skeleton"]);
						break;
                }
            }
        }
		
		/**
		 * Converts a material definition to a MaterialData object
		 * 
		 * @see away3dlite.loaders.data.MaterialData
		 */
        private function parseMaterial(symbol:String, materialName:String):void
        {
           	var _materialData:MaterialData = materialLibrary.addMaterial(materialName);
        	symbolLibrary[symbol] = _materialData;
            if(symbol == "FrontColorNoCulling") {
            	_materialData.materialType = MaterialData.SHADING_MATERIAL;
            } else {
                _materialData.textureFileName = getTextureFileName(materialName);
                
                if (_materialData.textureFileName) {
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
		private function parseMesh(geometryData:GeometryData):void
		{
			Debug.trace(" + Parse Geometry : "+ geometryData.name);
			
            // Triangles
            var trianglesXMLList:XMLList = geometryData.geoXML["mesh"].triangles;
            
            // C4D
            var isC4D:Boolean = (trianglesXMLList.length()==0 && geometryData.geoXML["mesh"].polylist.length()>0);
            if(isC4D)
            	trianglesXMLList = geometryData.geoXML["mesh"].polylist;
            
            for each (var triangles:XML in trianglesXMLList)
            {
                // Input
                var field:Array = [];
                
                for each(var input:XML in triangles["input"]) {
                	var semantic:String = input.@semantic;
                	switch(semantic) {
                		case "VERTEX":
                			deserialize(input, geometryData.geoXML, "Vertex", geometryData.vertices);
                			break;
                		case "TEXCOORD":
                			deserialize(input, geometryData.geoXML, "UV", geometryData.uvtData);
							break;
                		default:
                	}
                    field.push(input.@semantic);
                }
				
                var data     :Array  = triangles["p"].split(' ');
                var len      :Number = triangles.@count;
                var symbol :String = triangles.@material;
                
				Debug.trace(" + Parse MeshMaterialData");
                var _meshMaterialData:MeshMaterialData = new MeshMaterialData();
    			_meshMaterialData.symbol = symbol;
				geometryData.materials.push(_meshMaterialData);
				
				//if (!materialLibrary[material])
				//	parseMaterial(material, material);
					
                for (var j:Number = 0; j < len; ++j)
                {
                    var _faceData:FaceData = new FaceData();

                    for (var vn:Number = 0; vn < 3; vn++)
                    {
                        for each (var fld:String in field)
                        {
                        	switch(fld)
                        	{
                        		case "VERTEX":
                        			_faceData["v" + vn] = data.shift();
                        			break;
                        		case "TEXCOORD":
                        			_faceData["uv" + vn] = data.shift();
                        			break;
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
				geometryData.maxX = -Infinity;
				geometryData.minX = Infinity;
				geometryData.maxY = -Infinity;
				geometryData.minY = Infinity;
				geometryData.maxZ = -Infinity;
				geometryData.minZ = Infinity;
				var k:int = geometryData.vertices.length/3;
				var vertexX:Number;
				var vertexY:Number;
				var vertexZ:Number;
	            while (k--) {
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
			if (String(geometryData.geoXML["extra"].technique.double_sided) != "")
            	geometryData.bothsides = (geometryData.geoXML["extra"].technique.double_sided[0].toString() == "1");
            else
            	geometryData.bothsides = false;
			
			//parse controller
			if (!geometryData.ctrlXML)
				return;
			
			var skin:XML = geometryData.ctrlXML["skin"][0];
			
			var jointId:String = getId(skin["joints"].input.(@semantic == "JOINT")[0].@source);
            var tmp:String = skin["source"].(@id == jointId)["Name_array"].toString();
			//Blender?
			if (!tmp) tmp = skin["source"].(@id == jointId)["IDREF_array"].toString();
            tmp = tmp.replace(/\n/g, " ");
            var nameArray:Array = tmp.split(" ");
            
			var bind_shape:Matrix3D = new Matrix3D();
			bind_shape.rawData = array2matrix(getArray(skin["bind_shape_matrix"][0].toString()), yUp, scaling);
			
			var bindMatrixId:String = getId(skin["joints"].input.(@semantic == "INV_BIND_MATRIX").@source);
            var float_array:Array = getArray(skin["source"].(@id == bindMatrixId)[0].float_array.toString());
            
            var v:Array;
            var matrix:Matrix3D;
            var name:String;
			var skinController:SkinController;
            var i:int = 0;
            
            while (i < float_array.length)
            {
            	name = nameArray[i / 16];
				matrix = new Matrix3D();
				matrix.rawData = array2matrix(float_array.slice(i, i+16), yUp, scaling);
				matrix.prepend(bind_shape);
				
                geometryData.skinControllers.push(skinController = new SkinController());
                skinController.name = name;
                skinController.bindMatrix = matrix;
                _skinControllers[name] = skinController;
                i = i + 16;
            }
			
			Debug.trace(" + SkinWeight");

            tmp = skin["vertex_weights"][0].@count;
			var weightsId:String = getId(skin["vertex_weights"].input.(@semantic == "WEIGHT")[0].@source);
			
            tmp = skin["source"].(@id == weightsId)["float_array"].toString();
            var weights:Array = tmp.split(" ");
			
            tmp = skin["vertex_weights"].vcount.toString();
            var vcount:Array = tmp.split(" ");
			
            tmp = skin["vertex_weights"].v.toString();
            v = tmp.split(" ");
			
			var skinVertex	:SkinVertex;
            var c			:int;
            var count		:int = 0;
			
            i=0;
            while (i < geometryData.vertices.length/3) {
                c = int(vcount[i]);
                geometryData.skinVertices.push(skinVertex = new SkinVertex());
                j=0;
                while (j < c) {
					skinVertex.controllers.push(geometryData.skinControllers[int(v[count])]);
					count++;
                    skinVertex.weights.push(Number(weights[int(v[count])]));
                    count++;
                    ++j;
                }
                ++i;
            }
		}
		
		/**
		 * Detects and parses all animation clips
		 */ 
		private function parseAnimationClips() : void
        {
			
        	//Check for animations
			var anims:XML = collada["library_animations"][0];
			
			if (!anims) {
        		Debug.trace(" ! ------------- No animations to parse -------------");
        		return;
			}
        	
			//Check to see if animation clips exist
			var clips:XML = collada["library_animation_clips"][0];
			
			Debug.trace(" ! Animation Clips Exist : " + _haveClips);
			
            Debug.trace(" ! ------------- Begin Parse Animation -------------");
            
            var _channel_id:uint = 0;
            
            //loop through all animation channels
            if(anims["animation"]["animation"].length()==0)
			for each (var channel:XML in anims["animation"])
			{
				if(String(channel.@id).length>0)
				{
					channelLibrary.addChannel(channel.@id, channel);
				}else{
					// COLLADAMax NextGen;  Version: 1.1.0;  Platform: Win32;  Configuration: Release Max2009
					// issue#1 : missing channel.@id -> use automatic id instead
					Debug.trace(" ! COLLADAMax2009 id : _"+_channel_id);
					channelLibrary.addChannel("_"+String(_channel_id++), channel);
				}
			}

			// C4D 
			// issue#1 : animation -> animation.animation
			// issue#2 : missing channel.@id -> use automatic id instead
			for each (channel in anims["animation"]["animation"])
			{
				if(String(channel.@id).length > 0)
				{
					channelLibrary.addChannel(channel.@id, channel);
				}else{
					Debug.trace(" ! C4D id : _"+_channel_id);
					channelLibrary.addChannel("_"+String(_channel_id++), channel);
				}
			}
					
			if (clips) {
				//loop through all animation clips
				for each (var clip:XML in clips["animation_clip"])
					parseAnimationClip(clip);
			}
			
			//create default animation clip
			_defaultAnimationClip = animationLibrary.addAnimation("default");
			
			for each (var channelData:ChannelData in channelLibrary)
				_defaultAnimationClip.channels[channelData.name] = channelData;
			
			Debug.trace(" ! ------------- End Parse Animation -------------");
			_channelArray = channelLibrary.getChannelArray();
			_channelArrayLength = _channelArray.length;
			_totalChunks += _channelArrayLength;
        }
        
        private function parseAnimationClip(clip:XML) : void
        {
			var animationClip:AnimationData = animationLibrary.addAnimation(clip.@id);
			
			for each (var channel:XML in clip["instance_animation"])
				animationClip.channels[getId(channel.@url)] = channelLibrary[getId(channel.@url)];
        }
		
		private function parseChannel(channelData:ChannelData) : void
        {
        	var node:XML = channelData.xml;
			var id:String = node["channel"].@target;
			var name:String = id.split("/")[0];
            var type:String = id.split("/")[1];
			var sampler:XML = node["sampler"][0];
			
            if (!type) {
            	Debug.trace(" ! No animation type detected");
            	return;
            }
            
            // C4D : didn't have @id, Maya 7 exporter has X/Y/Z split on translate
            if (String(node.@id).length > 0 && (type.split(".").length == 1 || type.split(".")[1].length > 1)) {
            	type = type.split(".")[0];
            	
            	if ((type == "image" || node.@id.split(".")[1] == "frameExtension")) {
	                //TODO : Material Animation
					Debug.trace(" ! Material animation not yet implemented");
					return;
            	}
            	
            } else {
            	type = type.split(".").join("");
            }
            
			

            
            var channel:Channel = channelData.channel = new Channel(name);
			var i:int;
			var j:int;
			
			_defaultAnimationClip.channels[channelData.name] = channelData;
			
			Debug.trace(" ! channelType : " + type);
			
            for each (var input:XML in sampler["input"])
            {
				var src:XML = node["source"].(@id == getId(input.@source))[0];
                var list:Array = String(src["float_array"]).split(" ");
                var len:int = int(src["technique_common"].accessor.@count);
                var stride:int = int(src["technique_common"].accessor.@stride);
                var semantic:String = input.@semantic;
				
				//C4D : no stride defined
				if (stride == 0)
					stride=1;
				
				var p:String;
				
                switch(semantic) {
                    case "INPUT":
                        for each (p in list)
                            channel.times.push(Number(p));
                        
                        if (_defaultAnimationClip.start > channel.times[0])
                            _defaultAnimationClip.start = channel.times[0];
                        
                        if (_defaultAnimationClip.end < channel.times[channel.times.length-1])
                            _defaultAnimationClip.end = channel.times[channel.times.length-1];
                        
                        break;
                    case "OUTPUT":
                        i=0;
                        while (i < len) {
                           channel.param[i] = [];
                            
                            if (stride == 16) {
		                    	var m:Matrix3D = new Matrix3D();
		                    	m.rawData = array2matrix(list.slice(i*stride, i*stride + 16), yUp, scaling);
		                    	channel.param[i].push(m);
                            } else {
	                            j = 0;
	                            while (j < stride) {
	                            	channel.param[i].push(Number(list[i*stride + j]));
	                            	++j;
	                            }
                            }
                            ++i;
                        }
                        break;
                    case "INTERPOLATION":
                        for each (p in list)
                        {
							channel.interpolations.push(p);
                        }
                        break;
                    case "IN_TANGENT":
                        i=0;
                        while (i < len)
                        {
                        	channel.inTangent[i] = [];
                        	j = 0;
                            while (j < stride) {
                                channel.inTangent[i].push(Number(list[stride * i + j]), Number(list[stride * i + j + 1]));
                            	++j;
                            }
                            ++i;
                        }
                        break;
                    case "OUT_TANGENT":
                        i=0;
                        while (i < len)
                        {
                        	channel.outTangent[i] = [];
                        	j = 0;
                            while (j < stride) {
                                channel.outTangent[i].push(Number(list[stride * i + j]), Number(list[stride * i + j + 1]));
                            	++j;
                            }
                            ++i;
                        }
                        break;
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
			var material:XML = collada["library_materials"].material.(@id == materialName)[0];
	
			if( material )
			{
				var effectId:String = getId( material["instance_effect"].@url );
				var effect:XML = collada["library_effects"].effect.(@id == effectId)[0];
	
				if (effect..texture.length() == 0) return null;
	
				var textureId:String = effect..texture[0].@texture;
	
				var sampler:XML =  effect..newparam.(@sid == textureId)[0];
	
				// Blender
				var imageId:String = textureId;
	
				// Not Blender
				if( sampler )
				{
					var sourceId:String = sampler..source[0];
					var source:XML =  effect..newparam.(@sid == sourceId)[0];
	
					imageId = source..init_from[0];
				}
	
				var image:XML = collada["library_images"].image.(@id == imageId)[0];
	
				filename = image["init_from"];
	
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
        public function array2matrix(ar:Array, yUp:Boolean, scaling:Number):Vector.<Number>
        {
        	var rawData:Vector.<Number> = new Vector.<Number>(16);
        	
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
		private function parseColorMaterial(colorName:String, materialData:MaterialData):void
		{
			var material:XML = collada["library_materials"].material.(@id == colorName)[0];
			
			if (material) {
				var effectId:String = getId( material["instance_effect"].@url );
				var effect:XML = collada["library_effects"].effect.(@id == effectId)[0];
				
				materialData.ambientColor = getColorValue(effect..ambient[0]);
				materialData.diffuseColor = getColorValue(effect..diffuse[0]);
				materialData.specularColor = getColorValue(effect..specular[0]);
				materialData.shininess = Number(effect..shininess.float[0]);
			}
		}
		
		private function getColorValue(colorXML:XML):uint
		{
			if (!colorXML || colorXML.length() == 0)
				return 0xFFFFFF;
			
			if(!colorXML["color"] || colorXML["color"].length() == 0)
				return 0xFFFFFF;
			
			var colorArray:Array = colorXML["color"].split(" ");
			if(colorArray.length <= 0)
				return 0xFFFFFF;
			
			return int(colorArray[0]*255 << 16) | int(colorArray[1]*255 << 8) | int(colorArray[2]*255);
		}
		
		/**
		 * Converts a data string to an array of objects. Handles vertex and uv objects
		 */
        private function deserialize(input:XML, geo:XML, type:String, output:Vector.<Number>):void
        {
            var id:String = input.@source.split("#")[1];

            // Source?
            var acc:XMLList = geo..source.(@id == id)["technique_common"].accessor;

            if (acc != new XMLList())
            {
                // Build source floats array
                var floId:String  = acc.@source.split("#")[1];
                var floXML:XMLList = collada..float_array.(@id == floId);
                var floStr:String  = floXML.toString();
                var floats:Array   = getArray(floStr);
    			var float:Number;
                // Build params array
                var params:Array = [];
				var param:String;
				
                for each (var par:XML in acc["param"])
                    params.push(par.@name);

                // Build output array
    			var len:int = floats.length;
    			var i:int = 0;
                while (i < len)
                {
            		var value:Vector3D = new Vector3D();
	            	switch (type) {
	            		case "Vertex":
		                    for each (param in params) {
		                    	float = floats[i];
		                    	switch (param) {
		                    		case "X":
		                    			if (yUp)
		                    				value.x = -float*scaling;
		                    			else
		                    				value.x = float*scaling;
		                    			break;
		                    		case "Y":
		                    			if (yUp)
		                    				value.y = -float*scaling;
		                    			else
		                    				value.z = float*scaling;
		                    			break;
		                    			break;
		                    		case "Z":
		                    			if (yUp)
		                    				value.z = float*scaling;
		                    			else
		                    				value.y = -float*scaling;
		                    			break;
		                    			break;
		                    		default:
		                    	}
		                    	++i;
		                    }
		                    break;
		                case "UV":
		                    for each (param in params) {
		                    	float = floats[i];
		                    	switch (param) {
		                    		case "S":
		                    			value.x = float;
		                    			break;
		                    		case "T":
		                    			value.y = 1 - float;
		                    			break;
		                    		default:
		                    	}
		                    	++i;
		                    }
		                    break;
		                default:
		            }
	                output.push(value.x, value.y, value.z);
	            }
            }
            else
            {
                // Store indexes if no source
                var recursive :XMLList = geo..vertices.(@id == id)["input"];

                deserialize(recursive[0], geo, type, output);
            }
        }
    }
}