// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._0G_8

package Packets.fromClient {
import flash.utils.IDataOutput;

public class JoinPartyPacket extends CliPacketError {

    public function JoinPartyPacket(_arg1:uint) {
        super(_arg1);
    }
    public var partyID_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.partyID_);
    }

    override public function toString():String {
        return (formatToString("JOINPARTY", "partyID_"));
    }

}
}//package _0A_g

