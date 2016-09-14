// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._04R_

package Packets.fromServer {
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.utils.IDataInput;

public class CameraUpdatePacket extends SvrPacketError {

    public function CameraUpdatePacket(_arg1:uint) {
        this.cameraPos_ = new Position();
        super(_arg1);
    }
    public var cameraOffsetX_:int;
    public var cameraOffsetY_:int;
    public var cameraPos_:Position;
    public var cameraRot_:Number;
    public var fixedCamera_:Boolean;
    public var fixedCameraRot_:Boolean;

    override public function parseFromInput(_arg1:IDataInput):void {
        this.cameraOffsetX_ = _arg1.readInt();
        this.cameraOffsetY_ = _arg1.readInt();
        this.cameraPos_.parseFromInput(_arg1);
        this.cameraRot_ = _arg1.readFloat();
        this.fixedCamera_ = _arg1.readBoolean();
        this.fixedCameraRot_ = _arg1.readBoolean();
    }

    override public function toString():String {
        return (formatToString("CAMERAUPDATE", "cameraOffsetX_", "cameraOffsetY_", "cameraPos_", "fixedCamera_"));
    }

}
}//package _011

