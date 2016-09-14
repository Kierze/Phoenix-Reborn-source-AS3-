/**
 * Created by Roxy on 10/24/2015.
 */
package Frames
{
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.TooltipDivider;
import com.company.PhoenixRealmClient.util.CharMoodLibrary;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class MoodRectTooltip extends TooltipBase {

        public function MoodRectTooltip(_argType:int, _argUnlocked:Boolean)
        {
            super(Parameters._primaryColourDefault, 1, 0xFFFFFF, 1);
            _type = _argType;
            _unlocked = _argUnlocked;
            _xml = CharMoodLibrary.TypeToXML[_type];
            _color = _xml.Description.@color;

            if(_argUnlocked)
            {
                this._header = new ObjectTooltipHeader(_color, true, CharMoodLibrary.getImage(_type), CharMoodLibrary.TypeToName[_type]);
            }
            else
            {
                this._header = new ObjectTooltipHeader(0xD8D8D8, true, CharMoodLibrary.getImage(_type), CharMoodLibrary.TypeToName[_type]);
            }
            addChild(this._header);

            this._divider = new TooltipDivider(90, Parameters._primaryColourDark);
            this._divider.x = 6;
            this._divider.y = 228;
            addChild(this._divider);

            if (this._unlocked)
            {
                this._05h = new SimpleText(14, _color, false, 0, 0, "CHIP SB");
            }
            else
            {
                this._05h = new SimpleText(14, 11776947, false, 0, 0, "CHIP SB");
            }
            this._05h.text = ""
            this._05h.updateMetrics();
            this._05h.filters = [new DropShadowFilter(0, 0, 0)];
            this._05h.x = 8;
            this._05h.y = (height - 2);
            addChild(this._05h);
        }
        private var _type:int;
        private var _unlocked:Boolean;
        private var _xml:XML;
        private var _color:int;
        private var _header:ObjectTooltipHeader;
        private var _divider:TooltipDivider;
        private var _05h:SimpleText;

        override public function draw():void
        {
            this._divider._rs((width - 10), Parameters._primaryColourDark);
            super.draw();
        }
    }
}
