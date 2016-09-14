// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0A_g._J_I_

package Packets.fromClient {
import flash.utils.IDataOutput;

public class EnemyHitPacket extends CliPacketError {

    public function EnemyHitPacket(_arg1:uint) {
        super(_arg1);
    }
    public var time_:int;
    public var bulletId_:uint;
    public var targetId_:int;
    public var kill_:Boolean;
    public var dmg_:int;
    public var pen_:int;

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeInt(this.time_);
        _arg1.writeByte(this.bulletId_);
        _arg1.writeInt(this.targetId_);
        _arg1.writeBoolean(this.kill_);
        _arg1.writeInt(this.dmg_);
        _arg1.writeInt(this.pen_);
    }

    override public function toString():String {
        return (formatToString("ENEMYHIT", "time_", "bulletId_", "targetId_", "kill_", "dmg_", "pen_"));
    }

}
}//package _0A_g

