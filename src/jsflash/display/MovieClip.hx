package jsflash.display;


class MovieClip extends jsflash.display.Sprite
{
   public var enabled:Bool;
   public var currentFrame(GetCurrentFrame,null):Int;
   public var framesLoaded(GetTotalFrames,null):Int;
   public var totalFrames(GetTotalFrames,null):Int;

   var mCurrentFrame:Int;
   var mTotalFrames:Int;

   function GetTotalFrames() { return mTotalFrames; }
   function GetCurrentFrame() { return mCurrentFrame; }

   public function new()
   {
      super();
      enabled = true;
      mCurrentFrame = 0;
      mTotalFrames = 0;
      name = "MovieClip " + jsflash.display.DisplayObject.mNameID++;
   }

   public function gotoAndPlay(frame:Dynamic, ?scene:String):Void { }
   public function gotoAndStop(frame:Dynamic, ?scene:String):Void { }
   public function play():Void { }
   public function stop():Void { }


}




