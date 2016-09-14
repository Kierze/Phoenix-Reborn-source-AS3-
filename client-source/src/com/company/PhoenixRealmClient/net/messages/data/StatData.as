// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.net.messages.data.StatData

package com.company.PhoenixRealmClient.net.messages.data {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class StatData {

    public static const MaximumHP:int = 0;
    public static const HP:int = 1;
    public static const Size:int = 2;
    public static const MaximumMP:int = 3;
    public static const MP:int = 4;
    public static const ExperienceGoal:int = 5;
    public static const Experience:int = 6;
    public static const Level:int = 7;
    public static const Attack:int = 20;
    public static const Defense:int = 21;
    public static const Speed:int = 22;
    public static const Inventory_0:int = 8;
    public static const Inventory_1:int = 9;
    public static const Inventory_2:int = 10;
    public static const Inventory_3:int = 11;
    public static const Inventory_4:int = 12;
    public static const Inventory_5:int = 13;
    public static const Inventory_6:int = 14;
    public static const Inventory_7:int = 15;
    public static const Inventory_8:int = 16;
    public static const Inventory_9:int = 17;
    public static const Inventory_10:int = 18;
    public static const Inventory_11:int = 19;
    public static const Vitality:int = 26;
    public static const Wisdom:int = 27;
    public static const Dexterity:int = 28;
    public static const Effects:int = 29;
    public static const Stars:int = 30;
    public static const Name:int = 31;
    public static const Texture_1:int = 32;
    public static const Texture_2:int = 33;
    public static const MerchantMerchandiseType:int = 34;
    public static const Credits:int = 35;
    public static const SellablePrice:int = 36;
    public static const PortalUsable:int = 37;
    public static const AccountId:int = 38;
    public static const CurrentFame:int = 39;
    public static const SellablePriceCurrency:int = 40;
    public static const ObjectConnection:int = 41;
    public static const MerchantRemainingCount:int = 42;
    public static const MerchantRemainingMinute:int = 43;
    public static const MerchantDiscount:int = 44;
    public static const SellableRankRequirement:int = 45;
    public static const HPBoost:int = 46;
    public static const MPBoost:int = 47;
    public static const AttackBonus:int = 48;
    public static const DefenseBonus:int = 49;
    public static const SpeedBonus:int = 50;
    public static const VitalityBonus:int = 51;
    public static const WisdomBonus:int = 52;
    public static const DexterityBonus:int = 53;
    public static const OwnerAccountId:int = 54;
    public static const NameChangerStar:int = 55;
    public static const NameChosen:int = 56;
    public static const Fame:int = 57;
    public static const FameGoal:int = 58;
    public static const Glowing:int = 59;
    public static const SinkOffset:int = 60;
    public static const AltTextureIndex:int = 61;
    public static const Guild:int = 62;
    public static const GuildRank:int = 63;
    public static const OxygenBar:int = 64;
    public static const XpBoost:int = 65;
    public static const Skin:int = 66;
    //public static const VACANT:int = 67;
    //public static const VACANT:int = 68;
    public static const Silver:int = 69;
    public static const CanNexus:int = 70;
    public static const Party:int = 71;
    public static const PartyLeader:int = 72;
    public static const InvData_0:int = 73;
    public static const InvData_1:int = 74;
    public static const InvData_2:int = 75;
    public static const InvData_3:int = 76;
    public static const InvData_4:int = 77;
    public static const InvData_5:int = 78;
    public static const InvData_6:int = 79;
    public static const InvData_7:int = 80;
    public static const InvData_8:int = 81;
    public static const InvData_9:int = 82;
    public static const InvData_10:int = 83;
    public static const InvData_11:int = 84;
    public static const Effect:int = 85;
    public static const Ability_1:int = 86;
    public static const Ability_2:int = 87;
    public static const Ability_3:int = 88;
    public static const AbilityCD_1:int = 89;
    public static const AbilityCD_2:int = 90;
    public static const AbilityCD_3:int = 91;
    public static const Specialization:int = 92;
    public static const Mood:int = 93;
    public static const Aptitude:int = 94;
    public static const AptitudeBonus:int = 95;
    public static const Resilience:int = 96;
    public static const ResilienceBonus:int = 97;
    public static const Penetration:int = 98;
    public static const PenetrationBonus:int = 99;
    public static const AbilityAD_1:int = 100;
    public static const AbilityAD_2:int = 101;
    public static const AbilityAD_3:int = 102;
    public static const AbilityToggle:int = 103;
    public static const ChatBubbleColour:int = 104;

    public static function StatToString(_arg1:int):String {
        switch (_arg1) {
            case MaximumHP:
                return ("Maximum HP");
            case HP:
                return ("HP");
            case Size:
                return ("Size");
            case MaximumMP:
                return ("Maximum MP");
            case MP:
                return ("MP");
            case Experience:
                return ("XP");
            case Level:
                return ("Level");
            case Attack:
                return ("Attack");
            case Defense:
                return ("Defense");
            case Speed:
                return ("Speed");
            case Vitality:
                return ("Vitality");
            case Wisdom:
                return ("Wisdom");
            case Dexterity:
                return ("Dexterity");
            case Aptitude:
                return ("Aptitude");
            case Resilience:
                return ("Resilience");
            case Penetration:
                return ("Armor Penetration");
            default:
                return ("Unknown Stat");
        }
    }
    public var _0F_4:uint = 0;
    public var _h:int;
    public var _3x:String;

    public function GetUTFStats():Boolean {
        switch (this._0F_4) {
            case Name:
            case Guild:
            case InvData_0:
            case InvData_1:
            case InvData_2:
            case InvData_3:
            case InvData_4:
            case InvData_5:
            case InvData_6:
            case InvData_7:
            case InvData_8:
            case InvData_9:
            case InvData_10:
            case InvData_11:
            case Effect:
            case Specialization:
            case Mood:
            case ChatBubbleColour:
                return (true);
        }
        return (false);
    }

    public function parseFromInput(_arg1:IDataInput):void {
        this._0F_4 = _arg1.readUnsignedByte();
        if (!this.GetUTFStats()) {
            this._h = _arg1.readInt();
        } else {
            this._3x = _arg1.readUTF();
        }
    }

    public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeByte(this._0F_4);
        if (!this.GetUTFStats()) {
            _arg1.writeInt(this._h);
        } else {
            _arg1.writeUTF(this._3x);
        }
    }

    public function toString():String {
        if (!this.GetUTFStats()) {
            return ((((("[" + this._0F_4) + ": ") + this._h) + "]"));
        }
        return ((((("[" + this._0F_4) + ': "') + this._3x) + '"]'));
    }

}
}//package com.company.PhoenixRealmClient.net.messages.data

