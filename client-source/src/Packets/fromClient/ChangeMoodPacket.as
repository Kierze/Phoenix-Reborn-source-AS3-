/**
 * Created by Roxy on 10/23/2015.
 */
package Packets.fromClient {
import flash.utils.IDataOutput;

public class ChangeMoodPacket extends CliPacketError
    {
        public var moodName_:String;

        public function ChangeMoodPacket(_arg1:uint)
        {
            super(_arg1);
        }

        override public function writeToOutput(_arg1:IDataOutput):void
        {
            _arg1.writeUTF(this.moodName_);
        }

        override public function toString():String {
            return (formatToString("CHECKMOODS", "moodName_"));
        }
    }
}//package _0A_g
