// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0L_C_._2k

package _0L_C_ {
import _qN_.Account;

import flash.events.Event;

public class GuestGuardDialog extends TwoButtonDialog {

    public function GuestGuardDialog(_arg1:String) {
        super(_arg1, "Not Registered", "Cancel", "Register", "/needRegister");
        addEventListener(BUTTON1_EVENT, this.onCancel);
        addEventListener(BUTTON2_EVENT, this.onRegister);
    }

    private function onCancel(_arg1:Event):void {
        parent.removeChild(this);
    }

    private function onRegister(_arg1:Event):void {
        Account._get().showInGameRegister(stage);
        parent.removeChild(this);
    }

}
}//package _0L_C_

