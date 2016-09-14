// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g.UseItem_

package Packets.fromClient {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataOutput;

public class UseAbilityPacket extends CliPacketError {

    public function UseAbilityPacket(_arg1:uint) {
        this.itemUsePos_ = new Position();
        super(_arg1);
    }
    public var time_:int;
    public var ability_:int;
    public var itemUsePos_:Position;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.time_);
        _arg1.writeInt(this.ability_);
        this.itemUsePos_.writeToOutput(_arg1);
    }

    override public function toString():String {
        return (formatToString("USEITEM", "ability_", "itemUsePos_"));
    }

}
}//package _0A_g

