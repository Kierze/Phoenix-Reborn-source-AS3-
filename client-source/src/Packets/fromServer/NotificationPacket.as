// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._01R_

package Packets.fromServer {
import flash.utils.IDataInput;

public class NotificationPacket extends SvrPacketError {

    public function NotificationPacket(_arg1:uint) {
        super(_arg1);
    }
    public var objectId_:int;
    public var text_:String;
    public var color_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.objectId_ = _arg1.readInt();
        this.text_ = _arg1.readUTF();
        this.color_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("NOTIFICATION", "objectId_", "text_", "color_"));
    }

}
}//package _011

