// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_F_1._E_r

package _F_1 {

import _qN_.Account;

import _sp.Signal;

import com.company.graphic.ScreenGraphic;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class _E_r extends Sprite {

    public function _E_r() {
        this._j7 = new SimpleText(30, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this._j7.setBold(true);
        this._j7.htmlText = '<p align="center">Loading...</p>';
        this._j7.autoSize = TextFieldAutoSize.CENTER;
        this._j7.updateMetrics();
        this._j7.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        addChild(this._j7);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this._J_b = new Signal();
    }
    public var _J_b:Signal;
    private var _j7:SimpleText;

    private function _D_I_():void {
        Account.load(stage, this._0L_);
    }

    private function _0L_():void {
        this._J_b.dispatch();
    }

    protected function onAddedToStage(_arg1:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this._j7.x = ((1024 / 2) - (this._j7.width / 2));
        this._j7.y = 710;
        this._D_I_();
    }
}
}//package _F_1

