package away3dlite.loaders.data;

import away3dlite.animators.bones.Channel;
import flash.xml.XML;
	
/**
 * Data class for an animation channel
 */
class ChannelData
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
	
	/**
	 * The index of the channel inside the XML structure (in case there's more than 1 channel)
	 */
	public var channelIndex:Int;
	
	public function new()
	{
		
	}
}