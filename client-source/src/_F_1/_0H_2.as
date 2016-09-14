// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_F_1._0H_2

package _F_1 {
import _02t._R_f;

import _sp.Signal;

import com.company.PhoenixRealmClient.appengine._0K_R_;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.ui._0B_v;
import com.company.PhoenixRealmClient.ui._1B_v;
import com.company.graphic.ScreenGraphic;

import flash.events.Event;
import flash.events.MouseEvent;

public class _0H_2 extends _05p {

    public function _0H_2() {
        this._break = {};
        addChild(new _R_f());
        super(CurrentCharacterScreen);
        this.play = new Signal(int);
        this.close = new Signal();
    }
    public var close:Signal;
    public var play:Signal;
    private var _p6:titleTextButton;
    private var _H_t:_0B_v;
    private var _H_T_:_1B_v;
    private var _break:Object;

    override public function initialize(_arg1:_0K_R_):void {
        var _local2:int;
        var _local3:XML;
        var _local4:int;
        var _local5:String;
        var _local6:Boolean;
        var _local7:CharacterBox;
        super.initialize(_arg1);
        this._p6 = new titleTextButton("Back", 36, false);
        this._p6.addEventListener(MouseEvent.CLICK, this._0K_0);
        addChild(this._p6);
        this._H_t = new _0B_v();
        this._H_t.draw(_arg1.credits_, _arg1.fame_);
        addChild(this._H_t);
        this._H_T_ = new _1B_v();
        this._H_T_.draw(_arg1._silver);
        addChild(this._H_T_);
        _local2 = 0;
        while (_local2 < ObjectLibrary.playerClassObjects.length) {
            _local3 = ObjectLibrary.playerClassObjects[_local2];
            _local4 = int(_local3.@type);

            _local7 = new CharacterBox(_local3, _arg1.charStats_[_local4], _arg1);
            _local7.x = (((90 + (140 * int((_local2 % 6)))) + 70) - (_local7.width / 2));
            _local7.y = (120 + (140 * int((_local2 / 6))));
            this._break[_local4] = _local7;
            _local7.addEventListener(MouseEvent.ROLL_OVER, this._O_y);
            _local7.addEventListener(Event.ENTER_FRAME, this.spinEvent);
            _local7.addEventListener(Event.REMOVED_FROM_STAGE, this.remSpinEvent);
            _local7.addEventListener(MouseEvent.ROLL_OUT, this._02F_);
            if (_arg1.hasAvailableCharSlot()) {
                _local7.addEventListener(MouseEvent.CLICK, this._X_);
            }
            addChild(_local7);
            _local2++;
        }
        stage;
        this._p6.x = ((1024 / 2) - (this._p6.width / 2));
        this._p6.y = 710;
        stage;
        this._H_t.x = 1024;
        this._H_t.y = 20;
        stage;
        this._H_T_.x = 1024;
        this._H_T_.y = 44;
        //GA.global().trackPageview("/newCharScreen");
    }

    public function spinEvent(_arg1:Event):void {
        (_arg1.currentTarget as CharacterBox).tryUpdateSpin();
    }

    public function remSpinEvent(_arg1:Event):void {
        (_arg1.currentTarget as CharacterBox).removeEventListener(Event.ENTER_FRAME, this.spinEvent);
    }

    private function _0K_0(_arg1:Event):void {
        this.close.dispatch();
    }

    private function _O_y(_arg1:MouseEvent):void {
        var _local2:CharacterBox = (_arg1.currentTarget as CharacterBox);
        _local2._P_Y_(true);
        _local2.selectedOver = true;
        tooltip.dispatch(_local2.getTooltip());
    }

    private function _02F_(_arg1:MouseEvent):void {
        var _local2:CharacterBox = (_arg1.currentTarget as CharacterBox);
        _local2._P_Y_(false);
        _local2.selectedOver = false;
        tooltip.dispatch(null);
    }

    private function _X_(_arg1:MouseEvent):void {
        tooltip.dispatch(null);
        var _local2:CharacterBox = (_arg1.currentTarget as CharacterBox);
        if (!_local2._F_I_) {
            return;
        }
        var _local3:int = _local2.objectType();
        var _local4:String = ObjectLibrary.typeToDisplayId[_local3];
        //GA.global().trackEvent("character", "create", _local4);
        this.play.dispatch(_local3);
    }

}
}//package _F_1

