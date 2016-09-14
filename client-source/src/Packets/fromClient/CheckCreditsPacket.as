// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._X_c

package Packets.fromClient {
import flash.utils.IDataOutput;

public class CheckCreditsPacket extends CliPacketError {

    public function CheckCreditsPacket(_arg1:uint) {
        super(_arg1);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
    }

    override public function toString():String {
        return (formatToString("CHECKCREDITS"));
    }

}
}//package _0A_g

