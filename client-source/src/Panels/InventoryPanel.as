// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._sc

package Panels {

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Container;
import com.company.PhoenixRealmClient.ui.Inventory;
import com.company.PhoenixRealmClient.ui.Slot;

public class InventoryPanel extends Panel {

    private static const _hP_:Vector.<int> = new <int>[Slot.anySlot, Slot.anySlot, Slot.anySlot, Slot.anySlot, Slot.anySlot, Slot.anySlot, Slot.anySlot, Slot.anySlot];

    public function InventoryPanel(_arg1:GameSprite, _arg2:Container) {
        super(_arg1);
        this._e9 = new Inventory(gs_, _arg2, _arg2._include(), _hP_, 8, false, 0, false, int(_arg2.oneWay_));
        this._e9.x = 8;
        addChild(this._e9);
    }
    public var _e9:Inventory;

    override public function draw():void {
        this._e9.draw(this._e9._iA_.equipment_);
    }

}
}//package _R_v

