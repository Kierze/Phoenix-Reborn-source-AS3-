// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zm._01c

package _zm {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class DropdownList extends Sprite {

    public function DropdownList(_arg1:Vector.<String>, _arg2:int, _arg3:int, _arg4:String = null) {
        this._2s = new Sprite();
        super();
        this.options = _arg1;
        this.width_ = _arg2;
        this.height_ = _arg3;
        if (_arg4 != null) {
            this.labelText_ = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            this.labelText_.setBold(true);
            this.labelText_.text = (_arg4 + ":");
            this.labelText_.updateMetrics();
            addChild(this.labelText_);
            this._zT_ = (this.labelText_.width + 5);
        }
        this.setSelectedByArray(0);
    }
    protected var options:Vector.<String>;
    protected var width_:int;
    protected var height_:int;
    protected var labelText_:SimpleText;
    protected var _zT_:int = 0;
    protected var selected_:_fp;
    protected var _2s:Sprite;

    public function getValue():String {
        return (this.selected_.getValue());
    }

    public function setValue(_arg1:String):void {
        var _local2:int = 0;
        while (_local2 < this.options.length) {
            if (_arg1 == this.options[_local2]) {
                this.setSelectedByArray(_local2);
                return;
            }
            _local2++;
        }
    }

    public function setSelectedByArray(_arg1:int):void {
        this.setSelected(this.options[_arg1]);
    }

    public function _0K_M_():int {
        var _local1:int = 0;
        while (_local1 < this.options.length) {
            if (this.selected_.getValue() == this.options[_local1]) {
                return (_local1);
            }
            _local1++;
        }
        return (-1);
    }

    private function setSelected(_arg1:String):void {
        var _local2:String = (((this.selected_) != null) ? this.selected_.getValue() : null);
        this.selected_ = new _fp(_arg1, this.width_, this.height_);
        this.selected_.x = this._zT_;
        this.selected_.y = 0;
        addChild(this.selected_);
        this.selected_.addEventListener(MouseEvent.CLICK, this._021);
        if (_arg1 != _local2) {
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    private function _022():void {
        var _local2:Point;
        var _local4:_fp;
        var _local1:int;
        _local2 = parent.localToGlobal(new Point(x, y));
        this._2s.x = _local2.x;
        this._2s.y = _local2.y;
        var _local3:int = 0;
        while (_local3 < this.options.length) {
            _local4 = new _fp(this.options[_local3], this.width_, this.height_);
            _local4.addEventListener(MouseEvent.CLICK, this._cj);
            _local4.x = this._zT_;
            _local4.y = _local1;
            this._2s.addChild(_local4);
            _local1 = (_local1 + _local4.height_);
            _local3++;
        }
        this._2s.addEventListener(MouseEvent.ROLL_OUT, this._uH_);
        stage.addChild(this._2s);
    }

    private function _1c():void {
        this._2s.removeEventListener(MouseEvent.ROLL_OUT, this._uH_);
        stage.removeChild(this._2s);
    }

    private function _021(_arg1:MouseEvent):void {
        _arg1.stopImmediatePropagation();
        this.selected_.removeEventListener(MouseEvent.CLICK, this._021);
        if (contains(this.selected_)) {
            removeChild(this.selected_);
        }
        this._022();
    }

    private function _cj(_arg1:MouseEvent):void {
        _arg1.stopImmediatePropagation();
        this._1c();
        var _local2:_fp = (_arg1.target as _fp);
        this.setSelected(_local2.getValue());
    }

    private function _uH_(_arg1:MouseEvent):void {
        this._1c();
        this.setSelected(this.selected_.getValue());
    }

}
}//package _zm

