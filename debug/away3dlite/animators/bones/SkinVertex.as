package away3dlite.animators.bones
{
	import flash.geom.*;
	
    public class SkinVertex
    {
    	private var _i:int;
    	private var _position:Vector3D = new Vector3D();
        private var _output:Vector3D;
        private var _startIndex:int;
        private var _vertices:Vector.<Number>;
		private var _baseVertex:Vector3D;
		
        public var weights:Vector.<Number> = new Vector.<Number>();
        
        public var controllers:Vector.<SkinController> = new Vector.<SkinController>();
		
        public function SkinVertex()
        {
        }
		
		public function updateVertices(startIndex:int, vertices:Vector.<Number>):void
		{
			_startIndex = startIndex;
			_vertices = vertices;
            _baseVertex = new Vector3D(_vertices[_startIndex], _vertices[_startIndex + 1], _vertices[_startIndex + 2]);
		}
		
        public function update():void
        {
        	//reset values
            _output = new Vector3D();
            
            _i = weights.length;
            while (_i--) {
            	_position = controllers[_i].transformMatrix3D.transformVector(_baseVertex);
				_position.scaleBy(weights[_i]);
				_output = _output.add(_position);
            }
            
            _vertices[_startIndex] = _output.x;
            _vertices[_startIndex + 1] = _output.y;
            _vertices[_startIndex + 2] = _output.z;
        }
        
        public function clone():SkinVertex
        {
        	var skinVertex:SkinVertex = new SkinVertex();
        	skinVertex.weights = weights;
        	skinVertex.controllers = controllers;
        	
        	return skinVertex;
        }
    }
}
