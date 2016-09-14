// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7._0J_n

package Tooltips {
public class ComparisonConvert {

    public static const _Green:String = "#00FF00";
    public static const _Red:String = "#FF0000";
    public static const _White_ish:String = "#FFFF8F";

    public static function toString(_arg1:String, _arg2:String):String {
        return ('<font color="' + _arg2 + '">' + _arg1 + "</font>");
    }

    public static function Round(_arg1:Number):String {
        var _local2:Number = (_arg1 - int(_arg1));
        return (int(_local2 * 10) == 0 ? int(_arg1).toString() : _arg1.toFixed(1));
    }

    public static function _getCompareColor(_arg1:Number):String {
        if (_arg1 < 0) {
            return (_Red);
        }
        else if (_arg1 > 0) {
            return (_Green);
        }
        else {
            return (_White_ish);
        }

    }

}
}//package _E_7

