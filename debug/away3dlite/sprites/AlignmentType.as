package away3dlite.sprites
{

	/**
	 * Holds the accepted values for the alignment property in the <code>Sprite3D</code> class.
	 * 
	 * @see away3dlite.sprites.Sprite3D#alignment
	 */
	public class AlignmentType
	{
		/**
		 * Aligns the sprite parallel to the plane of the viewport.
		 */
		public static const VIEWPLANE:String = "viewplane";
		
		/**
		 * Aligns the sprite so that it faces the camera object.
		 */
		public static const VIEWPOINT:String = "viewpoint";
	}
}
