// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._mo

package Frames {
import _5H_._5P_;
import _5H_._xY_;

import _mv._F_8;
import _mv._md;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class TextList extends Sprite {

    public function TextList(_arg1:Vector.<String>) {
        this.strings = _arg1;
        this._nm();
        this._hT_();
        this._Y_o();
    }
    private var strings:Vector.<String>;
    private var _jf:Vector.<_T_I_>;
    private var _rF_:_5P_;

    public function setSelected(_arg1:String):void {
        this._rF_.setSelected(_arg1);
    }

    public function _rq():String {
        return (this._rF_._rq().getValue());
    }

    private function _nm():void {
        var stringsLength:int = this.strings.length;
        this._jf = new Vector.<_T_I_>(stringsLength, true);
        var count:int = 0;
        while (count < stringsLength) {
            this._jf[count] = this._w0(this.strings[count]);
            count++;
        }
    }

    private function _w0(_arg1:String):_T_I_ {
        var _local2:_T_I_ = new _T_I_(_arg1);
        _local2.addEventListener(MouseEvent.CLICK, this._0A_U_);
        addChild(_local2);
        return (_local2);
    }

    private function _hT_():void {
        var _local1:Vector.<DisplayObject> = this._gg();
        var _local2:_F_8 = new _md(20);
        _local2.layout(_local1);
    }

    private function _gg():Vector.<DisplayObject> {
        var _local1:int = this._jf.length;
        var _local2:Vector.<DisplayObject> = new <DisplayObject>[];
        var count:int = 0;
        while (count < _local1) {
            _local2[count] = this._jf[count];
            count++;
        }
        return (_local2);
    }

    private function _Y_o():void {
        var _local1:Vector.<_xY_> = this._G_S_();
        this._rF_ = new _5P_(_local1);
        this._rF_.setSelected(this._jf[0].getValue());
    }

    private function _G_S_():Vector.<_xY_> {
        var _local1:int = this._jf.length;
        var _local2:Vector.<_xY_> = new <_xY_>[];
        var count:int = 0;
        while (count < _local1) {
            _local2[count] = this._jf[count];
            count++;
        }
        return (_local2);
    }

    private function _0A_U_(_arg1:Event):void {
        var _local2:_xY_ = (_arg1.currentTarget as _xY_);
        this._rF_.setSelected(_local2.getValue());
    }

}
}//package _0D_d

