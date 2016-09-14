/**
 * Created by Thelzar on 7/20/2014.
 */
package com.company.PhoenixRealmClient.util {
import GameAssets.EmbedSprites.buttonEmbed;

import _sp.Signal;

import flash.display.Sprite;
import flash.events.MouseEvent;

public class xButtonSquare extends Sprite {

    public static var _str2539:Class = buttonEmbed;
    //probably the X button sprite for forms
    public const event:Signal = new Signal();

    public var disabled:Boolean = false;

    public function xButtonSquare() {
        addChild(new _str2539());
        buttonMode = true;
        addEventListener(MouseEvent.CLICK, this.onButtonClick);
    }
    public function disable():void{
        this.disabled = true;
        removeEventListener(MouseEvent.CLICK, this.onButtonClick);
    }
    private function onButtonClick(_arg1:MouseEvent):void{
        if (!this.disabled) {
            this.event.dispatch();
            removeEventListener(MouseEvent.CLICK, this.onButtonClick);
        }
    }
}
}
