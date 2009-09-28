package away3dlite.core.base
{
	import flash.geom.Vector3D;
	import away3dlite.arcane;
	import away3dlite.materials.*;
	
	use namespace arcane;
	
	/**
	 * Face value object. Stores information on each face in a mesh.
	 */
	public class Face
	{
		private var uvtData:Vector.<Number>;
		
		private var vertices:Vector.<Number>;
		
		private var screenVertices:Vector.<Number>;
		
		/**
		 * Mesh object to which the face belongs.
		 */
		public var mesh:Mesh;
		
		/**
		 * Material of the face.
		 */
		public var material:Material;
		
		/**
		 * Index value of the face.
		 */
		public var index:int;
		
		/**
		 * Index value of the first vertex in the face.
		 */
		public var i0:int;
		
		/**
		 * Index value of the second vertex in the face.
		 */
		public var i1:int;
		
		/**
		 * Index value of the third vertex in the face.
		 */
		public var i2:int;
		
		/**
		 * x index of the first screen vertex.
		 */
		public var x0:int;
		
		/**
		 * y index of the first screen vertex.
		 */
		public var y0:int;
				
		/**
		 * x index of the second screen vertex.
		 */
		public var x1:int;
				
		/**
		 * y index of the second screen vertex.
		 */
		public var y1:int;
				
		/**
		 * x index of the third screen vertex.
		 */
		public var x2:int;
				
		/**
		 * y index of the third screen vertex.
		 */
		public var y2:int;
		
		/**
		 * u index of the first mapping value.
		 */
		public var u0:int;
		
		/**
		 * v index of the first mapping value.
		 */
		public var v0:int;
		
		/**
		 * t index of the first mapping value.
		 */
		public var t0:int;
				
		/**
		 * u index of the second mapping value.
		 */
		public var u1:int;
				
		/**
		 * v index of the second mapping value.
		 */
		public var v1:int;
				
		/**
		 * t index of the second mapping value.
		 */
		public var t1:int;
						
		/**
		 * u index of the third mapping value.
		 */
		public var u2:int;
						
		/**
		 * v index of the third mapping value.
		 */
		public var v2:int;
						
		/**
		 * t index of the third mapping value.
		 */
		public var t2:int;
		
		/*
		public var normalX:Number;
		
		public var normalY:Number;
		
		public var normalZ:Number;
		*/
		
		public function Face(mesh:Mesh, i:int)
		{
			this.mesh = mesh;
			
			index = i;
			
			uvtData = mesh._uvtData;
			
			vertices = mesh._vertices;
			
			screenVertices = mesh._screenVertices;
			
			material = mesh._faceMaterials[i] || mesh.material;
			
			i0 = mesh._indices[int(i*3 + 0)];
			i1 = mesh._indices[int(i*3 + 1)];
			i2 = mesh._indices[int(i*3 + 2)];
			
			x0 = 2*i0;
			y0 = 2*i0 + 1;
			
			x1 = 2*i1;
			y1 = 2*i1 + 1;
			
			x2 = 2*i2;
			y2 = 2*i2 + 1;
			
			u0 = 3*i0;
			v0 = 3*i0 + 1;
			t0 = 3*i0 + 2;
			
			u1 = 3*i1;
			v1 = 3*i1 + 1;
			t1 = 3*i1 + 2;
			
			u2 = 3*i2;
			v2 = 3*i2 + 1;
			t2 = 3*i2 + 2;
			
			/*
			var d1x:Number = vertices[u1] - vertices[u0];
	        var d1y:Number = vertices[v1] - vertices[v0];
	        var d1z:Number = vertices[t1] - vertices[t0];
	    
	        var d2x:Number = vertices[u2] - vertices[u0];
	        var d2y:Number = vertices[v2] - vertices[v0];
	        var d2z:Number = vertices[t2] - vertices[t0];
	    
	        var pa:Number = d1y*d2z - d1z*d2y;
	        var pb:Number = d1z*d2x - d1x*d2z;
	        var pc:Number = d1x*d2y - d1y*d2x;
	        
	        var pdd:Number = Math.sqrt(pa*pa + pb*pb + pc*pc);
	
	        normalX = pa / pdd;
	        normalY = pb / pdd;
	        normalZ = pc / pdd;
	        */
		}
		
		/**
		 * selected function for calculating the screen Z coordinate of the face.
		 */
		public var calculateScreenZ:Function;
		
		/**
		 * Returns the average screen Z coordinate of the face.
		 */
		public function calculateAverageZ():int
		{
			return int((uvtData[t0] + uvtData[t1] + uvtData[t2])*1000000);
		}
		
		/**
		 * Returns the furthest screen Z coordinate of the face.
		 */
		public function calculateFurthestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z > uvtData[t1])
				z = uvtData[t1];
			
			if (z > uvtData[t2])
				z = uvtData[t2];
			
			return int(z*1000000);
		}
		
		/**
		 * Returns the nearest screen Z coordinate of the face.
		 */
		public function calculateNearestZ():int
		{
			var z:Number = uvtData[t0];
			
			if (z < uvtData[t1])
				z = uvtData[t1];
			
			if (z < uvtData[t2])
				z = uvtData[t2];
			
			return int(z*1000000);
		}
		
		/**
		 * Returns the uvt coordinate of the face at the given screen coordinate.
		 * 
		 * @param x		The x value of the screen coordinate.
		 * @param y		The y value of the screen coordinate.
		 */
		public function calculateUVT(x:Number, y:Number):Vector3D
		{
			var az:Number = uvtData[t0];
            var bz:Number = uvtData[t1];
            var cz:Number = uvtData[t2];
            
			var ax:Number = (screenVertices[x0] - x)/az;
            var bx:Number = (screenVertices[x1] - x)/bz;
            var cx:Number = (screenVertices[x2] - x)/cz;
            var ay:Number = (screenVertices[y0] - y)/az;
            var by:Number = (screenVertices[y1] - y)/bz;
            var cy:Number = (screenVertices[y2] - y)/cz;

            var det:Number = ax*(by - cy) + bx*(cy - ay) + cx*(ay - by);
            
            var da:Number = x*(by - cy) + bx*(cy - y) + cx*(y- by);
            var db:Number = ax*(y - cy) + x*(cy - ay) + cx*(ay - y);
            var dc:Number = ax*(by - y) + bx*(y - ay) + x*(ay - by);

            return new Vector3D((da*uvtData[u0] + db*uvtData[u1] + dc*uvtData[u2])/det, (da*uvtData[v0] + db*uvtData[v1] + dc*uvtData[v2])/det, (da/uvtData[t0] + db/uvtData[t1] + dc/uvtData[t2])/det);
		}
	}
}