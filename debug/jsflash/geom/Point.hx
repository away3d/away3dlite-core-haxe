//
//  Point
//
//  Created by Caue W. on 2010-03-20.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

package jsflash.geom;

class Point 
{
	public var x:Float;
	public var y:Float;
	
	public function new(?x = 0.0, ?y = 0.0)
	{
		this.x = x;
		this.y = y;
	}
}