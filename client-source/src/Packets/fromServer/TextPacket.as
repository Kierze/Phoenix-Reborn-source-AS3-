// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011.Text_

package Packets.fromServer {
import flash.utils.IDataInput;

public class TextPacket extends SvrPacketError {

    public function TextPacket(_arg1:uint) {
        this.name_ = String("");
        this.text_ = String("");
        this.cleanText_ = String("");
        super(_arg1);
    }
    public var name_:String;
    public var objectId_:int;
    public var numStars_:int;
    public var bubbleTime_:uint;
    public var recipient_:String;
    public var text_:String;
    public var cleanText_:String;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.name_ = _arg1.readUTF();
        this.objectId_ = _arg1.readInt();
        this.numStars_ = _arg1.readInt();
        this.bubbleTime_ = _arg1.readUnsignedByte();
        this.recipient_ = _arg1.readUTF();
        this.text_ = _arg1.readUTF();
        this.cleanText_ = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("TEXT", "name_", "objectId_", "numStars_", "bubbleTime_", "recipient_", "text_", "cleanText_"));
    }

}
}//package _011

