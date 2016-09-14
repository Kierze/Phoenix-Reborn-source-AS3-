// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d._0E_w

package _D_d {
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.map._sn;

import flash.display.Shape;

public class _0E_w extends _P_u {

    public function _0E_w(_arg1:XML) {
        super(int(_arg1.@type));
        this._hI_ = _arg1;
        var _local2:Shape = new Shape();
        _local2.graphics.beginFill(_sn.getColor(type_), 0.5);
        _local2.graphics.drawRect(0, 0, (WIDTH - 8), (HEIGHT - 8));
        _local2.graphics.endFill();
        _local2.x = ((WIDTH / 2) - (_local2.width / 2));
        _local2.y = ((HEIGHT / 2) - (_local2.height / 2));
        addChild(_local2);
    }
    public var _hI_:XML;

    override protected function getToolTip():TooltipBase {
        return (new _D_M_(this._hI_));
    }

}
}//package _D_d

