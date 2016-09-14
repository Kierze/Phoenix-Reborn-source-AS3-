// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util._0B_c

package com.company.PhoenixRealmClient.util {
import flash.display.BitmapData;
import flash.utils.Dictionary;

public class AnimatedTextures {

    private static var _0H_k:Dictionary = new Dictionary();

    public static function _J_v(_arg1:String, _arg2:int):_lJ_
    {
        var _local3:Vector.<_lJ_> = _0H_k[_arg1];
        if ((((_local3 == null)) || ((_arg2 >= _local3.length))))
        {
            return (null);
        }
        return (_local3[_arg2]);
    }

    public static function add(fileName:String, bitmap:BitmapData, bitmapMask:BitmapData, singleWidth:int, singleHeight:int, fullWidth:int, fullHeight:int, _arg8:int):void
    {
        var _local11:MaskedBitmap;
        var _local9:Vector.<_lJ_> = new Vector.<_lJ_>();
        var _local10:MaskBitmapFile = new MaskBitmapFile();
        _local10.addFromBitmapData(bitmap, bitmapMask, fullWidth, fullHeight);
        for each (_local11 in _local10.MaskBitmapsDict)
        {
            _local9.push(new _lJ_(_local11, singleWidth, singleHeight, _arg8));
        }
        _0H_k[fileName] = _local9;
    }

}
}//package com.company.PhoenixRealmClient.util

