//OK

package away3dlite.cameras;

import away3dlite.cameras.lenses.AbstractLens;
import away3dlite.core.base.Object3D;

/**
* Extended camera used to hover round a specified target object.
* 
* @see	away3dlite.containers.View3D
*/
class HoverCamera3D extends TargetCamera3D
{
	private var _currentPanAngle:Float;
	private var _currentTiltAngle:Float;
	
	/**
	* Rotation of the camera in degrees around the y axis. Defaults to 0.
	*/
	public var panAngle:Float;
	
	/**
	* Elevation angle of the camera in degrees. Defaults to 90.
	*/
	public var tiltAngle:Float;

	/**
	* Distance between the camera and the specified target. Defaults to 800.
	*/
	public var distance:Float;
			
	/**
	* Minimum bounds for the <code>tiltAngle</code>. Defaults to -90.
	* 
	* @see	#tiltAngle
	*/
	public var minTiltAngle:Float;
			
	/**
	* Maximum bounds for the <code>tiltAngle</code>. Defaults to 90.
	* 
	* @see	#tiltAngle
	*/
	public var maxTiltAngle:Float;
	
	/**
	* Fractional step taken each time the <code>hover()</code> method is called. Defaults to 8.
	* 
	* Affects the speed at which the <code>tiltAngle</code> and <code>panAngle</code> resolve to their targets.
	* 
	* @see	#tiltAngle
	* @see	#panAngle
	*/
	public var steps:Float;
	
	
	/**
	 * Fractional difference in distance between the horizontal camera orientation and vertical camera orientation. Defaults to 2.
	 * 
	 * @see	#distance
	 */
	public var yfactor:Float;
	
	/**
	 * Defines whether the value of the pan angle wraps when over 360 degrees or under 0 degrees. Defaults to false.
	 */
	public var wrapPanAngle:Bool;
	/**
	 * Creates a new <code>HoverCamera3D</code> object.
	 * 
	 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
	 * @param zoom		Defines the overall scale value of the view.
	 * @param target	The 3d object targeted by the camera.
	 */
	public function new(?zoom:Float = 10, ?focus:Float = 100, ?target:Object3D, ?panAngle:Float = 0, ?tiltAngle:Float = 0, ?distance:Float = 800, ?lens:AbstractLens = null)
	{
		super(zoom, focus, target, lens);
		
		_currentPanAngle = 0;
		_currentTiltAngle = 0;
		minTiltAngle = -90;
		maxTiltAngle = 90;
		steps = 8;
		yfactor = 2;
		wrapPanAngle = false;
		
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
	public function hover(?jumpTo:Bool):Bool
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
		
		var gx:Float = target.x + distance*Math.sin(_currentPanAngle*Camera3D.toRADIANS)*Math.cos(_currentTiltAngle*Camera3D.toRADIANS);
		var gz:Float = target.z + distance*Math.cos(_currentPanAngle*Camera3D.toRADIANS)*Math.cos(_currentTiltAngle*Camera3D.toRADIANS);
		var gy:Float = target.y - distance*Math.sin(_currentTiltAngle*Camera3D.toRADIANS)*yfactor;
		
		if ((x == gx) && (y == gy) && (z == gz))
			return false;
		
		x = gx;
		y = gy;
		z = gz;
		
		return true;
	}
}