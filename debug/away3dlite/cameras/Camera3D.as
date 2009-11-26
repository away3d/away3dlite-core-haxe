package away3dlite.cameras
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	import away3dlite.core.base.*;
	
	import flash.geom.*;
	
	use namespace arcane;
	
	/**
	 * Basic camera used to resolve a view.
	 * 
	 * @see	away3dlite.containers.View3D
	 */
	public class Camera3D extends Object3D
	{
		/** @private */
		arcane var _view:View3D;
		/** @private */
		arcane function update():void
		{
			_projection = root.transform.perspectiveProjection;
			
			if(_fieldOfViewDirty) {
				_fieldOfViewDirty = false;
				//_projection.fieldOfView = 360*Math.atan2(loaderInfo.width, 2*_zoom*_focus)/Math.PI;
				_projection.focalLength = _zoom*_focus;
			}
			
			_projectionMatrix3D = _projection.toMatrix3D();
			
			_invSceneMatrix3D.rawData = transform.matrix3D.rawData;
			_invSceneMatrix3D.prependTranslation(0, 0, -_focus);
			_invSceneMatrix3D.invert();
			
			_screenMatrix3D.rawData = _invSceneMatrix3D.rawData;
			_screenMatrix3D.append(_projectionMatrix3D);
		}
		
		private var _focus:Number = 100;
		private var _zoom:Number = 10;
		private var _projection:PerspectiveProjection;
		private var _projectionMatrix3D:Matrix3D;
		private var _screenMatrix3D:Matrix3D = new Matrix3D();
		private var _invSceneMatrix3D:Matrix3D = new Matrix3D();
		private var _fieldOfViewDirty:Boolean = true;
		
		protected const toRADIANS:Number = Math.PI/180;
		protected const toDEGREES:Number = 180/Math.PI;
		
		/**
		 * Defines the distance from the focal point of the camera to the viewing plane.
		 */
		public function get focus():Number
		{
			return _focus;
		}
		public function set focus(val:Number):void
		{
			_focus = val;
			
			_fieldOfViewDirty = true;
		}
		
		/**
		 * Defines the overall scale value of the view.
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(val:Number):void
		{
			_zoom = val;
			
			_fieldOfViewDirty = true;
		}
		
		/**
		 * Returns the 3d matrix representing the camera inverse scene transform for the view.
		 */
		public function get invSceneMatrix3D():Matrix3D
		{
			return _invSceneMatrix3D;
		}
		
		/**
		 * Returns the 3d matrix representing the camera projection for the view.
		 */
		public function get projectionMatrix3D():Matrix3D
		{
			return _projectionMatrix3D;
		}
		
		/**
		 * Returns the 3d matrix used in resolving screen space for the render loop.
		 * 
		 * @see away3dlite.containers.View3D#render()
		 */
		public function get screenMatrix3D():Matrix3D
		{
			return _screenMatrix3D;
		}
		
		/**
		 * Creates a new <code>Camera3D</code> object.
		 * 
		 * @param focus		Defines the distance from the focal point of the camera to the viewing plane.
		 * @param zoom		Defines the overall scale value of the view.
		 */
		public function Camera3D(zoom:Number = 10, focus:Number = 100)
		{
			super();
			
			this.zoom = zoom;
			this.focus = focus;
			
			//set default z position
			z = -1000;
		}
	}
}
