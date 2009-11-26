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
		private var _uvtData:Vector.<Number>;
		private var _vertices:Vector.<Number>;
		private var _screenVertices:Vector.<Number>;
		
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
		public var faceIndex:int;
		
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
		 * Index value of the fourth vertex in the face.
		 */
		public var i3:int;
		
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
		 * x index of the fourth screen vertex.
		 */
		public var x3:int;
				
		/**
		 * y index of the fourth screen vertex.
		 */
		public var y3:int;
		
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
						
		/**
		 * u index of the fourth mapping value.
		 */
		public var u3:int;
						
		/**
		 * v index of the fourth mapping value.
		 */
		public var v3:int;
						
		/**
		 * t index of the fourth mapping value.
		 */
		public var t3:int;
		
		
		/**
		 * Creates a new <code>Face</code> object.
		 * 
		 * @param mesh			The <code>Mesh</code> object to which the face belongs.
		 * @param faceIndex		The index of the face.
		 * @param index			The start index of the indices.
		 * @param length		The number of indices.
		 */
		public function Face(mesh:Mesh, faceIndex:int, index:int, length:int)
		{
			this.mesh = mesh;
			
			this.faceIndex = faceIndex;
			
			_uvtData = mesh._uvtData;
			
			_vertices = mesh._vertices;
			
			_screenVertices = mesh._screenVertices;
			
			i0 = mesh._indices[int(index)];
			i1 = mesh._indices[int(index + 1)];
			i2 = mesh._indices[int(index + 2)];
			
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
			
			if (length > 3) {
				i3 = mesh._indices[int(index + 3)];
				x3 = 2*i3;
				y3 = 2*i3 + 1;
				u3 = 3*i3;
				v3 = 3*i3 + 1;
				t3 = 3*i3 + 2;
			}
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
			return i3? int((_uvtData[t0] + _uvtData[t1] + _uvtData[t2] + _uvtData[t3])*750000) : int((_uvtData[t0] + _uvtData[t1] + _uvtData[t2])*1000000);
		}
		
		/**
		 * Returns the furthest screen Z coordinate of the face.
		 */
		public function calculateFurthestZ():int
		{
			var z:Number = _uvtData[t0];
			
			if (z > _uvtData[t1])
				z = _uvtData[t1];
			
			if (z > _uvtData[t2])
				z = _uvtData[t2];
			
			if (i3 && z > _uvtData[t3])
				z = _uvtData[t3];
			
			return int(z*3000000);
		}
		
		/**
		 * Returns the nearest screen Z coordinate of the face.
		 */
		public function calculateNearestZ():int
		{
			var z:Number = _uvtData[t0];
			
			if (z < _uvtData[t1])
				z = _uvtData[t1];
			
			if (z < _uvtData[t2])
				z = _uvtData[t2];
			
			if (i3 && z < _uvtData[t3])
				z = _uvtData[t3];
			
			return int(z*3000000);
		}
		
		/**
		 * Returns the uvt coordinate of the face at the given screen coordinate.
		 * 
		 * @param x		The x value of the screen coordinate.
		 * @param y		The y value of the screen coordinate.
		 */
		public function calculateUVT(x:Number, y:Number):Vector3D
		{
			var v0x:Number = _vertices[x0];
			var v0y:Number = _vertices[y0];
			var v2x:Number = _vertices[x2];
			var v2y:Number = _vertices[y2];
			
			var ax:Number;
			var ay:Number;
			var az:Number;
			var au:Number;
			var av:Number;
			
			var bx:Number;
			var by:Number;
			var bz:Number;
			var bu:Number;
			var bv:Number;
			
			var cx:Number;
			var cy:Number;
			var cz:Number;
			var cu:Number;
			var cv:Number;
			
			if (i3 && (v0x*(v2y - y) + x*(v0y - v2y) + v2x*(y - v0y)) < 0) {
				az = _uvtData[t0];
	            bz = _uvtData[t2];
	            cz = _uvtData[t3];
	            
				ax = (_screenVertices[x0] - x)/az;
	            bx = (_screenVertices[x2] - x)/bz;
	            cx = (_screenVertices[x3] - x)/cz;
	            ay = (_screenVertices[y0] - y)/az;
	            by = (_screenVertices[y2] - y)/bz;
	            cy = (_screenVertices[y3] - y)/cz;
	            
	            au = _uvtData[u0];
	            av = _uvtData[v0];
	            bu = _uvtData[u2];
	            bv = _uvtData[v2];
	            cu = _uvtData[u3];
	            cv = _uvtData[v3];
			} else {
				az = _uvtData[t0];
	            bz = _uvtData[t1];
	            cz = _uvtData[t2];
	            
				ax = (_screenVertices[x0] - x)/az;
	            bx = (_screenVertices[x1] - x)/bz;
	            cx = (_screenVertices[x2] - x)/cz;
	            ay = (_screenVertices[y0] - y)/az;
	            by = (_screenVertices[y1] - y)/bz;
	            cy = (_screenVertices[y2] - y)/cz;
	            
	            au = _uvtData[u0];
	            av = _uvtData[v0];
	            bu = _uvtData[u1];
	            bv = _uvtData[v1];
	            cu = _uvtData[u2];
	            cv = _uvtData[v2];
			}
            
            var det:Number = ax*(by - cy) + bx*(cy - ay) + cx*(ay - by);
            
            var ad:Number = x*(by - cy) + bx*(cy - y) + cx*(y- by);
            var bd:Number = ax*(y - cy) + x*(cy - ay) + cx*(ay - y);
            var cd:Number = ax*(by - y) + bx*(y - ay) + x*(ay - by);
			
            return new Vector3D((ad*au + bd*bu + cd*cu)/det, (ad*av + bd*bv + cd*cv)/det, (ad/az + bd/bz + cd/cz)/det);
		}
	}
}