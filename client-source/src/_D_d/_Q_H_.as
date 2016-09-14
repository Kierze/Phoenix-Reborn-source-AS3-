// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d._Q_H_

package _D_d {
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.objects.ObjectLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;

internal class _Q_H_ extends _P_u {

    public function _Q_H_(_arg1:XML) {
        super(int(_arg1.@type));
        this._J_i = _arg1;
        var _local2:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_, 100, true, false);
        var _local3:Bitmap = new Bitmap(_local2);
        var _local4:Number = ((WIDTH - 4) / Math.max(_local3.width, _local3.height));
        _local3.scaleX = (_local3.scaleY = _local4);
        _local3.x = ((WIDTH / 2) - (_local3.width / 2));
        _local3.y = ((HEIGHT / 2) - (_local3.height / 2));
        addChild(_local3);
    }
    public var _J_i:XML;

    override protected function getToolTip():TooltipBase {
        return (new _9o(this._J_i));
    }

}
}//package _D_d

