import js.Dom;

extern class Image {
	var align : String;
	var alt : String;
	var border : String;
	var height : Int;
	var hspace : Int;
	var isMap : Bool;
	var name : String;
	var src : String;
	var useMap : String;
	var vspace : Int;
	var width : Int;

	var complete : Bool;
	var lowsrc : String;

	var onabort : Event -> Void;
	var onerror : Event -> Void;
	var onload : Event -> Void;

	// HtmlDom
	var id : String;
	var title : String;
	var lang : String;
	var dir : String;
	var innerHTML : String;
	var className : String;

	var style : Style;

	function new ( ?width : Int, ?height : Int ):Void;
	function getElementsByTagName( tag : String ) : HtmlCollection<HtmlDom>;

	var scrollTop : Int;
	var scrollLeft : Int;
	var scrollHeight(default,null) : Int;
	var scrollWidth(default,null) : Int;
	var clientHeight(default,null) : Int;
	var clientWidth(default,null) : Int;
	var offsetParent : HtmlDom;
	var offsetLeft : Int;
	var offsetTop : Int;
	var offsetWidth : Int;
	var offsetHeight : Int;

	function blur() : Void;
	function click() : Void;
	function focus() : Void;

	var onscroll : Event -> Void;
	var onblur : Event -> Void;
	var onclick : Event -> Void;
	var ondblclick : Event -> Void;
	var onfocus : Event -> Void;
	var onkeydown : Event -> Void;
	var onkeypress : Event -> Void;
	var onkeyup : Event -> Void;
	var onmousedown : Event -> Void;
	var onmousemove : Event -> Void;
	var onmouseout : Event -> Void;
	var onmouseover : Event -> Void;
	var onmouseup : Event -> Void;
	var onresize : Event -> Void;
}
