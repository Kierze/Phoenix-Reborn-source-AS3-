package Packets.fromClient {
import flash.utils.IDataOutput;

public class VisibulletPacket extends CliPacketError {

    public function VisibulletPacket(param1:uint) {

        super(param1);
    }
    public var damage_:int;
    public var penetration_:int;
    public var enemyId_:int;
    public var bulletId_:uint;
    public var armorPiercing_:Boolean;

    override public function writeToOutput(param1:IDataOutput):void {
        param1.writeInt(this.damage_);
        param1.writeInt(this.penetration_);
        param1.writeInt(this.enemyId_);
        param1.writeByte(this.bulletId_);
        param1.writeBoolean(armorPiercing_);
    }

    override public function toString():String {
        return formatToString("VISIBULLET", "damage_", "penetration_", "enemyId_", "bulletId_", "armorPiercing_");
    }
}
}
