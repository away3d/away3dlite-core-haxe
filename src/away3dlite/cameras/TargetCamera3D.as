package away3dlite.cameras
{
	import away3dlite.arcane;
    import away3dlite.core.base.*;
	
	use namespace arcane;
	
    /**
    * Extended camera used to automatically look at a specified target object.
    * 
    * @see away3dlite.containers.View3D
    */
    public class TargetCamera3D extends Camera3D
    {
		/** @private */
        arcane override function update():void
		{
            if (target != null)
                lookAt(target.transform.matrix3D.position);
            
			super.update();
        }
        
        /**
        * The 3d object targeted by the camera.
        */
        public var target:Object3D;
    	
	    /**
	    * Creates a new <code>TargetCamera3D</code> object.
		 * 
		 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
		 * @param zoom		Defines the overall scale value of the view.
		 * @param target	The 3d object targeted by the camera.
		 */
        public function TargetCamera3D(focus:Number = 10, zoom:Number = 100, target:Object3D = null)
        {
            super(focus, zoom);
            
            this.target = target || new Object3D();
        }
    }

}   
