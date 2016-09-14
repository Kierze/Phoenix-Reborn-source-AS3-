// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareTricksterAbilityTooltip

package TooltipComparisons {
public class CompareTricksterAbilityTooltip extends TooltipComparison {

    private var _S_y:XMLList;
    private var _1Q_:XMLList;

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var duration:Number;
        var otherDuration:Number;
        this._S_y = itemXML.Activate.(text() == "Decoy");
        this._1Q_ = curItemXML.Activate.(text() == "Decoy");
        _t4 = "";
        if ((((this._S_y.length() == 1)) && ((this._1Q_.length() == 1)))) {
            duration = Number(this._S_y[0].@duration);
            otherDuration = Number(this._1Q_[0].@duration);
            _t4 = (_t4 + ("Decoy: " + ColorText((duration.toString() + " secs\n"), compareValuesToColor((duration - otherDuration)))));
            DictionaryA[this._S_y[0].toXMLString()] = true;
        }
    }

}
}//package TooltipComparisons

