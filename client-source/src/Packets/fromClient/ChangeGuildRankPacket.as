// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._09F_

package Packets.fromClient {
import flash.utils.IDataOutput;

public class ChangeGuildRankPacket extends CliPacketError {

    public function ChangeGuildRankPacket(_arg1:uint) {
        super(_arg1);
    }
    public var name_:String;
    public var guildRank_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.name_);
        _arg1.writeInt(this.guildRank_);
    }

    override public function toString():String {
        return (formatToString("CHANGEGUILDRANK", "name_", "guildRank_"));
    }

}
}//package _0A_g

