package jsflash.swf;

import jsflash.swf.Shape;
import jsflash.swf.MorphShape;
import jsflash.swf.Sprite;
import jsflash.swf.Bitmap;
import jsflash.swf.Font;
import jsflash.swf.StaticText;
import jsflash.swf.EditText;

enum Character
{
   charShape(inShape:Shape);
   charMorphShape(inMorphShape:MorphShape);
   charSprite(inSprite:Sprite);
   charBitmap(inBitmap:Bitmap);
   charFont(inFont:Font);
   charStaticText(inText:StaticText);
   charEditText(inText:EditText);
}
