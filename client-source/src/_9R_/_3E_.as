// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_9R_._3E_

package _9R_ {
import Packets.fromServer.NameResultPacket;

import flash.events.Event;

public class _3E_ extends Event {

    public static const NAMERESULTEVENT:String = "NAMERESULTEVENT";

    public function _3E_(_arg1:NameResultPacket) {
        super(NAMERESULTEVENT);
        this._yS_ = _arg1;
    }
    public var _yS_:NameResultPacket;
}
}//package _9R_

