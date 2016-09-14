// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._zX_

package com.company.PhoenixRealmClient.ui {
import _vf.MusicHandler;
import _vf._Q_P_;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

public class MuteButton extends Sprite {

    public function MuteButton() {
        this.bitmap_ = new Bitmap();
        super();
        addChild(this.bitmap_);
        this.bitmap_.scaleX = 1;
        this.bitmap_.scaleY = 1;
        this.reDraw();
        addEventListener(MouseEvent.CLICK, this._iK_);
        filters = [new GlowFilter(0, 1, 4, 4, 2, 1)];
    }
    private var bitmap_:Bitmap;

    private function reDraw():void {
        this.bitmap_.bitmapData = ((Parameters.ClientSaveData.playMusic || Parameters.ClientSaveData.playSFX) ? AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 3) : AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 4));
    }

    private function _iK_(_arg1:MouseEvent):void {
        var soundOn = !(Parameters.ClientSaveData.playMusic || Parameters.ClientSaveData.playSFX);
        MusicHandler._continue(soundOn);
        _Q_P_._2c(soundOn);
        Parameters.ClientSaveData.playPewPew = soundOn;
        Parameters.save();
        this.reDraw();
    }

}
}//package com.company.PhoenixRealmClient.ui

