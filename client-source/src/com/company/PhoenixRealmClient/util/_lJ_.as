// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util._lJ_

package com.company.PhoenixRealmClient.util {

import com.company.PhoenixRealmClient.map.View;
import com.company.util.Trig;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class _lJ_ {

    public static const RIGHT:int = 0;
    public static const LEFT:int = 1;
    public static const DOWN:int = 2;
    public static const UP:int = 3;
    public static const _02l:int = 4;
    public static const _sS_:int = 0;
    public static const _m1:int = 1;
    public static const _E_w:int = 2;
    public static const _0E_Z_:int = 3;
    private static const _n9:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[LEFT, UP, DOWN], new <int>[UP, LEFT, DOWN], new <int>[UP, RIGHT, DOWN], new <int>[RIGHT, UP, DOWN], new <int>[RIGHT, DOWN], new <int>[DOWN, RIGHT], new <int>[DOWN, LEFT], new <int>[LEFT, DOWN]];
    private static const angleDivider:Number = (Math.PI / 4);//0.785398163397448

    public function _lJ_(bitmap:MaskedBitmap, width:int, height:int, direction:int)
    {
        this._aI_ = new Dictionary();
        super();
        this.bitmap_ = bitmap;
        this.width_ = width;
        this.height_ = height;
        this.direction_ = direction;

        var _local5:Dictionary = new Dictionary();
        var _local6:MaskBitmapFile = new MaskBitmapFile();

        _local6.addFromMaskedBitmap(bitmap, width, height);
        if (direction == RIGHT)
        {
            this._aI_[RIGHT] = this._cJ_(0, false, false, _local6);
            this._aI_[LEFT] = this._cJ_(0, true, false, _local6);
            if (_local6.MaskBitmapsDict.length >= 14)
            {
                this._aI_[DOWN] = this._cJ_(7, false, true, _local6);
                if (_local6.MaskBitmapsDict.length >= 21)
                {
                    this._aI_[UP] = this._cJ_(14, false, true, _local6);
                }
            }
        }
        else
        {
            if (direction == DOWN)
            {
                this._aI_[DOWN] = this._cJ_(0, false, true, _local6);
                if (_local6.MaskBitmapsDict.length >= 14)
                {
                    this._aI_[RIGHT] = this._cJ_(7, false, false, _local6);
                    this._aI_[LEFT] = this._cJ_(7, true, false, _local6);
                    if (_local6.MaskBitmapsDict.length >= 21)
                    {
                        this._aI_[UP] = this._cJ_(14, false, true, _local6);
                    }
                }

            }
        }
    }
    public var bitmap_:MaskedBitmap;
    private var width_:int;
    private var height_:int;
    private var direction_:int;
    private var _aI_:Dictionary;

    public function _i3():BitmapData
    {
        var _local1:BitmapData = new BitmapData((this.width_ * 7), this.height_, true, 0);
        var _local2:Dictionary = this._aI_[this.direction_];
        var _local3:Vector.<MaskedBitmap> = _local2[_sS_];
        if (_local3.length > 0)
        {
            _local1.copyPixels(_local3[0].image_, _local3[0].image_.rect, new Point(0, 0));
        }
        _local3 = _local2[_m1];
        if (_local3.length > 0)
        {
            _local1.copyPixels(_local3[0].image_, _local3[0].image_.rect, new Point(this.width_, 0));
        }
        if (_local3.length > 1)
        {
            _local1.copyPixels(_local3[1].image_, _local3[1].image_.rect, new Point((this.width_ * 2), 0));
        }
        _local3 = _local2[_E_w];
        if (_local3.length > 0)
        {
            _local1.copyPixels(_local3[0].image_, _local3[0].image_.rect, new Point((this.width_ * 4), 0));
        }
        if (_local3.length > 1)
        {
            _local1.copyPixels(_local3[1].image_, new Rectangle(this.width_, 0, (this.width_ * 2), this.height_), new Point((this.width_ * 5), 0));
        }
        return (_local1);
    }

    public function _n3(_arg1:int, _arg2:int):Vector.<MaskedBitmap>
    {
        return (this._aI_[_arg1][_arg2]);
    }

    public function imageFromDir(_arg1:int, _arg2:int, _arg3:Number):MaskedBitmap
    {
        var _local4:Vector.<MaskedBitmap> = this._aI_[_arg1][_arg2];
        _arg3 = Math.max(0, Math.min(0.99999, _arg3));
        var _local5:int = (_arg3 * _local4.length);
        return (_local4[_local5]);
    }

    public function _l8(_arg1:Number, _arg2:int, _arg3:Number):MaskedBitmap
    {
        var _local4:int = (int(((_arg1 / angleDivider) + 4)) % 8);
        var _local5:Vector.<int> = _n9[_local4];
        var _local6:Dictionary = this._aI_[_local5[0]];
        if (_local6 == null) {
            _local6 = this._aI_[_local5[1]];
            if (_local6 == null) {
                _local6 = this._aI_[_local5[2]];
            }
        }
        var _local7:Vector.<MaskedBitmap> = _local6[_arg2];
        _arg3 = Math.max(0, Math.min(0.99999, _arg3));
        var _local8:int = (_arg3 * _local7.length);
        return (_local7[_local8]);
    }

    public function imageFromFacing(_arg1:Number, _arg2:View, _arg3:int, _arg4:Number):MaskedBitmap
    {
        var _local5:Number = Trig._V_r((_arg1 - _arg2.angleRad_));
        var _local6:int = (int(((_local5 / angleDivider) + 4)) % 8);
        var _local7:Vector.<int> = _n9[_local6];
        var _local8:Dictionary = this._aI_[_local7[0]];
        if (_local8 == null) {
            _local8 = this._aI_[_local7[1]];
            if (_local8 == null) {
                _local8 = this._aI_[_local7[2]];
            }
        }
        var _local9:Vector.<MaskedBitmap> = _local8[_arg3];
        _arg4 = Math.max(0, Math.min(0.99999, _arg4));
        var _local10:int = (_arg4 * _local9.length);
        return (_local9[_local10]);
    }

    private function _cJ_(_arg1:int, _arg2:Boolean, _arg3:Boolean, _arg4:MaskBitmapFile):Dictionary
    {
        var _local14:Vector.<MaskedBitmap>;
        var _local15:BitmapData;
        var _local16:BitmapData;
        var _local5:Dictionary = new Dictionary();
        var _local6:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 0)];
        var _local7:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 1)];
        var _local8:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 2)];
        if (_local8._F_9() == 1) {
            _local8 = null;
        }
        var _local9:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 4)];
        var _local10:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 5)];
        if (_local9._F_9() == 1) {
            _local9 = null;
        }
        if (_local10._F_9() == 1) {
            _local10 = null;
        }
        var _local11:MaskedBitmap = _arg4.MaskBitmapsDict[(_arg1 + 6)];
        if (((!((_local10 == null))) && (!((_local11._F_9() == 1))))) {
            _local15 = new BitmapData((this.width_ * 3), this.height_, true, 0);
            _local15.copyPixels(_local10.image_, new Rectangle(0, 0, this.width_, this.height_), new Point(this.width_, 0));
            _local15.copyPixels(_local11.image_, new Rectangle(0, 0, this.width_, this.height_), new Point((this.width_ * 2), 0));
            _local16 = null;
            if (((!((_local10.mask_ == null))) || (!((_local11.mask_ == null))))) {
                _local16 = new BitmapData((this.width_ * 3), this.height_, true, 0);
            }
            if (_local10.mask_ != null) {
                _local16.copyPixels(_local10.mask_, new Rectangle(0, 0, this.width_, this.height_), new Point(this.width_, 0));
            }
            if (_local11.mask_ != null) {
                _local16.copyPixels(_local11.mask_, new Rectangle(0, 0, this.width_, this.height_), new Point((this.width_ * 2), 0));
            }
            _local10 = new MaskedBitmap(_local15, _local16);
        }
        var _local12:Vector.<MaskedBitmap> = new Vector.<MaskedBitmap>();
        _local12.push(((_arg2) ? _local6.mirror() : _local6));
        _local5[_sS_] = _local12;
        var _local13:Vector.<MaskedBitmap> = new Vector.<MaskedBitmap>();
        _local13.push(((_arg2) ? _local7.mirror() : _local7));
        if (_local8 != null) {
            _local13.push(((_arg2) ? _local8.mirror() : _local8));
        } else {
            if (_arg3) {
                _local13.push(((_arg2) ? _local7 : _local7.mirror(7)));
            } else {
                _local13.push(((_arg2) ? _local6.mirror() : _local6));
            }
        }
        _local5[_m1] = _local13;
        if ((((_local9 == null)) && ((_local10 == null)))) {
            _local14 = _local13;
        } else {
            _local14 = new Vector.<MaskedBitmap>();
            if (_local9 != null) {
                _local14.push(((_arg2) ? _local9.mirror() : _local9));
            }
            if (_local10 != null) {
                _local14.push(((_arg2) ? _local10.mirror() : _local10));
            }
        }
        _local5[_E_w] = _local14;
        return (_local5);
    }

}
}//package com.company.PhoenixRealmClient.util

