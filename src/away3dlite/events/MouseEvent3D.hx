package away3dlite.events;

import away3dlite.containers.View3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Object3D;
import flash.geom.Vector3D;
import away3dlite.materials.Material;

import flash.events.Event;

/**
* Passed as a parameter when a 3d mouse event occurs
*/
class MouseEvent3D extends Event
{
	/**
	 * Defines the value of the type property of a mouseOver3d event object.
	 */
	public static inline var MOUSE_OVER:String = "mouseOver3d";
	
	/**
	 * Defines the value of the type property of a mouseOut3d event object.
	 */
	public static inline var MOUSE_OUT:String = "mouseOut3d";
	
	/**
	 * Defines the value of the type property of a mouseUp3d event object.
	 */
	public static inline var MOUSE_UP:String = "mouseUp3d";
	
	/**
	 * Defines the value of the type property of a mouseDown3d event object.
	 */
	public static inline var MOUSE_DOWN:String = "mouseDown3d";
	
	/**
	 * Defines the value of the type property of a mouseMove3d event object.
	 */
	public static inline var MOUSE_MOVE:String = "mouseMove3d";
	
	/**
	 * Defines the value of the type property of a rollOver3d event object.
	 */
	public static inline var ROLL_OVER:String = "rollOver3d";
	
	/**
	 * Defines the value of the type property of a rollOut3d event object.
	 */
	public static inline var ROLL_OUT:String = "rollOut3d";
	
	/**
	 * The horizontal coordinate at which the event occurred in view coordinates.
	 */
	public var screenX:Float;
	
	/**
	* The vertical coordinate at which the event occurred in view coordinates.
	*/
	public var screenY:Float;
	
	/**
	 * The xyz coordinate at which the event occurred in global scene coordinates.
	 */
	public var scenePosition:Vector3D;
	
	/**
	 * The view object inside which the event took place.
	 */
	public var view:View3D;
	
	/**
	 * The 3d object inside which the event took place.
	 */
	public var object:Object3D;
	
	/**
	 * The material of the 3d element inside which the event took place.
	 */
	public var material:Material;
	
	/**
	 * The uvt coordinate inside the triangle where the event took place.
	 */
	public var uvt:Vector3D;
	
	/**
	 * Indicates whether the Control key is active (true) or inactive (false).
	 */
	public var ctrlKey:Bool;
	
	/**
	* Indicates whether the Shift key is active (true) or inactive (false).
	*/
	public var shiftKey:Bool;
	
	/**
	* Indicates the face that received the mouse event.
	*/
	public var face:Face;
	
	/**
	 * Creates a new <code>MouseEvent3D</code> object.
	 * 
	 * @param	type		The type of the event. Possible values are: <code>MouseEvent3D.MOUSE_OVER</code>, <code>MouseEvent3D.MOUSE_OUT</code>, <code>MouseEvent3D.MOUSE_UP</code>, <code>MouseEvent3D.MOUSE_DOWN</code> and <code>MouseEvent3D.MOUSE_MOVE</code>.
	 */
	public function new(type:String)
	{
		super(type, false, true);
	}
	
	/**
	 * Creates a copy of the MouseEvent3D object and sets the value of each property to match that of the original.
	 */
	public override function clone():Event
	{
		var result:MouseEvent3D = new MouseEvent3D(type);

		if(isDefaultPrevented())
			result.preventDefault();
		
		result.face = face;
			
		result.screenX = screenX;
		result.screenY = screenY;
		
		result.scenePosition = scenePosition;
		
		result.view = view;
		result.object = object;
		result.material = material;
		result.uvt = uvt;
		
		result.ctrlKey = ctrlKey;
		result.shiftKey = shiftKey;

		return result;
	}
}