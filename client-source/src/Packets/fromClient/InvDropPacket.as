// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g.InvDrop_

package Packets.fromClient {
import com.company.PhoenixRealmClient.net.messages.data._0_3;

import flash.utils.IDataOutput;

public class InvDropPacket extends CliPacketError {

    public function InvDropPacket(_arg1:uint) {
        this.slotObject_ = new _0_3();
        super(_arg1);
    }
    public var slotObject_:_0_3;

    override public function writeToOutput(_arg1:IDataOutput):void {
        this.slotObject_.writeToOutput(_arg1);
    }

    override public function toString():String {
        return (formatToString("INVDROP", "slotObject_"));
    }

}
}//package _0A_g

