package away3dlite.animators.bones
{
	import away3dlite.containers.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * Stores the connection between a <code>Bone</code> and a collection of <code>SkinVertices</code> in a bones animation.
	 * 
	 * @see away3dlite.animators.BonesAnimator
	 */
    public class SkinController
    {
        private var _transformMatrix3D:Matrix3D;
        
        /**
         * Reference to the name of the controlling <code>Bone</code> object.
         */
    	public var name:String;
    	
    	/**
    	 * Reference to the joint of the controlling <code>Bone</code> object.
    	 */
		public var joint:ObjectContainer3D;
		
		/**
		 * Defines the 3d matrix that transforms the position of the <code>Bone</code> to the position of the <code>SkinVertices</code>.
		 */
        public var bindMatrix:Matrix3D;
        
        /**
         * Defines the containing 3d object that holds the <code>Mesh</code> to which the <code>SkinVertex</code> objects belong.
         */
        public var parent:ObjectContainer3D;
        
        /**
         * Store of all <code>SkinVertex</code> being controlled
         */
        public var skinVertices:Vector.<SkinVertex> =  new Vector.<SkinVertex>();
        
        /**
         * Returns the 3d transform matrix to apply to the <code>SkinVertex</code> objects.
         */
        public function get transformMatrix3D():Matrix3D
        {
        	return _transformMatrix3D;
        }
        
        /**
         * Updates the 3d transform matrix.
         */
        public function update():void
        {
        	if (!joint)
        		return;
        	
        	_transformMatrix3D = joint.transform.matrix3D.clone();
        	var child:DisplayObjectContainer = joint;
        	
        	while (child.parent != parent) {
        		child = child.parent;
        		_transformMatrix3D.append(child.transform.matrix3D);
        	}
        	_transformMatrix3D.prepend(bindMatrix);
        }
        
    }
}
