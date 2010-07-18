package away3dlite.loaders.data;

import away3dlite.containers.ObjectContainer3D;
/**
 * Data class for 3d object containers.
 */
class ContainerData extends MeshData
{
	/**
	 * An array containing the child 3d objects of the container.
	 */
	public var children:Array<ObjectData>;
	
	/**
	 * Reference to the 3d container object of the resulting container.
	 */
	public var container:ObjectContainer3D;
			
	/**
	 * Returns the maximum x value of the container data
	 */
	public var maxX:Float;
	
	/**
	 * Returns the minimum x value of the container data
	 */
	public var minX:Float;
	
	/**
	 * Returns the maximum y value of the container data
	 */
	public var maxY:Float;
	
	/**
	 * Returns the minimum y value of the container data
	 */
	public var minY:Float;
	
	/**
	 * Returns the maximum z value of the container data
	 */
	public var maxZ:Float;
	
	/**
	 * Returns the minimum z value of the container data
	 */
	public var minZ:Float;
	
	public function new()
	{
		super();
		children = [];
	}
}