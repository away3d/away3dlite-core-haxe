package away3dlite.cameras;
import away3dlite.cameras.lenses.AbstractLens;
import away3dlite.core.base.Object3D;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* Extended camera used to automatically look at a specified target object.
* 
* @see away3dlite.containers.View3D
*/
class TargetCamera3D extends Camera3D
{
	/** @private */
	/*arcane*/ private override function update():Void
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
	public function new(?focus:Float = 10, ?zoom:Float = 100, ?target:Object3D, ?lens:AbstractLens)
	{
		super(focus, zoom, lens);
		
		this.target = (target != null) ? target : new Object3D();
	}
}