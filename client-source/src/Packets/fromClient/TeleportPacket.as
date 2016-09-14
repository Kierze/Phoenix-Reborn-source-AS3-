// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g.Teleport

package Packets.fromClient {
import flash.utils.IDataOutput;

public class TeleportPacket extends CliPacketError {

    public function TeleportPacket(_arg1:uint) {
        super(_arg1);
    }
    public var objectId_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.objectId_);
    }

    override public function toString():String {
        return (formatToString("TELEPORT", "objectId_"));
    }

}
}//package _0A_g

