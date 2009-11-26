package away3dlite.containers
{
	import away3dlite.animators.bones.*;
	import away3dlite.arcane;
	import away3dlite.cameras.*;
	import away3dlite.core.base.*;
	import away3dlite.sprites.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	use namespace arcane;
    
    /**
    * 3d object container node for other 3d objects in a scene.
    */
	public class ObjectContainer3D extends Mesh
	{
		/** @private */
		arcane override function updateScene(val:Scene3D):void
		{
			if (scene == val)
				return;
			
			super.updateScene(val);
			
			var child:Object3D;
			
			for each (child in _children)
				child.updateScene(_scene);
		}
		/** @private */
		arcane override function project(camera:Camera3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			if (_sprites.length) {
				_cameraInvSceneMatrix3D = camera.invSceneMatrix3D;
				_cameraSceneMatrix3D.rawData = _cameraInvSceneMatrix3D.rawData;
				_cameraSceneMatrix3D.invert();
				_cameraPosition = _cameraSceneMatrix3D.position;
				_cameraForwardVector = new Vector3D(_cameraSceneMatrix3D.rawData[8], _cameraSceneMatrix3D.rawData[9], _cameraSceneMatrix3D.rawData[10]);
			}
			
			super.project(camera, parentSceneMatrix3D);
			
			var child:Object3D;
			
			for each (child in _children)
				child.project(camera, _sceneMatrix3D);
		}
		
		private const _toDegrees:Number = 180/Math.PI;
		private var _index:int;
		private var _children:Array = new Array();
        private var _sprites:Vector.<Sprite3D> = new Vector.<Sprite3D>();
        private var _spriteVertices:Vector.<Number> = new Vector.<Number>();
        private var _spriteIndices:Vector.<int> = new Vector.<int>();
        private var _spritesDirty:Boolean;
        private var _cameraPosition:Vector3D;
		private var _cameraForwardVector:Vector3D;
        private var _spritePosition:Vector3D;
		private var _spriteRotationVector:Vector3D;
        private var _cameraSceneMatrix3D:Matrix3D = new Matrix3D();
        private var _cameraInvSceneMatrix3D:Matrix3D = new Matrix3D();
		private var _orientationMatrix3D:Matrix3D = new Matrix3D();
		private var _cameraMatrix3D:Matrix3D = new Matrix3D();
		
		private var _viewDecomposed:Vector.<Vector3D>;
		
        /**
        * Returns the children of the container as an array of 3d objects.
        */
		public function get children():Array
		{
			return _children;
		}
        
        /**
        * Returns the sprites of the container as an array of 3d sprites.
        */
		public function get sprites():Vector.<Sprite3D>
		{
			return _sprites;
		}
		
		/**
		 * @inheritDoc
		 */
        public override function get vertices():Vector.<Number>
        {
        	if (_sprites.length) {
	    		var i:int;
	    		var index:int;
	    		var sprite:Sprite3D;
	    		
	        	if (_spritesDirty) {
	        		_spritesDirty = false;
	        		
	        		for each (sprite in _sprites) {
	        			_spriteIndices = sprite.indices;
	        			
	        			index = sprite.index*4;
		    			i = 4;
		    			
		    			while (i--)
							_indices[int(index + i)] = _spriteIndices[int(i)] + index;
	        		}
	        		
					buildFaces();
	        	}
	        	
				_orientationMatrix3D.rawData = _sceneMatrix3D.rawData;
				_orientationMatrix3D.append(_cameraInvSceneMatrix3D);
				
				_viewDecomposed = _orientationMatrix3D.decompose(Orientation3D.AXIS_ANGLE);
				
				_orientationMatrix3D.identity();
	    		_orientationMatrix3D.appendRotation(-_viewDecomposed[1].w*180/Math.PI, _viewDecomposed[1]);
	    		
	    		for each (sprite in _sprites) {
	    			if (sprite.alignmentType == AlignmentType.VIEWPLANE) {
	    				_orientationMatrix3D.transformVectors(sprite.vertices, _spriteVertices);
	    			} else {
	    				_spritePosition = sprite.position.subtract(_cameraPosition);
						
						_spriteRotationVector = _cameraForwardVector.crossProduct(_spritePosition);
						_spriteRotationVector.normalize();
						
						_cameraMatrix3D.rawData = _orientationMatrix3D.rawData;
						_cameraMatrix3D.appendRotation(Math.acos(_cameraForwardVector.dotProduct(_spritePosition)/(_cameraForwardVector.length*_spritePosition.length))*_toDegrees, _spriteRotationVector);
	    				_cameraMatrix3D.transformVectors(sprite.vertices, _spriteVertices);
	    			}
	    			
					index = sprite.index*12;
	    			i = 12;
	    			
	    			while ((i-=3) >= 0) {
	    				//int casting avoids memory leak
	    				_vertices[int(index + i)] = _spriteVertices[int(i)] + sprite.x;
	    				_vertices[int(index + i + 1)] = _spriteVertices[int(i + 1)] + sprite.y;
	    				_vertices[int(index + i + 2)] = _spriteVertices[int(i + 2)] + sprite.z;
	    			}
	    		}
        	}
    		
			return _vertices;
        }
        
	    /**
	     * Creates a new <code>ObjectContainer3D</code> object.
	     * 
	     * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation.
	     */
		public function ObjectContainer3D(...childArray)
		{
			super();
			
			for each (var child:Object3D in childArray)
				addChild(child);
		}
        
		/**
		 * Adds a 3d object to the scene as a child of the container.
		 * 
		 * @param	child	The 3d object to be added.
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			child = super.addChild(child);
			
			_children[_children.length] = child as Object3D;
			
			(child as Object3D).updateScene(_scene);
			
			return child;
		}
        
		/**
		 * Removes a 3d object from the child array of the container.
		 * 
		 * @param	child	The 3d object to be removed.
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			child = super.removeChild(child);
			
			_index = _children.indexOf(child);
			
			if (_index == -1)
				return null;
			
			_children.splice(_index, 1);
			
			(child as Object3D).updateScene(null);
			
			return child;
		}
        
		/**
		 * Adds a 3d object to the scene as a child of the container.
		 * 
		 * @param	child	The 3d object to be added.
		 */
		public function addSprite(sprite:Sprite3D):Sprite3D
		{
			_sprites[sprite.index = _sprites.length] = sprite;
			
			_indices.length += 4;
			_vertices.length += 12;
			
			_uvtData = _uvtData.concat(sprite.uvtData);
			_faceMaterials.push(sprite.material);
			_faceLengths.push(4);
			
			_spritesDirty = true;
			
			return sprite;
		}
        
		/**
		 * Removes a 3d sprite from the sprites array of the container.
		 * 
		 * @param	sprite	The 3d sprite to be removed.
		 */
		public function removeSprite(sprite:Sprite3D):Sprite3D
		{
			_index = _sprites.indexOf(sprite);
			
			if (_index == -1)
				return null;
			
			_sprites.splice(_index, 1);
			
			_indices.length -= 4;
			_vertices.length -= 12;
			
			_uvtData.splice(_index*12, 12);
			_faceMaterials.splice(_index, 1);
			_faceLengths.splice(_index, 1);
			
			_spritesDirty = true;
			
			return sprite;
		}
		/**
		 * Returns a 3d object specified by name from the child array of the container
		 * 
		 * @param	name	The name of the 3d object to be returned
		 * @return			The 3d object, or <code>null</code> if no such child object exists with the specified name
		 */
        public override function getChildByName(childName:String):DisplayObject
        {	
			var child:Object3D;
            for each(var object3D:Object3D in children) {
            	if (object3D.name)
					if (object3D.name == childName)
						return object3D;
				
            	if (object3D is ObjectContainer3D) {
	                child = (object3D as ObjectContainer3D).getChildByName(childName) as Object3D  ;
	                if (child)
	                    return child;
	            }
            }
			
            return null;
        }
        
		/**
		 * Returns a bone object specified by name from the child array of the container
		 * 
		 * @param	name	The name of the bone object to be returned
		 * @return			The bone object, or <code>null</code> if no such bone object exists with the specified name
		 */
        public function getBoneByName(boneName:String):Bone
        {	
			var bone:Bone;
            for each(var object3D:Object3D in children) {
            	if (object3D is Bone) {
            		bone = object3D as Bone;
            		
	            	if (bone.name)
						if (bone.name == boneName)
							return bone;
					
					if (bone.boneId)
						if (bone.boneId == boneName)
							return bone;
            	}
            	if (object3D is ObjectContainer3D) {
	                bone = (object3D as ObjectContainer3D).getBoneByName(boneName);
	                if (bone)
	                    return bone;
	            }
            }
			
            return null;
        }
		
		/**
		 * Duplicates the 3d object's properties to another <code>ObjectContainer3D</code> object
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied
		 * @return						The new object instance with duplicated properties applied
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var container:ObjectContainer3D = (object as ObjectContainer3D) || new ObjectContainer3D();
            super.clone(container);
			
			var child:Object3D;
            for each (child in children)
            	container.addChild(child.clone());
            
            return container;
        }
	}
}
