package away3dlite.loaders.data
{
	import away3dlite.containers.ObjectContainer3D;
	/**
	 * Data class for 3d object containers.
	 */
	public class ContainerData extends ObjectData
	{
		/**
		 * An array containing the child 3d objects of the container.
		 */
		public var children:Array = [];
		
		/**
		 * Reference to the 3d container object of the resulting container.
		 */
		public var container:ObjectContainer3D;
				
    	/**
    	 * Returns the maximum x value of the container data
    	 */
		public var maxX:Number;
		
    	/**
    	 * Returns the minimum x value of the container data
    	 */
		public var minX:Number;
		
    	/**
    	 * Returns the maximum y value of the container data
    	 */
		public var maxY:Number;
		
    	/**
    	 * Returns the minimum y value of the container data
    	 */
		public var minY:Number;
		
    	/**
    	 * Returns the maximum z value of the container data
    	 */
		public var maxZ:Number;
		
    	/**
    	 * Returns the minimum z value of the container data
    	 */
		public var minZ:Number;
	}
}