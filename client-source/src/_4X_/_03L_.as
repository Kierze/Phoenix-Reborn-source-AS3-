// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_4X_._03L_

package _4X_ {
import _sp.Signal;

public class _03L_ extends Task {

    public function _03L_(_arg1:Signal, ..._args) {
        this._xA_ = _arg1;
        this._5g = _args;
    }
    private var _xA_:Signal;
    private var _5g:Array;

    override protected function startTask():void {
        this._xA_.dispatch.apply(null, this._5g);
        _C_t(true);
    }

}
}//package _4X_

