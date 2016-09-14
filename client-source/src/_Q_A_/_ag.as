// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_Q_A_._ag

package _Q_A_ {
import Frames.Frame;
import Frames.TextInput;

import _qN_.Account;

import _zo._8C_;
import _zo._mS_;

import com.company.PhoenixRealmClient.appengine._0B_u;
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.events.MouseEvent;

internal class _ag extends Frame {

    public function _ag() {
        super("Change your password", "Cancel", "Submit", "/changePassword");
        this.password_ = new TextInput("Password", true, "");
        addTextInputBox(this.password_);
        this._sY_ = new TextInput("New Password", true, "");
        addTextInputBox(this._sY_);
        this._a9 = new TextInput("Retype New Password", true, "");
        addTextInputBox(this._a9);
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this._bR_);
    }
    public var password_:TextInput;
    public var _sY_:TextInput;
    public var _a9:TextInput;

    private function onCancel(_arg1:MouseEvent):void {
        dispatchEvent(new _nJ_(_nJ_._tp));
    }

    private function _bR_(_arg1:MouseEvent):void {
        if (this.password_.text().length < 5) {
            this.password_._0B_T_("Incorrect password");
            return;
        }
        if (this._sY_.text().length < 5) {
            this._sY_._0B_T_("Password too short");
            return;
        }
        if (this._sY_.text() != this._a9.text()) {
            this._a9._0B_T_("Password does not match");
            return;
        }
        var _local2:_0B_u = new _0B_u(Parameters._fK_(), "/account", true);
        _local2.addEventListener(_8C_.GENERIC_DATA, this._0K_H_);
        _local2.addEventListener(_mS_.TEXT_ERROR, this._1X_);
        _local2.sendRequest("changePassword", {
            "guid": Account._get().guid(),
            "password": this.password_.text(),
            "newPassword": this._sY_.text()
        });
        setAllButtonsGray();
    }

    private function _0K_H_(_arg1:_8C_):void {
        //GA.global().trackEvent("account", "passwordChanged");
        Account._get().modify(Account._get().guid(), this._sY_.text(), null);
        dispatchEvent(new _nJ_(_nJ_._tp));
    }

    private function _1X_(_arg1:_mS_):void {
        this.password_._0B_T_(_arg1.text_);
        setAllButtonsWhite();
    }

}
}//package _Q_A_

