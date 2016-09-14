// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.ComparePriestAbilityTooltip

package TooltipComparisons {
public class ComparePriestAbilityTooltip extends TooltipComparison {

    override protected function compareSlots(itemXML:XML, curItemXML:XML):void {
        var nova:XMLList;
        var otherNova:XMLList;
        var tag:XML;
        var range:int;
        var otherRange:int;
        var amount:int;
        var otherAmount:int;
        var wavg:Number;
        var otherWavg:Number;
        var effectText:String;
        nova = itemXML.Activate.(text() == "HealNova");
        otherNova = curItemXML.Activate.(text() == "HealNova");
        _t4 = "";
        if ((((nova.length() == 1)) && ((otherNova.length() == 1)))) {
            range = int(itemXML.Activate.@range);
            otherRange = int(curItemXML.Activate.@range);
            amount = int(itemXML.Activate.@amount);
            otherAmount = int(curItemXML.Activate.@amount);
            wavg = ((0.5 * range) + (0.5 * amount));
            otherWavg = ((0.5 * otherRange) + (0.5 * otherAmount));
            if (itemXML.@id == "Tome of Purification") {
                range = 6;
            }
            effectText = (((amount + " HP within ") + range) + " sqrs\n");
            _t4 = (_t4 + ("Party Heal: " + ColorText(effectText, compareValuesToColor((wavg - otherWavg)))));
            DictionaryA[nova.toXMLString()] = true;
        }
        if (itemXML.@id == "Tome of Purification") {
            tag = itemXML.Activate.(text() == "RemoveNegativeConditions")[0];
            _t4 = (_t4 + ColorText("Removes negative conditions\n", _purple));
            DictionaryA[tag.toXMLString()] = true;
        } else {
            if (itemXML.@id == "Tome of Holy Protection") {
                tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
                _t4 = (_t4 + ("Effect on Self:\n" + ColorText((("Armored for " + tag.@duration) + " secs\n"), _purple)));
                DictionaryA[tag.toXMLString()] = true;
            }
        }
    }

}
}//package TooltipComparisons

