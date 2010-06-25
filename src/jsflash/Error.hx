/**
 * ...
 * @author waneck
 */

package jsflash;
import haxe.Stack;
/*
class Error {
	public var errorID(default,null) : Int;
	public var message : Dynamic;
	public var name : Dynamic;
	public function new(?message : String, ?id : Int) : Void
	{
		this.message = message;
		this.errorID = id;
	}
	public function getStackTrace() : String
	{
		return Stack.toString(Stack.callStack());
	}
}*/

enum Error
{
	RangeError;
	ArgumentError;
	Message(str:String);
}