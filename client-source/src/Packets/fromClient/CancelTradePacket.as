// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._vp

package Packets.fromClient {
import flash.utils.IDataOutput;

public class CancelTradePacket extends CliPacketError {

    public function CancelTradePacket(_arg1:uint) {
        super(_arg1);
    }
    public var objectId_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
    }

    override public function toString():String {
        return (formatToString("CANCELTRADE"));
    }

}
}//package _0A_g

