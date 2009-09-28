package away3dlite.cameras
{
	import away3dlite.core.base.*;
	
    /**
    * Extended camera used to hover round a specified target object.
    * 
    * @see	away3dlite.containers.View3D
    */
    public class HoverCamera3D extends TargetCamera3D
    {
    	private var _currentPanAngle:Number = 0;
    	private var _currentTiltAngle:Number = 0;
        
        /**
        * Rotation of the camera in degrees around the y axis. Defaults to 0.
        */
        public var panAngle:Number = 0;
        
        /**
        * Elevation angle of the camera in degrees. Defaults to 90.
        */
        public var tiltAngle:Number = 0;

        /**
        * Distance between the camera and the specified target. Defaults to 800.
        */
        public var distance:Number = 800;
                
        /**
        * Minimum bounds for the <code>tiltAngle</code>. Defaults to -90.
        * 
        * @see	#tiltAngle
        */
        public var minTiltAngle:Number = -90;
                
        /**
        * Maximum bounds for the <code>tiltAngle</code>. Defaults to 90.
        * 
        * @see	#tiltAngle
        */
        public var maxTiltAngle:Number = 90;
        
        /**
        * Fractional step taken each time the <code>hover()</code> method is called. Defaults to 8.
        * 
        * Affects the speed at which the <code>tiltAngle</code> and <code>panAngle</code> resolve to their targets.
        * 
        * @see	#tiltAngle
        * @see	#panAngle
        */
        public var steps:Number = 8;
    	
    	
    	/**
    	 * Fractional difference in distance between the horizontal camera orientation and vertical camera orientation. Defaults to 2.
    	 * 
    	 * @see	#distance
    	 */
        public var yfactor:Number = 2;
        
        /**
         * Defines whether the value of the pan angle wraps when over 360 degrees or under 0 degrees. Defaults to false.
         */
        public var wrapPanAngle:Boolean = false;
	    /**
	     * Creates a new <code>HoverCamera3D</code> object.
		 * 
		 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
		 * @param zoom		Defines the overall scale value of the view.
		 * @param target	The 3d object targeted by the camera.
		 */
        public function HoverCamera3D(zoom:Number = 10, focus:Number = 100, target:Object3D = null, panAngle:Number = 0, tiltAngle:Number = 0, distance:Number = 800)
        {
            super(zoom, focus, target);
			
			this.panAngle = panAngle;
			this.tiltAngle = tiltAngle;
			this.distance = distance;
			
            hover();
        }
        
        /**
        * Updates the camera orientation.
        * Values are calculated using the defined <code>tiltAngle</code>, <code>panAngle</code> and <code>steps</code> variables.
        * 
        * @param jumpTo		Determines if step property is used. Defaults to false.
        * 
        * @return			True if the camera position was updated, otherwise false.
        * 
        * @see	#tiltAngle
        * @see	#panAngle
        * @see	#steps
        */
        public function hover(jumpTo:Boolean = false):Boolean
        {
            if (tiltAngle != _currentTiltAngle || panAngle != _currentPanAngle) {
            	
	            tiltAngle = Math.max(minTiltAngle, Math.min(maxTiltAngle, tiltAngle));
	            
	            if (wrapPanAngle) {
		            if (panAngle < 0)
		            	panAngle = (panAngle % 360) + 360;
		            else
		            	panAngle = panAngle % 360;
		            
		            if (panAngle - _currentPanAngle < -180)
		            	panAngle += 360;
		            else if (panAngle - _currentPanAngle > 180)
		            	panAngle -= 360;
	            }
	            
	            if (jumpTo) {
	            	_currentTiltAngle = tiltAngle;
	            	_currentPanAngle = panAngle;
	            } else {
		            _currentTiltAngle += (tiltAngle - _currentTiltAngle)/(steps + 1);
		            _currentPanAngle += (panAngle - _currentPanAngle)/(steps + 1);
	            }
	            
				//snap coords if angle differences are close
	            if ((Math.abs(tiltAngle - _currentTiltAngle) < 0.01) && (Math.abs(panAngle - _currentPanAngle) < 0.01)) {
	                _currentTiltAngle = tiltAngle;
	                _currentPanAngle = panAngle;
	            }
            	
            }
            
			var gx:Number = target.x + distance*Math.sin(_currentPanAngle*toRADIANS)*Math.cos(_currentTiltAngle*toRADIANS);
            var gz:Number = target.y + distance*Math.cos(_currentPanAngle*toRADIANS)*Math.cos(_currentTiltAngle*toRADIANS);
            var gy:Number = target.z - distance*Math.sin(_currentTiltAngle*toRADIANS)*yfactor;
			
            if ((x == gx) && (y == gy) && (z == gz))
                return false;
			
            x = gx;
            y = gy;
            z = gz;
			
            return true;
        }
    }
}