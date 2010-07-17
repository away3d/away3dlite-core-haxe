package away3dlite.core.clip
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	
	use namespace arcane;
	
    /**
    * Rectangle clipping
    */
    public class RectangleClipping extends Clipping
    {
        /** @private */
        arcane override function collectFaces(mesh:Mesh, faces:Vector.<Face>):void
        {
        	_faces = mesh._faces;
        	_uvtData = mesh._uvtData;
			_screenVertices = mesh._screenVertices;
			
			_screenVerticesCull = new Vector.<int>();
        	_index = _screenVerticesCull.length = _screenVertices.length/2;
        	_screenVerticesCull.fixed = true;
        	
        	while (_index--) {
        		_indexX = _index*2;
        		_indexY = _indexX + 1;
        		_indexZ = _index*3 + 2;
        		
        		if (_uvtData[_indexZ] < 0) {
        			_screenVerticesCull[_index] += 0x10000;
        		} else {
	        		if (_screenVertices[_indexX] < _minX)
	        			_screenVerticesCull[_index] += 0x1000;
	        		else if (_screenVertices[_indexX] > _maxX)
	        			_screenVerticesCull[_index] += 0x100;
	        		
	        		if (_screenVertices[_indexY] < _minY)
	        			_screenVerticesCull[_index] += 0x10;
	        		else if (_screenVertices[_indexY] > _maxY)
	        			_screenVerticesCull[_index] += 0x1;
        		}
        	}
        	
        	for each(_face in _faces) {
        		if (mesh.bothsides || _screenVertices[_face.x0]*(_screenVertices[_face.y2] - _screenVertices[_face.y1]) + _screenVertices[_face.x1]*(_screenVertices[_face.y0] - _screenVertices[_face.y2]) + _screenVertices[_face.x2]*(_screenVertices[_face.y1] - _screenVertices[_face.y0]) > 0) {
        			
        			if (_face.i3) {
        				_cullTotal = 4;
        				_cullCount = _screenVerticesCull[_face.i0] + _screenVerticesCull[_face.i1] + _screenVerticesCull[_face.i2] + _screenVerticesCull[_face.i3];
        			} else {
        				_cullTotal = 3;
	        			_cullCount = _screenVerticesCull[_face.i0] + _screenVerticesCull[_face.i1] + _screenVerticesCull[_face.i2];
        			}
	        		
        			if (!(_cullCount >> 16) && (_cullCount >> 12 & 15) < _cullTotal && (_cullCount >> 8 & 15) < _cullTotal && (_cullCount >> 4 & 15) < _cullTotal && (_cullCount & 15) < _cullTotal)
						faces[faces.length] = _face;
        		}
        	}
        }
        
		/**
		 * Creates a new <code>RectangleClipping</code> object.
		 * 
		 * @param minX	Minimum allowed x value for primitives.
		 * @param maxX	Maximum allowed x value for primitives.
		 * @param minY	Minimum allowed y value for primitives.
		 * @param maxY	Maximum allowed y value for primitives.
		 * @param minZ	Minimum allowed z value for primitives.
		 * @param maxZ	Maximum allowed z value for primitives.
		 */
        public function RectangleClipping(minX:Number = -100000, maxX:Number = 100000, minY:Number = -100000, maxY:Number = 100000, minZ:Number = -100000, maxZ:Number = 100000)
        {
            super(minX, maxX, minY, maxY, minZ, maxZ);
        }
        
		public override function clone(object:Clipping = null):Clipping
        {
        	var clipping:RectangleClipping = (object as RectangleClipping) || new RectangleClipping();
        	
        	super.clone(clipping);
        	
        	return clipping;
        }
    }
}