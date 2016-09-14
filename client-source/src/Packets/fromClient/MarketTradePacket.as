package Packets.fromClient {
import flash.utils.IDataOutput;

public class MarketTradePacket extends CliPacketError {

    public function MarketTradePacket(_arg1:uint) {
        super(_arg1);
    }

    public var tradeId_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.tradeId_);
    }

    override public function toString():String {
        return formatToString("MARKETTRADE", "tradeId_");
    }
}
}
