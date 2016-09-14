package com.company.PhoenixRealmClient.objects
{
import Panels.InteractNPCPanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;

public class InteractNPC extends GameObject implements IPanelProvider
    {
        public var named:Boolean;
        public var isMerchant:Boolean;

        public function InteractNPC(_arg1:XML)
        {
            super(_arg1);
            if (this.CharName != null && this.CharTitle) named = true;

            UsesPanel = true;
        }

        public function getPanel(_arg1:GameSprite):Panel
        {
            return (new InteractNPCPanel(_arg1, this));
        }
    }
}

