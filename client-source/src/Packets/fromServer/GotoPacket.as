// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._04R_

package Packets.fromServer {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataInput;

public class GotoPacket extends SvrPacketError {

    public function GotoPacket(_arg1:uint) {
        this.pos_ = new Position();
        super(_arg1);
    }
    public var objectId_:int;
    public var pos_:Position;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.objectId_ = _arg1.readInt();
        this.pos_.parseFromInput(_arg1);
    }

    override public function toString():String {
        return (formatToString("GOTO", "objectId_", "pos_"));
    }

}
}//package _011

