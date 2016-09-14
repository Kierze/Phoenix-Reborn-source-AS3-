// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareArmorTooltip

package TooltipComparisons {
public class CompareArmorTooltip extends TooltipComparison {

    private static const defenseEnum:String = "21";
    private static const resilienceEnum:String = "94";

    public function CompareArmorTooltip() {
        _t4 = "";
    }
    private var defenseXmls:XMLList;
    private var otherDefenseXmls:XMLList;
    private var resilienceXmls:XMLList;
    private var otherResilienceXmls:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var defense:int;
        var otherDefense:int;
        var resilience:int;
        var otherResilience:int;

        this.defenseXmls = itemXML.ActivateOnEquip.(@stat == defenseEnum);
        this.otherDefenseXmls = curItemXML.ActivateOnEquip.(@stat == defenseEnum);
        if ((((this.defenseXmls.length() == 1)) && ((this.otherDefenseXmls.length() == 1)))) {
            defense = int(this.defenseXmls.@amount);
            otherDefense = int(this.otherDefenseXmls.@amount);
            DictionaryB[this.defenseXmls[0].toXMLString()] = this.compareDef(defense, otherDefense);
        }
        this.resilienceXmls = itemXML.ActivateOnEquip.(@stat == resilienceEnum);
        this.otherResilienceXmls = curItemXML.ActivateOnEquip.(@stat == resilienceEnum);
        if ((((this.resilienceXmls.length() == 1)) && ((this.otherResilienceXmls.length() == 1)))) {
            resilience = int(this.resilienceXmls.@amount);
            otherResilience = int(this.otherResilienceXmls.@amount);
            DictionaryB[this.resilienceXmls[0].toXMLString()] = this.compareRes(resilience, otherResilience);
        }
    }

    private function compareDef(_arg1:int, _arg2:int):String {
        var _local3:String = compareValuesToColor((_arg1 - _arg2));
        return (ColorText((("+" + _arg1) + " Defense"), _local3));
    }
    private function compareRes(_arg1:int, _arg2:int):String {
        var _local3:String = compareValuesToColor((_arg1 - _arg2));
        return (ColorText((("+" + _arg1) + " Resilience"), _local3));
    }

}
}//package TooltipComparisons

