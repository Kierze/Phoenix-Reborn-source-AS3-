// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._Y_F_

package Packets.fromServer {
import flash.utils.IDataInput;

public class QuestObjIdPacket extends SvrPacketError {

    public function QuestObjIdPacket(_arg1:uint) {
        super(_arg1);
    }
    public var objectId_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.objectId_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("QUESTOBJID", "objectId_"));
    }

}
}//package _011

