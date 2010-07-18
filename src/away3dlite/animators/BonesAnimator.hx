//OK

package away3dlite.animators;
import away3dlite.animators.bones.Channel;
import away3dlite.animators.bones.SkinController;
import away3dlite.animators.bones.SkinVertex;
import away3dlite.containers.ObjectContainer3D;
import away3dlite.core.utils.Debug;
import flash.utils.TypedDictionary;
import flash.Vector;

/**
 * hold the animation information for a bones animation imported from a collada object
 * 
 * @see away3dlite.loaders.Collada
 */
class BonesAnimator
{
	private var _channels:Vector<Channel>;
	private var _skinControllers:Vector<SkinController>;
	private var _skinController:SkinController;
	private var _skinVertices:Vector<SkinVertex>;
	private var _uniqueSkinVertices:TypedDictionary<SkinVertex, Int>;
	private var _skinVertex:SkinVertex;
	
	/**
	 * Defines wether the animation will loop
	 */
	public var loop:Bool;
	
	/**
	 * Defines the total length of the animation in seconds
	 */
	public var length:Float;
	
	/**
	 * Defines the start of the animation in seconds
	 */
	public var start:Float;
	
	public function new()
	{
		Debug.trace(" + bonesAnimator");
		_channels = new Vector<Channel>();
		_skinControllers = new Vector<SkinController>();
		_skinVertices = new Vector<SkinVertex>(); 
		_uniqueSkinVertices = new TypedDictionary<SkinVertex, Int>(true);
		loop = true;
		length = 0;
	}
	
	/**
	 * Updates all channels in the animation with the given time in seconds.
	 * 
	 * @param	time						Defines the time in seconds of the playhead of the animation.
	 * @param	interpolate		[optional]	Defines whether the animation interpolates between channel points Defaults to true.
	 */
	public function update(time:Float, ?interpolate:Bool = true):Void
	{
		if (time > start + length ) {
			if (loop) {
				time = start + (time - start) % length;
			}else{
				time = start + length;
			}
		} else if (time < start) {
			if (loop) {
				time = start + (time - start) % length + length;
			}else{
				time = start;
			}
		}
		
		// ensure vertex list is populated
		if (!_skinVertices.fixed)
			populateVertices();
		
		//update channels
		for (channel in _channels)
			channel.update(time, interpolate);
		
		//update skincontrollers
		for (_skinController in _skinControllers)
			_skinController.update();
		
		//update skinvertices
		for (_skinVertex in _skinVertices)
			_skinVertex.update();
	}
	
	/**
	 * Populates the skin vertex list from the set of unique vertices
	 */ 
	public function populateVertices():Void
	{
		_skinVertices.fixed = false;
		for (skinVertex in _uniqueSkinVertices.keys())
			_skinVertices.push(skinVertex);
		
		_skinVertices.fixed = true;
	}
	
	/**
	 * Clones the animation data into a new <code>BonesAnimator</code> object.
	 */
	public function clone(object:ObjectContainer3D):BonesAnimator
	{
		var bonesAnimator:BonesAnimator = new BonesAnimator();
		
		bonesAnimator.loop = loop;
		bonesAnimator.length = length;
		bonesAnimator.start = start;
		
		for (channel in _channels)
			bonesAnimator.addChannel(channel.clone(object));
		
		_skinVertices.fixed = false;
		return bonesAnimator;
	}
	
	/**
	 * Adds an animation channel to the animation timeline.
	 */
	public function addChannel(channel:Channel):Void
	{
		_channels.push(channel);
	}
	
	/**
	 * Adds a <code>SkinController</code> and all associated <code>SkinVertex</code> objects to the animation.
	 */
	public function addSkinController(skinController:SkinController):Void
	{
		if (_skinControllers.indexOf(skinController) != -1)
			return;
		
		_skinControllers.push(skinController);
		
		for (_skinVertex in skinController.skinVertices)
			_uniqueSkinVertices.set(_skinVertex, 1);
	}
}
