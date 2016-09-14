// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._I_o

package Packets.fromServer {
import flash.utils.IDataInput;

public class AllyShootPacket extends SvrPacketError {

    public function AllyShootPacket(_arg1:uint) {
        super(_arg1);
    }
    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var angle_:Number;
    public var dmg_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.bulletId_ = _arg1.readUnsignedByte();
        this.ownerId_ = _arg1.readInt();
        this.containerType_ = _arg1.readShort();
        this.angle_ = _arg1.readFloat();
        this.dmg_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("ALLYSHOOT", "bulletId_", "ownerId_", "containerType_", "angle_", "dmg_"));
    }

}
}//package _011

