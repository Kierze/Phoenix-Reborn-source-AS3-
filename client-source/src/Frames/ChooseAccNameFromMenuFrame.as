// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._A_t

package Frames {
import _qN_.Account;

import _zo._8C_;
import _zo._mS_;

import com.company.PhoenixRealmClient.appengine._0B_u;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.util._H_U_;
import com.company.util.keyboardKeys;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class ChooseAccNameFromMenuFrame extends Frame {

    public function ChooseAccNameFromMenuFrame() {
        super("Choose a unique account name", "Cancel", "Choose", "/newChooseName");
        this.name_ = new TextInput("Name", false, "");
        this.name_.inputText_.restrict = "A-Za-z";
        this.name_.inputText_.maxChars = 12;
        addTextInputBox(this.name_);
        addLabel("Maximum 12 characters");
        addLabel("No numbers, spaces or punctuation");
        addLabel("Racism or profanity gets you banned");
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this._J_p);
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }
    private var name_:TextInput;
    private var _zH_:_0B_u = null;

    private function onCancel(_arg1:MouseEvent):void {
        stage.focus = null;
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function _J_p(_arg1:MouseEvent):void {
        if (this.name_.text().length < 1) {
            this.name_._0B_T_("Name too short");
            return;
        }
        var _local2:_0B_u = new _0B_u(Parameters._fK_(), "/account", true);
        _local2.addEventListener(_8C_.GENERIC_DATA, this._E_0);
        _local2.addEventListener(_mS_.TEXT_ERROR, this._06Q_);
        var _local3:Object = {"name": this.name_.text()};
        _H_U_._t2(_local3, Account._get().credentials());
        _local2.sendRequest("setName", _local3);
        setAllButtonsGray();
    }

    private function _E_0(_arg1:_8C_):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function _06Q_(_arg1:_mS_):void {
        this.name_._0B_T_(_arg1.text_);
        setAllButtonsWhite();
    }

    private function onAdded(e:Event):void {
        this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onRemoved(e:Event):void {
        this.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onKeyPressed(e:KeyboardEvent):void {

        if (e.keyCode == keyboardKeys.ENTER) {
            this._J_p(null);
        }
    }

}
}//package _0D_d

