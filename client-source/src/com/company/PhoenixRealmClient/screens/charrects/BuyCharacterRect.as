// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.screens.charrects.BuyCharacterRect

package com.company.PhoenixRealmClient.screens.charrects {
import _G_A_.GameContext;

import com.company.PhoenixRealmClient.appengine.AppEngine;
import com.company.PhoenixRealmClient.appengine._0K_R_;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.PurchaseButton;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.filters.DropShadowFilter;

public class BuyCharacterRect extends CharacterRect {

    public function BuyCharacterRect(_arg1:_0K_R_) {
        super(Parameters._primaryColourDark2, Parameters._primaryColourDefault);
        var _local2:Shape = this.buildIcon();
        _local2.x = 7;
        _local2.y = 7;
        addChild(_local2);
        this.classNameText_ = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.classNameText_.setBold(true);
        this.classNameText_.text = (("Buy " + this.getOrdinalString((_arg1.maxNumChars_ + 1))) + " Character Slot");
        this.classNameText_.updateMetrics();
        this.classNameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.classNameText_.x = 58;
        this.classNameText_.y = 2;
        addChild(this.classNameText_);
        var _local3:int = (100 - (_arg1.nextCharSlotPrice_ / 10));
        if (_local3 != 0) {
            this.taglineText_ = new SimpleText(14, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.taglineText_.text = (("Normally 1000 " + Currency.getCurrencyName(GameContext.getInjector().getInstance(AppEngine).parameters.CharSlotCurrency) + ".  Save " + _local3.toString()) + "%!");
            this.taglineText_.updateMetrics();
            this.taglineText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.taglineText_.x = 58;
            this.taglineText_.y = 24;
            addChild(this.taglineText_);
        }
        this.priceText_ = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.priceText_.text = _arg1.nextCharSlotPrice_.toString();
        this.priceText_.updateMetrics();
        this.priceText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.priceText_.x = (393 - this.priceText_.width);
        this.priceText_.y = 2;
        addChild(this.priceText_);
        var _local4:BitmapData = PurchaseButton.iconFromCurrency(GameContext.getInjector().getInstance(AppEngine).parameters.CharSlotCurrency);
        _local4 = BitmapUtil.getRectanglefromBitmap(_local4, 6, 6, (_local4.width - 12), (_local4.height - 12));
        this.coin_ = new Bitmap();
        this.coin_.bitmapData = _local4;
        this.coin_.x = 390;
        this.coin_.y = 1;
        addChild(this.coin_);
    }
    private var classNameText_:SimpleText;
    private var taglineText_:SimpleText;
    private var priceText_:SimpleText;
    private var coin_:Bitmap;

    private function buildIcon():Shape {
        var _local1:Shape = new Shape();
        var _local2:Graphics = _local1.graphics;
        _local2.beginFill(Parameters._primaryColourDefault);
        _local2.lineStyle(1, Parameters._primaryColourLight);
        _local2.drawCircle(19, 19, 19);
        _local2.lineStyle();
        _local2.endFill();
        _local2.beginFill(Parameters._primaryColourDark2);
        _local2.drawRect(11, 17, 16, 4);
        _local2.endFill();
        _local2.beginFill(Parameters._primaryColourDark2);
        _local2.drawRect(17, 11, 4, 16);
        _local2.endFill();
        return (_local1);
    }

    private function getOrdinalString(_arg1:int):String {
        var _local2:String = _arg1.toString();
        var _local3:int = (_arg1 % 10);
        var _local4:int = (int((_arg1 / 10)) % 10);
        if (_local4 == 1) {
            _local2 = (_local2 + "th");
        } else {
            if (_local3 == 1) {
                _local2 = (_local2 + "st");
            } else {
                if (_local3 == 2) {
                    _local2 = (_local2 + "nd");
                } else {
                    if (_local3 == 3) {
                        _local2 = (_local2 + "rd");
                    } else {
                        _local2 = (_local2 + "th");
                    }
                }
            }
        }
        return (_local2);
    }

}
}//package com.company.PhoenixRealmClient.screens.charrects

