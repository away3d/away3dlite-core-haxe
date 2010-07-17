package away3dlite.loaders.data
{
	import away3dlite.animators.bones.Channel;
		
	/**
	 * Data class for an animation channel
	 */
	public class ChannelData
	{
		/**
		 * The name of the channel used as a unique reference.
		 */
		public var name:String;
		
		/**
		 * The channel object.
		 */
		public var channel:Channel;
		
		public var type:String;
		
		/**
		 * The xml object
		 */
		public var xml:XML;
	}
}