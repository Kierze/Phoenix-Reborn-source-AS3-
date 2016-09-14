package com.company.PhoenixRealmClient.net.messages.data
{
import flash.utils.IDataInput;

public class InTradeItem
    {
        public var item_:int;
        public var data_:String;
        public var slotType_:int;
        public var tradeable_:Boolean;
        public var included_:Boolean;

        public function parseFromInput(_arg1:IDataInput):void
        {
            this.item_ = _arg1.readInt();
            this.data_ = _arg1.readUTF();
            this.slotType_ = _arg1.readInt();
            this.tradeable_ = _arg1.readBoolean();
            this.included_ = _arg1.readBoolean();
        }

        public function toString():String
        {
            return ("item: " + this.item_ + " data: " + this.data_ + " slotType: " + this.slotType_ + " tradeable: " + this.tradeable_ + " included:" + this.included_);
        }

    }
}
