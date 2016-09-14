package Packets.fromServer {

import flash.utils.IDataInput;

public class UnboxResultPacket extends SvrPacketError
    {

        public function UnboxResultPacket(_arg1:uint)
        {
            this.items_ = new Vector.<int>();
            this.datas_ = new Vector.<Object>();
            super(_arg1);
        }

        public var items_:Vector.<int>;
        public var datas_:Vector.<Object>;

        override public function parseFromInput(_arg1:IDataInput):void
        {
            this.items_.length = 0;
            this.datas_.length = 0;
            var _local1:int;
            var _local2:int = _arg1.readShort();
            this.items_.length = _local2;
            for(_local1 = 0; _local1 < _local2; _local1++)
            {
                this.items_[_local1] = _arg1.readInt();
            }
            _local2 = _arg1.readShort();
            this.datas_.length = _local2;
            for(_local1 = 0; _local1 < _local2; _local1++)
            {
                this.datas_[_local1] = JSON.parse(_arg1.readUTF());
            }
        }

        override public function toString():String
        {
            return (formatToString("UNBOXRESULT", "items_", "datas_"));
        }

    }
}