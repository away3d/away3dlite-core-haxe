package away3dlite.animators
{
	import away3dlite.animators.bones.*;
	import away3dlite.containers.*;
	import away3dlite.core.utils.*;
	
	/**
	 * hold the animation information for a bones animation imported from a collada object
	 * 
	 * @see away3dlite.loaders.Collada
	 */
	public class BonesAnimator
    {
        private var _channels:Vector.<Channel>;
        private var _skinControllers:Vector.<SkinController>;
        private var _skinController:SkinController;
        private var _skinVertices:Vector.<SkinVertex>;
        private var _skinVertex:SkinVertex;
        
    	/**
    	 * Defines wether the animation will loop
    	 */
		public var loop:Boolean;
		
		/**
		 * Defines the total length of the animation in seconds
		 */
        public var length:Number;
		
		/**
		 * Defines the start of the animation in seconds
		 */
        public var start:Number;
		
        public function BonesAnimator()
        {
            Debug.trace(" + bonesAnimator");
			_channels = new Vector.<Channel>();
			_skinControllers = new Vector.<SkinController>();
			_skinVertices = new Vector.<SkinVertex>(); 
            loop = true;
            length = 0;
        }
		
		/**
		 * Updates all channels in the animation with the given time in seconds.
		 * 
		 * @param	time						Defines the time in seconds of the playhead of the animation.
		 * @param	interpolate		[optional]	Defines whether the animation interpolates between channel points Defaults to true.
		 */
        public function update(time:Number, interpolate:Boolean = true):void
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
        	
        	//update channels
            for each (var channel:Channel in _channels)
                channel.update(time, interpolate);
            
            //update skincontrollers
            for each(_skinController in _skinControllers)
				_skinController.update();
			
			//update skinvertices
            for each(_skinVertex in _skinVertices)
				_skinVertex.update();
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
			
			for each (var channel:Channel in _channels)
				bonesAnimator.addChannel(channel.clone(object));
			
			return bonesAnimator;
		}
		
		/**
		 * Adds an animation channel to the animation timeline.
		 */
        public function addChannel(channel:Channel):void
        {
			_channels.push(channel);
        }
		
		/**
		 * Adds a <code>SkinController</code> and all associated <code>SkinVertex</code> objects to the animation.
		 */
        public function addSkinController(skinController:SkinController):void
        {
        	if (_skinControllers.indexOf(skinController) != -1)
        		return;
        	
			_skinControllers.push(skinController);
			
			for each (_skinVertex in skinController.skinVertices)
				if (_skinVertices.indexOf(_skinVertex) == -1)
					_skinVertices.push(_skinVertex);
        }
    }
}
