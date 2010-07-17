package away3dlite.materials;

import away3dlite.containers.Scene3D;
import away3dlite.haxeutils.FastStd;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;


//use namespace arcane;
using away3dlite.namespace.Arcane;

class MovieMaterial extends BitmapMaterial
{
	/** @private */
	/*arcane*/ override function notifyActivate(scene:Scene3D):Void
	{
		super.notifyActivate(scene);
		scene.arcaneNS()._broadcaster.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		onEnterFrame();
	}
	/** @private */
	/*arcane*/ override function notifyDeactivate(scene:Scene3D):Void
	{
		super.notifyActivate(scene);
		scene.arcaneNS()._broadcaster.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private var _transparent:Bool;
	private var _movie:Sprite;
	private var _movieRect:Rectangle;
	private var _rect:Rectangle;
	private var _drawRect:Rectangle;
	private var _bitmapDirty:Bool;
	
	private function onEnterFrame(?event:Event):Void
	{
		if (autoUpdate)
			update();
	}
	
	private function updateBitmap():Void
	{
		_bitmapDirty = false;
		
		_drawRect = (_rect != null) ? _rect : _movieRect;
		
		if (_drawRect.width == 0 || _drawRect.height == 0)
			_drawRect = new Rectangle(0, 0, 256, 256);
		
		_graphicsBitmapFill.bitmapData = new BitmapData(Std.int(_drawRect.width + 0.99), Std.int(_drawRect.height + 0.99), _transparent, 0);
	}
	
	/**
	* Indicates whether the texture bitmap is updated on every frame
	*/
	public var autoUpdate:Bool;
	
	/**
	* Defines the transparent property of the texture bitmap created from the movie
	* 
	* @see movie
	*/
	public var transparent(get_transparent, set_transparent):Bool;
	private function get_transparent():Bool
	{
		return _transparent;
	}
	
	private function set_transparent(val:Bool):Bool
	{
		_transparent = val;
		
		_bitmapDirty = true;
		return val;
	}
	
	/**
	* Defines the movieclip used for rendering the material
	*/
	public var movie(get_movie, set_movie):Sprite;
	private function get_movie():Sprite
	{
		return _movie;
	}
	
	private function set_movie(val:Sprite):Sprite
	{
		if (_movie == val)
			return val;
		
		//if (val && val.parent)
		//	val.parent.removeChild(val);
		
		_movie = val;
		
		_movieRect = _movie.getBounds(_movie);
		
		_bitmapDirty = true;
		
		if (!autoUpdate)
			update();
		return val;
	}
	
	/**
	* Defines the rectangle of the movie to be rendered into the texture bitmap.
	* 
	* @see movie
	*/
	public var rect(get_rect, set_rect):Rectangle;
	private function get_rect():Rectangle
	{
		return _rect;
	}
	
	private function set_rect(val:Rectangle):Rectangle
	{
		_rect = val;
		
		_bitmapDirty = true;
		
		return val;
	}
	
	public function new(movie:Sprite, ?rect:Rectangle, ?autoUpdate:Bool = true, ?transparent:Bool = true)
	{
		super();
		
		this.autoUpdate = autoUpdate;
		this.movie = movie;
		this.rect = rect;
		this.transparent = transparent;
	}
	
	/**
	 * Manually updates the texture bitmap with the current frame of the <code>movie</code> display object.
	 * Automatically triggered unless <code>autoUpdate</code> is set to false.
	 * 
	 * @see movie
	 * @see autoUpdate
	 */
	public function update():Void
	{
		if (_bitmapDirty)
			updateBitmap();
		
		var r:Rectangle = _graphicsBitmapFill.bitmapData.rect;
		var m:Matrix = new Matrix(_movie.scaleX, 0, 0, _movie.scaleY, -_drawRect.x, -_drawRect.y);
		
		_graphicsBitmapFill.bitmapData.fillRect(r, 0x000000);
		_graphicsBitmapFill.bitmapData.draw(_movie, m, _movie.transform.colorTransform, _movie.blendMode, r);
	}
}