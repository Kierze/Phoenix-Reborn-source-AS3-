package Panels {
import Frames.CreateGuildFrame;

import _0L_C_.TwoButtonDialog;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Button;
import com.company.PhoenixRealmClient.ui.FrameHolder;
import com.company.PhoenixRealmClient.ui.PurchaseButton;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.PhoenixRealmClient.util._07E_;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class GuildCreateRenouncePanel extends Panel
{

    public function GuildCreateRenouncePanel(_arg1:GameSprite)
    {
        var _local3:String;
        var _local4:PurchaseButton;
        super(_arg1);
        if (gs_.map_ == null || gs_.map_.player_ == null)
        {
            return;
        }
        var _local2:Player = gs_.map_.player_;
        this._O_k = new SimpleText(18, 0xFFFFFF, false, WIDTH, 0, "Myriad Pro");
        this._O_k.setBold(true);
        this._O_k.wordWrap = true;
        this._O_k.multiline = true;
        this._O_k.autoSize = TextFieldAutoSize.CENTER;
        this._O_k.filters = [new DropShadowFilter(0, 0, 0)];
        if (_local2.guildName_ != null && _local2.guildName_.length > 0)
        {
            _local3 = _07E_._0C_n(_local2.guildRank_);
            this._O_k.htmlText = '<p align="center">' + _local3 + " of \n" + _local2.guildName_ + "</p>";
            this._O_k.y = 0;
            addChild(this._O_k);
            this._ek = new Button(16, "Renounce");
            this._ek.addEventListener(MouseEvent.CLICK, this.clickRenounce);
            this._ek.x = ((WIDTH / 2) - (this._ek.width / 2));
            this._ek.y = ((HEIGHT - this._ek.height) - 4);
            addChild(this._ek);
        }
        else
        {
            this._O_k.htmlText = '<p align="center">Create a Guild</p>';
            this._O_k.y = 0;
            addChild(this._O_k);
            _local4 = new PurchaseButton("Create ", 16, Parameters._0H_m, Currency.FAME);
            _local4.addEventListener(MouseEvent.CLICK, this.clickCreateGuild);
            _local4.x = (WIDTH / 2) - (_local4.w_ / 2);
            _local4.y = (HEIGHT - (_local4.height / 2)) - 10;
            addChild(_local4);
            this._ek = _local4;
        }
    }
    private var _O_k:SimpleText;
    private var _ek:Sprite;

    public function clickRenounce(_arg1:MouseEvent):void
    {
        if (gs_.map_ == null || gs_.map_.player_ == null)
        {
            return;
        }
        var _local2:Player = gs_.map_.player_;
        var _local3:TwoButtonDialog = new TwoButtonDialog(("Are you sure you want to quit:\n" + _local2.guildName_), "Renounce Guild", "No, I'll stay", "Yes, I'll quit", "/renounceGuild");
        _local3.addEventListener(TwoButtonDialog.BUTTON1_EVENT, this.cancel);
        _local3.addEventListener(TwoButtonDialog.BUTTON2_EVENT, this.RenounceGuild);
        stage.addChild(_local3);
    }

    public function clickCreateGuild(_arg1:MouseEvent):void
    {
        var _local2:Sprite = new FrameHolder(new CreateGuildFrame(gs_));
        stage.addChild(_local2);
        visible = false;
    }

    private function cancel(_arg1:Event):void
    {
        stage.removeChild((_arg1.currentTarget as TwoButtonDialog));
    }

    private function RenounceGuild(_arg1:Event):void
    {
        if (gs_.map_ == null || gs_.map_.player_ == null)
        {
            return;
        }
        var _local2:Player = gs_.map_.player_;
        gs_.gsc_.guildRemove(_local2.name_);
        stage.removeChild((_arg1.currentTarget as TwoButtonDialog));
        visible = false;
    }

}
}//package _R_v

