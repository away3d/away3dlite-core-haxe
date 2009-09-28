package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.animators.bones.*;
	import away3dlite.core.base.*;
	
	import flash.geom.*;
	import flash.display.*;
	
	use namespace arcane;
    
    /**
    * 3d object container node for other 3d objects in a scene.
    */
	public class ObjectContainer3D extends Object3D
	{
		/** @private */
		arcane override function updateScene(val:Scene3D):void
		{
			if (scene == val)
				return;
			
			_scene = val;
			
			var child:Object3D;
			
			for each (child in _children)
				child.updateScene(_scene);
		}
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			var child:Object3D;
			
			for each (child in _children)
				child.project(projectionMatrix3D, _sceneMatrix3D);
		}
		
		private var _index:int;
		private var _children:Array = new Array();
        
        /**
        * Returns the children of the container as an array of 3d objects.
        */
		public function get children():Array
		{
			return _children;
		}
		
	    /**
	     * Creates a new <code>ObjectContainer3D</code> object.
	     * 
	     * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
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
			
			if (_scene)
				_scene._dirtyFaces = true;
			
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
			
			(child as Object3D)._scene = null;
			
			_scene._dirtyFaces = true;
			
			return child;
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
