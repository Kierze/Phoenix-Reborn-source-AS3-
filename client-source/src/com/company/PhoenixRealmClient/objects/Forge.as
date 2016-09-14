package com.company.PhoenixRealmClient.objects {
import Panels.ForgePanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class Forge extends GameObject implements IPanelProvider {

    public function Forge(param1:XML) {
        super(param1);
        UsesPanel = true;
    }

    public function getPanel(param1:GameSprite):Panel {
        return new ForgePanel(param1, this);
    }
}
}
