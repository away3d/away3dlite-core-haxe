package away3dlite.core.base
{

	/**
	 * Holds the accepted values for the sortType property in the <code>Mesh</code> class.
	 * 
	 * @see away3dlite.core.base.Mesh
	 */
	public class MeshSortType
	{
		/**
		 * Sorts the faces in the mesh using their center z-depth ie. the average between all vertices.
		 */
		public static const CENTER:String = "center";
		
		/**
		 * Sorts the faces in the mesh using their nearest vertex z-depth.
		 */
		public static const FRONT:String = "front";
		
		/**
		 * Sorts the faces in the mesh using their furthest vertex z-depth.
		 */
		public static const BACK:String = "back";
	}
}
