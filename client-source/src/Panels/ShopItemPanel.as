// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._aR_

package Panels {
import Tooltips.TooltipBase;

import _0L_C_.GuestGuardDialog;

import _qN_.Account;

import _sp.Signal;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.objects.SellableObject;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.PurchaseButton;
import com.company.PhoenixRealmClient.ui.StarRankSprite;
import com.company.PhoenixRealmClient.ui.Chat;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.PhoenixRealmClient.util.Modal;
import com.company.PhoenixRealmClient.util._07E_;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class ShopItemPanel extends Panel {

    private const _00e:int = 10;

    private static function _hF_(_arg1:int):Sprite {
        var _local2:Sprite;
        _local2 = new Sprite();
        var _local3:SimpleText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        _local3.setBold(true);
        _local3.text = "Rank Required:";
        _local3.updateMetrics();
        _local3.filters = [new DropShadowFilter(0, 0, 0)];
        _local2.addChild(_local3);
        var _local4:Sprite = new StarRankSprite(_arg1, false, false);
        _local4.x = (_local3.width + 4);
        _local4.y = ((_local3.height / 2) - (_local4.height / 2));
        _local2.addChild(_local4);
        return (_local2);
    }

    private static function _0B_1(_arg1:int):SimpleText {
        var _local2:SimpleText = new SimpleText(16, 0xFF0000, false, 0, 0, "Myriad Pro");
        _local2.setBold(true);
        _local2.text = (_07E_._0C_n(_arg1) + " Rank Required");
        _local2._08S_();
        _local2.filters = [new DropShadowFilter(0, 0, 0)];
        return (_local2);
    }

    public function ShopItemPanel(_arg1:GameSprite, _arg2:SellableObject) {
        this.event = new Signal(SellableObject);
        super(_arg1);
        this.nameText_ = new SimpleText(16, 0xFFFFFF, false, (WIDTH - 44), 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.htmlText = '<p align="center">Thing For Sale</p>';
        this.nameText_.wordWrap = true;
        this.nameText_.multiline = true;
        this.nameText_.autoSize = TextFieldAutoSize.CENTER;
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this._5U_ = new Sprite();
        addChild(this._5U_);
        this.bitmap_ = new Bitmap(null);
        this._5U_.addChild(this.bitmap_);
        this._8O_ = new PurchaseButton("Buy for ", 16, 0, Currency.INVALID);
        this._8O_.addEventListener(MouseEvent.CLICK, this._i);
        addChild(this._8O_);
        this._r(_arg2);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    private var _iA_:SellableObject;
    private var modal:Modal;
    private var nameText_:SimpleText;
    private var _8O_:PurchaseButton;
    private var _0F_y:Sprite = null;
    private var _0C_:SimpleText = null;
    private var _5U_:Sprite;
    private var bitmap_:Bitmap;
    private var toolTip_:TooltipBase;

    public var event:Signal;

    override public function draw():void {
        var _local1:Player = gs_.map_.player_;
        this.nameText_.y = (((this.nameText_.height) > 30) ? 0 : 12);
        var _local2:int = this._iA_._U_R_;
        if (_local1.numStars_ < _local2) {
            if (contains(this._8O_)) {
                removeChild(this._8O_);
            }
            if ((((this._0F_y == null)) || (!(contains(this._0F_y))))) {
                this._0F_y = _hF_(_local2);
                this._0F_y.x = ((WIDTH / 2) - (this._0F_y.width / 2));
                this._0F_y.y = ((HEIGHT - (this._0F_y.height / 2)) - 20);
                addChild(this._0F_y);
            }
        } else {
            if (_local1.guildRank_ < this._iA_._0F_S_) {
                if (contains(this._8O_)) {
                    removeChild(this._8O_);
                }
                if ((((this._0C_ == null)) || (!(contains(this._0C_))))) {
                    this._0C_ = _0B_1(this._iA_._0F_S_);
                    this._0C_.x = ((WIDTH / 2) - (this._0C_.width / 2));
                    this._0C_.y = ((HEIGHT - (this._0C_.height / 2)) - 20);
                    addChild(this._0C_);
                }
            } else {
                this._8O_.setPrice(this._iA_.price_, this._iA_.currency_);
                this._8O_._A_w((gs_.gsc_.outstandingBuy_ == null));
                this._8O_.x = ((WIDTH / 2) - (this._8O_.w_ / 2));
                this._8O_.y = ((HEIGHT - (this._8O_.height / 2)) - this._00e);
                if (!contains(this._8O_)) {
                    addChild(this._8O_);
                }
                if (((!((this._0F_y == null))) && (contains(this._0F_y)))) {
                    removeChild(this._0F_y);
                }
            }
        }
    }

    public function _r(_arg1:SellableObject):void {
        if (_arg1 == this._iA_) {
            return;
        }
        this._iA_ = _arg1;
        this._8O_.setPrice(this._iA_.price_, this._iA_.currency_);
        var _local2:String = this._iA_.soldObjectName();
        this.nameText_.htmlText = (('<p align="center">' + _local2) + "</p>");
        this.bitmap_.bitmapData = this._iA_.getIcon();
    }

    private function _iO_():void {
        if (!Account._get().isRegistered()) {
            stage.addChild(new GuestGuardDialog((("In order to use " + Currency.getCurrencyName(this._iA_.currency_)) + ", you must be a registered user.")));
        } else {
            this.modal = new Modal(this.event, this._iA_, this._8O_.width, gs_);
            parent.addChild(this.modal);
            //_gameSprite.gsc_.buy(this._iA_.objectId_);
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        this._5U_.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this._5U_.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this._0A_Y_);
        this._5U_.x = -4;
        this._5U_.y = -8;
        this.nameText_.x = 44;
    }

    private function onRemovedFromStage(_arg1:Event):void {
        this._5U_.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this._5U_.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._0A_Y_);
        if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }
        if ((!(parent == null) && !(this.modal == null)) && this.modal.open) {
            parent.removeChild(this.modal);
        }
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }
        this.toolTip_ = this._iA_.getTooltip();
        stage.addChild(this.toolTip_);
    }

    private function onMouseOut(_arg1:MouseEvent):void {
        if (this.toolTip_ != null) {
            if (this.toolTip_.parent != null) {
                this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
        }
    }

    private function _i(_arg1:MouseEvent):void {
        if (Modal.isClosed) {
            this._iO_();
        }
    }

    private function _0A_Y_(_arg1:KeyboardEvent):void {
        if ((((_arg1.keyCode == Parameters.ClientSaveData.interact)) && (!(Chat._0G_B_)) && (Modal.isClosed))) {
            this._iO_();
        }
    }

}
}//package _R_v

