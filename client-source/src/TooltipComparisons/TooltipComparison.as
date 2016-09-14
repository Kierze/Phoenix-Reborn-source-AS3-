// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//TooltipComparisons.TooltipComparison

package TooltipComparisons {
import flash.utils.Dictionary;

public class TooltipComparison {

    internal static const _green:String = "#00ff00";
    internal static const _red:String = "#ff0000";
    internal static const _yellow:String = "#FFFF8F";
    internal static const _gray:String = "#B3B3B3";
    internal static const _purple:String = "#8a2be2";

    public var DictionaryA:Dictionary;
    public var DictionaryB:Dictionary;
    public var _t4:String;

    public function CompareSlotTooltips(_arg1:XML, _arg2:XML):void {
        this._09d();
        this.compareSlots(_arg1, _arg2);
    }

    public function _NQ_d_(_arg1:XML, _arg2:XML, _arg3:Object, _arg4:Object):void {
        this.compareSlotsData(_arg1, _arg2, _arg3, _arg4);
    }

    protected function compareSlots(_arg1:XML, _arg2:XML):void {
    }

    protected function compareSlotsData(_arg1:XML, _arg2:XML, _arg3:Object, _arg4:Object):void {
    }

    protected function compareValuesToColor(_arg1:Number):String {
        if (_arg1 < 0) {
            return (_red);
        }
        if (_arg1 > 0) {
            return (_green);
        }
        return (_yellow);
    }

    protected function ColorText(_arg1:String, _arg2:String = "#FFFF8F"):String {
        return ('<font color="' + _arg2 + '">' + _arg1 + "</font>");
    }

    protected function _X_C_(_arg1:String):String {
        return (this.ColorText("MP Cost: ", _gray) + this.ColorText(_arg1, _yellow) + "\n");
    }

    private function _09d():void {
        this.DictionaryA = new Dictionary();
        this.DictionaryB = new Dictionary();
    }

}
}//package TooltipComparisons

