/**
 * Created by Roxy on 11/1/2015.
 */
package TooltipComparisons
{
public class CompareAPTooltip extends TooltipComparison {

    private static const APStatType:String = "94";

    public function CompareAPTooltip()
    {
        _t4 = "";
    }
    private var itemXmlList:XMLList;
    private var otherItemXmlList:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void
    {
        var abilPow:int;
        var otherAbilPow:int;
        this.itemXmlList = itemXML.ActivateOnEquip.(@stat == APStatType);
        this.otherItemXmlList = curItemXML.ActivateOnEquip.(@stat == APStatType);
        if (this.itemXmlList.length == 1 && this.otherItemXmlList.length == 1)
        {
            abilPow = int(this.itemXmlList.@amount);
            otherAbilPow = int(this.otherItemXmlList.@amount);
            DictionaryB[this.itemXmlList[0].toXMLString()] = this._CompareAP(abilPow, otherAbilPow);
        }
        else if (this.itemXmlList.length == 1)
        {
            abilPow = int(this.itemXmlList.@amount);
            otherAbilPow = 0;
            DictionaryB[this.itemXmlList[0].toXMLString()] = this._CompareAP(abilPow, otherAbilPow);
        }
    }

    private function _CompareAP(_arg1:int, _arg2:int):String {
        var _local3:String = compareValuesToColor((_arg1 - _arg2));
        return (ColorText(("+" + _arg1 + " Aptitude"), _local3));
    }

}
}
