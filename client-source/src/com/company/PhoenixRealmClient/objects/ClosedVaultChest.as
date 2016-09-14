// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.ClosedVaultChest

package com.company.PhoenixRealmClient.objects {
import Tooltips.TextTagTooltip;
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.display.BitmapData;

public class ClosedVaultChest extends SellableObject {

    public function ClosedVaultChest(_arg1:XML) {
        super(_arg1);
    }

    override public function soldObjectName():String {
        return ("Vault Chest");
    }

    override public function soldObjectInternalName():String {
        return ("Vault Chest");
    }

    override public function getTooltip():TooltipBase {
        return (new TextTagTooltip(Parameters._primaryColourDefault, 0x9B9B9B, this.soldObjectName(), ("A chest that will safely store 8 items and is " + "accessible by all of your characters."), 200));
    }

    override public function getIcon():BitmapData {
        return (ObjectLibrary.getRedrawnTextureFromType(ObjectLibrary.idToType["Vault Chest"], 80, true));
    }

}
}//package com.company.PhoenixRealmClient.objects

