// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._039

package Packets.fromServer {
import flash.utils.IDataInput;

public class InvitedToGuildPacket extends SvrPacketError {

    public function InvitedToGuildPacket(_arg1:uint) {
        super(_arg1);
    }
    public var name_:String;
    public var guildName_:String;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.name_ = _arg1.readUTF();
        this.guildName_ = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("INVITEDTOGUILD", "name_", "guildName_"));
    }

}
}//package _011

