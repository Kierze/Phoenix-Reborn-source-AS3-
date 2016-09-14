// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.util._kp

package com.company.util {

import flash.display.BitmapData;

public class AssetFile {

    public function AssetFile()
    {
        this.Bitmaps = new Vector.<BitmapData>();
    }
    public var Bitmaps:Vector.<BitmapData>;

    public function add(_arg1:BitmapData):void
    {
        this.Bitmaps.push(_arg1);
    }

    public function random():BitmapData
    {
        return (this.Bitmaps[int(Math.random() * this.Bitmaps.length)]);
    }

    public function addFromBitmapData(bitmap:BitmapData, totWidth:int, totHeight:int):void
    {
        var xCount:int;
        var widthIndex:int = (bitmap.width / totWidth);
        var heightIndex:int = (bitmap.height / totHeight);
        var yCount:int = 0;
        while (yCount < heightIndex)
        {
            xCount = 0;
            while (xCount < widthIndex)
            {
                this.Bitmaps.push(BitmapUtil.getRectanglefromBitmap(bitmap, (xCount * totWidth), (yCount * totHeight), totWidth, totHeight));
                xCount++;
            }
            yCount++;
        }
    }

}
}//package com.company.util

