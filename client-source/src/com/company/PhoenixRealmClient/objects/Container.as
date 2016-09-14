// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.Container

package com.company.PhoenixRealmClient.objects {
import Panels.InventoryPanel;
import Panels.Panel;

import _vf.SFXHandler;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.map._X_l;
import com.company.util.PointUtil;

public class Container extends GameObject implements IPanelProvider {

    public function Container(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
        this._G_B_ = _arg1.hasOwnProperty("Loot");
        this.oneWay_ = _arg1.hasOwnProperty("OneWay");
        this.ownerId_ = -1;
    }
    public var _G_B_:Boolean;
    public var oneWay_:Boolean;
    public var ownerId_:int;

    override public function addTo(_arg1:_X_l, _arg2:Number, _arg3:Number):Boolean {
        if (!super.addTo(_arg1, _arg2, _arg3)) {
            return (false);
        }
        if (map_.player_ == null) {
            return (true);
        }
        var _local4:Number = PointUtil._R_O_(map_.player_.x_, map_.player_.y_, _arg2, _arg3);
        if (((this._G_B_) && ((_local4 < 10)))) {
            SFXHandler.play("loot_appears");
        }
        return (true);
    }

    public function _75(_arg1:int):void {
        this.ownerId_ = _arg1;
        UsesPanel = (((this.ownerId_ < 0)) || (this._X_w()));
    }

    public function _X_w():Boolean {
        return ((map_.player_.accountId_ == this.ownerId_));
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new InventoryPanel(_arg1, this));
    }

}
}//package com.company.PhoenixRealmClient.objects

