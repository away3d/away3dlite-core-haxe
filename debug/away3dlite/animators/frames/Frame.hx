//OK

package away3dlite.animators.frames;
import flash.Vector;
/**
 * Stores a set of vertices representing the position of a mesh for a sigle frame of an animation.
 * 
 * @see away3dlite.animators.MovieMesh
 */
class Frame
{
	/**
	 * The name of the frame.
	 */
	public var name:String;
	
	/**
	 * The array of vertices contained inside the frame
	 */
	public var vertices:Vector<Float>;

	/**
	 * Creates a new <code>Frame</code> object with a name and a set of vertices
	 *
	 * @param	name		The name of the frame.
	 * @param	vertices	An array of Vertex objects.
	 */
	public function new (name:String, vertices:Vector<Float>)
	{
		this.name = name;
		this.vertices = vertices;
	}
	
	/**
	 * Returns a string representation of the <code>Frame</code> object
	 */
	public function toString():String
	{
		return "[Frame][name:" + name + "][vertices:" + vertices.length + "]";
	}
}