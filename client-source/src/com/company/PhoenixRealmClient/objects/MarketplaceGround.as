// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.GuildChronicle

package com.company.PhoenixRealmClient.objects {
import Panels.MarketPanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class MarketplaceGround extends GameObject implements IPanelProvider {

    public function MarketplaceGround(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new MarketPanel(_arg1));
    }

}
}//package com.company.PhoenixRealmClient.objects

