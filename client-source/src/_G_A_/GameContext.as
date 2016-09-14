// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_G_A_._8P_

package _G_A_ {
import _03T_._03;

import _eZ_._08b;

public class GameContext extends _03 {

    public static var _O_R_:_08b;

    public static function getInjector():_08b {
        return (_O_R_);
    }

    public function GameContext() {
        if (!GameContext._O_R_) {
            GameContext._O_R_ = this.getInjector;
        }
    }

}
}//package _G_A_

