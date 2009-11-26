package away3dlite.loaders.data
{	import away3dlite.animators.bones.SkinVertex;
	
	/**
	 * Data class for the geometry data used in a mesh object
	 */
	public class GeometryData
	{
		/**
		 * The name of the geometry used as a unique reference.
		 */
		public var name:String;
		
		/**
		 * Array of vertex data.
		 */
		public var vertices:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Array of skinvertex data.
		 */
		public var skinVertices:Vector.<SkinVertex> = new Vector.<SkinVertex>();
		
		/**
		 * Array of uv data.
		 */
		public var uvtData:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Array of indices data.
		 */
		public var indices:Vector.<int> = new Vector.<int>();
		
		/**
		 * Array of face indices length data.
		 */
		public var faceLengths:Vector.<int> = new Vector.<int>();
		
		/**
		 * Array of face data objects.
		 *
		 * @see away3dlite.loaders.data.FaceData
		 */
		public var faces:Array = [];
		
		/**
		 * Optional assigned materials to the geometry.
		 */
		public var materials:Array = [];
		
		/**
		 * Defines whether both sides of the geometry are visible
		 */
		public var bothsides:Boolean;
        
        /**
         * Array of skin controller objects used in bone animations
         * 
         * @see away3dlite.animators.skin.SkinController
         */
        public var skinControllers:Array = [];
		
		/**
		 * Reference to the xml object defining the geometry.
		 */
		public var geoXML:XML;
		
		/**
		 * Reference to the xml object defining the controller.
		 */
		public var ctrlXML:XML;
		
    	/**
    	 * Returns the maximum x value of the geometry data
    	 */
		public var maxX:Number;
		
    	/**
    	 * Returns the minimum x value of the geometry data
    	 */
		public var minX:Number;
		
    	/**
    	 * Returns the maximum y value of the geometry data
    	 */
		public var maxY:Number;
		
    	/**
    	 * Returns the minimum y value of the geometry data
    	 */
		public var minY:Number;
		
    	/**
    	 * Returns the maximum z value of the geometry data
    	 */
		public var maxZ:Number;
		
    	/**
    	 * Returns the minimum z value of the geometry data
    	 */
		public var minZ:Number;
	}
}