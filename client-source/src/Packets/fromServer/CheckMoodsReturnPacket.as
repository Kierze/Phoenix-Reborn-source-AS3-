/**
 * Created by Roxy on 10/25/2015.
 */

package Packets.fromServer
{
import flash.utils.IDataInput;

public class CheckMoodsReturnPacket extends SvrPacketError
    {

        public function CheckMoodsReturnPacket(_arg1:uint)
        {
            this.unlockedMoods = new Vector.<Boolean>();
            super(_arg1);
        }
        public var unlockedMoods:Vector.<Boolean>;

        override public function parseFromInput(_arg1:IDataInput):void
        {
            var _local2:int = 0;
            this.unlockedMoods.length = 0;
            var _local3:int = _arg1.readShort();
            while (_local2 < _local3)
            {
                this.unlockedMoods.push(_arg1.readBoolean());
                _local2++;
            }
        }

        override public function toString():String
        {
            return (formatToString("CHECKMOODSRETURN", "unlockedMoods"));
        }

    }
}


