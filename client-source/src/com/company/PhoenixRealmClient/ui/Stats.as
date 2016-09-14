// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui.Stats

package com.company.PhoenixRealmClient.ui {
import Tooltips.TextTagTooltip;

import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Stats extends Sprite {

    public static const AttPos:int = 0;
    public static const DefPos:int = 1;
    public static const SpdPos:int = 2;
    public static const DexPos:int = 3;
    public static const VitPos:int = 4;
    public static const WisPos:int = 5;
    public static const ApPos:int = 6;
    public static const ResPos:int = 7;

    public function Stats(_arg1:int, _arg2:int) {
        var _local3:XML;
        var _local4:Stat;
        this._stats = new Vector.<Stat>();
        this.toolTip_ = new TextTagTooltip(Parameters._primaryColourDefault, 0x9B9B9B, "", "", 200);
        super();
        this.w_ = _arg1;
        this.h_ = _arg2;
        var _xj:XML = <Stats>
            <Stat>
                <Abbr>ATT</Abbr>
                <Name>Attack</Name>
                <Description>This stat increases the amount of damage done by weapons and certain abilities.</Description>
                <RedOnZero/>
            </Stat>
            <Stat>
                <Abbr>DEF</Abbr>
                <Name>Defense</Name>
                <Description>This stat subtracts damage that you receive after reduction.</Description>
            </Stat>
            <Stat>
                <Abbr>SPD</Abbr>
                <Name>Speed</Name>
                <Description>This stat increases the speed at which the character moves.</Description>
                <RedOnZero/>
            </Stat>
            <Stat>
                <Abbr>DEX</Abbr>
                <Name>Dexterity</Name>
                <Description>This stat increases the rate at which the character attacks.</Description>
                <RedOnZero/>
            </Stat>
            <Stat>
                <Abbr>VIT</Abbr>
                <Name>Vitality</Name>
                <Description>This stat increases the overall effectiveness of healing effects.</Description>
                <RedOnZero/>
            </Stat>
            <Stat>
                <Abbr>WIS</Abbr>
                <Name>Wisdom</Name>
                <Description>This stat increases the passive magic regeneration rate and ability cooldown reduction.</Description>
                <RedOnZero/>
            </Stat>
            <Stat>
                <Abbr>APT</Abbr>
                <Name>Aptitude</Name>
                <Description>This stat increases the overall effectiveness of abilities.</Description>
            </Stat>
            <Stat>
                <Abbr>RES</Abbr>
                <Name>Resilience</Name>
                <Description>This stat reduces overall damage reception.</Description>
                <RedOnZero/>
            </Stat>
        </Stats>;
        for each (_local3 in _xj.Stat) {
            _local4 = new Stat(_local3.Abbr, _local3.Name, _local3.Description, _local3.hasOwnProperty("RedOnZero"));
            _local4.x = ((8 + 14) + (int(this._stats.length % 2) * ((this.w_ / 2) - 7)));
            _local4.y = ((8 + (this.h_ / 6)) + ((int((this._stats.length / 2)) * this.h_) / 3));
            addChild(_local4);
            this._stats.push(_local4);
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var w_:int;
    public var h_:int;
    public var _stats:Vector.<Stat>;
    public var toolTip_:TextTagTooltip;

    public function draw(_arg1:Player):void {
        this._stats[AttPos].draw(_arg1.attack_, _arg1._attBonus, _arg1._maxATT);
        this._stats[DefPos].draw(_arg1.defense_, _arg1._defBonus, _arg1._maxDEF);
        this._stats[SpdPos].draw(_arg1.speed_, _arg1._spdBonus, _arg1._maxSPD);
        this._stats[DexPos].draw(_arg1.dexterity_, _arg1._dexBonus, _arg1._maxDEX);
        this._stats[VitPos].draw(_arg1.vitality_, _arg1._vitBonus, _arg1._maxVIT);
        this._stats[WisPos].draw(_arg1.wisdom_, _arg1._wisBonus, _arg1._maxWIS);
        this._stats[ApPos].draw(_arg1.aptitude_, _arg1._aptitudeBonus, _arg1._maxAP);
        this._stats[ResPos].draw(_arg1.resilience_, _arg1._resBonus, _arg1._maxRES);
        //TODO: add resilience and MAYBE ability power but NOT penetration
    }

    private function onAddedToStage(_arg1:Event):void {
        var _local2:Stat;
        for each (_local2 in this._stats) {
            _local2.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            _local2.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function onRemovedFromStage(_arg1:Event):void {
        var _local2:Stat;
        if (this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
        for each (_local2 in this._stats) {
            _local2.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            _local2.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        var _local2:Stat = (_arg1.target as Stat);
        this.toolTip_._N_k(_local2.fullName_);
        this.toolTip_._02C_(_local2.description_);
        if (!stage.contains(this.toolTip_)) {
            stage.addChild(this.toolTip_);
        }
    }

    private function onMouseOut(_arg1:MouseEvent):void {
        var _local2:Stat = (_arg1.target as Stat);
        if (this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
    }

}
}//package com.company.PhoenixRealmClient.ui

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextFormat;

class Stat extends Sprite {

    public var fullName_:String;
    public var description_:String;
    public var nameText_:SimpleText;
    public var valText_:SimpleText;
    public var redOnZero_:Boolean;
    public var val_:int = -1;
    public var boost_:int = -1;
    public var valColor_:uint = 0xB3B3B3;

    public function Stat(_arg1:String, _arg2:String, _arg3:String, _arg4:Boolean) {
        this.fullName_ = _arg2;
        this.description_ = _arg3;
        this.nameText_ = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.text = _arg1;
        this.nameText_.updateMetrics();
        this.nameText_.x = -(this.nameText_.width);
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.valText_ = new SimpleText(12, this.valColor_, false, 0, 0, "Myriad Pro");
        this.valText_.setBold(true);
        this.valText_.text = "-";
        this.valText_.updateMetrics();
        this.valText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.valText_);
        this.redOnZero_ = _arg4;
    }

    public function draw(_arg1:int, _arg2:int, _arg3:int):void {
        var _local4:uint;
        var _local5:TextFormat;
        if ((((_arg1 == this.val_)) && ((_arg2 == this.boost_)))) {
            return;
        }
        this.val_ = _arg1;
        this.boost_ = _arg2;
        if ((_arg1 - _arg2) >= _arg3) {
            _local4 = 0xFCDF00;
        } else {
            if (((((this.redOnZero_) && ((this.val_ <= 0)))) || ((this.boost_ < 0)))) {
                _local4 = 16726072;
            } else {
                if (this.boost_ > 0) {
                    _local4 = 6206769;
                } else {
                    _local4 = 0xB3B3B3;
                }
            }
        }
        if (this.valColor_ != _local4) {
            this.valColor_ = _local4;
            _local5 = this.valText_.defaultTextFormat;
            _local5.color = this.valColor_;
            this.valText_.setTextFormat(_local5);
            this.valText_.defaultTextFormat = _local5;
        }
        this.valText_.text = this.val_.toString() + " ";
        if (this.boost_ != 0) {
            this.valText_.text = (this.valText_.text + (((" (" + (((this.boost_ > 0)) ? "+" : "")) + this.boost_.toString()) + ")"));
        }
        this.valText_.updateMetrics();
    }

}

