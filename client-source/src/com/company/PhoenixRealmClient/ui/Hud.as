// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui.Hud

package com.company.PhoenixRealmClient.ui {
import Packets.fromServer.ItemSelectStartPacket;
import Packets.fromServer.TradeAcceptedPacket;
import Packets.fromServer.TradeChangedPacket;
import Packets.fromServer.TradeStartPacket;

import Panels.PanelManager;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.map.SidebarShadow;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.util._O_m;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

public class Hud extends Sprite {

    private static const _08A_:int = 4;
    private static const _0D_Q_:int = 8;

    public function Hud(_arg1:GameSprite, _arg2:int, _arg3:int) {
        this._3S_ = new TooltipDivider(184, Parameters._primaryColourDark);
        super();
        this.gs_ = _arg1;
        this.w_ = _arg2;
        this.h_ = _arg3;
        this._L_C_ = false;
        mouseEnabled = true;
        mouseChildren = true;
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var Minimap_:Minimap = null;
    public var _02y:InGameSideBarUI;
    public var _U_T_:PanelManager;
    public var _6K_:_zg = null;
    public var _C_K_:Sprite;
    public var itemSelect_:ItemSelect = null;
    public var abilityBox_:AbilityBox;
    private var gs_:GameSprite;
    private var w_:int;
    private var h_:int;
    private var _L_C_:Boolean;
    private var background_:Shape;
    private var _3S_:TooltipDivider;

    public function initialize():void {
        this._4T_();
        this._C_K_ = new SidebarShadow();
        this._C_K_.mouseEnabled = false;
        addChild(this._C_K_);
        this.abilityBox_ = new AbilityBox(this.gs_);
        this.abilityBox_.x = 115;
        this.abilityBox_.y = 355 - 45;
//        addChild(this.abilityBox_);
    }

    public function dispose():void {
        if (this.Minimap_ != null) {
            if (contains(this.Minimap_)) {
                removeChild(this.Minimap_);
            }
            this.Minimap_.dispose();
            this.Minimap_ = null;
        }
        if (this._02y != null) {
            if (contains(this._02y)) {
                removeChild(this._02y);
            }
            this._02y = null;
        }
        if(this._C_K_ != null) {
            if (contains(this._C_K_)) {
                removeChild(this._C_K_);
            }
            this._C_K_ = null;
        }
        if(this.abilityBox_ != null) {
            if (contains(this.abilityBox_)) {
                removeChild(this.abilityBox_);
            }
            this.abilityBox_ = null;
        }
    }

    public function _0L_v(_arg1:TradeStartPacket):void {
        if (this._6K_ != null) {
            return;
        }
        abilityBox_.visible = false;
        this._6K_ = new _zg(this.gs_, _arg1);
        this._6K_.y = 200;
        this._6K_.addEventListener(Event.CANCEL, this._05I_);
    }

    public function selectItem(_arg1:ItemSelectStartPacket):void {
        if(this._02y == null) {
            return;
        }
        this._02y.selectItems(_arg1);
    }

    public function _ss(_arg1:TradeChangedPacket):void {
        if (this._6K_ == null) {
            return;
        }
        this._6K_._hf(_arg1.offer_);
    }

    public function _A_a():void {
        this._0L_A_();
    }

    public function _mH_(_arg1:TradeAcceptedPacket):void {
        if (this._6K_ == null) {
            return;
        }
        this._6K_._C_D_(_arg1.myOffer_, _arg1.yourOffer_);
    }

    public function draw():void {
        if (this.gs_.map_.player_ == null) {
            return;
        }
        if (!this._L_C_) {
            this._rC_();
            _O_m._041(this, this.Minimap_);
            this._0J_s();
            this._L_C_ = true;
        }
        this.Minimap_.draw();
        if (this._6K_ != null) {
            this._3S_.visible = false;
            _O_m._03d(this, this._02y);
            _O_m._03d(this, this._U_T_);
            _O_m._041(this, this._6K_);
        } else {
            this._3S_.visible = false;
            _O_m._041(this, this._02y);
            _O_m._041(this, this._U_T_);
            this._02y.draw();
            this._U_T_.draw();
        }
        if (!Parameters._0F_o) {
            this._C_K_.visible = true;
            this._C_K_.x = -10;
            this._C_K_.y = 0;
        } else {
            this._C_K_.visible = false;
        }
        this.setChildIndex(this._C_K_, this.numChildren - 1);
    }

    private function _0L_A_():void {
        if (this._6K_ != null) {
            this._6K_.removeEventListener(Event.CANCEL, this._05I_);
            _O_m._03d(this, this._6K_);
            this._6K_ = null;
            abilityBox_.visible = true;
        } else if (this._02y != null && this._02y.itemSelect_ != null) {
            this._02y.cancelSelect();
        }
    }

    private function _4T_():void {
        this.Minimap_ = new Minimap(this.gs_.map_, (200 - (2 * _08A_)), (200 - (2 * _08A_)));
        this.Minimap_.x = _08A_;
        this.Minimap_.y = _08A_;
    }

    private function _0J_s():void {
        var _local1:Player;
        _local1 = this.gs_.map_.player_;
        this._02y = new InGameSideBarUI(this.gs_, _local1, 200, 300);
        this._02y.y = 200;
        this._U_T_ = new PanelManager(this.gs_, _local1, 200, 135);
        this._U_T_.x = 0;
        this._U_T_.y = 620 + 30;
    }

    private function _rC_():void {
        this.background_ = new Shape();
        var _local1:Graphics = this.background_.graphics;
        _local1.clear();
        _local1.beginFill(Parameters._primaryColourDefault);
        _local1.drawRect(0, 0, this.w_, this.h_);
        _local1.endFill();
        addChild(this.background_);
        this._3S_.x = 8;
        this._3S_.y = 500 - 45;
        //addChild(this._3S_); //Disable if adding HP/MP pot buttons
        addChild(this.abilityBox_);
    }

    private function _05I_(_arg1:Event):void {
        this._0L_A_();
        abilityBox_.visible = true;
    }

    private function onEnterFrame(_arg1:Event):void {
        this.draw();
    }

    private function onAddedToStage(_arg1:Event):void {
        stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(_arg1:Event):void {
        stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

}
}//package com.company.PhoenixRealmClient.ui

