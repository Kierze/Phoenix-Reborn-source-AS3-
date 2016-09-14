// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.GuildMerchant

package com.company.PhoenixRealmClient.objects {
import Tooltips.TextTagTooltip;
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.PhoenixRealmClient.util._07E_;

import flash.display.BitmapData;

public class GuildMerchant extends SellableObject implements IPanelProvider {

    public function GuildMerchant(_arg1:XML) {
        super(_arg1);
        price_ = int(_arg1.Price);
        currency_ = Currency.GUILDFAME;
        this.description_ = _arg1.Description;
        _0F_S_ = _07E_._tS_;
    }
    public var description_:String;

    override public function soldObjectName():String {
        return (ObjectLibrary.typeToDisplayId[objectType_]);
    }

    override public function soldObjectInternalName():String {
        var _local1:XML = ObjectLibrary.typeToXml[objectType_];
        return (_local1.@id.toString());
    }

    override public function getTooltip():TooltipBase {
        return (new TextTagTooltip(Parameters._primaryColourDefault, 0x9B9B9B, this.soldObjectName(), this.description_, 200));
    }

    override public function getIcon():BitmapData {
        return (ObjectLibrary.getRedrawnTextureFromType(objectType_, 80, true));
    }

}
}//package com.company.PhoenixRealmClient.objects

