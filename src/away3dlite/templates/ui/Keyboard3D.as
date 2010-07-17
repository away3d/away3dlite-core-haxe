package away3dlite.templates.ui
{
	import away3dlite.templates.events.Keyboard3DEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	/**
	 * @author katopz
	 */
	public class Keyboard3D extends EventDispatcher
	{
		public static var isKeyRight:Boolean = false;
		public static var isKeyLeft:Boolean = false;
		public static var isKeyForward:Boolean = false;
		public static var isKeyBackward:Boolean = false;
		public static var isKeyUp:Boolean = false;
		public static var isKeyDown:Boolean = false;

		public static var isKeyPeekLeft:Boolean = false;
		public static var isKeyPeekRight:Boolean = false;

		public static var isCTRL:Boolean = false;
		public static var isALT:Boolean = false;
		public static var isSHIFT:Boolean = false;
		public static var isSPACE:Boolean = false;

		public static var numKeyPress:int = 0;
		
		public static var keyType:String = KeyboardEvent.KEY_UP;
		public static var keyCode:uint = 0;

		public static var position:Vector3D;

		private var container:Stage;
		private var yUp:Boolean = true;

		public function Keyboard3D(container:Stage, yUp:Boolean = true)
		{
			this.container = container;
			this.yUp = yUp;

			position = new Vector3D();
			container.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			container.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}

		public function destroy():void
		{
			container.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			container.removeEventListener(KeyboardEvent.KEY_UP, keyHandler);
			container.removeEventListener(Event.ENTER_FRAME, onKey);
		}

		private function onKey(event:Event):void
		{
			var dx:int = 0;
			var dy:int = 0;
			var dz:int = 0;
			var dw:int = 0;

			//up, down
			if (isKeyForward)
			{
				dz = 1;
			}
			else if (isKeyBackward)
			{
				dz = -1;
			}

			//left, right
			if (isKeyRight)
			{
				dx = 1;
			}
			else if (isKeyLeft)
			{
				dx = -1;
			}

			//up, down
			if (isKeyUp)
			{
				dy = 1;
			}
			else if (isKeyDown)
			{
				dy = -1;
			}

			//peek left, peek right
			if (isKeyPeekLeft)
			{
				dw = -1;
			}
			else if (isKeyPeekRight)
			{
				dw = 1;
			}

			if (yUp)
			{
				position.x = dx;
				position.y = -dy;
				position.z = dz;
				position.w = dw;
			}
			else
			{
				position.x = dx;
				position.y = dy;
				position.z = dz;
				position.w = dw;
			}

			dispatchEvent(new Keyboard3DEvent(Keyboard3DEvent.KEY_PRESS, position));
		}

		private function keyHandler(event:KeyboardEvent):void
		{
			isCTRL = event.ctrlKey;
			isALT = event.altKey;
			isSHIFT = event.shiftKey;
			
			keyType = event.type; 

			switch (event.type)
			{
				case KeyboardEvent.KEY_DOWN:
					keyCode = event.keyCode;
					isSPACE = (event.keyCode == Keyboard.SPACE);
					switch (event.keyCode)
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							isKeyForward = true;
							isKeyBackward = false;
							numKeyPress++;
							break;
	
						case "S".charCodeAt():
						case Keyboard.DOWN:
							isKeyBackward = true;
							isKeyForward = false;
							numKeyPress++;
							break;
	
						case "A".charCodeAt():
						case Keyboard.LEFT:
							isKeyLeft = true;
							isKeyRight = false;
							numKeyPress++;
							break;
	
						case "D".charCodeAt():
						case Keyboard.RIGHT:
							isKeyRight = true;
							isKeyLeft = false;
							numKeyPress++;
							break;
	
						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							isKeyDown = true;
							isKeyUp = false;
							numKeyPress++;
							break;
	
						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							isKeyUp = true;
							isKeyDown = false;
							numKeyPress++;
							break;
	
						case "Q".charCodeAt():
						case "[".charCodeAt():
							isKeyPeekLeft = true;
							isKeyPeekRight = false;
							numKeyPress++;
							break;
	
						case "E".charCodeAt():
						case "]".charCodeAt():
							isKeyPeekRight = true;
							isKeyPeekLeft = false;
							numKeyPress++;
							break;
					}
					if ((numKeyPress > 0) && !container.hasEventListener(Event.ENTER_FRAME))
						container.addEventListener(Event.ENTER_FRAME, onKey, false, 0, true);
					break;
				case KeyboardEvent.KEY_UP:
					keyCode = 0;
					if (event.keyCode == Keyboard.SPACE)
					{
						isSPACE = false;
					}
					switch (event.keyCode)
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							isKeyForward = false;
							--numKeyPress;
							break;
	
						case "S".charCodeAt():
						case Keyboard.DOWN:
							isKeyBackward = false;
							--numKeyPress;
							break;
	
						case "A".charCodeAt():
						case Keyboard.LEFT:
							isKeyLeft = false;
							--numKeyPress;
							break;
	
						case "D".charCodeAt():
						case Keyboard.RIGHT:
							isKeyRight = false;
							--numKeyPress;
							break;
	
						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							isKeyDown = false;
							--numKeyPress;
							break;
	
						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							isKeyUp = false;
							--numKeyPress;
							break;
	
						case "Q".charCodeAt():
						case "[".charCodeAt():
							isKeyPeekLeft = false;
							isKeyPeekRight = false;
							--numKeyPress;
							break;
	
						case "E".charCodeAt():
						case "]".charCodeAt():
							isKeyPeekRight = false;
							isKeyPeekLeft = false;
							--numKeyPress;
							break;
					}
					if (numKeyPress == 0)
					{
						container.removeEventListener(Event.ENTER_FRAME, onKey);
						position = new Vector3D();
					}
					break;
			}
		}
	}
}