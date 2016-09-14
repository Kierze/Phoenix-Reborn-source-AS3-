// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011.CreateSuccess_

package Packets.fromServer {
import flash.utils.IDataInput;

public class CreateSuccessPacket extends SvrPacketError {

    public function CreateSuccessPacket(_arg1:uint) {
        super(_arg1);
    }
    public var objectId_:int;
    public var charId_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.objectId_ = _arg1.readInt();
        this.charId_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("CREATE_SUCCESS", "objectId_", "charId_"));
    }

}
}//package _011

