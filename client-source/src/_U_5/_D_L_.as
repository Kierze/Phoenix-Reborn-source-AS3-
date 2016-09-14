// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_U_5._D_L_

package _U_5 {
import Packets.fromServer.MapInfoPacket;

import _sp.Signal;

public class _D_L_ extends Signal {

    private static var instance:_D_L_;

    public static function getInstance():_D_L_ {
        if (!instance) {
            instance = new (_D_L_)();
        }
        return (instance);
    }

    public function _D_L_() {
        super(MapInfoPacket);
        instance = this;
    }

}
}//package _U_5

