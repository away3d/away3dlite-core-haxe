//OK

package away3dlite.containers;
import away3dlite.core.base.Object3D;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
* The root container of all 3d objects in a single scene
*/
class Scene3D extends ObjectContainer3D
{
	/*arcane*/ private var _dirtyFaces:Bool;
	
	/**
	 * Creates a new <code>Scene3D</code> object
	 * 
	 * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	 */
	public function new(?childArray:Array<Object3D>)
	{
		super();
		
		_dirtyFaces = true;
		
		if (childArray != null)
			for (child in childArray)
				addChild(child);
		
		_scene = this;
	}
}