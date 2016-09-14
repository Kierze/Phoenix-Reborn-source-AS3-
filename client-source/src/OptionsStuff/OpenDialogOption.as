/**
 * Created by Fabian on 14.09.2015.
 */
package OptionsStuff {
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.events.Event;
import flash.events.MouseEvent;

public class OpenDialogOption extends _0_i {

    private var dialog:DialogOption;
    private var onChange:Function;
    private var button:Button;

    private static var lock:Boolean;

    public function OpenDialogOption(dialog:DialogOption, title:String, tooltip:String, onChange:Function) {
        super(dialog.optionsKey, title, tooltip);
        this.dialog = dialog;
        this.onChange = onChange;
        this.button = new Button();
        this.button.addEventListener(MouseEvent.CLICK, this.openDialog);
        addChild(this.button);
    }

    private function openDialog(event:MouseEvent):void {
        parent.addChild(this.dialog);
        this.dialog.addEventListener(Event.COMPLETE, this.onComplete);
        this.dialog.x = 400 - (this.dialog.width / 2);
        this.dialog.y = 300 - (this.dialog.height / 2);
        lock = true;
    }

    private function onComplete(event:Event):void {
        parent.removeChild(this.dialog);
        Parameters.ClientSaveData[_W_Y_] = dialog.value();
        Parameters.save();
        lock = false;
    }
}
}

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

class Button extends Sprite {

    public static const WIDTH:int = 80;
    public static const HEIGHT:int = 32;

    public function Button() {
        this.over = false;
        this.text = new SimpleText(16, 0xFFFFFF, false, WIDTH, HEIGHT, "Myriad Pro");
        this.text.setBold(true);
        this.text.htmlText = "<p align='center'>Select</p>";
        this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.text.updateMetrics();
        this.text.y = 5;
        addChild(this.text);
        this._rC_();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    public var over:Boolean;
    private var text:SimpleText;

    private function _rC_():void {
        var _local1:Graphics = graphics;
        _local1.clear();
        _local1.lineStyle(2, (this.over ? 0xB3B3B3 : Parameters._primaryColourLight2));
        _local1.beginFill(Parameters._primaryColourLight);
        _local1.drawRect(0, 0, WIDTH, HEIGHT);
        _local1.endFill();
        _local1.lineStyle();
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this.over = true;
        this._rC_();
    }

    private function onRollOut(_arg1:MouseEvent):void {
        this.over = false;
        this._rC_();
    }
}
