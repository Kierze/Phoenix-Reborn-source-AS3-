// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util.TextureRedrawer

package com.company.PhoenixRealmClient.util {
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shader;
import flash.display.Shape;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.filters.ShaderFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class TextureRedrawer {

    private static const BORDER:int = 4;
    private static const GRADIENT_MAX_SUB:uint = 0x282828;
    private static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0, 0.8, 1.4, 1.4, 0xFF, BitmapFilterQuality.LOW, false, false);
    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 12, 12, 2, BitmapFilterQuality.LOW, false, false);
    public static var _rn:BitmapData = null;

    private static var cache_:Dictionary = new Dictionary();
    private static var _1d:Dictionary = new Dictionary();
    private static var _17C:Dictionary = new Dictionary();

    private static var gradient_:Shape = getGradient();
    private static var tempMatrix_:Matrix = new Matrix();
    private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed_;
    private static var textureShaderData_:ByteArray = (new textureShaderEmbed_() as ByteArray);
    private static var colorTexture1:BitmapData = new BitmapData(1, 1, false);
    private static var colorTexture2:BitmapData = new BitmapData(1, 1, false);

    public static function redraw(_arg1:BitmapData, _arg2:int, _arg3:Boolean, _arg4:uint, _arg5:Boolean = true, _arg6:Number = 5):BitmapData {
        var _local7:String = getHash(_arg2, _arg3, _arg4, _arg6);
        if (((_arg5) && (_1Ro(_arg1, _local7)))) {
            return (_17C[_arg1][_local7]);
        }
        var _local8:BitmapData = resize(_arg1, null, _arg2, _arg3, 0, 0, _arg6);
        _local8 = outlineGlow(_local8, _arg4, 1.4);
        if (_arg5) {
            _0n(_arg1, _local7, _local8);
        }
        return (_local8);
    }

    private static function getHash(_arg1:int, _arg2:Boolean, _arg3:uint, _arg4:Number):String {
        return (((((((_arg1.toString() + ",") + _arg3.toString()) + ",") + _arg2) + ",") + _arg4));
    }
    private static function _1Ro(_arg1:BitmapData, _arg2:String):Boolean {
        if ((_arg1 in _17C)) {
            if ((_arg2 in _17C[_arg1])) {
                return (true);
            }
        }
        return (false);
    }

    private static function _0n(_arg1:BitmapData, _arg2:String, _arg3:BitmapData):void {
        if (!(_arg1 in _17C)) {
            _17C[_arg1] = {};
        }
        _17C[_arg1][_arg2] = _arg3;
    }

    public static function resize(_arg1:BitmapData, _arg2:BitmapData, _arg3:int, _arg4:Boolean, _arg5:int, _arg6:int, _arg7:Number = 5):BitmapData {
        if (((!((_arg2 == null))) && (((!((_arg5 == 0))) || (!((_arg6 == 0))))))) {
            _arg1 = retexture(_arg1, _arg2, _arg5, _arg6);
            _arg3 = (_arg3 / 5);
        }
        var _local8:int = ((_arg7 * (_arg3 / 100)) * _arg1.width);
        var _local9:int = ((_arg7 * (_arg3 / 100)) * _arg1.height);
        var _local10:Matrix = new Matrix();
        _local10.scale((_local8 / _arg1.width), (_local9 / _arg1.height));
        _local10.translate(12, 12);
        var _local11:BitmapData = new BitmapData(((_local8 + 12) + 12), ((_local9 + ((_arg4) ? 12 : 1)) + 12), true, 0);
        _local11.draw(_arg1, _local10);
        return (_local11);
    }

    public static function outlineGlow(_arg1:BitmapData, _arg2:uint, _arg3:Number=1.4):BitmapData {
        var _local6:BitmapData = _arg1.clone();
        tempMatrix_.identity();
        tempMatrix_.scale((_arg1.width / 0x0100), (_arg1.height / 0x0100));
        _local6.draw(gradient_, tempMatrix_, null, BlendMode.SUBTRACT);
        var _local7:Bitmap = new Bitmap(_arg1);
        _local6.draw(_local7, null, null, BlendMode.ALPHA);
        TextureRedrawer.OUTLINE_FILTER.blurX = _arg3;
        TextureRedrawer.OUTLINE_FILTER.blurY = _arg3;
        var _local8:uint;
        TextureRedrawer.OUTLINE_FILTER.color = _local8;
        _local6.applyFilter(_local6, _local6.rect, PointUtil._P_5, TextureRedrawer.OUTLINE_FILTER);
        if (_arg2 != 0xFFFFFFFF){
            GLOW_FILTER.color = _arg2;
            _local6.applyFilter(_local6, _local6.rect, PointUtil._P_5, GLOW_FILTER);
        }
        return (_local6);
    }
    
    public static function redrawSolidSquare(_arg1:uint, _arg2:int):BitmapData {
        var _local3:Dictionary = cache_[_arg2];
        if (_local3 == null) {
            _local3 = new Dictionary();
            cache_[_arg2] = _local3;
        }
        var _local4:BitmapData = _local3[_arg1];
        if (_local4 != null) {
            return (_local4);
        }
        _local4 = new BitmapData(((_arg2 + 4) + 4), ((_arg2 + 4) + 4), true, 0);
        _local4.fillRect(new Rectangle(4, 4, _arg2, _arg2), (0xFF000000 | _arg1));
        _local4.applyFilter(_local4, _local4.rect, PointUtil._P_5, OUTLINE_FILTER);
        _local3[_arg1] = _local4;
        return (_local4);
    }

    public static function clearCache():void {
        var _local1:BitmapData;
        var _local2:Dictionary;
        var _local3:Dictionary;
        for each (_local2 in cache_) {
            for each (_local1 in _local2) {
                _local1.dispose();
            }
        }
        cache_ = new Dictionary();
        for each (_local3 in _1d) {
            for each (_local1 in _local3) {
                _local1.dispose();
            }
        }
        _1d = new Dictionary();
    }

    public static function _uB_(_arg1:BitmapData, _arg2:Number):BitmapData {
        if (_arg2 == 1) {
            return (_arg1);
        }
        var _local3:Dictionary = _1d[_arg2];
        if (_local3 == null) {
            _local3 = new Dictionary();
            _1d[_arg2] = _local3;
        }
        var _local4:BitmapData = _local3[_arg1];
        if (_local4 != null) {
            return (_local4);
        }
        _local4 = _arg1.clone();
        _local4.colorTransform(_local4.rect, new ColorTransform(_arg2, _arg2, _arg2));
        _local3[_arg1] = _local4;
        return (_local4);
    }

    private static function getTexture(_arg1:int, _arg2:BitmapData):BitmapData {
        var _local3:BitmapData;
        var _local4:* = ((_arg1 >> 24) & 0xFF);
        var _local5:* = (_arg1 & 0xFFFFFF);
        switch (_local4) {
            case 0:
                _local3 = _arg2;
                break;
            case 1:
                _arg2.setPixel(0, 0, _local5);
                _local3 = _arg2;
                break;
            case 4:
                _local3 = (AssetLibrary.getBitmapFromFileIndex("textile4x4", _local5));
                break;
            case 5:
                _local3 = (AssetLibrary.getBitmapFromFileIndex("textile5x5", _local5));
                break;
            case 9:
                _local3 = (AssetLibrary.getBitmapFromFileIndex("textile9x9", _local5));
                break;
            case 10:
                _local3 = (AssetLibrary.getBitmapFromFileIndex("textile10x10", _local5));
                break;
            case 0xFF:
                _local3 = (_rn);
                break;
            default:
                _local3 = _arg2;
        }
        return (_local3);
    }

    private static function retexture(_arg1:BitmapData, _arg2:BitmapData, _arg3:int, _arg4:int):BitmapData {
        var _local5:Matrix = new Matrix();
        _local5.scale(5, 5);
        var _local6:BitmapData = new BitmapData((_arg1.width * 5), (_arg1.height * 5), true, 0);
        _local6.draw(_arg1, _local5);
        var _local7:BitmapData = getTexture(_arg3, colorTexture1);
        var _local8:BitmapData = getTexture(_arg4, colorTexture2);
        var _local9:Shader = new Shader(textureShaderData_);
        _local9.data.src.input = _local6;
        _local9.data.mask.input = _arg2;
        _local9.data.texture1.input = _local7;
        _local9.data.texture2.input = _local8;
        _local9.data.texture1Size.value = [(((_arg3 == 0)) ? 0 : _local7.width)];
        _local9.data.texture2Size.value = [(((_arg4 == 0)) ? 0 : _local8.width)];
        _local6.applyFilter(_local6, _local6.rect, PointUtil._P_5, new ShaderFilter(_local9));
        return (_local6);
    }

    private static function getGradient():Shape {
        var _local1:Shape = new Shape();
        var _local2:Matrix = new Matrix();
        _local2.createGradientBox(0x0100, 0x0100, (Math.PI / 2), 0, 0);
        _local1.graphics.beginGradientFill(GradientType.LINEAR, [0, GRADIENT_MAX_SUB], [1, 1], [127, 0xFF], _local2);
        _local1.graphics.drawRect(0, 0, 0x0100, 0x0100);
        _local1.graphics.endFill();
        return (_local1);
    }

}
}//package com.company.PhoenixRealmClient.util

