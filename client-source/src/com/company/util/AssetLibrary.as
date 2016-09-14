// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.util.AssetLibrary

package com.company.util {
import flash.display.BitmapData;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

public class AssetLibrary {

    private static var assetIDtoFile:Dictionary = new Dictionary();
    private static var AssetFiles:Dictionary = new Dictionary();
    private static var _6x:Dictionary = new Dictionary();
    private static var _4d:Dictionary = new Dictionary();

    public static function _9_(_arg1:String, _arg2:BitmapData):void
    {
        assetIDtoFile[_arg1] = _arg2;
        _4d[_arg2] = _arg1;
    }

    public static function _05q(AssetFileID:String, bitmapData:BitmapData, indexWidth:int, indexHeight:int):void
    {
        assetIDtoFile[AssetFileID] = bitmapData;
        var file:AssetFile = new AssetFile();
        file.addFromBitmapData(bitmapData, indexWidth, indexHeight);
        AssetFiles[AssetFileID] = file;
        var count:int = 0;
        while (count < file.Bitmaps.length)
        {
            _4d[file.Bitmaps[count]] = [AssetFileID, count];
            count++;
        }
    }

    public static function _0F_R_(_arg1:String, _arg2:BitmapData):void
    {
        var _local3:AssetFile = AssetFiles[_arg1];
        if (_local3 == null) {
            _local3 = new AssetFile();
            AssetFiles[_arg1] = _local3;
        }
        _local3.add(_arg2);
        var _local4:int = (_local3.Bitmaps.length - 1);
        _4d[_local3.Bitmaps[_local4]] = [_arg1, _local4];
    }

    public static function _tl(_arg1:String, _arg2:Class):void
    {
        var _local3:Array = _6x[_arg1];
        if (_local3 == null) {
            _6x[_arg1] = [];
        }
        _6x[_arg1].push(_arg2);
    }

    public static function _eT_(_arg1:BitmapData):Object
    {
        return (_4d[_arg1]);
    }

    public static function getImage(_arg1:String):BitmapData
    {
        return (assetIDtoFile[_arg1]);
    }

    public static function getAssetFile(_arg1:String):AssetFile
    {
        return (AssetFiles[_arg1]);
    }

    public static function getBitmapFromFileIndex(_arg1:String, _arg2:int):BitmapData
    {
        var file:AssetFile = AssetFiles[_arg1];
        return (file.Bitmaps[_arg2]);
    }

    public static function _I_w(_arg1:String):Sound
    {
        var _local2:Array = _6x[_arg1];
        var _local3:int = (Math.random() * _local2.length);
        return (new (_6x[_arg1][_local3])());
    }

    public static function _05M_(_arg1:String, _arg2:Number = 1):void
    {
        var _local3:Array = _6x[_arg1];
        var _local4:int = (Math.random() * _local3.length);
        var _local5:Sound = new (_6x[_arg1][_local4])();
        var _local6:SoundTransform;
        if (_arg2 != 1) {
            _local6 = new SoundTransform(_arg2);
        }
        _local5.play(0, 0, _local6);
    }

    public function AssetLibrary(_arg1:StaticEnforcer)
    {
    }

}
}//package com.company.util

class StaticEnforcer {

}

