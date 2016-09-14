// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._R_q

package Packets.fromClient {
import com.company.net.Packet;

import flash.utils.IDataInput;

public class CliPacketError extends Packet {

    public function CliPacketError(_arg1:uint) {
        super(_arg1);
    }

    final override public function parseFromInput(_arg1:IDataInput):void {
        throw (new Error((("Client should not receive " + id_) + " messages")));
    }

}
}//package _0A_g

