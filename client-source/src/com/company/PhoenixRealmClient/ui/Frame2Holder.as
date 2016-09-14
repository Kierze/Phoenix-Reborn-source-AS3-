/**
 * Created by vooolox on 07-2-2016.
 */
package com.company.PhoenixRealmClient.ui {
import Frames.Frame2;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Frame2Holder extends Sprite {

    public function Frame2Holder(frame:Frame2) {
        this.dimScreen = new Shape();
        var _local2:Graphics = this.dimScreen.graphics;
        _local2.clear();
        _local2.beginFill(0, 0.8);
        _local2.drawRect(0, 0, 1024, 768);
        _local2.endFill();
        addChild(this.dimScreen);
        this.frame = frame;
        this.frame.addEventListener(Event.COMPLETE, this.onComplete);
        this.frame.addEventListener(MouseEvent.MOUSE_DOWN, startMove);
        this.frame.addEventListener(MouseEvent.MOUSE_UP, stopMove);
        addChild(this.frame);
    }
    private var frame:Frame2;
    private var dimScreen:Shape;

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