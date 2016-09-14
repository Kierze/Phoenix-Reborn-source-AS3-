// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._bG_

package Packets.fromClient {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataOutput;

public class AOEAckPacket extends CliPacketError {

    public function AOEAckPacket(_arg1:uint) {
        this.position_ = new Position();
        super(_arg1);
    }
    public var time_:int;
    public var position_:Position;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.time_);
        this.position_.writeToOutput(_arg1);
    }

    override public function toString():String {
        return (formatToString("AOEACK", "time_", "position_"));
    }

}
}//package _0A_g

