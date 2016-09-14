// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.tutorial.doneAction

package com.company.PhoenixRealmClient.tutorial {
import com.company.PhoenixRealmClient.game.GameSprite;

public function doneAction(_arg1:GameSprite, _arg2:String):void {
    if (_arg1.tutorial_ == null) {
        return;
    }
    _arg1.tutorial_.doneAction(_arg2);
}
}//package com.company.PhoenixRealmClient.tutorial

