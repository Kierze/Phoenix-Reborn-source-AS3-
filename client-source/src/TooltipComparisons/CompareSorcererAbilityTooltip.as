// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.CompareSorcererAbilityTooltip

package TooltipComparisons {
public class CompareSorcererAbilityTooltip extends TooltipComparison {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var result:XMLList;
        var otherResult:XMLList;
        var damage:int;
        var otherDamage:int;
        var textColor:String;
        var targets:int;
        var otherTargets:int;
        var condition:String;
        var duration:Number;
        var compositeStr:String;
        var htmlStr:String;
        result = itemXML.Activate.(text() == "Lightning");
        otherResult = curItemXML.Activate.(text() == "Lightning");
        _t4 = "";
        if ((((result.length() == 1)) && ((otherResult.length() == 1)))) {
            damage = int(result[0].@totalDamage);
            otherDamage = int(otherResult[0].@totalDamage);
            textColor = compareValuesToColor((damage - otherDamage));
            targets = int(result[0].@maxTargets);
            otherTargets = int(otherResult[0].@maxTargets);
            _t4 = (_t4 + ("Lightning: " + ColorText((((damage + " to ") + targets) + " targets\n"), compareValuesToColor((damage - otherDamage)))));
            DictionaryA[result[0].toXMLString()] = true;
        }
        if (itemXML.Activate.@condEffect) {
            condition = itemXML.Activate.@condEffect;
            duration = itemXML.Activate.@condDuration;
            compositeStr = ((((" " + condition) + " for ") + duration) + " secs\n");
            htmlStr = ("Shot Effect:\n" + ColorText(compositeStr, _yellow));
            _t4 = (_t4 + htmlStr);
        }
    }

}
}//package TooltipComparisons

