/**
 * Created by Roxy on 10/25/2015.
 */
package Packets.fromClient {
import flash.utils.IDataOutput;

public class CheckMoodsPacket extends CliPacketError
    {

        public function CheckMoodsPacket(_arg1:uint)
        {
            super(_arg1);
        }

        override public function writeToOutput(_arg1:IDataOutput):void
        {
        }

        override public function toString():String {
            return (formatToString("CHECKMOODS"));
        }
    }
}//package _0A_g
