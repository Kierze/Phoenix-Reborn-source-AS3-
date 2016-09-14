// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._0F_u

package Packets.fromServer {
import flash.utils.IDataInput;

public class ClientStatPacket extends SvrPacketError {

    public function ClientStatPacket(_arg1:uint) {
        super(_arg1);
    }
    public var name_:String;
    public var value_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.name_ = _arg1.readUTF();
        this.value_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("CLIENTSTAT", "name_", "value_"));
    }

}
}//package _011

