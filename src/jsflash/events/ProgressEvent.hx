package jsflash.events;

class ProgressEvent extends Event {
	public function new(type : String, ?bubbles : Bool, ?cancelable : Bool) : Void {
     super(type,bubbles,cancelable);
	}
		public var bytesLoaded : Int;
		public var bytesTotal : Int;
		public static var PROGRESS:String = "progress";
		public static var SOCKET_DATA:String = "socketData";
}

