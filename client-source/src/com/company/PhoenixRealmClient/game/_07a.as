// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.game._07a

package com.company.PhoenixRealmClient.game {
import OptionsStuff.Options;

import _4K_.Stats;

import _sP_.MarketplaceContainerUI;

import com.company.PhoenixRealmClient.map.Square;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.tutorial.Tutorial;
import com.company.PhoenixRealmClient.tutorial.doneAction;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.util.keyboardKeys;

import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.utils.Timer;

public class _07a {

    private static const _0_X_:uint = 175;

    private static var _086:Stats = new Stats();
    private static var _nN_:Boolean = false;

    public function _07a(_arg1:GameSprite) {
        this.gs_ = _arg1;
        this._lD_ = new Timer(_0_X_, 1);
        this._lD_.addEventListener(TimerEvent.TIMER_COMPLETE, this._0C_J_);
        this.gs_.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.gs_.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var gs_:GameSprite;
    private var movingLeft:Boolean = false;
    private var movingRight:Boolean = false;
    private var movingUp:Boolean = false;
    private var movingDown:Boolean = false;
    private var rotatingLeft:Boolean = false;
    private var rotatingRight:Boolean = false;
    private var _08R_:Boolean = false;
    private var autofiring:Boolean = false;
    private var focusingMovement:Boolean = false;
    private var _G_v:Boolean = true;
    private var _lD_:Timer;
    private var _Z_W_:uint;
    private var _062:Point;

    public function clearInput():void {
        this.movingLeft = false;
        this.movingRight = false;
        this.movingUp = false;
        this.movingDown = false;
        this.rotatingLeft = false;
        this.rotatingRight = false;
        this.focusingMovement = false;
        this._08R_ = false;
        this.autofiring = false;
        this.directionalMove();
    }

    public function _vB_(_arg1:Boolean):void {
        if (this._G_v == _arg1) {
            return;
        }
        this._G_v = _arg1;
        this.clearInput();
    }

    private function directionalMove():void {
        var player:Player = this.gs_.map_.player_;
        if (player != null)
        {
            if (this._G_v)
            {
                player.MoveFromInput(((this.rotatingRight ? 1 : 0) - (this.rotatingLeft ? 1 : 0)), ((this.movingRight ? 1 : 0) - (this.movingLeft ? 1 : 0)), ((this.movingDown ? 1 : 0) - (this.movingUp ? 1 : 0)));
            }
            else
            {
                player.MoveFromInput(0, 0, 0);
            }
            player.focusingMove = focusingMovement;
        }
    }

    private function useItem(_arg1:int):void {

        if ((((this.gs_.HudView._02y == null)) || ((this.gs_.HudView._02y.playerInventory == null)))) {
            return;
        }
        this.gs_.HudView._02y.playerInventory.useItem(_arg1);

    }

    private function togglePerformanceStats():void {
        if (this.gs_.contains(_086)) {
            this.gs_.removeChild(_086);
            this.gs_.removeChild(this.gs_.gsc_._0l);
            this.gs_.gsc_._rT_();
        } else {
            this.gs_.addChild(_086);
            this.gs_.gsc_._9G_();
            this.gs_.gsc_._0l.y = _086.height;
            this.gs_.addChild(this.gs_.gsc_._0l);
        }
    }

    private function _0D_2():void {
        Parameters._0F_o = !(Parameters._0F_o);
        if (Parameters._0F_o) {
            this.gs_.HudView.visible = false;
            this.gs_.textBox_._01P_.visible = false;
        } else {
            this.gs_.HudView.visible = true;
            this.gs_.textBox_._01P_.visible = true;
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        var _local2:Stage = this.gs_.stage;
        _local2.addEventListener(Event.ACTIVATE, this._G_d);
        _local2.addEventListener(Event.DEACTIVATE, this._nb);
        _local2.addEventListener(KeyboardEvent.KEY_DOWN, this.useHotkey);
        _local2.addEventListener(KeyboardEvent.KEY_UP, this.ReleaseKey);
        _local2.addEventListener(MouseEvent.MOUSE_WHEEL, this._lb);
        this.gs_.map_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        this.gs_.map_.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        _local2.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        _local2.addEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
    }

    private function onRemovedFromStage(_arg1:Event):void {
        var _local2:Stage = this.gs_.stage;
        _local2.removeEventListener(Event.ACTIVATE, this._G_d);
        _local2.removeEventListener(Event.DEACTIVATE, this._nb);
        _local2.removeEventListener(KeyboardEvent.KEY_DOWN, this.useHotkey);
        _local2.removeEventListener(KeyboardEvent.KEY_UP, this.ReleaseKey);
        _local2.removeEventListener(MouseEvent.MOUSE_WHEEL, this._lb);
        this.gs_.map_.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        this.gs_.map_.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        _local2.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        _local2.removeEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
    }

    private function _G_d(_arg1:Event):void {
    }

    private function _nb(_arg1:Event):void {
        this.clearInput();
    }

    private function onMouseDown(_arg1:MouseEvent):void {
        var _local2:Player = this.gs_.map_.player_;
        if (_local2 == null) {
            return;
        }
        if (this._lD_.running == false) {
            this._Z_W_ = 1;
            this._lD_.start();
        } else {
            this._Z_W_++;
        }
        if (!this._G_v) {
            return;
        }
        doneAction(this.gs_, Tutorial._9Z_);
        var _local3:Number = Math.atan2(_arg1.localY, _arg1.localX);
        //var _local3:Number = Math.atan2(this._gameSprite.map_.mouseY, this._gameSprite.map_.mouseX);
        _local2._O_7(_local3); // Use this to handle (Unstable) Debuff
        this._08R_ = true;
    }

    private function _0C_J_(_arg1:TimerEvent):void {
        var _local2:Point;
        if (this._Z_W_ > 1) {
            _local2 = this.gs_.map_.pSTopW(this.gs_.map_.mouseX, this.gs_.map_.mouseY);
        }
    }

    private function onRightClick(_arg1:MouseEvent):void {
        //TODO: Maybe a custom in-game context menu?
    }

    private function onMouseUp(_arg1:MouseEvent):void {
        this._08R_ = false;
    }

    private function _lb(_arg1:MouseEvent):void {
        if (((((this.gs_) && (this.gs_.HudView))) && (this.gs_.HudView.Minimap_))) {
            if (_arg1.delta > 0) {
                this.gs_.HudView.Minimap_._K_r();
            } else {
                this.gs_.HudView.Minimap_._w_();
            }
        }
    }

    private function onEnterFrame(_arg1:Event):void {
        var _local2:Number;
        var _local3:Player;
        doneAction(this.gs_, Tutorial._xX_);
        if (((this._G_v) && (((this._08R_) || (this.autofiring))))) {
            _local2 = Math.atan2(this.gs_.map_.mouseY, this.gs_.map_.mouseX);
            _local3 = this.gs_.map_.player_;
            if (_local3 != null) {
                _local3._O_7(_local2);
            }
        }
    }

    private function useHotkey(_arg1:KeyboardEvent):void {
        var _local4:Square;
        var _local2:Stage = this.gs_.stage;
        switch (_arg1.keyCode)
        {
            case keyboardKeys.F1:
            case keyboardKeys.F2:
            case keyboardKeys.F3:
            case keyboardKeys.F4:
            case keyboardKeys.F5:
            case keyboardKeys.F6:
            case keyboardKeys.F7:
            case keyboardKeys.F8:
            case keyboardKeys.F9:
            case keyboardKeys.F10:
            case keyboardKeys.F11:
            case keyboardKeys.F12:
            case keyboardKeys.INSERT:
            case keyboardKeys.ALT:
                break;
            default:
                if (_local2.focus != null) {
                    return;
                }
        }
        var player:Player = this.gs_.map_.player_;
        switch (_arg1.keyCode)
        {
            case Parameters.ClientSaveData.moveUp:
                doneAction(this.gs_, Tutorial._04m);
                this.movingUp = true;
                break;
            case Parameters.ClientSaveData.moveDown:
                doneAction(this.gs_, Tutorial._03b);
                this.movingDown = true;
                break;
            case Parameters.ClientSaveData.moveLeft:
                doneAction(this.gs_, Tutorial._S_B_);
                this.movingLeft = true;
                break;
            case Parameters.ClientSaveData.moveRight:
                doneAction(this.gs_, Tutorial._0A_j);
                this.movingRight = true;
                break;
            case Parameters.ClientSaveData.rotateLeft:
                if (!Parameters.ClientSaveData.allowRotation) break;
                doneAction(this.gs_, Tutorial._0B_d);
                this.rotatingLeft = true;
                break;
            case Parameters.ClientSaveData.rotateRight:
                if (!Parameters.ClientSaveData.allowRotation) break;
                doneAction(this.gs_, Tutorial._95);
                this.rotatingRight = true;
                break;
            case Parameters.ClientSaveData.resetToDefaultCameraAngle:
                if (this.gs_.camera_.fixedRot_) break;
                Parameters.ClientSaveData.cameraAngle = Parameters.ClientSaveData.defaultCameraAngle;
                Parameters.save();
                break;
            case Parameters.ClientSaveData.useAbility1:
                player.useAbility(0, this.gs_.map_.mouseX, this.gs_.map_.mouseY);
                break;
            case Parameters.ClientSaveData.useAbility2:
                player.useAbility(1, this.gs_.map_.mouseX, this.gs_.map_.mouseY);
                break;
            case Parameters.ClientSaveData.useAbility3:
                player.useAbility(2, this.gs_.map_.mouseX, this.gs_.map_.mouseY);
                break;
            case Parameters.ClientSaveData.autofireToggle:
                this.autofiring = !(this.autofiring);
                break;
            case Parameters.ClientSaveData.useInvSlot1:
                this.useItem(0);
                break;
            case Parameters.ClientSaveData.useInvSlot2:
                this.useItem(1);
                break;
            case Parameters.ClientSaveData.useInvSlot3:
                this.useItem(2);
                break;
            case Parameters.ClientSaveData.useInvSlot4:
                this.useItem(3);
                break;
            case Parameters.ClientSaveData.useInvSlot5:
                this.useItem(4);
                break;
            case Parameters.ClientSaveData.useInvSlot6:
                this.useItem(5);
                break;
            case Parameters.ClientSaveData.useInvSlot7:
                this.useItem(6);
                break;
            case Parameters.ClientSaveData.useInvSlot8:
                this.useItem(7);
                break;
            case Parameters.ClientSaveData.miniMapZoomOut:
                if (this.gs_.HudView.Minimap_ == null) break;
                this.gs_.HudView.Minimap_._w_();
                break;
            case Parameters.ClientSaveData.miniMapZoomIn:
                if (this.gs_.HudView.Minimap_ == null) break;
                this.gs_.HudView.Minimap_._K_r();
                break;
            case Parameters.ClientSaveData.togglePerformanceStats:
                this.togglePerformanceStats();
                break;
            case Parameters.ClientSaveData.escapeToNexus:
            case Parameters.ClientSaveData.escapeToNexus2:
                this.gs_.gsc_._M_6();
                Parameters.ClientSaveData.needsRandomRealm = false;
                Parameters.save();
                break;
            case Parameters.ClientSaveData.options:
                this.clearInput();
                this.gs_.addChild(new Options(this.gs_));
                break;
            case Parameters.ClientSaveData.toggleCentering:
                Parameters.ClientSaveData.centerOnPlayer = !(Parameters.ClientSaveData.centerOnPlayer);
                Parameters.save();
                break;
            case Parameters.ClientSaveData.toggleFullscreen:
                if (Capabilities.playerType == "Desktop") {
                    Parameters.ClientSaveData.fullscreenMode = !(Parameters.ClientSaveData.fullscreenMode);
                    Parameters.save();
                    _local2.displayState = ((Parameters.ClientSaveData.fullscreenMode) ? "fullScreenInteractive" : StageDisplayState.NORMAL);
                }
                break;
            case Parameters.ClientSaveData.switchTabs:
                if (this.gs_.HudView._02y == null) break;
                this.gs_.HudView._02y.nextTab();
                break;
            case Parameters.ClientSaveData.marketHotkey:
                this.clearInput();
                this.gs_.addChild(new MarketplaceContainerUI(this.gs_));
                break;
            case Parameters.ClientSaveData.FocusMove:
                this.focusingMovement = true;
                break;

        }
        if (!Parameters.isTesting) {
            switch (_arg1.keyCode) {
                case keyboardKeys.F2:
                    this._0D_2();
                    break;
                case keyboardKeys.F3:
                    Parameters.HideHUD = !(Parameters.HideHUD);
                    break;
                case keyboardKeys.F4:
                    this.gs_.map_.mapOverlay_.visible = !(this.gs_.map_.mapOverlay_.visible);
                    this.gs_.map_.partyOverlay_.visible = !(this.gs_.map_.partyOverlay_.visible);
                    break;
                case keyboardKeys.F6:
                    TextureRedrawer.clearCache();
                    Parameters._Q_b = ((Parameters._Q_b + 1) % 7);
                    this.gs_.textBox_.addText(Parameters.SendError, ("Projectile Color Type: " + Parameters._Q_b));
                    break;
                case keyboardKeys.F7:
                    for each (_local4 in this.gs_.map_.squares_) {
                        if (_local4 != null) {
                            _local4.faces_.length = 0;
                        }
                    }
                    Parameters._R_P_ = ((Parameters._R_P_ + 1) % 2);
                    this.gs_.textBox_.addText(Parameters.SendClient, ("Blend type: " + Parameters._R_P_));
                    break;
                case keyboardKeys.F8:
                    Parameters.ClientSaveData.surveyDate = 0;
                    Parameters.ClientSaveData.needsSurvey = true;
                    Parameters.ClientSaveData.playTimeLeftTillSurvey = 5;
                    Parameters.ClientSaveData.surveyGroup = "testing";
                    break;
                case keyboardKeys.F9:
                    Parameters.DrawProjectiles = !(Parameters.DrawProjectiles);
                    break;
            }
        }
        this.directionalMove();
    }

    private function ReleaseKey(_arg1:KeyboardEvent):void {
        var _local3:Player = this.gs_.map_.player_;
        switch (_arg1.keyCode) {
            case Parameters.ClientSaveData.moveUp:
                this.movingUp = false;
                break;
            case Parameters.ClientSaveData.moveDown:
                this.movingDown = false;
                break;
            case Parameters.ClientSaveData.moveLeft:
                this.movingLeft = false;
                break;
            case Parameters.ClientSaveData.moveRight:
                this.movingRight = false;
                break;
            case Parameters.ClientSaveData.rotateLeft:
                this.rotatingLeft = false;
                break;
            case Parameters.ClientSaveData.rotateRight:
                this.rotatingRight = false;
                break;
            case Parameters.ClientSaveData.FocusMove:
                this.focusingMovement = false;
                break;
        }
        this.directionalMove();
    }

}
}//package com.company.PhoenixRealmClient.game

