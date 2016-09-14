// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._08K_

package Packets.fromServer {
import flash.utils.IDataInput;

public class InvResultPacket extends SvrPacketError {

    public function InvResultPacket(_arg1:uint) {
        super(_arg1);
    }
    public var result_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.result_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("INVRESULT", "result_"));
    }

}
}//package _011

