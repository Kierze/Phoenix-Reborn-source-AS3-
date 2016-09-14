package _nA_ {
import _qN_.Account;

import _vf.SFXHandler;

import com.company.PhoenixRealmClient.parameters.Parameters;

import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class _xI_ extends Sprite {

    private var file_:String = "lofiInterface2";
    private var index_:int;

    private var icon_:Bitmap;
    private var background_:Sprite;
    private var image_:BitmapData;
    private var text_:SimpleText;
    private var useImg_:Boolean;

    private var action_:String;
    private var actions:Array = ['UPDATE', 'MULEDUMP'];

    public function _xI_(_arg1:Boolean=true, _arg2:int=15, _arg3:String="Updates", _arg4:String="UPDATE") {
        this.useImg_ = _arg1;
        this.index_ = _arg2;
        if (this.useImg_) {
            this.image_ = TextureRedrawer.redraw(AssetLibrary.getBitmapFromFileIndex(file_, index_), 40, true, 0);
            this.icon_ = new Bitmap(this.image_);
            this.icon_.x = -5;
            this.icon_.y = -8;
        }
        this.background_ = _eX_1_._c9_9();
        this.background_.mouseChildren = false;
        this.background_.mouseEnabled = true;
        this.text_ = new SimpleText(16, 0xFFFFFF, false, 0, 0, "CHIP SB");
        this.text_.text = _arg3;
        this.text_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.draw();
        this.text_.x = this.useImg_ ? 28 : 10;
        this.text_.y = 3;
        this.action_ = _arg4.toUpperCase();
        this.background_.addEventListener(MouseEvent.CLICK, this.openUI);
    }
    public function openUI(_arg1:MouseEvent):void{
        switch (this.action_) {
            case actions[0]:
                navigateToURL(new URLRequest(Parameters.lastUpdate), "_blank");
                break;
            case actions[1]:
                //navigateToURL(new URLRequest("http://kithio.com/login.php?username=" + Account._get().guid().toLowerCase() + "&password=" + Account._get().password()), "_blank");
                    //seems invalid atm, going to comment it out until i figure out a use for it later
                break;
            default:
                break;
        }
        SFXHandler.play("button_click");
    }
    public function draw():void{
        addChild(this.background_);
        addChild(this.text_);
        if (this.useImg_)
            addChild(this.icon_);
    }
}
}
