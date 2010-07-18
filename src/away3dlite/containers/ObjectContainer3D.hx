package away3dlite.containers;

import away3dlite.animators.bones.Bone;
import away3dlite.cameras.Camera3D;
import away3dlite.core.base.Mesh;
import away3dlite.haxeutils.FastStd;
import away3dlite.lights.AbstractLight3D;
import away3dlite.sprites.AlignmentType;
import away3dlite.sprites.Sprite3D;
import away3dlite.core.base.Object3D;
import flash.display.DisplayObject;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;
import flash.geom.Orientation3D;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* 3d object container node for other 3d objects in a scene.
*/
class ObjectContainer3D extends Mesh
{
	/** @private */
	/*arcane*/ private override function updateScene(val:Scene3D):Void
	{
		if (_scene == val)
			return;
		
		if (_scene != null)
			for (i in 0..._lights.length)
				_scene.arcane_ns().removeSceneLight(_lights[i]);
		
		if (val != null)
			for (i in 0..._lights.length)
				val.arcane_ns().addSceneLight(_lights[i]);
				
		super.updateScene(val);
		
		for (child in _children)
			child.updateScene(_scene);
	}
	/** @private */
	/*arcane*/ private override function project(camera:Camera3D, ?parentSceneMatrix3D:Matrix3D):Void
	{
		if (_sprites.length != 0)
		{
			_cameraInvSceneMatrix3D = camera.arcaneNS()._invSceneMatrix3D;
			_cameraSceneMatrix3D.rawData = _cameraInvSceneMatrix3D.rawData;
			_cameraSceneMatrix3D.invert();
			_cameraPosition = _cameraSceneMatrix3D.position;
			_cameraForwardVector = new Vector3D(_cameraSceneMatrix3D.rawData[8], _cameraSceneMatrix3D.rawData[9], _cameraSceneMatrix3D.rawData[10]);
		}
		
		for (i in 0..._lights.length)
			_lights[i].arcaneNS()._camera = camera;
		
		super.project(camera, parentSceneMatrix3D);
		
		if (!_perspCulling)
		{
			var child:Object3D;
		
			for (child in _children)
				child.project(camera, _sceneMatrix3D);
		}
	}
	
	private static inline var _toDegrees:Float = 180/Math.PI;
	private var _index:Int;
	private var _children:Array<Object3D>;
	private var _sprites:Vector<Sprite3D>;
	private var _lights:Vector<AbstractLight3D>;
	private var _spriteVertices:Vector<Float>;
	private var _spriteIndices:Vector<Int>;
	private var _spritesDirty:Bool;
	private var _cameraPosition:Vector3D;
	private var _cameraForwardVector:Vector3D;
	private var _spritePosition:Vector3D;
	private var _spriteRotationVector:Vector3D;
	private var _cameraSceneMatrix3D:Matrix3D;
	private var _cameraInvSceneMatrix3D:Matrix3D;
	private var _orientationMatrix3D:Matrix3D;
	private var _cameraMatrix3D:Matrix3D;
	
	private var _viewDecomposed:Vector<Vector3D>;
	
	
	/**
	* Returns the children of the container as an array of 3d objects.
	*/
	public var children(get_children, null):Array<Object3D>;
	private function get_children():Array<Object3D>
	{
		return _children;
	}	
	
	/**
	* Returns the sprites of the container as an array of 3d sprites.
	*/
	public var sprites(get_sprites, null):Vector<Sprite3D>;
	private function get_sprites():Vector<Sprite3D>
	{
		return _sprites;
	}
	
	public inline var lights(get_lights, never):Vector<AbstractLight3D>;
	private inline function get_lights()
	{
		return _lights;
	}
	
	/**
	 * @inheritDoc
	 */
	private override function get_vertices():Vector<Float>
	{
		if (_sprites.length > 0) {
			var i:Int;
			var index:Int;
			var sprite:Sprite3D;
			
			if (_spritesDirty) {
				_spritesDirty = false;
				
				for (sprite in _sprites) {
					_spriteIndices = sprite.arcaneNS().indices;
					
					index = Std.int(sprite.arcaneNS().index*4);
					i = 4;
					
					while (i-- > 0)
						_indices[Std.int(index + i)] = _spriteIndices[Std.int(i)] + index;
				}
				
				buildFaces();
			}
			
			_orientationMatrix3D.rawData = _sceneMatrix3D.rawData;
			_orientationMatrix3D.append(_cameraInvSceneMatrix3D);
			
			_viewDecomposed = _orientationMatrix3D.decompose(Orientation3D.AXIS_ANGLE);
			
			_orientationMatrix3D.identity();
			_orientationMatrix3D.appendRotation(-_viewDecomposed[1].w*180/Math.PI, _viewDecomposed[1]);
			
			for (sprite in _sprites) {
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
				
				index = sprite.arcaneNS().index*12;
				i = 12;
				
				while ((i-=3) >= 0) {
					//int casting avoids memory leak
					_vertices[Std.int(index + i)] = _spriteVertices[Std.int(i)] + sprite.x;
					_vertices[Std.int(index + i + 1)] = _spriteVertices[Std.int(i + 1)] + sprite.y;
					_vertices[Std.int(index + i + 2)] = _spriteVertices[Std.int(i + 2)] + sprite.z;
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
	public function new(?childArray:Array<Object3D>)
	{
		super();
		
		_children = new Array<Object3D>();
		_sprites = new Vector<Sprite3D>();
		_spriteVertices = new Vector<Float>();
		_spriteIndices = new flash.Vector<Int>();
		_cameraSceneMatrix3D = new Matrix3D();
		_cameraInvSceneMatrix3D = new Matrix3D();
		_orientationMatrix3D = new Matrix3D();
		_cameraMatrix3D = new Matrix3D();
		_lights = new Vector<AbstractLight3D>();
		
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
		
		Lib.as(child, Object3D).updateScene(null);
		
		return child;
	}
	
	/**
	 * Adds a 3d sprite to the scene as a child of the container.
	 * 
	 * @param	sprite	The 3d object to be added.
	 */
	public function addSprite(sprite:Sprite3D):Sprite3D
	{
		vectorsFixed = false;
		_sprites[sprite.arcaneNS().index = _sprites.length] = sprite;
		
		_indices.length += 4;
		_vertices.length += 12;
		
		_uvtData = _uvtData.concat(sprite.arcaneNS().uvtData);
		_faceMaterials.push(sprite.material);
		_faceLengths.push(4);
		
		_spritesDirty = true;
		vectorsFixed = true;
		
		return sprite;
	}
	
	/**
	 * Removes a 3d sprite from the sprites array of the container.
	 * 
	 * @param	sprite	The 3d sprite to be removed.
	 */
	public function removeSprite(sprite:Sprite3D):Sprite3D
	{
		vectorsFixed = false;
		_index = _sprites.indexOf(sprite);
		
		if (_index == -1)
			return null;
		
		_sprites.splice(_index, 1);
		
		// shift indices down one - get vertices chokes on this
		for (i in 0..._sprites.length)
			_sprites[i].arcaneNS().index = i;

		// remove screen vertices if needed - clipping chokes on them
		if (_screenVertices.length > 0)
			_screenVertices.length -= 8;

		_indices.length -= 4;
		_vertices.length -= 12;
		
		_uvtData.splice(_index*12, 12);
		_faceMaterials.splice(_index, 1);
		_faceLengths.splice(_index, 1);
		_faces.splice(_index, 1); // rectangle clipping chokes on faces
		_spritesDirty = true;
		vectorsFixed = true;
		
		return sprite;
	}
	
    /**
	 * lock or unlock vectors when adding or removing sprites
	 */
	public var vectorsFixed(never, set_vectorsFixed):Bool;
	private function set_vectorsFixed(value:Bool):Bool 
	{
		return _sprites.fixed = _indices.fixed = _vertices.fixed = _uvtData.fixed = _faceMaterials.fixed = _faceLengths.fixed = _faces.fixed = value;
	}

	/**
	 * Adds a 3d light to the lights array of the container.
	 * 
	 * @param	light	The 3d light to be added.
	 */
	public function addLight(light:AbstractLight3D):AbstractLight3D
	{
		_lights[_lights.length] = light;
		
		if (_scene != null)
			_scene.arcaneNS().addSceneLight(light);
		
		return light;
	}
	
	/**
	 * Removes a 3d light from the lights array of the container.
	 * 
	 * @param	light	The 3d light to be removed.
	 */
	public function removeLight(light:AbstractLight3D):AbstractLight3D
	{
		_index = _lights.indexOf(light);
		
		if (_index == -1)
			return null;
		
		_sprites.splice(_index, 1);
		
		if (_scene != null)
			_scene.arcaneNS().removeSceneLight(light);
		
		return light;
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
			
			if (FastStd.is(object3D, ObjectContainer3D)) {
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
			if (FastStd.is(object3D, Bone)) {
				bone = Lib.as(object3D, Bone);
				
				if (bone.name != null)
					if (bone.name == boneName)
						return bone;
				
				if (bone.boneId != null)
					if (bone.boneId == boneName)
						return bone;
			}
			if (FastStd.is(object3D, ObjectContainer3D)) {
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