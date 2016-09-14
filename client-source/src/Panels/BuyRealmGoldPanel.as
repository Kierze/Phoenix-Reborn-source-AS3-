package Panels {
import _qN_.Account;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Chat;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class BuyRealmGoldPanel extends TextPanel
    {
        public function BuyRealmGoldPanel(_arg1:GameSprite)
        {
            super(_arg1, "Buy Realm Gold", "Buy");
            Account._get().cacheOffers();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        override protected function onButtonClick(_arg1:MouseEvent):void
        {
            Account._get().showMoneyManagement(stage);
        }

        private function onRemovedFromStage(_arg1:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._0A_Y_);
        }

        private function onAddedToStage(_arg1:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this._0A_Y_);
        }

        private function _0A_Y_(_arg1:KeyboardEvent):void
        {
            if ((_arg1.keyCode == Parameters.ClientSaveData.interact) && !Chat._0G_B_)
            {
                Account._get().showMoneyManagement(stage);
            }
        }
    }
}

