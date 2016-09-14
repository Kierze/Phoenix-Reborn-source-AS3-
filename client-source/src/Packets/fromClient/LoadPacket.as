// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._r5

package Packets.fromClient {
import flash.utils.IDataOutput;

public class LoadPacket extends CliPacketError {

    public function LoadPacket(_arg1:uint) {
        super(_arg1);
    }
    public var charId_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.charId_);
    }

    override public function toString():String {
        return (formatToString("LOAD", "charId_"));
    }

}
}//package _0A_g

