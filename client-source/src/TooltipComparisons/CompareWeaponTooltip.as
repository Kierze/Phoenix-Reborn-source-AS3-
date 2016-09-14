// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareWeaponTooltip

package TooltipComparisons {
import Tooltips.ComparisonConvert;

public class CompareWeaponTooltip extends TooltipComparison {

    private var itemXML:XML;
    private var curItemXML:XML;
    private var itemData:Object;
    private var curItemData:Object;
    private var _E_y:XML;
    private var _0F_j:XML;

    override protected function compareSlotsData(_arg1:XML, _arg2:XML, _arg3:Object, _arg4:Object):void {
        var _local3:String;
        this.itemXML = _arg1;
        this.curItemXML = _arg2;
        this.itemData = _arg3;
        this.curItemData = _arg4;
        _local3 = "";
        _t4 = "";
        if (_arg1.hasOwnProperty("NumProjectiles")) {
            _local3 = this._go();
            _t4 = (_t4 + _local3);
            DictionaryA[_arg1.NumProjectiles.toXMLString()] = _local3;
        }
        if (_arg1.hasOwnProperty("Projectile")) {
            _local3 = this._56();
            _t4 = (_t4 + _local3);
            DictionaryA[_arg1.Projectile.toXMLString()] = _local3;
        }
        this._R_J_();
    }

    private function _56():String {
        var _local1:String = this._wD_();
        var _local2:Number = ((Number(this._E_y.Speed) * Number(this._E_y.LifetimeMS)) / 10000);
        var _local3:Number = ((Number(this._0F_j.Speed) * Number(this._0F_j.LifetimeMS)) / 10000);
        var customRange:Number = (this.itemData != null && this.itemData.hasOwnProperty("Range")) ? Number(this.itemData.Range) : 0;
        var customRangeCur:Number = (this.curItemData != null && this.curItemData.hasOwnProperty("Range")) ? Number(this.curItemData.Range) : 0;

        _local2 += customRange;
        _local3 += customRangeCur;

        var _local4:String = ComparisonConvert.Round(_local2);
        var _display:String = customRange ? (_local4 + " (+" + customRange + ") ") : _local4;

        _local1 = (_local1 + (ColorText("Projectile Range: ", _gray) + ColorText((_display + "\n"), compareValuesToColor((_local2 - _local3)))));
        if (this._E_y.hasOwnProperty("MultiHit")) {
            _local1 = (_local1 + ColorText("Shots hit multiple targets\n", _yellow));
        }
        if (this._E_y.hasOwnProperty("PassesCover")) {
            _local1 = (_local1 + ColorText("Shots pass through obstacles\n", _yellow));
        }
        return (_local1);
    }

    private function _go():String {
        var _local1:int = int(this.itemXML.NumProjectiles);
        var _local2:int = int(this.curItemXML.NumProjectiles);
        var _local3:String = compareValuesToColor((_local1 - _local2));
        return (((ColorText("Number of Shots: ", _gray) + ColorText(_local1.toString(), _local3)) + "\n"));
    }

    private function _wD_():String {
        var _local1:Boolean = false;
        var _local9:int = 0;
        var _local10:int = 0;
        this._E_y = XML(this.itemXML.Projectile);
        var _local2:int = int(this._E_y.MinDamage);
        var _local3:int = int(this._E_y.MaxDamage);
        var customMin:int = (this.itemData != null && this.itemData.hasOwnProperty("MinDamage")) ? int(this.itemData.MinDamage) : 0;
        var customMax:int = (this.itemData != null && this.itemData.hasOwnProperty("MaxDamage")) ? int(this.itemData.MaxDamage) : 0;

        var bonusFR:int = (this.itemData != null && this.itemData.hasOwnProperty("FireRate")) ? int(this.itemData.FireRate * 100) : 0;
        var curBonusFR:int = (this.curItemData != null && this.curItemData.hasOwnProperty("FireRate")) ? int(this.curItemData.FireRate * 100) : 0;
        var boolFR:Boolean = false;

        if (this.itemData != null && this.itemData.hasOwnProperty("FireRate") && this.itemData.FireRate != 0)
        {
            boolFR = true;
        }

        var addString:String = (customMin != 0 && customMax != 0) ? " <font color=\"#" + (customMin > 0 || customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + "-" + customMax + " DMG)</font>"
                : customMin != 0 ? " <font color=\"#" + (customMin > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMin > 0 ? "+" : "-") + customMin + " Minimum DMG)</font>"
                : customMax != 0 ? " <font color=\"#" + (customMax > 0 ? "1CABFF" : "FF6863") + "\">(" + (customMax > 0 ? "+" : "-") + customMax + " Maximum DMG)</font>"
                : "";
        _local2 += customMin;
        _local3 += customMax;
        if(this.itemData != null && this.itemData.hasOwnProperty("DmgPercentage") && this.itemData.DmgPercentage != 0) {
            _local1 = true;
            _local9 = int(this.itemData.DmgPercentage);
            _local2 += (_local2 * (_local9 / 100));
            _local3 += (_local3 * (_local9 / 100));
        }
        var _local4:Number = ((_local3 + _local2) / 2);
        this._0F_j = XML(this.curItemXML.Projectile);
        var _local5:int = int(this._0F_j.MinDamage);
        var _local6:int = int(this._0F_j.MaxDamage);
        var customMin2:int = (this.curItemData != null && this.curItemData.hasOwnProperty("MinDamage")) ? int(this.curItemData.MinDamage) : 0;
        var customMax2:int = (this.curItemData != null && this.curItemData.hasOwnProperty("MaxDamage")) ? int(this.curItemData.MaxDamage) : 0;
        _local5 += customMin2;
        _local6 += customMax2;
        if(this.curItemData != null && this.curItemData.hasOwnProperty("DmgPercentage") && this.curItemData.DmgPercentage != 0) {
            _local1 = true;
            _local10 = int(this.curItemData.DmgPercentage);
            _local5 += (_local5 * (_local10 / 100));
            _local6 += (_local6 * (_local10 / 100));
        }
        var _local7:Number = ((_local6 + _local5) / 2);
        var _local8:String = (((_local2 == _local3)) ? _local2 : ((_local2 + " - ") + _local3)).toString();
        var _local11:int = (_local9 - _local10);
        var _local12:String = (_local9 < 0 ? "-" : "+") + _local9.toString();

        var FRCompare:Number = (bonusFR - curBonusFR);
        var FRtoString:String = (bonusFR < 0 ? "-" : "+") + bonusFR.toString();
        return (((ColorText("Attack Damage: ", _gray) + ColorText(_local8, compareValuesToColor((_local4 - _local7)))) + addString + "\n")) +
                (_local1 ? (ColorText("Damage Multiplier: ", _gray) + ColorText(_local12, compareValuesToColor(_local11)) + "%\n") : "") +
                (boolFR ? (ColorText("Fire Rate Bonus: ", _gray) + ColorText(FRtoString, compareValuesToColor(FRCompare)) + "%\n") : "");
    }

    private function _R_J_():void {
        if ((((this.itemXML.RateOfFire.length() == 0)) || ((this.curItemXML.RateOfFire.length() == 0)))) {
            return;
        }
        var _local1:Number = Number(this.curItemXML.RateOfFire[0]);
        var _local2:Number = Number(this.itemXML.RateOfFire[0]);

        if (curItemData != null && curItemData.hasOwnProperty("FireRate") && curItemData.FireRate != 0) {
            _local1 *= Number(curItemData.FireRate);
        }
        if (itemData != null && itemData.hasOwnProperty("FireRate") && itemData.FireRate != 0) {
            _local2 *= Number(itemData.FireRate);
        }

        //_local1 =  Math.round( Number(Math.pow(10, 2)) * _local1) / Number(Math.pow(10, 2));
        //_local2 =  Math.round( Number(Math.pow(10, 2)) * _local2) / Number(Math.pow(10, 2));

        var _local3:int = int(((_local2 / _local1) * 100));
        var _local4:int = (_local3 - 100);
        if (_local4 == 0) {
            return;
        }


        var _local5:String = compareValuesToColor(_local4);
        var _local6:String = _local4.toString();
        if (_local4 > 0) {
            _local6 = ("+" + _local6);
        }
        _local6 = ColorText((_local6 + "%"), _local5);
        _t4 = (_t4 + (("Fire Rate: " + _local6) + "\n"));
        DictionaryA[this.itemXML.RateOfFire[0].toXMLString()];
    }

}
}//package TooltipComparisons

