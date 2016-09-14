// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_011._0K_U_

package Packets.fromServer {
import flash.utils.IDataInput;

public class AccountListPacket extends SvrPacketError {

    public function AccountListPacket(_arg1:uint) {
        this.accountIds_ = new Vector.<int>();
        super(_arg1);
    }
    public var accountListId_:int;
    public var accountIds_:Vector.<int>;

    override public function parseFromInput(_arg1:IDataInput):void {
        var _local2:int;
        this.accountListId_ = _arg1.readInt();
        this.accountIds_.length = 0;
        var _local3:int = _arg1.readShort();
        _local2 = 0;
        while (_local2 < _local3) {
            this.accountIds_.push(_arg1.readInt());
            _local2++;
        }
    }

    override public function toString():String {
        return (formatToString("ACCOUNTLIST", "accountListId_", "accountIds_"));
    }

}
}//package _011

