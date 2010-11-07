/**
 * Wrapper class for haXe compatibility with E4X features.
 */

package away3dlite.haxeutils.xml;
import away3dlite.haxeutils.FastStd;
import flash.utils.Proxy;
import flash.xml.XMLList;
import flash.xml.XML;
import flash.Vector;

using away3dlite.haxeutils.xml.E4X;

#if haxe_205 extern #end class E4X
{
	/**
	 * Used to replicate bracketed access in XML and XMLList classes. Will also work with the "@" operator.
	 * 
	 * EXAMPLE:
	 * 					myxml.@attribute (as3)
	 * will become -> 	myxml._("@attribute") (haXe)
	 * 					myxml["insert long string here"] (as3)
	 * will become -> 	myxml._("insert long string here") (haXe)
	 * 
	 * @param	field 
	 * @return	A new E4XMLList wrapper
	 */
	public static inline function _(node:XML, field:String):XMLList
	{
		return untyped cast node[field];
	}
	
	/**
	 * Used to replicate the ".." operator in XML and XMLList classes.
	 * Same as calling this.node.descendants(str), but will already return a new E4XMLList wrapper.
	 * 
	 * @param	descendantField (optional)
	 * @return	A new E4XMLList wrapper
	 */
	public static inline function __(node:XML, descendantField:String):XMLList
	{
		return untyped node.descendants(descendantField);
	}
	
	/**
	 * Replicates the filter behaviour. Will iterate through all elements and run a test function on each of them.
	 * 
	 * @param	field				internal xml field that we want to test for equality
	 * @param	compareTo			external field (can be a string or another XMLList)
	 * @param	compareFunction		the compare function. Defaults to the equal function
	 */
	public static inline function _filter(node:XML, field:String, compareTo:Dynamic, compareFunction:Dynamic->Dynamic->Bool):XMLList
	{
		var len = untyped node.length();
		var retval = "";
		var i = -1;
		while (++i < len)
		{
			var teste : XML = cast untyped node[i];
			if (compareFunction(untyped teste[field], compareTo))
			{
				retval += untyped node[i];
			}
		}

		return new XMLList(retval);
	}
	
	/**
	 * Will remove the currently unsupported namespaces
	 * 
	 * @return
	 */
	public static inline function removeNamespaces(node:XML):XML
	{
		return node = new XML((~/xmlns(?:.*?)?=".*?"/is.replace(node.toXMLString(), "")));
	}
	
	public static inline function _filter_eq(node:XML, field:String, compareTo:Dynamic):XMLList
	{
		var len = untyped node.length();
		var retval = "";
		var i = -1;
		while (++i < len)
		{
			var teste : XML = cast untyped node[i];
			if (untyped teste[field] == compareTo)
			{
				retval += untyped node[i].toXMLString();
			}
		}

		return new XMLList(retval);
	}
	
	public static inline function toFloat(node:XML):Float
	{
		return FastStd.parseFloat(node.toString());
	}
}

class E4XML 
{
	public static function iterator(node:XML):Iterator<XML>
	{
		return untyped {
			n : node,
			len : node.length(),
			i : 0,
			hasNext: function() { return (this.i < this.len); },
			next: function() { return new XML( this.n[this.i++] ); }
		}
	}
}

#if haxe_205 extern #end class E4XList
{
	/**
	 * Used to replicate bracketed access in XML and XMLList classes. Will also work with the "@" operator.
	 * 
	 * EXAMPLE:
	 * 					myxml.@attribute (as3)
	 * will become -> 	myxml._("@attribute") (haXe)
	 * 					myxml["insert long string here"] (as3)
	 * will become -> 	myxml._("insert long string here") (haXe)
	 * 
	 * @param	field 
	 * @return	A new E4XMLList wrapper
	 */
	public static inline function _(node:XMLList, field:String):XMLList
	{
		return cast untyped node[field];
	}
	
	/**
	 * Used to replicate the ".." operator in XML and XMLList classes.
	 * Same as calling this.node.descendants(str), but will already return a new E4XMLList wrapper.
	 * 
	 * @param	descendantField (optional)
	 * @return	A new E4XMLList wrapper
	 */
	public static inline function __(node:XMLList, descendantField:String):XMLList
	{
		return untyped node.descendants(descendantField);
	}
	
	/**
	 * Replicates the filter behaviour. Will iterate through all elements and run a test function on each of them.
	 * 
	 * @param	field				internal xml field that we want to test for equality
	 * @param	compareTo			external field (can be a string or another XMLList)
	 * @param	?compareFunction	the compare function. Defaults to the equality function ( == )
	 */
	public static inline function _filter(node:XMLList, field:String, compareTo:Dynamic, compareFunction:Dynamic->Dynamic->Bool):XMLList
	{
		var len = untyped node.length();
		var retval = "";
		var i = -1;
		while (++i < len)
		{
			var teste : XML = cast untyped node[i];
			if (compareFunction(untyped teste[field], compareTo))
			{
				retval += untyped node[i].toXMLString();
			}
		}

		return new XMLList(retval);
	}
	
	public static inline function _filter_eq(node:XMLList, field:String, compareTo:Dynamic):XMLList
	{
		var len = node.length();
		var retval = "";
		var i = -1;
		while (++i < len)
		{
			var teste : XML = node[i];
			if (untyped teste[field] == compareTo)
			{
				retval += untyped node[i].toXMLString();
			}
		}

		return new XMLList(retval);
	}
	
	public static inline function toFloat(node:XMLList):Float
	{
		return FastStd.parseFloat(node.toString());
	}
}

class E4XMLList
{
	public static function iterator(node:XMLList):Iterator<XML>
	{
		return untyped {
			n : node,
			len : node.length(),
			i : 0,
			hasNext: function() { return (this.i < this.len); },
			next: function() { return new XML( this.n[this.i++] ); }
		}
	}
}