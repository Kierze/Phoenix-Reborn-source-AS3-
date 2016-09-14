// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g.PlayerText_

package Packets.fromClient {
import flash.utils.IDataOutput;

public class PlayerTextPacket extends CliPacketError {

    public function PlayerTextPacket(_arg1:uint) {
        this.text_ = String("");
        super(_arg1);
    }
    public var text_:String;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.text_);
    }

    override public function toString():String {
        return (formatToString("PLAYERTEXT", "text_"));
    }

}
}//package _0A_g

