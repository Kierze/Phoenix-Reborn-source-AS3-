// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._zL_

package Panels {
import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class CharacterChangerPanel extends TextPanel {

    public function CharacterChangerPanel(_arg1:GameSprite) {
        super(_arg1, "Change Characters", "Change");
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    override protected function onButtonClick(_arg1:MouseEvent):void {
        this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if(event.keyCode == Parameters.ClientSaveData.interact){
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
}
}//package _R_v

