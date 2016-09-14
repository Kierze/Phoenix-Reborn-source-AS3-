/**
 * Created by club5_000 on 9/1/2015.
 */
package Tooltips {

import com.company.PhoenixRealmClient.objects.Formula;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.TooltipDivider;
import com.company.PhoenixRealmClient.util.AbilityLibrary;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.filters.DropShadowFilter;

public class AbilityToolTip extends TooltipBase {
        private static const maxWidth:int = 286;
        private static const fontName:String = "CHIP SB";
        private static const fontSize:int = 16;

        public function AbilityToolTip(_arg1:int, _arg2:Number) {
            this.abilityType_ = _arg1;
            this.abilityPower = _arg2;
            this.abilityXML_ = AbilityLibrary.TypeToXML[this.abilityType_];
            super(Parameters._primaryColourDefault, 1, 0x9B9B9B, 1, true);
            this.init();
        }

        public var abilityType_:int;
        public var abilityXML_:XML;
        public var abilityPower:Number;
        private var icon_:Bitmap;
        private var name_:SimpleText;
        private var desc_:SimpleText;
        private var stats_:SimpleText;
        private var effs_:Vector.<Effect>;
        private var nextPos_:int;
        private var formulas_:XML;

        private function init():void {
            this.initIcon();
            this.initName();
            this.initDesc();

            this.initMpCost();
            this.initMpCostPerSec();
            this.initCooldown();

            this.initStats();
        }

        private function initIcon():void {
            var _local1:BitmapData = AbilityLibrary.getIcon(this.abilityType_);
            this.icon_ = new Bitmap(_local1);
            this.effs_ = new Vector.<Effect>();
            addChild(this.icon_);
            nextPos(this.icon_);
        }

        private function initName():void {
            this.name_ = new SimpleText(fontSize + 2, 0xFFFFFF, false, (((maxWidth - this.icon_.width) - 4) - 30), 0, fontName);
            this.name_.setBold(true);
            this.name_.wordWrap = true;
            this.name_.text = AbilityLibrary.getDisplayName(this.abilityType_);
            this.name_.updateMetrics();
            this.name_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
            this.name_.x = this.icon_.width + 4;
            this.name_.y = (this.icon_.height / 2) - (this.name_._I_x / 2);
            addChild(this.name_);
        }

        private function initDesc():void
        {
            var descriptionText:String = String(this.abilityXML_.Description);
            var tags:Array;
            var IDs:Vector.<String>;
            var numbers:Vector.<Number> = new Vector.<Number>;
            //var pattern:RegExp = /{\d*}/gi;
            var pattern:RegExp = new RegExp("{.*?}", "gi");
            var replacePattern:RegExp = new RegExp("{.*?}", "i");
            //Regular expression filtering out substrings that start with { and have 1 or more characters after and then ends with }
            this.desc_ = new SimpleText(fontSize, 0xB3B3B3, false, maxWidth, 0, fontName);
            this.desc_.wordWrap = true;

            tags = descriptionText.match(pattern);
            if (tags != null && tags.length > 0)
            {
                IDs = new Vector.<String>;
                numbers = new Vector.<Number>;
                var count:int;
                for (count = 0; count < tags.length; count++)
                {
                    if (tags[count] != null) IDs[count] = tags[count].substring(1, tags[count].length - 1); //takes off the brackets for each
                    numbers[count] = Formula.RetrieveDescData(this.abilityXML_, IDs[count], this.abilityPower); //finds the formula and returns the value
                    if (IDs[count] == "DurationMS" || IDs[count] == "ActiveDuration")
                    {
                        numbers[count] = Math.floor(numbers[count] * 0.01) * 0.1;
                    }
                }
                for (count = 0; count < numbers.length; count++)
                {
                    descriptionText = descriptionText.replace(replacePattern, numbers[count]); //replaces the whole tag with the new number
                }
            }
            this.desc_.text = descriptionText;
            this.desc_.updateMetrics();
            this.desc_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
            this.desc_.x = 4;
            this.desc_.y = nextPos()+4;
            addChild(this.desc_);
            nextPos(this.desc_);
        }

        private function initStats():void {
            if(this.effs_.length != 0) {
                this.addLine(nextPos());
                this.stats_ = new SimpleText(fontSize, 0xB3B3B3, false, ((maxWidth - 4)), 0, fontName);
                this.stats_.wordWrap = true;
                this.stats_.htmlText = this._41(this.effs_);
                this.stats_._08S_();
                this.stats_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
                this.stats_.x = 4;
                this.stats_.y = nextPos();
                addChild(this.stats_);
            }
        }

        private function initMpCost():void
        {
            var i:int = 0;
            var xml:XML;
            var form:Formula;
            if(this.abilityXML_.hasOwnProperty("MpCost"))
            {
                i = int(this.abilityXML_.MpCost);
            }
            else if (this.abilityXML_.hasOwnProperty("Formula"))
            {
                for each (xml in this.abilityXML_.Formula)
                {
                    if (xml == "MpCost")
                    {
                        form = new Formula(xml);
                        i = int(Formula.Calculate(form, this.abilityPower));
                    }
                }
            }
            this.effs_.push(new Effect("MP Cost", String(i)));
        }

        private function initMpCostPerSec():void
        {
            var i:int = 0;
            var xml:XML;
            var form:Formula;
            if(this.abilityXML_.hasOwnProperty("MpCostPerSec"))
            {
                i = int(this.abilityXML_.MpCostPerSec);
            }
            else if (this.abilityXML_.hasOwnProperty("Formula"))
            {
                for each (xml in this.abilityXML_.Formula)
                {
                    if (xml == "MpCostPerSec")
                    {
                        form = new Formula(xml);
                        i = int(Formula.Calculate(form, this.abilityPower));
                    }
                }
            }
            if (i > 0) this.effs_.push(new Effect("MP Cost Per Second", String(i)));
        }

        private function initCooldown():void
        {
            var xml:XML;
            var form:Formula;
            var cd:Number = 0;
            if(this.abilityXML_.hasOwnProperty("Cooldown"))
            {
                cd = int(Math.round(this.abilityXML_.Cooldown / 100)) / 10;
            }
            else if (this.abilityXML_.hasOwnProperty("Formula"))
            {
                for each (xml in this.abilityXML_.Formula)
                {
                    if (xml == "Cooldown")
                    {
                        form = new Formula(xml);
                        cd = int(Math.floor(Formula.Calculate(form, this.abilityPower) / 100)) / 10;
                    }
                }
            }
            if (cd != 0) this.effs_.push(new Effect("Cooldown", String(cd)));
        }

        private function addLine(_arg1:int):void {
            var _local1:TooltipDivider = new TooltipDivider(maxWidth - 12, 0x310800);
            _local1.x = 8;
            _local1.y = _arg1;
            addChild(_local1);
            nextPos(_local1);
        }

        private function _41(_arg1:Vector.<Effect>):String {
            var _local4:Effect;
            var _local5:String;
            var _local2:String = "";
            var _local3:Boolean = true;
            for each (_local4 in _arg1) {
                _local5 = "#FFFF8F";
                if (!_local3) {
                    _local2 = (_local2 + "\n");
                } else {
                    _local3 = false;
                }
                if (_local4.name_ != "") {
                    _local2 = (_local2 + (_local4.name_ + ": "));
                }
                _local2 = (_local2 + (((('<font color="' + _local5) + '">') + _local4.value_) + "</font>"));
            }
            return (_local2);
        }

        private function nextPos(_arg1:DisplayObject=null):int {
            if(_arg1 != null) {
                nextPos_ = _arg1.y + _arg1.height;
            }
            return nextPos_;
        }
    }
}

class Effect {

    public var name_:String;
    public var value_:String;

    public function Effect(_arg1:String, _arg2:String) {
        this.name_ = _arg1;
        this.value_ = _arg2;
    }
}
class Restriction {

    public var text_:String;
    public var color_:uint;
    public var bold_:Boolean;

    public function Restriction(_arg1:String, _arg2:uint, _arg3:Boolean) {
        this.text_ = _arg1;
        this.color_ = _arg2;
        this.bold_ = _arg3;
    }
}