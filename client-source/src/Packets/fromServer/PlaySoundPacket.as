// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._bB_

package Packets.fromServer {
import flash.utils.IDataInput;

public class PlaySoundPacket extends SvrPacketError {

    public function PlaySoundPacket(_arg1:uint) {
        super(_arg1);
    }
    public var ownerId_:int;
    public var soundId_:int;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.ownerId_ = _arg1.readInt();
        this.soundId_ = _arg1.readUnsignedByte();
    }

    override public function toString():String {
        return (formatToString("PLAYSOUND", "ownerId_", "soundId_"));
    }

}
}//package _011

