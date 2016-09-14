// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._S_p

package Panels {
import _6e._4L_;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.util._07E_;

import flash.events.MouseEvent;

public class GuildBoardPanel extends TextPanel {

    public function GuildBoardPanel(_arg1:GameSprite) {
        super(_arg1, "Guild Board", "View");
    }

    override protected function onButtonClick(_arg1:MouseEvent):void {
        var _local2:Player = gs_.map_.player_;
        if (_local2 == null) {
            return;
        }
        gs_.addChild(new _4L_((_local2.guildRank_ >= _07E_._f3)));
    }

}
}//package _R_v

