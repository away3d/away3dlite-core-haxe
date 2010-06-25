//
//  Manager
//
//  Created by Caue W. on 2010-03-21.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
package jsflash;
import jsflash.display.Stage;
import jsflash.display.Sprite;
import html5.HTMLCanvasElement;
import js.Lib;
import js.Dom;
import webgl.wrappers.GLEnum;

class Manager 
{
	
	public static var current(default, null):Sprite;
	
	public static var stage(default, null):Stage;
	
	public static function init(?canvas:HTMLCanvasElement, ?width:Int, ?height:Int):Void 
	{
		if (canvas == null)
			canvas = cast Lib.document.createElement("canvas");
			
		if (width != null)
			canvas.width = width;
		if (height != null)
			canvas.height = height;
		
		stage = new Stage(canvas);
		current = new Sprite();
		stage.addChild(current);
		untyped jsflash.Lib.current = current;
	}
	
	public static function setupWebGL(?stage:Stage):Void
	{
		if (stage == null)
			stage = Manager.stage;
			
		var gl = stage.RenderingContext;
		gl.viewport(0, 0, Std.int(stage.stageWidth), Std.int(stage.stageHeight));
		gl.clearColor(0.0, 0.0, 0.0, 1.0);
		gl.clearDepth(1.0);
		gl.enable(GLEnum.DEPTH_TEST);
		gl.depthFunc(GLEnum.LEQUAL);
		//gl.cullFace(GLEnum.FRONT_AND_BACK);
		gl.cullFace(GLEnum.FRONT);
	}
}