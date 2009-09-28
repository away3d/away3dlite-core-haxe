//OK

package away3dlite.containers;
import away3dlite.animators.bones.Bone;
import away3dlite.core.base.Object3D;
import flash.display.DisplayObject;
import flash.geom.Matrix3D;
import flash.Lib;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* 3d object container node for other 3d objects in a scene.
*/
class ObjectContainer3D extends Object3D
{
	/** @private */
	/*arcane*/ private override function updateScene(val:Scene3D):Void
	{
		if (scene == val)
			return;
		
		_scene = val;
		
		for (child in _children)
			child.updateScene(_scene);
	}
	/** @private */
	/*arcane*/ private override function project(projectionMatrix3D:Matrix3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		super.project(projectionMatrix3D, parentSceneMatrix3D);
		
		var child:Object3D;
		
		for (child in _children)
			child.project(projectionMatrix3D, _sceneMatrix3D);
	}
	
	private var _index:Int;
	private var _children:Array<Object3D>;
	
	/**
	* Returns the children of the container as an array of 3d objects.
	*/
	public var children(get_children, null):Array<Object3D>;
	private function get_children():Array<Object3D>
	{
		return _children;
	}
	
	/**
	 * Creates a new <code>ObjectContainer3D</code> object.
	 * 
	 * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	 */
	public function new(?childArray:Array<Object3D>)
	{
		super();
		
		_children = new Array<Object3D>();
		
		if (childArray != null)
			for (child in childArray)
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
		
		_children[_children.length] = Lib.as(child, Object3D);
		
		Lib.as(child, Object3D).updateScene(_scene);
		
		if (_scene != null)
			_scene.arcane()._dirtyFaces = true;
		
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
		
		//_index = _children.indexOf(child);
		_index = -1;
		var i = 0;
		for (_child in _children)
		{
			if (_child == child)
				_index = i;
			i++;
		}
		
		if (_index == -1)
			return null;
		
		_children.splice(_index, 1);
		
		Lib.as(child, Object3D)._scene = null;
		
		_scene.arcane()._dirtyFaces = true;
		
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
		for (object3D in children) {
			if (object3D.name != null)
				if (object3D.name == childName)
					return object3D;
			
			if (Std.is(object3D, ObjectContainer3D)) {
				child = Lib.as( Lib.as(object3D, ObjectContainer3D).getChildByName(childName),  Object3D )  ;
				if (child != null)
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
		for (object3D in children) {
			if (Std.is(object3D, Bone)) {
				bone = Lib.as(object3D, Bone);
				
				if (bone.name != null)
					if (bone.name == boneName)
						return bone;
				
				if (bone.boneId != null)
					if (bone.boneId == boneName)
						return bone;
			}
			if (Std.is(object3D, ObjectContainer3D)) {
				bone = Lib.as(object3D, ObjectContainer3D).getBoneByName(boneName);
				if (bone != null)
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
	public override function clone(?object:Object3D):Object3D
	{
		var container:ObjectContainer3D = (object != null) ? (Lib.as(object, ObjectContainer3D)) : new ObjectContainer3D();
		super.clone(container);
		
		for (child in children)
			container.addChild(child.clone());
		
		return container;
	}
}