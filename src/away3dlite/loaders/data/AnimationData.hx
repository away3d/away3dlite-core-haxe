package away3dlite.loaders.data;
import away3dlite.animators.BonesAnimator;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.base.Object3D;

using away3dlite.haxeutils.HaxeUtils;

/**
 * Data class for the animation of a mesh.
 * 
 * @see away3dlite.loaders.data.MeshData
 */
class AnimationData
{
	/**
	 * String representing a vertex animation.
	 */
	public static inline var VERTEX_ANIMATION:String = "vertexAnimation";
	
	/**
	 * String representing a skin animation.
	 */
	public static inline var SKIN_ANIMATION:String = "skinAnimation";
	
	/**
	 * The name of the animation used as a unique reference.
	 */
	public var name:String;
	
	/**
	 * Reference to the animation object of the resulting animation.
	 */
	public var animation:BonesAnimator;
	
	/**
	 * Reference to the time the animation starts.
	 */
	public var start:Float;
	
	public function new()
	{
		start = Math.POSITIVE_INFINITY;
		end = 0;
		animationType = SKIN_ANIMATION;
		channels = new Hash<ChannelData>();
	}
	
	/**
	 * Reference to the Float of seconds the animation ends.
	 */
	public var end:Float;
	
	/**
	 * String representing the animation type.
	 */
	public var animationType:String;
	
	/**
	 * Dictonary of names representing the animation channels used in the animation.
	 */
	//public var channels:Dictionary = new Dictionary(true); //ChannelData / String	
	public var channels:Hash<ChannelData>;
	
	/**
	 * Duplicates the animation data's properties to another <code>AnimationData</code> object
	 * 
	 * @param	object	The new object instance into which all properties are copied
	 * @return			The new object instance with duplicated properties applied
	 */
	public function clone(object:Object3D):AnimationData
	{
		var animationData:AnimationData = object.animationLibrary.addAnimation(name);
		
		animationData.start = start;
		animationData.end = end;
		animationData.animationType = animationType;
		animationData.animation = animation.clone(object.downcast(ObjectContainer3D));
		
		return animationData;
	}
}