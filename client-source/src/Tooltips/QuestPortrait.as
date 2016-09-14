// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7._C_8

package Tooltips {
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class QuestPortrait extends TooltipBase {

    public function QuestPortrait(_arg1:GameObject) {
        super(6036765, 1, 16549442, 1, false);
        this._tm = new Bitmap();
        this._tm.x = 0;
        this._tm.y = 0;
        var _local2:BitmapData = _arg1.getPortrait();
        _local2 = BitmapUtil.getRectanglefromBitmap(_local2, 10, 10, (_local2.width - 20), (_local2.height - 20));
        this._tm.bitmapData = _local2;
        addChild(this._tm);
        filters = [];
    }
    private var _tm:Bitmap;
}
}//package _E_7

