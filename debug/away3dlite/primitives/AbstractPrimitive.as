package away3dlite.primitives
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	import away3dlite.materials.*;
    
	use namespace arcane;
	
    /**
    * Abstract base class for shaded primitives
    */ 
    public class AbstractPrimitive extends Mesh
    {
		/** @private */
        arcane var _primitiveDirty:Boolean;
     	
     	protected function updatePrimitive():void
     	{
			buildPrimitive();
			
			buildFaces();
     	}
     	
		/**
		 * Builds the vertex, face and uv objects that make up the 3d primitive.
		 */
    	protected function buildPrimitive():void
    	{
    		_primitiveDirty = false;
    		
    		_vertices.fixed = false;
			_uvtData.fixed = false;
			_indices.fixed = false;
			
			_vertices.length = 0;
			_uvtData.length = 0;
			_indices.length = 0;
    	}
        
		/**
		 * @inheritDoc
		 */
        public override function get vertices():Vector.<Number>
        {
    		if (_primitiveDirty)
    			updatePrimitive();
    		
            return super.vertices;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function get faces():Vector.<Face>
        {
    		if (_primitiveDirty)
    			updatePrimitive();
    		
            return super.faces;
        }
		
		/**
		 * Creates a new <code>AbstractPrimitive</code> object.
		 * 
		 * @param material		Defines the global material used on the faces in the primitive.
		 */
		public function AbstractPrimitive(material:Material = null)
		{
			super(material);
			
			_primitiveDirty = true;
		}
    }
}