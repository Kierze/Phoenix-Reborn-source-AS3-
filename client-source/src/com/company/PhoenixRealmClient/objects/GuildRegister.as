// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.GuildRegister

package com.company.PhoenixRealmClient.objects {
import Panels.GuildCreateRenouncePanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class GuildRegister extends GameObject implements IPanelProvider {

    public function GuildRegister(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new GuildCreateRenouncePanel(_arg1));
    }

}
}//package com.company.PhoenixRealmClient.objects

