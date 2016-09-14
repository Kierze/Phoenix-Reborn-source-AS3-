// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._f

package Panels {
import _sP_.MarketplaceContainerUI;

import com.company.PhoenixRealmClient.game.GameSprite;

import flash.events.MouseEvent;

public class MarketPanel extends TextPanel {

    public function MarketPanel(_arg1:GameSprite) {
        super(_arg1, "Marketplace", "View");
    }

    override protected function onButtonClick(_arg1:MouseEvent):void {
        gs_.mui_.clearInput();
        gs_.addChild(new MarketplaceContainerUI(gs_));
    }

}
}//package _R_v

