// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._zg

package com.company.PhoenixRealmClient.ui {
import Packets.fromServer.TradeStartPacket;

import com.company.PhoenixRealmClient.game.GameSprite;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class _zg extends Sprite {

    public static const WIDTH:int = 200;
    public static const HEIGHT:int = 400;

    public function _zg(gs:GameSprite, packet:TradeStartPacket)
    {
        this.gs_ = gs;
        var myPlayerName:String = this.gs_.map_.player_.name_;
        this._rl = new _eb(gs, myPlayerName, packet.myItems_, true);
        this._rl.x = 14;
        this._rl.y = 0;
        this._rl.addEventListener(Event.CHANGE, this._E_u);
        addChild(this._rl);
        this._8F_ = new _eb(gs, packet.yourName_, packet.yourItems_, false);
        this._8F_.x = 14;
        this._8F_.y = 174;
        addChild(this._8F_);
        this._t3 = new Button(16, "Cancel", 80);
        this._t3.addEventListener(MouseEvent.CLICK, this._0G_U_);
        this._t3.x = ((WIDTH / 4) - (this._t3.width / 2));
        this._t3.y = ((HEIGHT - this._t3.height) - 10);
        addChild(this._t3);
        this._0A_C_ = new _K_K_(16, 80);
        this._0A_C_.addEventListener(MouseEvent.CLICK, this._nk);
        this._0A_C_.x = (((3 * WIDTH) / 4) - (this._0A_C_.width / 2));
        this._0A_C_.y = ((HEIGHT - this._0A_C_.height) - 10);
        addChild(this._0A_C_);
        this._55();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var gs_:GameSprite;
    private var _rl:_eb;
    private var _8F_:_eb;
    private var _t3:Button;
    private var _0A_C_:_K_K_;

    public function _hf(_arg1:Vector.<Boolean>):void
    {
        this._8F_._0K_s(_arg1);
        this._55();
    }

    public function _C_D_(_arg1:Vector.<Boolean>, _arg2:Vector.<Boolean>):void
    {
        if (this._rl._02S_(_arg1) && this._8F_._02S_(_arg2))
        {
            this._8F_._07t(_eb._Q_p);
        }
    }

    public function _55():void
    {
        var _local1:int = this._rl._07c();
        var _local2:int = this._rl._91();
        var _local3:int = this._8F_._07c();
        var _local4:int = this._8F_._91();
        var _local5:Boolean = true;
        if (((_local3 - _local1) - _local2) > 0)
        {
            this._rl._07t(_eb._fo);
            _local5 = false;
        }
        else
        {
            this._rl._07t(_eb._0G_E_);
        }
        if (((_local1 - _local3) - _local4) > 0)
        {
            this._8F_._07t(_eb._fo);
            _local5 = false;
        }
        else
        {
            this._8F_._07t(_eb._iR_);
        }
        if (_local5)
        {
            this._0A_C_.reset();
        }
        else
        {
            this._0A_C_._pW_();
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        stage.addEventListener(Event.ACTIVATE, this._G_d);
    }

    private function onRemovedFromStage(_arg1:Event):void {
        stage.removeEventListener(Event.ACTIVATE, this._G_d);
    }

    private function _G_d(_arg1:Event):void {
        this._0A_C_.reset();
    }

    private function _E_u(_arg1:Event):void {
        this.gs_.gsc_._rQ_(this._rl._ao());
        this._55();
    }

    private function _0G_U_(_arg1:MouseEvent):void {
        this.gs_.gsc_.__set();
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function _nk(_arg1:MouseEvent):void {
        this.gs_.gsc_._E_i(this._rl._ao(), this._8F_._ao());
        this._rl._07t(_eb._Q_p);
    }

}
}//package com.company.PhoenixRealmClient.ui

