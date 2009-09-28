package away3dlite.animators
{
	import away3dlite.arcane;
	import away3dlite.core.base.*;
	import away3dlite.animators.frames.Frame;
	
	import flash.events.*;
	import flash.utils.*;
	
	use namespace arcane;
	
	/**
	 * Animates a series of <code>Frame</code> objects in sequence in a mesh.
	 */
	public class MovieMesh extends Mesh
	{
		/*
		 * Three kinds of animation sequences:
		 *  [1] Normal (sequential, just playing)
		 *  [2] Loop   (a loop)
		 *  [3] Stop   (stopped, not animating)
		 */
		public static const ANIM_NORMAL:int = 1;
		public static const ANIM_LOOP:int = 2;
		public static const ANIM_STOP:int = 4;
		private var framesLength:int = 0;
		
		//Keep track of the current frame number and animation
		private var _currentFrame:int = 0;
		private var _addFrame:int;
		private var _interp:Number = 0;
		private var _begin:int;
		private var _end:int;
		private var _type:int;
		private var _ctime:Number = 0;
		private var _otime:Number = 0;

		private var labels:Dictionary = new Dictionary(true);
		private var _currentLabel:String;
		
		private function onEnterFrame(event:Event = null):void
		{
			_ctime = getTimer();

			var cframe:Frame;
			var nframe:Frame;
			var i:int = _vertices.length;
			
			cframe = frames[_currentFrame];
			nframe = frames[(_currentFrame + 1) % framesLength];

			// TODO : optimize
			var _cframe_vertices:Vector.<Number> = cframe.vertices;
			var _nframe_vertices:Vector.<Number> = nframe.vertices;
			
			while (i--)
				_vertices[i] = _cframe_vertices[i] + _interp*(_nframe_vertices[i] - _cframe_vertices[i]);
			
			if (_type != ANIM_STOP) {
				_interp += fps * (_ctime - _otime) / 1000;
				
				if (_interp > 1) {
					_addFrame = int(_interp);
					
					if (_type == ANIM_LOOP && _currentFrame + _addFrame >= _end)
						keyframe = _begin + _currentFrame + _addFrame - _end;
					else
						keyframe += _addFrame;
					
					_interp -= _addFrame;
				}
			}
			_otime = _ctime;
		}
		
		/**
		 * Number of animation frames to display per second
		 */
		public var fps:int = 24;

		/**
		 * The array of frames that make up the animation sequence.
		 */
		public var frames:Vector.<Frame> = new Vector.<Frame>();
		
		/**
		 * Creates a new <code>MovieMesh</code> object that provides a "keyframe animation"/"vertex animation"/"mesh deformation" framework for subclass loaders.
		 */
		public function MovieMesh()
		{
			super();
		}
		
		/**
		 * Adds a new frame to the animation timeline.
		 */
		public function addFrame(frame:Frame):void
		{
			var _name:String = frame.name.slice(0, frame.name.length - 3);
			
			if (!labels[_name])
				labels[_name] = {begin:framesLength, end:framesLength};
			else
				++labels[_name].end;

			frames.push(frame);
			
			framesLength++;
		}
		
		/**
		 * Begins a looping sequence in the animation.
		 * 
		 * @param begin		The starting frame position.
		 * @param end		The ending frame position.
		 */
		public function loop(begin:int, end:int):void
		{
			if (framesLength > 0) {
				_begin = (begin % framesLength);
				_end = (end % framesLength);
			} else {
				_begin = begin;
				_end = end;
			}

			keyframe = begin;
			_type = ANIM_LOOP;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Plays a pre-defined labelled sequence of animation frames.
		 */
		public function play(label:String = ""):void
		{
			if (!labels)
				return;

			if (_currentLabel != label) {
				_currentLabel = label;
				loop(labels[label].begin, labels[label].end);
			}

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Stops the animation.
		 */
		public function stop():void
		{
			_type = ANIM_STOP;
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Defines the current keyframe.
		 */
		public function get keyframe():int
		{
			return _currentFrame;
		}

		public function set keyframe(i:int):void
		{
			_currentFrame = i % framesLength;
		}
	}
}