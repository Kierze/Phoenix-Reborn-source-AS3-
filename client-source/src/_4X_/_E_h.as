// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_4X_._E_h

package _4X_ {


public class _E_h {

    public function _E_h() {
        this._A_X_ = new <Task>[];
    }
    private var _A_X_:Vector.<Task>;

    public function add(_arg1:Task):void {
        this._A_X_.push(_arg1);
        _arg1._iu.addOnce(this._T_T_);
    }

    public function _fw(_arg1:Task):Boolean {
        return (!((this._A_X_.indexOf(_arg1) == -1)));
    }

    private function _T_T_(_arg1:Task, _arg2:Boolean, _arg3:String = ""):void {
        this._A_X_.splice(this._A_X_.indexOf(_arg1), 1);
    }

}
}//package _4X_

