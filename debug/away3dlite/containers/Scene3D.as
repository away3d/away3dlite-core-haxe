package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	
	use namespace arcane;
	
    /**
    * The root container of all 3d objects in a single scene
    */
	public class Scene3D extends ObjectContainer3D
	{
		arcane var _dirtyFaces:Boolean = true;
    	
		/**
		 * Creates a new <code>Scene3D</code> object
	     * 
	     * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	     */
		public function Scene3D(...childArray)
		{
			super();
			
			for each (var child:Object3D in childArray)
				addChild(child);
			
			_scene = this;
		}
	}
}
