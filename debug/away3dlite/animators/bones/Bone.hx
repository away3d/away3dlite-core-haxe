//OK
package away3dlite.animators.bones;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Object3D;
import flash.Lib;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * ObjectContainer3D representing a bone and joint in a bones animation skeleton.
 * 
 * @see away3dlite.animators.BonesAnimator
 */
class Bone extends ObjectContainer3D
{
	/**
	 * the joint object of the bone
	 */
	public var joint:ObjectContainer3D;
	
	/**
	 * Collada 3.05B id value
	 */
	public var boneId:String;
	
	/**
	 * Defines the euler angle of rotation of the 3d object around the x-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
	 */
	public var jointRotationX(get_jointRotationX, set_jointRotationX):Float;
	private inline function get_jointRotationX():Float
	{
		return joint.rotationX;
	}

	private function set_jointRotationX(rot:Float):Float
	{
		return joint.rotationX = rot;
	}
	
	/**
	 * Defines the euler angle of rotation of the 3d object around the y-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
	 */
	
	private inline function get_jointRotationY():Float
	{
		return joint.rotationY;
	}

	private function set_jointRotationY(rot:Float):Float
	{
		return joint.rotationY = rot;
	}
	
	/**
	 * Defines the euler angle of rotation of the 3d object around the z-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
	 */
	private inline function get_jointRotationZ():Float
	{
		return joint.rotationZ;
	}

	private function set_jointRotationZ(rot:Float):Float
	{
		return joint.rotationZ = rot;
	}
	
	/**
	 * Defines the scale of the 3d object along the x-axis, relative to local coordinates.
	 */
	private inline function get_jointScaleX():Float
	{
		return joint.scaleX;
	}

	private function set_jointScaleX(scale:Float):Float
	{
		return joint.scaleX = scale;
	}
	
	/**
	 * Defines the scale of the 3d object along the y-axis, relative to local coordinates.
	 */
	private inline function get_jointScaleY():Float
	{
		return joint.scaleY;
	}

	private function set_jointScaleY(scale:Float):Float
	{
		return joint.scaleY = scale;
	}
	
	/**
	 * Defines the scale of the 3d object along the z-axis, relative to local coordinates.
	 */
	private inline function get_jointScaleZ():Float
	{
		return joint.scaleZ;
	}

	private function set_jointScaleZ(scale:Float):Float
	{
		return joint.scaleZ = scale;
	}
	
	/**
	 * Creates a new <code>Bone</code> object.
	 */
	public function new()
	{
		super();
		
		//create the joint for the bone
		addChild(joint = new ObjectContainer3D());
	}
	
	/**
	 * Duplicates the 3d object's properties to another <code>Bone</code> object
	 * 
	 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Bone</code>.
	 * @return						The new object instance with duplicated properties applied.
	 */
	public override function clone(?object:Object3D):Object3D
	{
		var bone:Bone = (object != null) ? (Lib.as(object,Bone)) : new Bone();
		super.clone(bone);
		
		bone.joint = Lib.as(bone.children[0], ObjectContainer3D);
		
		return bone;
	}
}