// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._V_3

package Packets.fromClient {
import flash.utils.IDataOutput;

public class PartyInvitePacket extends CliPacketError {

    public function PartyInvitePacket(_arg1:uint) {
        super(_arg1);
    }
    public var name_:String;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.name_);
    }

    override public function toString():String {
        return (formatToString("PARTYINVITE", "name_"));
    }

}
}//package _0A_g

