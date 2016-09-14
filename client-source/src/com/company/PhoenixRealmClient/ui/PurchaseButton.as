// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._u5

package com.company.PhoenixRealmClient.ui {
import com.company.PhoenixRealmClient.util.Currency;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicHelper;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class PurchaseButton extends Sprite {

    private static var coin_:BitmapData = null;
    private static var _Q_7:BitmapData = null;
    private static var _K_F_:BitmapData = null;
    private static var _silver:BitmapData = null;

    public static function iconFromCurrency(currency:int):BitmapData {
        switch (currency) {
            case Currency.CREDITS:
                return _I_H_();
            case Currency.FAME:
                return fame();
            case Currency.GUILDFAME:
                return _0M_s();
            case Currency.SILVER:
                return silver();
        }
        throw new ArgumentError("Not a valid currency");
    }

    public static function _I_H_():BitmapData {
        if (coin_ == null) {
            coin_ = TextureRedrawer.resize(AssetLibrary.getBitmapFromFileIndex("lofiObj3", 225), null, 40, true, 0, 0);
            coin_ = TextureRedrawer.outlineGlow(coin_, 0xFFFFFFFF);
        }
        return (coin_);
    }

    public static function fame():BitmapData {
        if (_Q_7 == null) {
            _Q_7 = TextureRedrawer.resize(AssetLibrary.getBitmapFromFileIndex("lofiObj3", 224), null, 40, true, 0, 0);
            _Q_7 = TextureRedrawer.outlineGlow(_Q_7, 0xFFFFFFFF);
        }
        return (_Q_7);
    }

    public static function silver():BitmapData {
        if (_silver == null) {
            _silver = TextureRedrawer.resize(AssetLibrary.getBitmapFromFileIndex("lofiObj3", 239), null, 40, true, 0, 0);
            _silver = TextureRedrawer.outlineGlow(_silver, 0xFFFFFFFF);
        }
        return (_silver);
    }

    public static function _0M_s():BitmapData {
        if (_K_F_ == null) {
            _K_F_ = TextureRedrawer.resize(AssetLibrary.getBitmapFromFileIndex("lofiObj3", 226), null, 40, true, 0, 0);
            _K_F_ = TextureRedrawer.outlineGlow(_K_F_, 0xFFFFFFFF);
        }
        return (_K_F_);
    }

    public function PurchaseButton(_arg1:String, _arg2:int, _arg3:int, _arg4:int, fixedWidth:int=0) {
        this._pL_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this._f1 = new GraphicsSolidFill(0x7F7F7F, 1);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[_pL_, path_, GraphicHelper.END_FILL];
        this.fixedWidth = fixedWidth;
        super();
        this._A_2 = _arg1;
        this.text_ = new SimpleText(_arg2, 0x363636, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        addChild(this.text_);
        this._5U_ = new Bitmap();
        addChild(this._5U_);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        this.setPrice(_arg3, _arg4);
    }
    public var _A_2:String;
    public var text_:SimpleText;
    public var _5U_:Bitmap;
    public var price_:int = -1;
    public var currency_:int = -1;
    public var w_:int;
    private var fixedWidth:int;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var _pL_:GraphicsSolidFill;
    private var _f1:GraphicsSolidFill;
    private var path_:GraphicsPath;

    public function setPrice(_arg1:int, _arg2:int):void {
        if ((((this.price_ == _arg1)) && ((this.currency_ == _arg2)))) {
            return;
        }
        this.price_ = _arg1;
        this.currency_ = _arg2;
        if(_arg1 != 0) {
            this.text_.text = (this._A_2 + _arg1);
            this.text_.updateMetrics();
            switch (_arg2) {
                case Currency.CREDITS:
                    this._5U_.bitmapData = _I_H_();
                    break;
                case Currency.FAME:
                    this._5U_.bitmapData = fame();
                    break;
                case Currency.GUILDFAME:
                    this._5U_.bitmapData = _0M_s();
                    break;
                case Currency.SILVER:
                    this._5U_.bitmapData = silver();
                    break;
                default:
                    this._5U_.bitmapData = null;
            }
        } else {
            this.text_.text = (this._A_2 + "Free");
            this.text_.updateMetrics();
        }
        this.text_.x = this.fixedWidth != 0 ? ((this.fixedWidth / 2) - ((this.text_.width + 12) / 2) - 10) : ((((this.text_.width + 12) / 2) - (this.text_.textWidth / 2)) - 2);
        this.text_.y = 1;
        this._5U_.x = this.text_.x + this.text_.width - 10;
        this._5U_.y = ((this.text_.textHeight + 8) / 2 - (this._5U_.height / 2));
        if(this._5U_.bitmapData != null) {
            this.w_ = this.fixedWidth != 0 ? this.fixedWidth : ((this.text_.width + this._5U_.width) - 6);
        } else {
            this.w_ = this.fixedWidth != 0 ? this.fixedWidth : (this.text_.textWidth + 16);
        }
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(0, 0, this.fixedWidth != 0 ? this.fixedWidth : this.w_, (this.text_.textHeight + 8), 4, [1, 1, 1, 1], this.path_);
        this.draw();
    }

    public function _A_w(_arg1:Boolean):void {
        if (_arg1 == mouseEnabled) {
            return;
        }
        mouseEnabled = _arg1;
        this.graphicsData_[0] = ((_arg1) ? this._pL_ : this._f1);
        this.draw();
    }

    private function draw():void {
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this._pL_.color = 16768133;
        this.draw();
    }

    private function onRollOut(_arg1:MouseEvent):void {
        this._pL_.color = 0xFFFFFF;
        this.draw();
    }

}
}//package com.company.PhoenixRealmClient.ui

