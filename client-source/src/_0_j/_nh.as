// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0_j._nh

package _0_j {
import _060._0F_z;
import _060._H_G_;
import _060._rp;

import com.company.util.keyboardKeys;

public class _nh extends _H_G_ {

    public static const _C_7:int = 0;
    public static const _3O_:int = 1;
    public static const _001:int = 2;
    public static const _mt:int = 3;

    public function _nh() {
        _6B_("(D)raw", keyboardKeys.D, this._0M_c, _3O_);
        _6B_("(E)rase", keyboardKeys.E, this._3, _001);
        _6B_("S(A)mple", keyboardKeys.A, this._bc, _mt);
        _6B_("(U)ndo", keyboardKeys.U, this._ck, _C_7);
        _6B_("(R)edo", keyboardKeys.R, this._0I_x, _C_7);
        _6B_("(C)lear", keyboardKeys.C, this._hm, _C_7);
        _034();
        _6B_("(L)oad", keyboardKeys.L, this._0E_o, _C_7);
        _6B_("(S)ave", keyboardKeys.S, this._na, _C_7);
    }

    private function _0M_c(_arg1:_0F_z):void {
        setSelected(_arg1);
    }

    private function _3(_arg1:_0F_z):void {
        setSelected(_arg1);
    }

    private function _bc(_arg1:_0F_z):void {
        setSelected(_arg1);
    }

    private function _ck(_arg1:_0F_z):void {
        dispatchEvent(new _rp(_rp.UNDO_COMMAND_EVENT));
    }

    private function _0I_x(_arg1:_0F_z):void {
        dispatchEvent(new _rp(_rp.REDO_COMMAND_EVENT));
    }

    private function _hm(_arg1:_0F_z):void {
        dispatchEvent(new _rp(_rp.CLEAR_COMMAND_EVENT));
    }

    private function _0E_o(_arg1:_0F_z):void {
        dispatchEvent(new _rp(_rp.LOAD_COMMAND_EVENT));
    }

    private function _na(_arg1:_0F_z):void {
        dispatchEvent(new _rp(_rp.SAVE_COMMAND_EVENT));
    }

}
}//package _0_j

