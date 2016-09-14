// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._8x

package Frames {
import _9R_._3E_;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.util.keyboardKeys;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class ChooseAccNameFromPanelFrame extends Frame
{

    public function ChooseAccNameFromPanelFrame(_arg1:GameSprite, _arg2:Boolean)
    {
        super("Choose a unique account name", "Cancel", "Choose", "/chooseName");
        this.gs_ = _arg1;
        this.nameChosen = _arg2;
        this.name_ = new TextInput("Name", false, "");
        this.name_.inputText_.restrict = "A-Za-z";
        this.name_.inputText_.maxChars = 12;
        addTextInputBox(this.name_);
        addLabel("Maximum 12 characters");
        addLabel("No numbers, spaces or punctuation");
        addLabel("Racism or profanity gets you banned");
        Button1.addEventListener(MouseEvent.CLICK, this.onCancel);
        Button2.addEventListener(MouseEvent.CLICK, this.onChoose);
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }
    private var name_:TextInput;
    private var gs_:GameSprite;
    private var nameChosen:Boolean;

    public function receiveNameResultEvent(_arg1:_3E_):void
    {
        this.gs_.removeEventListener(_3E_.NAMERESULTEVENT, this.receiveNameResultEvent);
        if (_arg1._yS_.success_)
        {
            /*if (this.nameChosen) {
                GA.global().trackEvent("credits", ((this._gameSprite.charList_.converted_) ? "buyConverted" : "buy"), "Name Change", Parameters._0u);
            }*/
            this.gs_.charList_.name_ = this.name_.text();
            this.gs_.HudView._02y.setName(this.name_.text());
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        else
        {
            this.name_._0B_T_(_arg1._yS_.errorText_);
            setAllButtonsWhite();
        }
    }

    private function onCancel(_arg1:MouseEvent):void
    {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onChoose(_arg1:MouseEvent):void
    {
        this.gs_.addEventListener(_3E_.NAMERESULTEVENT, this.receiveNameResultEvent);
        this.gs_.gsc_._K_Q_(this.name_.text());
        setAllButtonsGray();
    }

    private function onAdded(e:Event):void
    {
        this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onRemoved(e:Event):void
    {
        this.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPressed);
    }

    private function onKeyPressed(e:KeyboardEvent):void
    {
        if (e.keyCode == keyboardKeys.ENTER)
        {
            this.onChoose(null);
        }
    }

}
}//package _0D_d

