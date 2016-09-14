// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareKnightAbilityTooltip

package TooltipComparisons {
public class CompareKnightAbilityTooltip extends TooltipComparison {

    public function CompareKnightAbilityTooltip() {
        this._7_ = new CompareWeaponTooltip();
    }
    private var _7_:CompareWeaponTooltip;

    override protected function compareSlots(_arg1:XML, _arg2:XML):void {
        var _local3:String;
        this._7_.CompareSlotTooltips(_arg1, _arg2);
        _t4 = this._7_._t4;
        for (_local3 in this._7_.DictionaryA) {
            DictionaryA[_local3] = this._7_.DictionaryA[_local3];
        }
        this._04S_(_arg1);
    }

    private function _04S_(itemXML:XML):void {
        var tag:XML;
        var str:String;
        if (itemXML.@id == "Shield of Ogmur") {
            tag = itemXML.ConditionEffect.(text() == "Armor Broken")[0];
            str = (("Armor Broken for " + tag.@duration) + " secs\n");
            str = ("Party Effect: " + ColorText(str, _purple));
            _t4 = (_t4 + str);
            DictionaryA[tag.toXMLString()] = str;
        }
    }

}
}//package TooltipComparisons

