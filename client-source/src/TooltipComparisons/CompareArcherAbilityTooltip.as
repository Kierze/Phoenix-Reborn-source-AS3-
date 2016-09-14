// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareArcherAbilityTooltip

package TooltipComparisons {
public class CompareArcherAbilityTooltip extends TooltipComparison {

    public function CompareArcherAbilityTooltip() {
        this._7_ = new CompareWeaponTooltip();
    }
    private var _7_:CompareWeaponTooltip;
    private var condition:XMLList;
    private var _0r:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var tagStr:String;
        var duration:Number;
        var conditionName:String;
        var compositeStr:String;
        var htmlStr:String;
        this.condition = itemXML.Projectile.ConditionEffect.(((((text() == "Slowed")) || ((text() == "Paralyzed")))) || ((text() == "Dazed")));
        this._0r = curItemXML.Projectile.ConditionEffect.(((((text() == "Slowed")) || ((text() == "Paralyzed")))) || ((text() == "Dazed")));
        this._7_.CompareSlotTooltips(itemXML, curItemXML);
        _t4 = this._7_._t4;
        for (tagStr in this._7_.DictionaryA) {
            DictionaryA[tagStr] = true;
        }
        if ((((this.condition.length() == 1)) && ((this._0r.length() == 1)))) {
            duration = Number(this.condition[0].@duration);
            conditionName = this.condition.text();
            compositeStr = ((((" " + conditionName) + " for ") + duration) + " secs\n");
            htmlStr = ("Shot Effect:\n" + ColorText(compositeStr, _yellow));
            _t4 = (_t4 + htmlStr);
            DictionaryA[this.condition[0].toXMLString()] = htmlStr;
        }
    }

}
}//package TooltipComparisons

