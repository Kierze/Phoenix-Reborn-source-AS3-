// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._ic

package Packets.fromServer {
import flash.utils.IDataInput;

public class MarketTradeResultPacket extends SvrPacketError {

    public function MarketTradeResultPacket(_arg1:uint) {
        super(_arg1);
    }
    public var success_:Boolean;
    public var errorText_:String;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.success_ = _arg1.readBoolean();
        this.errorText_ = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("MARKETTRADERESULT", "success_", "errorText_"));
    }

}
}//package _011

