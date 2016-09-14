// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_Q_A_._0L_h

package _Q_A_ {
import Frames.CheckBox;
import Frames.Frame;
import Frames.TextInput;

import _qN_.Account;

import _zo._8C_;
import _zo._mS_;

import com.company.PhoenixRealmClient.appengine._0B_u;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.TextButton;
import com.company.util._9S_;
import com.company.util.keyboardKeys;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

internal class _0L_h extends Frame {

    public function _0L_h(_arg1:Boolean = true) {
        super("Register in order to enter the server!", "Cancel", "Register", "/registerAccount");
        this.username_ = new TextInput("Username", false, "");
        addTextInputBox(this.username_);
        this.email_ = new TextInput("Email", false, "");
        addTextInputBox(this.email_);
        this.password_ = new TextInput("Password", true, "");
        addTextInputBox(this.password_);
        this.password2_ = new TextInput("Retype Password", true, "");
        addTextInputBox(this.password2_);
        this._8n = new CheckBox((('I agree to the <font color="#EA533F"><a href="' + Parameters.ToS_Url_) + '" target="_blank">Terms of Phoenix</a></font>.'), false, "");
        addCheckBox(this._8n);
        if (_arg1) {
            this._k4 = new TextButton(12, false, "Already Registered?  Click here to Sign In");
            addTextButton(this._k4);
        }
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this._mO_);
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        if (_arg1) {
            this._k4.addEventListener(MouseEvent.CLICK, this._q5);
        }
    }
    public var username_:TextInput;
    public var email_:TextInput;
    public var password_:TextInput;
    public var password2_:TextInput;
    public var _8n:CheckBox;
    public var _k4:TextButton;

    private function onCancel(_arg1:MouseEvent):void {
        dispatchEvent(new _nJ_(_nJ_.DONE));
    }

    private function _mO_(_arg1:MouseEvent):void {
        if (!_9S_._02A_(this.username_.text())) {
            this.username_._0B_T_("Invalid username!");
            return;
        }
        if (!_9S_.isEmail(this.email_.text())) {
            this.email_._0B_T_("Invalid email address!");
            return;
        }
        if (this.password_.text().length < 5) {
            this.password_._0B_T_("Password too short!");
            return;
        }
        if (this.password_.text() != this.password2_.text()) {
            this.password2_._0B_T_("Passwords do not match!");
            return;
        }
        if (!this._8n._u6()) {
            this._8n._0B_T_("Must agree to register!");
            return;
        }
        var _local2:_0B_u = new _0B_u(Parameters._fK_(), "/account", true);
        _local2.addEventListener(_8C_.GENERIC_DATA, this._Q__);
        _local2.addEventListener(_mS_.TEXT_ERROR, this._J_o);
        _local2.sendRequest("register", {
            "guid": Account._get().guid(),
            "newGUID": this.username_.text(),
            "email": this.email_.text(),
            "newPassword": this.password_.text(),
            "entrytag": Account._get().entrytag()
        });
        setAllButtonsGray();
    }

    private function _Q__(_arg1:_8C_):void {
        //GA.global().trackEvent("account", "accountRegistered");
        Account._get().modify(this.username_.text(), this.password_.text(), null);
        dispatchEvent(new _nJ_(_nJ_._tp));
    }

    private function _J_o(_arg1:_mS_):void {
        this.username_._0B_T_(_arg1.text_);
        setAllButtonsWhite();
    }

    private function _q5(_arg1:MouseEvent):void {
        dispatchEvent(new _nJ_(_nJ_._2K_));
    }

    private function onAdded(e:Event):void {
        this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onRemoved(e:Event):void {
        this.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onKeyPressed(e:KeyboardEvent):void {

        if (e.keyCode == keyboardKeys.ENTER) {
            this._mO_(null);
        }
    }

}
}//package _Q_A_

