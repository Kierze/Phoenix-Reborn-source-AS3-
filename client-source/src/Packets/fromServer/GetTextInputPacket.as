// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._08K_

package Packets.fromServer {
import flash.utils.IDataInput;

public class GetTextInputPacket extends SvrPacketError {

    public function GetTextInputPacket(_arg1:uint) {
        super(_arg1);
    }

    public var name_:String;
    public var action_:String;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.name_ = _arg1.readUTF();
        this.action_ = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("GETTEXTINPUT", "name_", "action_"));
    }

}
}//package _011

