package away3dlite.core.base;

/**
 * Holds the accepted values for the sortType property in the <code>Mesh</code> class.
 * 
 * @see away3dlite.core.base.Mesh
 */
class SortType
{
	/**
	 * Sorts the faces in the mesh using their center z-depth ie. the average between all vertices.
	 */
	public static inline var CENTER:String = "center";
	
	/**
	 * Sorts the faces in the mesh using their nearest vertex z-depth.
	 */
	public static inline var FRONT:String = "front";
	
	/**
	 * Sorts the faces in the mesh using their furthest vertex z-depth.
	 */
	public static inline var BACK:String = "back";
}
