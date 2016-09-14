// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util._x2

package com.company.PhoenixRealmClient.util {

import com.company.util.AssetFile;

import flash.display.BitmapData;

public class MaskBitmapFile {

    public function MaskBitmapFile() {
        this.MaskBitmapsDict = new Vector.<MaskedBitmap>();
        super();
    }
    public var MaskBitmapsDict:Vector.<MaskedBitmap>;

    public function addFromBitmapData(_arg1:BitmapData, _arg2:BitmapData, _arg3:int, _arg4:int):void
    {
        var mainFile:AssetFile = new AssetFile();
        mainFile.addFromBitmapData(_arg1, _arg3, _arg4);
        var maskFile:AssetFile;
        if (_arg2 != null) {
            maskFile = new AssetFile();
            maskFile.addFromBitmapData(_arg2, _arg3, _arg4);
        }
        var count:int = 0;
        while (count < mainFile.Bitmaps.length) {
            this.MaskBitmapsDict.push(new MaskedBitmap(mainFile.Bitmaps[count], (maskFile == null ? null : maskFile.Bitmaps[count])));
            count++;
        }
    }

    public function addFromMaskedBitmap(_arg1:MaskedBitmap, width:int, height:int):void
    {
        this.addFromBitmapData(_arg1.image_, _arg1.mask_, width, height);
    }

}
}//package com.company.PhoenixRealmClient.util

