/**
 * Created by vooolox on 07-2-2016.
 */
package com.company.PhoenixRealmClient.ui {
import Frames.Frame2;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Frame2HolderNoDim extends Sprite {

    public function Frame2HolderNoDim(frame:Frame2) {

        this.frame = frame;
        this.frame.addEventListener(Event.COMPLETE, this.onComplete);
        this.frame.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
        this.frame.addEventListener(MouseEvent.MOUSE_UP, stopMove);
        addChild(this.frame);
    }
    private var frame:Frame2;

    private function onComplete(_arg1:Event):void {
        parent.removeChild(this);
    }

    internal function startMove(evt:MouseEvent):void {
        frame.startDrag();
    }
    internal function stopMove(e:MouseEvent):void {
        frame.stopDrag();
    }
}
}