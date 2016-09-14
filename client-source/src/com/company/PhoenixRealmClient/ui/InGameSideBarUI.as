// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui.InGameSideBarUI

package com.company.PhoenixRealmClient.ui {
import OptionsStuff.Options;

import Packets.fromServer.ItemSelectStartPacket;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class InGameSideBarUI extends Sprite {

    public function InGameSideBarUI(_arg1:GameSprite, _arg2:Player, _arg3:int, _arg4:int) {
        this._gameSprite = _arg1;
        this._player = _arg2;
        this._width = _arg3;
        this._height = _arg4;
        this.playerPortrait = new Bitmap(null);
        this.playerPortrait.x = 0;
        this.playerPortrait.y = 40 - 45;
        addChild(this.playerPortrait);
        this.nameText_ = new SimpleText(20, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.x = 36;
        this.nameText_.y = 50 - 45;

        if (this._gameSprite.charList_.name_ == null)
            this.nameText_.text = this._player.name_;
        else
            this.nameText_.text = this._gameSprite.charList_.name_;

        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        if (this._gameSprite.gsc_.gameId_ != Parameters.NEXUS_ID) {
            this._nw = new _rN_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 6), "Nexus", "escapeToNexus");
            this._nw.addEventListener(MouseEvent.CLICK, this.pressNexusButton);
            this._nw.x = 170;
            this._nw.y = 55 - 45;
            addChild(this._nw);
        } else {
            this._nw = new _rN_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 5), "Options", "options");
            this._nw.addEventListener(MouseEvent.CLICK, this.pressOptionsButton);
            this._nw.x = 170;
            this._nw.y = 55 - 45;
            addChild(this._nw);
        }
        this._expBar = new StatsBar(176, 16, 5931045, Parameters._primaryColourDark2, "Lvl X");
        this._expBar.x = 12;
        this._expBar.y = 80 - 45;
        addChild(this._expBar);

        this._expBar.visible = true;
        this._fameBar = new StatsBar(176, 16, 0xE25F00, Parameters._primaryColourDark2, "Fame");
        this._fameBar.x = 12;
        this._fameBar.y = 80 - 45;
        addChild(this._fameBar);

        this._fameBar.visible = false;
        this._hpBar = new StatsBar(176, 16, 14693428, Parameters._primaryColourDark2, "HP");
        this._hpBar.x = 12;
        this._hpBar.y = 104 - 45;
        addChild(this._hpBar);

        this._mpBar = new StatsBar(176, 16, 6325472, Parameters._primaryColourDark2, "MP");
        this._mpBar.x = 12;
        this._mpBar.y = 128 - 45;
        addChild(this._mpBar);

        this.InvEquips = new Inventory(_arg1, _arg2, "Inventory", _arg2.inventorySlotTypes_.slice(0, 4), 4, true, 0, true);
        this.InvEquips.x = 14;
        this.InvEquips.y = 220 - 45;
        addChild(this.InvEquips);

        this.tabList_ = [];
        this.invTab_ = new TabButton(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 0x20), true, 0);
        this.invTab_.addEventListener(MouseEvent.CLICK, this.onTabClick);
        this.invTab_.x = 7;
        this.invTab_.y = 270 - 45;
        addChild(this.invTab_);
        this.tabList_[0] = this.invTab_;
        this.statTab_ = new TabButton(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 0x21), false, 1);
        this.statTab_.addEventListener(MouseEvent.CLICK, this.onTabClick);
        this.statTab_.x = 35;
        this.statTab_.y = 270 - 45;
        addChild(this.statTab_);
        this.tabList_[1] = this.statTab_;
        this.playerStats = new Stats(191, 45);
        this.playerStats.x = 6;
        this.playerStats.y = 7;
        this.statTab_.holder_.addChild(this.playerStats);
        this.playerInventory = new Inventory(_arg1, _arg2, "Inventory", _arg2.inventorySlotTypes_.slice(4), 8, true, 4);
        this.playerInventory.x = 7;
        this.playerInventory.y = 7;
        this.invTab_.holder_.addChild(this.playerInventory);
        mouseEnabled = false;
        this.setChildIndex(this.invTab_, this.numChildren - 1);
        this.draw();
    }
    public var InvEquips:Inventory;
    public var playerInventory:Inventory;
    public var pack_:Inventory;
    public var _0E__:int;
    public var itemSelect_:ItemSelect;
    private var _gameSprite:GameSprite;
    private var _player:Player;
    private var _width:int;
    private var _height:int;
    private var playerPortrait:Bitmap;
    private var nameText_:SimpleText;
    private var _L_P_:Sprite;
    private var _nw:_rN_ = null;
    private var _expBar:StatsBar;
    private var _fameBar:StatsBar;
    private var _hpBar:StatsBar;
    private var _mpBar:StatsBar;
    private var playerStats:Stats;
    private var invTab_:TabButton;
    private var statTab_:TabButton;
    private var tabBG_:TabBackground;
    private var tabList_:Array;
    private var selectedTab_:int = 0;
    private var stackPots:Boolean = false;

    public function setName(_arg1:String):void {
        this.nameText_.text = _arg1;
        this.nameText_.updateMetrics();
    }

    public function nextTab():void {
        if (this.selectedTab_ + 1 == this.tabList_.length) {
            this.switchTab(this.tabList_[0] as TabButton);
        } else {
            this.switchTab(this.tabList_[this.selectedTab_ + 1] as TabButton);
        }
    }

    public function switchTab(_tab:TabButton):void {
        if (_tab.selected_) return;
        for each(var _i:TabButton in this.tabList_) {
            _i.setSelected(false);
        }
        _tab.setSelected(true);
        this.selectedTab_ = _tab.tabId_;
        this.setChildIndex(_tab, this.numChildren - 1);
    }

    public function draw():void {
        this.playerPortrait.bitmapData = this._player.getPortrait();
        var _local1:String = ("Lvl " + this._player.level_);
        if (_local1 != this._expBar.labelText_.text) {
            this._expBar.labelText_.text = _local1;
            this._expBar.labelText_.updateMetrics();
        }
        if (this._player.level_ != Parameters.levelCap_)
        {
            if (!this._expBar.visible)
            {
                this._expBar.visible = true;
                this._fameBar.visible = false;
            }
            this._expBar.draw(this._player.exp_, this._player._7V_, 0);
            if (this._0E__ != this._player._gz)
            {
                this._0E__ = this._player._gz;
                this._expBar._Y_r(this._0E__, this._player._gz);
            }
        }
        else
        {
            if (!this._fameBar.visible)
            {
                this._fameBar.visible = true;
                this._expBar.visible = false;
            }
            this._fameBar.draw(this._player._0L_o, this._player._n8, 0);
        }
        //this.tabBG_.draw(this.invTab_.selected_);
        this._hpBar.draw(this._player.HP_, this._player.maxHP_, this._player._P_7, this._player._maxMAXHP);
        this._mpBar.draw(this._player.MP_, this._player.maxMP_, this._player._0D_G_, this._player._maxMAXMP);
        this.playerStats.draw(this._player);
        this.InvEquips.draw(this._player.equipment_.slice(0, 4));
        this.playerInventory.draw(this._player.equipment_.slice(4));
    }

    public function destroy():void {
    }

    private function pressNexusButton(_arg1:MouseEvent):void {
        this._gameSprite.gsc_._M_6();
        //GA.global().trackEvent("enterPortal", "Nexus Button");
        Parameters.ClientSaveData.needsRandomRealm = false;
        Parameters.save();
    }

    private function pressOptionsButton(_arg1:MouseEvent):void {
        this._gameSprite.mui_.clearInput();
        //GA.global().trackEvent("options", "Options Button");
        this._gameSprite.addChild(new Options(this._gameSprite));
    }

    private function onTabClick(event:MouseEvent):void {
        if (event.target is TabButton) {
            this.switchTab(event.target as TabButton);
        }
    }

    public function selectItems(_arg1:ItemSelectStartPacket) {
        if(this.itemSelect_ != null) {
            return;
        }
        this.InvEquips.visible = false;
        this.statTab_.visible = false;
        this.invTab_.visible = false;
        this.itemSelect_ = new ItemSelect(this._gameSprite, _arg1);
        this.itemSelect_.y = 200 - 45;
        addChild(this.itemSelect_);
        this.itemSelect_.addEventListener(Event.CANCEL, this.cancelSelect)
    }

    public function cancelSelect(event:Event=null):void {
        this.InvEquips.visible = true;
        this.statTab_.visible = true;
        this.invTab_.visible = true;
        if(this.itemSelect_ != null) {
            this.itemSelect_.removeEventListener(Event.CANCEL, this.cancelSelect);
            removeChild(this.itemSelect_);
            this.itemSelect_ = null;
        }
    }
}
}//package com.company.PhoenixRealmClient.ui

