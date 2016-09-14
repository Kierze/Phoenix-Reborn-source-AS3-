package com.company.PhoenixRealmClient.objects {
import Panels.Panel;
import Panels.ReforgePanel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class Reforge extends GameObject implements IPanelProvider {
    public function Reforge(_arg1:XML) {
        super(_arg1);
        this.UsesPanel = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return new ReforgePanel(_arg1, this);
    }
}
}