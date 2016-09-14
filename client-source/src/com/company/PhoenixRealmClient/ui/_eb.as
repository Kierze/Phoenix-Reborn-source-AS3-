// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._eb

package com.company.PhoenixRealmClient.ui {
import Tooltips.EquipmentToolTip;
import Tooltips.TooltipBase;

import _ke._U_c;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.net.messages.data.InTradeItem;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class _eb extends Sprite {

    private static const _pm:Array = [0, 0, 0, 0];
    private static const _xV_:Array = [
        [1, 0, 0, 1],
        _pm,
        _pm,
        [0, 1, 1, 0],
        [1, 0, 0, 0],
        _pm,
        _pm,
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        _pm,
        _pm,
        [0, 0, 1, 0]
    ];
    public static const _0G_E_:int = 0;
    public static const _fo:int = 1;
    public static const _Q_p:int = 2;
    public static const _iR_:int = 3;

    private static var _fO_:TooltipBase = null;

    public function _eb(_arg1:GameSprite, _arg2:String, _arg3:Vector.<InTradeItem>, _arg4:Boolean) {
        var item:InTradeItem;
        var _local7:_2j;
        this.slots_ = new Vector.<_2j>();
        super();
        this.gs_ = _arg1;
        this.thisPlayerName = _arg2;
        this.nameText_ = new SimpleText(20, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        this.nameText_.text = this.thisPlayerName;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.taglineText_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.taglineText_.x = 0;
        this.taglineText_.y = 22;
        this.taglineText_.text = "";
        this.taglineText_.updateMetrics();
        this.taglineText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.taglineText_);
        var count:int = 0;
        while (count < _arg3.length)
        {
            item = _arg3[count];
            _local7 = new _2j(item.item_, item.tradeable_, item.included_, item.slotType_, (count - 3), _xV_[count], count, JSON.parse(item.data_));
            _local7.x = (int((count % 4)) * (Slot.WIDTH + 4));
            _local7.y = ((int((count / 4)) * (Slot.HEIGHT + 4)) + 46);
            if (item.item_ != -1) {
                _local7.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                _local7.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            }
            if (((_arg4) && (item.tradeable_))) {
                _local7.addEventListener(MouseEvent.MOUSE_DOWN, this.__do);
            }
            this.slots_.push(_local7);
            addChild(_local7);
            count++;
        }
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var gs_:GameSprite;
    public var thisPlayerName:String;
    public var slots_:Vector.<_2j>;
    private var _0_G_:int;
    private var nameText_:SimpleText;
    private var taglineText_:SimpleText;

    public function _ao():Vector.<Boolean> {
        var _local1:Vector.<Boolean> = new Vector.<Boolean>();
        var _local2:int;
        while (_local2 < this.slots_.length) {
            _local1.push(this.slots_[_local2].included_);
            _local2++;
        }
        return (_local1);
    }

    public function _0K_s(_arg1:Vector.<Boolean>):void {
        var _local2:int;
        while (_local2 < this.slots_.length) {
            this.slots_[_local2].setIncluded(_arg1[_local2]);
            _local2++;
        }
    }

    public function _02S_(_arg1:Vector.<Boolean>):Boolean {
        var _local2:int;
        while (_local2 < this.slots_.length) {
            if (_arg1[_local2] != this.slots_[_local2].included_) {
                return (false);
            }
            _local2++;
        }
        return (true);
    }

    public function _07c():int {
        var _local1:int;
        var _local2:int;
        while (_local2 < this.slots_.length) {
            if (this.slots_[_local2].included_) {
                _local1++;
            }
            _local2++;
        }
        return (_local1);
    }

    public function _91():int {
        var _local1:int;
        var _local2:int = 4;
        while (_local2 < this.slots_.length) {
            if (this.slots_[_local2].item_ == -1) {
                _local1++;
            }
            _local2++;
        }
        return (_local1);
    }

    public function _07t(_arg1:int):void {
        switch (_arg1) {
            case _0G_E_:
                this.nameText_.setColor(0xB3B3B3);
                this.taglineText_.setColor(0xB3B3B3);
                this.taglineText_.text = "Click items you want to trade";
                this.taglineText_.updateMetrics();
                return;
            case _fo:
                this.nameText_.setColor(0xFF0000);
                this.taglineText_.setColor(0xFF0000);
                this.taglineText_.text = "Not enough space for trade!";
                this.taglineText_.updateMetrics();
                return;
            case _Q_p:
                this.nameText_.setColor(9022300);
                this.taglineText_.setColor(9022300);
                this.taglineText_.text = "Trade accepted!";
                this.taglineText_.updateMetrics();
                return;
            case _iR_:
                this.nameText_.setColor(0xB3B3B3);
                this.taglineText_.setColor(0xB3B3B3);
                this.taglineText_.text = "Player is selecting items";
                this.taglineText_.updateMetrics();
                return;
        }
    }

    private function _V_B_(_arg1:TooltipBase):void {
        this._X_S_();
        _fO_ = _arg1;
        if (_fO_ != null) {
            stage.addChild(_fO_);
        }
    }

    private function _X_S_():void {
        if (_fO_ != null) {
            if (_fO_.parent != null) {
                _fO_.parent.removeChild(_fO_);
            }
            _fO_ = null;
        }
    }

    private function onRemovedFromStage(_arg1:Event):void {
        this._X_S_();
    }

    private function onMouseOver(_arg1:Event):void {
        var _local2:_2j = (_arg1.currentTarget as _2j);
        this._V_B_(new EquipmentToolTip(_local2.item_, this.gs_.map_.player_, -1, _U_c.OTHER_PLAYER, _local2.id, false, _local2.data_));
    }

    private function onRollOut(_arg1:Event):void {
        this._X_S_();
    }

    private function __do(_arg1:MouseEvent):void {
        var _local2:_2j = (_arg1.currentTarget as _2j);
        _local2.setIncluded(!(_local2.included_));
        dispatchEvent(new Event(Event.CHANGE));
    }

}
}//package com.company.PhoenixRealmClient.ui

