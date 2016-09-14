// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._T_K_

package Frames {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

public class AccNameChooseRect extends Sprite {

    public function AccNameChooseRect() {
        this.rect = new Shape();
        var _local1:Graphics = this.rect.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
        _local1.drawRect(0, 0, 1024, 768);
        _local1.endFill();
        addChild(this.rect);
        this.nameChooserFrame = new ChooseAccNameFromMenuFrame();
        this.nameChooserFrame.addEventListener(Event.CANCEL, this.onCancel);
        this.nameChooserFrame.addEventListener(Event.COMPLETE, this.onComplete);
        addChild(this.nameChooserFrame);
    }
    private var rect:Shape;
    private var nameChooserFrame:ChooseAccNameFromMenuFrame;

    private function onCancel(_arg1:Event):void {
        stage.focus = null;
        parent.removeChild(this);
    }

    private function onComplete(_arg1:Event):void {
        parent.removeChild(this);
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}//package _0D_d

