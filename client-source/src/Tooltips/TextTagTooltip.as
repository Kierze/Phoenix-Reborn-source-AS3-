// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7._aS_

package Tooltips {
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class TextTagTooltip extends TooltipBase {

    public function TextTagTooltip(_arg1:uint, _arg2:uint, _arg3:String, _arg4:String, _arg5:int) {
        super(_arg1, 1, _arg2, 1);
        if (_arg3 != null) {
            this._P_V_ = new SimpleText(20, 0xFFFFFF, false, _arg5, 0, "Myriad Pro");
            this._P_V_.setBold(true);
            this._P_V_.wordWrap = true;
            this._P_V_.text = _arg3;
            this._P_V_.updateMetrics();
            this._P_V_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this._P_V_);
        }
        if (_arg4 != null) {
            this._0B_A_ = new SimpleText(14, 0xB3B3B3, false, _arg5, 0, "Myriad Pro");
            this._0B_A_.wordWrap = true;
            this._0B_A_.y = (((this._P_V_) != null) ? (this._P_V_.height + 8) : 0);
            this._0B_A_.text = _arg4;
            this._0B_A_._08S_();
            this._0B_A_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this._0B_A_);
        }
    }
    public var _P_V_:SimpleText;
    public var _0B_A_:SimpleText;

    public function _N_k(_arg1:String):void {
        this._P_V_.text = _arg1;
        this._P_V_.updateMetrics();
        draw();
    }

    public function _02C_(_arg1:String):void {
        this._0B_A_.text = _arg1;
        this._0B_A_._08S_();
        draw();
    }

}
}//package _E_7

