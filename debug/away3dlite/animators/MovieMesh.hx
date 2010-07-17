//OK
//?

package away3dlite.animators;
import away3dlite.animators.frames.Frame;
import away3dlite.core.base.Mesh;
import flash.events.Event;
import flash.Lib;
import flash.Vector;


//use namespace arcane;

/**
 * Animates a series of <code>Frame</code> objects in sequence in a mesh.
 */
class MovieMesh extends Mesh
{
	/*
	 * Three kinds of animation sequences:
	 *  [1] Normal (sequential, just playing)
	 *  [2] Loop   (a loop)
	 *  [3] Stop   (stopped, not animating)
	 */
	public static inline var ANIM_NORMAL:Int = 1;
	public static inline var ANIM_LOOP:Int = 2;
	public static inline var ANIM_STOP:Int = 4;
	private var framesLength:Int;
	
	//Keep track of the current frame number and animation
	private var _currentFrame:Int;
	private var _addFrame:Int;
	private var _interp:Float;
	private var _begin:Int;
	private var _end:Int;
	private var _type:Int;
	private var _ctime:Float;
	private var _otime:Float;

	private var labels:Hash<Keyframe>;
	private var _currentLabel:String;
	
	private function onEnterFrame(?event:Event):Void
	{
		_ctime = Lib.getTimer();

		var cframe:Frame;
		var nframe:Frame;
		var i:Int = _vertices.length;
		
		cframe = frames[_currentFrame];
		nframe = frames[(_currentFrame + 1) % framesLength];

		// TODO : optimize
		var _cframe_vertices:Vector<Float> = cframe.vertices;
		var _nframe_vertices:Vector<Float> = nframe.vertices;
		
		while (i-- != 0)
			_vertices[i] = _cframe_vertices[i] + _interp*(_nframe_vertices[i] - _cframe_vertices[i]);
		
		if (_type != ANIM_STOP) {
			_interp += fps * (_ctime - _otime) / 1000;
			
			if (_interp > 1) {
				_addFrame = Std.int(_interp);
				
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
	public var fps:Int;

	/**
	 * The array of frames that make up the animation sequence.
	 */
	public var frames:Vector<Frame>;
	
	/**
	 * Creates a new <code>MovieMesh</code> object that provides a "keyframe animation"/"vertex animation"/"mesh deformation" framework for subclass loaders.
	 */
	public function new()
	{
		super();
		
		frames = new Vector<Frame>();
		fps = 24;
		framesLength = 0;
		_currentFrame = 0;
		_interp = 0;
		_ctime = 0;
		_otime = 0;
		labels = new Hash<Keyframe>();
	}
	
	/**
	 * Adds a new frame to the animation timeline.
	 */
	public function addFrame(frame:Frame):Void
	{
		//var _name:String = frame.name.slice(0, frame.name.length - 3);
		//HAXE_EQ
		var _name = frame.name.substr(0, frame.name.length - 3);
		
		if (!labels.exists(_name))
			labels.set(_name, { begin:framesLength, end:framesLength } );
		else
		{
			//HAXE_MODIFYIED
			//MUST_OPTIMIZE
			var label = labels.get(_name);
			label.end++;
			labels.set(_name, label);
		}

		frames.push(frame);
		
		framesLength++;
	}
	
	/**
	 * Begins a looping sequence in the animation.
	 * 
	 * @param begin		The starting frame position.
	 * @param end		The ending frame position.
	 */
	public function loop(begin:Int, end:Int):Void
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
	public function play(?label:String = ""):Void
	{
		//HAXE_MOD
		if (labels == null)
			return;

		if (_currentLabel != label) {
			_currentLabel = label;
			var keylabel = labels.get(label);
			loop(keylabel.begin, keylabel.end);
		}

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/**
	 * Stops the animation.
	 */
	public function stop():Void
	{
		_type = ANIM_STOP;
		
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/**
	 * Defines the current keyframe.
	 */
	public var keyframe(get_keyframe, set_keyframe):Int;
	private inline function get_keyframe():Int
	{
		return _currentFrame;
	}

	private function set_keyframe(i:Int):Int
	{
		return _currentFrame = i % framesLength;
	}
}

typedef Keyframe = { begin:Int, end:Int };