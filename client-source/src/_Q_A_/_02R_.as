// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_Q_A_._02R_

package _Q_A_ {
import Frames.buyMoneyFrame;

import _00g._02U_;
import _00g._0H_i;

import _9R_._B_w;

import _zo._8C_;

import com.company.PhoenixRealmClient.appengine._02k;
import com.company.PhoenixRealmClient.util.offer.Offers;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

public class _02R_ extends Sprite {

    public function _02R_() {
        var _local1:Shape = new Shape();
        var _local2:Graphics = _local1.graphics;
        _local2.clear();
        _local2.beginFill(0, 0.8);
        _local2.drawRect(0, 0, 1024, 768);
        _local2.endFill();
        addChild(_local1);
        _02k._U_t("/credits", this._nK_);
    }
    private var _2m:Boolean;

    private function _nK_(_arg1:_8C_):void {
        var _local2:_0H_i = new _0H_i();
        _local2.addEventListener(Event.CANCEL, this.onCancel);
        _local2.addEventListener(Event.COMPLETE, this.onComplete);
        _local2._0J_E_ = new Offers(XML(_arg1.data_));
        _local2._yI_ = "€";
        _local2._Q_W_ = "";
        _local2._d0 = true;
        _local2._02Z_ = true;
        _local2._04Z_ = new _02U_();
        var _local3:buyMoneyFrame = new buyMoneyFrame(_local2);
        addChild(_local3);
    }

    private function onCancel(_arg1:Event):void {
        parent.removeChild(this);
    }

    private function onComplete(_arg1:Event):void {
        stage.addEventListener(Event.ACTIVATE, this._5h);
        parent.removeChild(this);
    }

    private function _5h(_arg1:Event):void {
        var _local2:Stage = (_arg1.target as Stage);
        _local2.dispatchEvent(new _B_w());
        _local2.removeEventListener(Event.ACTIVATE, this._5h);
    }

}
}//package _Q_A_

