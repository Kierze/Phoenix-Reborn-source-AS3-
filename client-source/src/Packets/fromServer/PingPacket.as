// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011.Ping_

package Packets.fromServer {
import flash.utils.IDataInput;

public class PingPacket extends SvrPacketError {

    public function PingPacket(_arg1:uint) {
        super(_arg1);
    }
    public var serial_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.serial_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("PING", "serial_"));
    }

}
}//package _011

