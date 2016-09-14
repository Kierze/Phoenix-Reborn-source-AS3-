// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._Y_G_

package Packets.fromServer {
import flash.utils.IDataInput;

public class TradeRequestedPacket extends SvrPacketError {

    public function TradeRequestedPacket(_arg1:uint) {
        super(_arg1);
    }
    public var name_:String;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.name_ = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("TRADEREQUESTED", "name_"));
    }

}
}//package _011

