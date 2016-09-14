// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._0K_o

package Panels {
import Frames.ChooseAccNameFromPanelFrame;

import _0L_C_.GuestGuardDialog;

import _qN_.Account;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Button;
import com.company.PhoenixRealmClient.ui.FrameHolder;
import com.company.PhoenixRealmClient.ui.PurchaseButton;
import com.company.PhoenixRealmClient.ui.StarRankSprite;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class NameChangePanel extends Panel
{

    public function NameChangePanel(_arg1:GameSprite, _arg2:int)
    {
        var purchaseButton:PurchaseButton;
        var _local6:Sprite;
        var rankReqText:SimpleText;
        var _local8:Sprite;
        super(_arg1);
        if ((gs_.map_ == null) || (gs_.map_.player_ == null))
        {
            return;
        }
        var player:Player = gs_.map_.player_;
        this.nameChosen = player.NameChosen;
        var name:String = gs_.charList_.name_;

        this._htmlHeader = new SimpleText(18, 0xFFFFFF, false, WIDTH, 0, "Myriad Pro");
        this._htmlHeader.setBold(true);
        this._htmlHeader.wordWrap = true;
        this._htmlHeader.multiline = true;
        this._htmlHeader.autoSize = TextFieldAutoSize.CENTER;
        this._htmlHeader.filters = [new DropShadowFilter(0, 0, 0)];
        if (this.nameChosen)
        {
            this._htmlHeader.htmlText = (('<p align="center">Your name is: \n' + name) + "</p>");
            this._htmlHeader.y = 0;
            addChild(this._htmlHeader);
            purchaseButton = new PurchaseButton("Change ", 16, Parameters._0u, Currency.CREDITS);
            purchaseButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
            purchaseButton.x = ((WIDTH / 2) - (purchaseButton.w_ / 2));
            purchaseButton.y = ((HEIGHT - (purchaseButton.height / 2)) - 10);
            addChild(purchaseButton);
            this.chooseButton = purchaseButton;
        }
        else
        {
            if (player.numStars_ < _arg2)
            {
                this._htmlHeader.htmlText = '<p align="center">Choose Account Name</p>';
                addChild(this._htmlHeader);
                _local6 = new Sprite();
                rankReqText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
                rankReqText.setBold(true);
                rankReqText.text = "Rank Required:";
                rankReqText.updateMetrics();
                rankReqText.filters = [new DropShadowFilter(0, 0, 0)];
                _local6.addChild(rankReqText);
                _local8 = new StarRankSprite(_arg2, false, false);
                _local8.x = (rankReqText.width + 4);
                _local8.y = ((rankReqText.height / 2) - (_local8.height / 2));
                _local6.addChild(_local8);
                _local6.x = ((WIDTH / 2) - (_local6.width / 2));
                _local6.y = ((HEIGHT - (_local6.height / 2)) - 20);
                addChild(_local6);
            }
            else
            {
                this._htmlHeader.htmlText = '<p align="center">Choose Account Name</p>';
                this._htmlHeader.y = 6;
                addChild(this._htmlHeader);
                this.chooseButton = new Button(16, "Choose");
                this.chooseButton.addEventListener(MouseEvent.CLICK, this.onButtonClick);
                this.chooseButton.x = ((WIDTH / 2) - (this.chooseButton.width / 2));
                this.chooseButton.y = ((HEIGHT - this.chooseButton.height) - 4);
                addChild(this.chooseButton);
            }
        }
    }
    private var nameChosen:Boolean;
    private var _htmlHeader:SimpleText;
    private var chooseButton:Sprite;

    private function onButtonClick(_arg1:MouseEvent):void
    {
        var _local2:Sprite;
        if (Account._get().isRegistered())
        {
            _local2 = new FrameHolder(new ChooseAccNameFromPanelFrame(gs_, this.nameChosen));
            visible = false;
        }
        else
        {
            _local2 = new GuestGuardDialog(("In order to choose an " + "account name, you must be registered"));
        }
        stage.addChild(_local2);
    }

}
}//package _R_v

