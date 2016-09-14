// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._06N_

package Packets.fromServer {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataInput;

public class ShowEffectPacket extends SvrPacketError {

    public static const None:int = 0; //Assuming none?
    public static const Potion:int = 1;
    public static const Teleport:int = 2;
    public static const Stream:int = 3;
    public static const Throw:int = 4;
    public static const AreaBlast:int = 5;
    public static const Dead:int = 6;
    public static const Trail:int = 7;
    public static const Diffuse:int = 8;
    public static const Flow:int = 9;
    public static const Trap:int = 10;
    public static const Lightning:int = 11;
    public static const Concentrate:int = 12;
    public static const BlastWave:int = 13;
    public static const Earthquake:int = 14;
    public static const Flashing:int = 15;
    public static const BeachBall:int = 16;

    public function ShowEffectPacket(_arg1:uint) {
        this.pos1_ = new Position();
        this.pos2_ = new Position();
        super(_arg1);
    }
    public var effectType_:uint;
    public var targetObjectId_:int;
    public var pos1_:Position;
    public var pos2_:Position;
    public var color_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.effectType_ = _arg1.readUnsignedByte();
        this.targetObjectId_ = _arg1.readInt();
        this.pos1_.parseFromInput(_arg1);
        this.pos2_.parseFromInput(_arg1);
        this.color_ = _arg1.readInt();
    }

    override public function toString():String {
        return (formatToString("SHOW_EFFECT", "effectType_", "targetObjectId_", "pos1_", "pos2_", "color_"));
    }

}
}//package _011

