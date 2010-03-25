//
//  DisplayObjectContainer
//
//  Created by Caue W. on 2010-03-21.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

package jsflash.display;
import jsflash.Error;

class DisplayObjectContainer extends DisplayObject
{
	private var __children:Array<DisplayObject>;
	
	public function new()
	{
		super();
		__children = [];
	}
	
	public function addChild(child:DisplayObject):DisplayObject
	{
		return addChildAt(child, __children.length);
	}
	
	public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		if (index > __children.length )
			throw Error.RangeError;
		else if (index == __children.length)
			__children.push(child);
		else
			__children.insert(index, child);
		
		if (child.parent != null)
			child.parent.removeChild(child);
		
		child.Internal().parent = this;
		child.Internal().root = this.root;
		child.Internal().stage = this.stage;
		
		return  child;
	}
	
	
	public function removeChild(child:DisplayObject):DisplayObject
	{
		if(!__children.remove(child))
			throw ArgumentError;
		
		child.Internal().parent = null;
		child.Internal().root = null;
		child.Internal().stage = null;
		
		return child;
	}
	
	public function removeChildAt(index:Int):DisplayObject
	{
		if (index >= __children.length)
			throw RangeError;
		
		var child = __children.splice(index, 1)[0];
		
		child.Internal().parent = null;
		child.Internal().root = null;
		child.Internal().stage = null;
		
		return child;
	}
	
	public function contains(child:DisplayObject):Bool
	{
		return Lambda.has(__children, child);
	}
	
	public function getChildAt(index:Int):DisplayObject
	{
		return __children[index];
	}
	
	public function getChildByName(name:String):DisplayObject
	{
		return Lambda.fold(__children, function(child, rslt) return ((child.name == name) ? child : rslt ), null);
	}
	
	public function getChildIndex(child:DisplayObject):Int
	{
		var idx = 0;
		for (_child in __children)
		{
			if (_child == child)
				return idx;
			idx++;
		}
		return -1;
	}
	
	//function getObjectsUnderPoint(point : flash.geom.Point) : Array<DisplayObject>;
	public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		if (index >= __children.length)
			throw RangeError;
		
		var idx = getChildIndex(child);
		if (idx == -1)
			throw ArgumentError;
		
		__children.splice(idx, 1);
		__children.insert(index, child);
	}
	
	public function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : Void
	{
		var idx1 = getChildIndex(child1);
		var idx2 = getChildIndex(child2);
		if (idx1 == -1 || idx2 == -1)
			throw ArgumentError;
		
		__children[idx2] = child1;
		__children[idx1] = child2;
	}
	
	public function swapChildrenAt(index1 : Int, index2 : Int) : Void
	{
		if (index1 >= __children.length || index2 >= __children.length)
			throw RangeError;
		
		var child1 = __children[index1];
		var child2 = __children[index2];
		
		__children[index2] = child1;
		__children[index1] = child2;
	}
	
	private override function set_stage(val)
	{
		for (child in __children)
		{
			child.Internal().stage = val;
		}
		return super.set_stage(val);
	}
	
	private override function set_root(val:DisplayObject)
	{
		for (child in __children)
		{
			child.Internal().root = val;
		}
		return super.set_root(val);
	}
}