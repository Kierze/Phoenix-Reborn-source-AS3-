// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._jM_

package com.company.PhoenixRealmClient.ui {
import _vf.SFXHandler;

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class TextButton extends Sprite {

    public function TextButton(_arg1:int, _arg2:Boolean, _arg3:String, _arg4:Boolean=false) {
        this.text_ = new SimpleText(_arg1, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.setBold(_arg2);
        this.text_.text = _arg3;
        this.text_.updateMetrics();
        addChild(this.text_);
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        this._g4_ = _arg4;
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }
    public var text_:SimpleText;
    public var _c9:int;
    public var _I_x:int;
    public var color:uint = 0xFFFFFF;
    public var _G3_:uint = 0xB3B3B3;
    private var _g4_:Boolean = false;

    public function _bu(_arg1:String):void {
        this.text_.text = _arg1;
        this.text_.updateMetrics();
        this.SetTextColor(0xB3B3B3);
        mouseEnabled = false;
        mouseChildren = false;
    }

    public function setTextColor(_arg1:uint):void {
        this.text_.setColor(_arg1);
    }

    public function SetTextColor(_arg1:uint):void {
        this.color = _arg1;
        this.setTextColor(this.color);
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this.setTextColor(16768133);
    }

    private function onMouseOut(_arg1:MouseEvent):void {
        if (this._g4_)
            this.setTextColor(this._G3_);
        else
            this.setTextColor(this.color);
    }

    private function onClick(_arg1:MouseEvent):void {
        SFXHandler.play("button_click");
    }

}
}//package com.company.PhoenixRealmClient.ui

