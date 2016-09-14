// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g.Buy

package Packets.fromClient {
import flash.utils.IDataOutput;

public class ChangeSpecPacket extends CliPacketError {

    public function ChangeSpecPacket(_arg1:uint) {
        super(_arg1);
    }
    public var specName_:String;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.specName_);
    }

    override public function toString():String {
        return (formatToString("CHANGESPEC", "specName_"));
    }

}
}//package _0A_g

