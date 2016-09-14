/**
 * Created by club5_000 on 9/1/2015.
 */
package com.company.PhoenixRealmClient.ui {

import Frames.SpecChooser;

import Tooltips.AbilityToolTip;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Formula;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.AbilityLibrary;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Ability extends Sprite {

        private var abilitySlot_:int;
        private var abilityType_:int;
        private var abilityIcon_:Bitmap;

        private var toolTip_:AbilityToolTip;
        private var myAbility_:Boolean;
        private var gs_:GameSprite;

        // Overlays
        private var cooldownOverlay_:Sprite;
        private var toggledOverlay_:Sprite;
        private var activeDurationOverlay_:Sprite;
        private var manaOverlay:Sprite;

        // Texts
        private var manaText:SimpleText;
        private var cooldownText_:SimpleText;
        private var toggledText_:SimpleText;
        private var activeDurationText_:SimpleText;

        public function Ability(_arg1:GameSprite, _arg2:int, _arg3:int, _arg4:Boolean=true, _arg5:Boolean = true) {
            this.gs_ = _arg1;
            this.abilitySlot_ = _arg2;
            this.myAbility_ = _arg4;
            this.setAbilityType(_arg3);
            this.initCooldownOverlay();
            this.initToggledOverlay();
            this.initActiveDurationOverlay();
            this.initManaCheck();
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
            if (_arg5 == true){
                addEventListener(MouseEvent.CLICK, chooseSpec);
            }
        }

        private function removedFromStage(event:Event):void {
            this._9();
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }

        private function addedToStage(event:Event):void {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }

        private function initManaCheck() {
            this.manaOverlay = new Sprite();
            this.manaOverlay.graphics.beginFill(0x000000, 0.75);
            this.manaOverlay.graphics.drawRect(0, 0, 40, 40);
            this.manaOverlay.graphics.endFill();
            this.manaOverlay.visible = false;
            this.manaText = new SimpleText(26, 0xFFFFFF, false);
            this.manaText.setBold(true);
            this.manaText.text = "";
            this.manaText.updateMetrics();
            this.manaText.x = 20 - this.manaText.textWidth / 2;
            this.manaText.y = 20 - this.manaText.textHeight / 2;
            this.manaOverlay.addChild(this.manaText);
            addChild(this.manaOverlay);
        }

        private function initCooldownOverlay() {
            this.cooldownOverlay_ = new Sprite();
            this.cooldownOverlay_.graphics.beginFill(0x000000, 0.75);
            this.cooldownOverlay_.graphics.drawRect(0, 0, 40, 40);
            this.cooldownOverlay_.graphics.endFill();
            this.cooldownOverlay_.visible = false;
            this.cooldownText_ = new SimpleText(26, 0xFFFFFF, false);
            this.cooldownText_.setBold(true);
            this.cooldownText_.text = "99";
            this.cooldownText_.updateMetrics();
            this.cooldownText_.x = 20 - this.cooldownText_.textWidth / 2;
            this.cooldownText_.y = 20 - this.cooldownText_.textHeight / 2;
            this.cooldownOverlay_.addChild(this.cooldownText_);
            addChild(this.cooldownOverlay_);
        }

        private function initToggledOverlay() {
            this.toggledOverlay_ = new Sprite();
            this.toggledOverlay_.graphics.beginFill(0x66FF66, 0.70);
            this.toggledOverlay_.graphics.drawRect(0, 0, 40, 40);
            this.toggledOverlay_.graphics.endFill();
            this.toggledOverlay_.visible = false;
            this.toggledText_ = new SimpleText(26, 0xB3FFB3, false);
            this.toggledText_.setBold(true);
            this.toggledText_.text = "98";
            this.toggledText_.updateMetrics();
            this.toggledText_.x = 20 - this.toggledText_.textWidth / 2;
            this.toggledText_.y = 20 - this.toggledText_.textHeight / 2;
            this.toggledOverlay_.addChild(this.toggledText_);
            addChild(this.toggledOverlay_);
        }

        private function initActiveDurationOverlay() {
            this.activeDurationOverlay_ = new Sprite();
            this.activeDurationOverlay_.graphics.beginFill(0x5B4DFF, 0.70);
            this.activeDurationOverlay_.graphics.drawRect(0, 0, 40, 40);
            this.activeDurationOverlay_.graphics.endFill();
            this.activeDurationOverlay_.visible = false;
            this.activeDurationText_ = new SimpleText(26, 0xB9B3FF, false);
            this.activeDurationText_.setBold(true);
            this.activeDurationText_.text = "97";
            this.activeDurationText_.updateMetrics();
            this.activeDurationText_.x = 20 - this.activeDurationText_.textWidth / 2;
            this.activeDurationText_.y = 20 - this.activeDurationText_.textHeight / 2;
            this.activeDurationOverlay_.addChild(this.activeDurationText_);
            addChild(this.activeDurationOverlay_);
        }



        public function setAbilityType(_arg1:int) {
            this.abilityType_ = _arg1;
            this.redraw();
        }

        public function draw() {
            graphics.clear();
            graphics.beginFill(Parameters._primaryColourDark);
            graphics.drawRect(-1, -1, 42, 42);
            graphics.endFill();
            graphics.beginFill(Parameters._primaryColourLight);
            graphics.drawRect(0, 0, 40, 40);
            graphics.endFill();
        }

        public function redraw() {
            this.draw();
            if(this.abilityIcon_ != null) {
                if(contains(this.abilityIcon_)) {
                    removeChild(this.abilityIcon_);
                }
                this.abilityIcon_ = null;
            }
            if(abilityType_ != -1) {
                var _local1:BitmapData = AbilityLibrary.getIcon(abilityType_);
                this.abilityIcon_ = new Bitmap(_local1);
                addChild(this.abilityIcon_);
            }
        }

        private function chooseSpec(event:MouseEvent):void
        {
            if (this.gs_.map_.player_ != null && this.gs_.map_.player_.level_ >= 10 && (this.gs_.map_.player_.spec_ == null || this.gs_.map_.player_.spec_ == ""))
            {
                //Checks if Level > 10 and Spec has not been chosen yet
                var _local1:Frame2Holder = new Frame2Holder(new SpecChooser(this.gs_));
                stage.addChild(_local1);
            }
            else if(this.gs_.map_.player_.level_ < 10)
            {
                this.gs_.textBox_.addText("", "You have to be at least level 10 to specialize");
            }else
            {
                this.gs_.textBox_.addText("", "You cannot specialize again");
            }
        }

        private function onEnterFrame(event:Event):void
        {
            if(!this.myAbility_)
                return;
            if(this.gs_.map_.player_ != null)
            {
                var player:Player = this.gs_.map_.player_;
                if(player.abilities[abilitySlot_] != abilityType_)
                {
                    this.setAbilityType(player.abilities[abilitySlot_]);
                }

                if (player.abilityToggles[abilitySlot_] && !this.toggledOverlay_.visible)
                {
                    this.toggledOverlay_.visible = true;
                }
                if(this.toggledOverlay_.visible)
                {
                    this.toggledText_.text = " "; //temporary
                    this.toggledText_.x = 20 - this.toggledText_.textWidth / 2;
                    setChildIndex(this.toggledOverlay_, this.numChildren - 1);
                }
                if(!player.abilityToggles[abilitySlot_] && this.toggledOverlay_.visible)
                {
                    this.toggledOverlay_.visible = false;
                }

                //Active Duration Overlay
                if(player.abilityActiveDurations[abilitySlot_] > 0 && !this.activeDurationOverlay_.visible)
                {
                    this.activeDurationOverlay_.visible = true;
                }
                if(this.activeDurationOverlay_.visible)
                {
                    this.activeDurationText_.text = String(Math.ceil(player.abilityActiveDurations[abilitySlot_]/1000));
                    this.activeDurationText_.x = 20 - this.activeDurationText_.textWidth / 2;
                    setChildIndex(this.activeDurationOverlay_, this.numChildren - 1);
                }
                if(player.abilityActiveDurations[abilitySlot_] <= 0 && this.activeDurationOverlay_.visible)
                {
                    this.activeDurationOverlay_.visible = false;
                }

                //Cooldown Overlay
                if(player.abilityCooldowns[abilitySlot_] > 0 && !this.cooldownOverlay_.visible)
                {
                    this.cooldownOverlay_.visible = true;
                }
                if(player.abilityCooldowns[abilitySlot_] == 0 && this.cooldownOverlay_.visible)
                {
                    this.cooldownOverlay_.visible = false;
                }
                if(this.cooldownOverlay_.visible) {
                    this.cooldownText_.text = String(Math.ceil(player.abilityCooldowns[abilitySlot_]/1000));
                    this.cooldownText_.x = 20 - this.cooldownText_.textWidth / 2;
                    setChildIndex(this.cooldownOverlay_, this.numChildren - 1);
                }
                // Mana overlay
                if(GetMana(abilitySlot_) >= player.MP_ && !this.manaOverlay.visible)
                {
                    this.manaOverlay.visible = true;
                }
                if(GetMana(abilitySlot_) <= player.MP_ && this.manaOverlay.visible)
                {
                    this.manaOverlay.visible = false;
                }
                if(manaOverlay.visible)
                {
                    setChildIndex(this.manaOverlay, this.numChildren - 1);
                }
            }
        }

    private function GetMana(_arg1:int):int
    {
        var AP:Number = this.gs_.map_.player_.aptitude_;
        var _local1:int = this.gs_.map_.player_.abilities[_arg1];
        var _local2:XML;
        var form:Formula;
        var xml:XML;

        if(this.gs_.map_.player_.abilities[_arg1] != -1)
        {
            _local2 = AbilityLibrary.TypeToXML[_local1];
            if(_local2.hasOwnProperty("MpCost"))
            {
                return int(_local2.MpCost);
            }

            if (_local2.hasOwnProperty("Formula"))
            {
                for each (xml in _local2.Formula)
                {
                    if (xml == "MpCost")
                    {
                        form = new Formula(xml);
                        return int(Formula.Calculate(form, AP));
                    }
                }
            }
        }
        return 9999;
    }

        private function _9():void {
            if (toolTip_ != null) {
                if (toolTip_.parent != null) {
                    toolTip_.parent.removeChild(toolTip_);
                }
                toolTip_ = null;
            }
        }

        private function onMouseOver(e:MouseEvent):void {
            this._9();
            if(this.abilityType_ != -1 && this.gs_.map_.player_ != null) {
                var AP:Number = this.gs_.map_.player_.aptitude_;
                this.toolTip_ = new AbilityToolTip(this.abilityType_, AP);
                stage.addChild(this.toolTip_);
            }
        }

        private function onMouseOut(e:MouseEvent):void {
            this._9();
        }
    }
}
