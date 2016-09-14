// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zm._fp

package _zm {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class _fp extends Sprite {

    public function _fp(_arg1:String, _arg2:int, _arg3:int) {
        this.width_ = _arg2;
        this.height_ = _arg3;
        this.nameText_ = new SimpleText(16, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.text = _arg1;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.nameText_.x = ((this.width_ / 2) - (this.nameText_.width / 2));
        this.nameText_.y = ((this.height_ / 2) - (this.nameText_.height / 2));
        addChild(this.nameText_);
        this._rC_(Parameters._primaryColourDefault);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
    }
    public var width_:int;
    public var height_:int;
    private var nameText_:SimpleText;

    public function getValue():String {
        return (this.nameText_.text);
    }

    private function _rC_(_arg1:uint):void {
        graphics.clear();
        graphics.lineStyle(1, 0xB3B3B3);
        graphics.beginFill(_arg1, 1);
        graphics.drawRect(0, 0, this.width_, this.height_);
        graphics.endFill();
        graphics.lineStyle();
    }

    private function onMouseOver(_arg1:MouseEvent):void {
        this._rC_(Parameters._primaryColourLight);
    }

    private function onMouseOut(_arg1:MouseEvent):void {
        this._rC_(Parameters._primaryColourDefault);
    }

}
}//package _zm

