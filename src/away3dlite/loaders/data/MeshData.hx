package away3dlite.loaders.data;
import flash.Lib;

/**
 * Data class for the mesh data of a 3d object
 */
class MeshData extends ObjectData
{
	public var material:MaterialData;
	/**
	 * Defines the geometry used by the mesh instance
	 */
	public var geometry:GeometryData;
	 
	/**
	 *
	 */
	public var skeleton:String;
	
	public function new()
	{
		super();
	}	
		
	/**
	 * Duplicates the mesh data's properties to another <code>MeshData</code> object
	 * 
	 * @param	object	The new object instance into which all properties are copied
	 * @return			The new object instance with duplicated properties applied
	 */
	public override function clone(object:ObjectData):Void
	{
		super.clone(object);
		
		var mesh:MeshData = (Lib.as(object, MeshData));
		
		mesh.material = material;
		mesh.geometry = geometry;
		mesh.skeleton = skeleton;
	}
}