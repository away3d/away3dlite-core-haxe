package away3dlite.loaders.data;
import flash.geom.Matrix3D;


/**
 * Data class for a bone used in SkinAnimation.
 */
class BoneData extends ContainerData
{
	/**
	 * Transform information for the joint in a SkinAnimation
	 */
	public var jointTransform:Matrix3D;
	
	public function new()
	{
		super();
		jointTransform = new Matrix3D();
	}
}