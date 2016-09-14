// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._061

package com.company.PhoenixRealmClient.ui {
import Panels.InventoryPanel;

import _vf.SFXHandler;

import com.company.PhoenixRealmClient.map._X_l;
import com.company.PhoenixRealmClient.objects.Container;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

public class _061 extends Sprite {

    private static const _1U_:Matrix = function ():Matrix {
        var _local1:* = new Matrix();
        _local1.translate(10, 5);
        return (_local1);
    }();

    private static var _0B_w:int = -1000;

    public function _061(_arg1:int, _arg2:_E_6, _arg3:Object) {
        var _local6:SimpleText;
        super();
        this._0M_X_ = _arg1;
        this.data_ = _arg3;
        var _local3:XML = ObjectLibrary.typeToXml[_arg1];
        var _local4:Number = 5;
        if (_local3.hasOwnProperty("ScaleValue")) {
            _local4 = _local3.ScaleValue;
        }
        var _local5:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._0M_X_, 80, true, true, _local4);
        if(this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "") {
            _local5 = ObjectLibrary.getRedrawnTextureFromTypeCustom(this._0M_X_, 80, true, this.data_, true, _local4);
        }
        var _local7:Object;
        if(_local3.hasOwnProperty("Doses")) {
            _local7 = _local3.Doses;
        }
        if(this.data_ != null && this.data_.hasOwnProperty("Doses") && Number(this.data_.Doses) > 0) {
            _local7 = this.data_.Doses;
        }
        if (_local7 != null) {
            _local5 = _local5.clone();
            _local6 = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            _local6.text = String(_local7);
            _local6.updateMetrics();
            _local5.draw(_local6, _1U_);
        }
        this.bitmap_ = new Bitmap(_local5);
        this.bitmap_.x = (-(this.bitmap_.width) / 2);
        this.bitmap_.y = (-(this.bitmap_.height) / 2);
        addChild(this.bitmap_);
        this._03f = _arg2;
        addEventListener(MouseEvent.MOUSE_UP, this._0_5);
    }
    public var data_:Object;
    public var bitmap_:Bitmap;
    public var _0N_1:int;
    public var _0M_X_:int;
    public var _03f:_E_6;
    public var _e:Boolean;

    private function _08D_(_arg1:_E_6):void {
        if ((((_arg1 == null)) || (!(_arg1._t8(this._0M_X_))))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        if (_arg1 == this._03f) {
            this._0K_9();
            return;
        }
        var _local2:int = _arg1.objectType_;
        if (((!((_local2 == -1))) && (!(this._03f._t8(_local2))))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        if (_local2 == this._0M_X_) {
            this._0K_9();
            return;
        }
        if(_arg1._e9.oneWay_ == 1) {
            this._0K_9();
            return;
        }
        if ((this._03f._e9.gs_.lastUpdate_ - _0B_w) < 500) {
            this._0K_9();
            return;
        }
        var _local3:Player = this._03f._e9.gs_.map_.player_;
        if (_local3 == null) {
            this._0K_9();
            return;
        }
        if ((((((_arg1._e9._iA_ is Player)) && ((_arg1.id_ < 4)))) && (!(ObjectLibrary._S_d(this._0M_X_, (_arg1._e9._iA_ as Player)))))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        if (_arg1._e9._iA_ is Player && (this._03f.id_ < 4) && (_local2 != -1) && !ObjectLibrary.checkLevelRequirement(_local2, (_arg1._e9._iA_ as Player))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        if (_arg1._e9._iA_ is Player && (_arg1.id_ < 4) && (this._0M_X_ != -1) && !ObjectLibrary.checkLevelRequirement(this._0M_X_, (_arg1._e9._iA_ as Player))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        _0B_w = this._03f._e9.gs_.lastUpdate_;
        //this._03f.playerInventory._gameSprite.gsc_.invSwap(_0B_w, _local3.x_, _local3.y_, this._03f.playerInventory._iA_.objectId_, this._03f.id_, this._0M_X_, _arg1.playerInventory._iA_.objectId_, _arg1.id_, _local2);
        this._03f._e9.gs_.gsc_.invSwap(_local3, this._03f._e9._iA_, this._03f.id_, this._03f.objectType_, _arg1._e9._iA_, _arg1.id_, _arg1.objectType_);
        //SFXHandler.play("inventory_move_item");
    }

    private function _Y_4():void {
        var _local6:InventoryPanel;
        var _local7:_E_6;
        var _local1:Player = this._03f._e9.gs_.map_.player_;
        var _local2:GameObject = this._03f._e9._iA_;
        var _local3:Container = (_local2 as Container);
        var _local4:Boolean = ObjectLibrary.checkSoulbound(this._0M_X_);
        if (((!((_local2 == _local1))) && ((((((_local3 == null)) || (!((_local3.ownerId_ == _local1.accountId_))))) || (_local4))))) {
            this._0K_9();
            SFXHandler.play("error");
            return;
        }
        var _local5:Container = (this._03f._e9.gs_.HudView._U_T_._dN_ as Container);
        if (((!((_local5 == null))) && (((((_local5._X_w()) && (_local4))) || ((((_local5.ownerId_ == -1)) && (!(_local4)))))))) {
            _local6 = (this._03f._e9.gs_.HudView._U_T_._G_2 as InventoryPanel);
            if (((!((_local6 == null))) && (!((_local6._e9 == null))))) {
                for each (_local7 in _local6._e9.slots_) {
                    if (_local7.objectType_ == -1) {
                        this._08D_(_local7);
                        return;
                    }
                }
            }
        }
        this._03f._e9.gs_.gsc_._8q(this._03f._e9._iA_.objectId_, this._03f.id_, this._0M_X_);
    }

    private function _0K_9():void {
        this._03f.addChild(this);
        this._03f._0E_J_();
    }

    public function _0_5(_arg1:Event):void {
        if (!this._e) {
            return;
        }
        stopDrag();
        this._e = false;
        var _local2:DisplayObject = dropTarget;
        while (_local2 != null) {
            if ((_local2 is _E_6)) {
                this._08D_((_local2 as _E_6));
                return;
            }
            if ((((_local2 is _X_l)) || ((_local2 is Chat)))) {
                this._Y_4();
                return;
            }
            _local2 = _local2.parent;
        }
        this._0K_9();
        SFXHandler.play("error");
    }

}
}//package com.company.PhoenixRealmClient.ui

