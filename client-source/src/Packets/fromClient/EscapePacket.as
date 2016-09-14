// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._0F_i

package Packets.fromClient {
import flash.utils.IDataOutput;

public class EscapePacket extends CliPacketError {

    public function EscapePacket(_arg1:uint) {
        super(_arg1);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
    }

    override public function toString():String {
        return (formatToString("ESCAPE"));
    }

}
}//package _0A_g

