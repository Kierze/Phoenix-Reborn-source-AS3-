// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011.Shoot_

package Packets.fromServer {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataInput;

public class ShootPacket extends SvrPacketError {

    public function ShootPacket(_arg1:uint) {
        this.startingPos_ = new Position();
        super(_arg1);
    }
    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var startingPos_:Position;
    public var angle_:Number;
    public var damage_:int;
    public var fromAbility_:Boolean;
    public var hasFormula_:Boolean;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.bulletId_ = _arg1.readUnsignedByte();
        this.ownerId_ = _arg1.readInt();
        this.containerType_ = _arg1.readShort();
        this.startingPos_.parseFromInput(_arg1);
        this.angle_ = _arg1.readFloat();
        this.damage_ = _arg1.readShort();
        this.fromAbility_ = _arg1.readBoolean();
        this.hasFormula_ = _arg1.readBoolean();
    }

    override public function toString():String {
        return (formatToString("SHOOT", "bulletId_", "ownerId_", "containerType_", "startingPos_", "angle_", "damage_", "fromAbility_", "hasFormula_"));
    }

}
}//package _011

