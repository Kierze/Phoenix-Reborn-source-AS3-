// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.GuildHallPortal

package com.company.PhoenixRealmClient.objects {
import Panels.EnterGuildPortalPanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class GuildHallPortal extends GameObject implements IPanelProvider {

    public function GuildHallPortal(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new EnterGuildPortalPanel(_arg1, this));
    }

}
}//package com.company.PhoenixRealmClient.objects

