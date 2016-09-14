package Packets.fromServer {
import flash.utils.IDataInput;

public class SwitchMusicPacket extends SvrPacketError {
    public function SwitchMusicPacket(_arg1:uint) {

        super(_arg1);
    }
    public var music_:String;

    override public function parseFromInput(_arg1:IDataInput):void {

        this.music_ = _arg1.readUTF();
    }

    override public function toString():String {

        return formatToString("SWITCHMUSIC", "music_");
    }
}
}