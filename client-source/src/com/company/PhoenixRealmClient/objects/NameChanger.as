// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.NameChanger

package com.company.PhoenixRealmClient.objects {
import Panels.NameChangePanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class NameChanger extends GameObject implements IPanelProvider {

    public function NameChanger(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
    }
    public var _0I_a:int = 0;

    public function _Y__(_arg1:int):void {
        this._0I_a = _arg1;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new NameChangePanel(_arg1, this._0I_a));
    }

}
}//package com.company.PhoenixRealmClient.objects

