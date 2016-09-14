// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._lx

package Frames {
import _9R_._J_F_;

import com.company.PhoenixRealmClient.game.GameSprite;

import flash.events.Event;
import flash.events.MouseEvent;

public class CreateGuildFrame extends Frame {

    public function CreateGuildFrame(_arg1:GameSprite) {
        super("Create a new Guild", "Cancel", "Create", "/createGuild");
        this.gs_ = _arg1;
        this.name_ = new TextInput("Guild Name", false, "");
        this.name_.inputText_.restrict = "A-Za-z ";
        this.name_.inputText_.maxChars = 20;
        addTextInputBox(this.name_);
        addLabel("Maximum 20 characters");
        addLabel("No numbers or punctuation");
        addLabel("Racism or profanity gets your guild banned");
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this._U_p);
    }
    private var name_:TextInput;
    private var gs_:GameSprite;

    private function onCancel(_arg1:MouseEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function _U_p(_arg1:MouseEvent):void {
        this.gs_.addEventListener(_J_F_._hx, this._0J_I_);
        this.gs_.gsc_._S_W_(this.name_.text());
        setAllButtonsGray();
    }

    private function _0J_I_(_arg1:_J_F_):void {
        this.gs_.removeEventListener(_J_F_._hx, this._0J_I_);
        if (_arg1.success_) {
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        } else {
            this.name_._0B_T_(_arg1.errorText_);
            setAllButtonsWhite();
        }
    }

}
}//package _0D_d

