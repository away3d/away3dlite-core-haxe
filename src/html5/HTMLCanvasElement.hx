/**
 * ...
 * @author waneck
 */

package html5;

#if js
typedef HTMLCanvasElement = 
{>js.Dom.HtmlDom,
	var width:Int;
	var height:Int;
	function toDataURL(?type:String, args:Dynamic):String;
	function getContext(contextId:String):Dynamic;
}

typedef DOMString = String;

#else

typedef HTMLCanvasElement = Dynamic;
#end