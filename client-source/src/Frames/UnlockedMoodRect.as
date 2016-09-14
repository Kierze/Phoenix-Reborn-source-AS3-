/**
 * Created by Roxy on 10/23/2015.
 */

package Frames {

import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.CharMoodLibrary;
import com.company.graphic.StarGraphic;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class UnlockedMoodRect extends RectangleSprite {

        private static var toolTip_:TooltipBase = null;
        public static const WIDTH:int = 250;
        public static const HEIGHT:int = 50;

        public function UnlockedMoodRect(_type:int) {
            super(Parameters._primaryColourLight, Parameters._primaryColourLight2, WIDTH, HEIGHT);
            this.Type = _type;
            this.Xml = CharMoodLibrary.TypeToXML[_type];
            this.makeSelectContainer();
            this.makeBitmap();
            this.makeNameText();
            this.MakeTagline();
            //this.selected = new _u3(this.selectContainer, MouseEvent.CLICK).mapTo(this.character);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        public var Type:int;
        public var Xml:XML;
        //public var selected:Signal;
        private var selectContainer:DisplayObjectContainer;
        private var bitmap:Bitmap;
        private var _nameText:SimpleText;
        private var taglineIcon:Sprite;
        private var taglineText:SimpleText;

        private function makeSelectContainer():void {
            this.selectContainer = new Sprite();
            Sprite(this.selectContainer).graphics.beginFill(0xFF00FF, 0);
            Sprite(this.selectContainer).graphics.drawRect(0, 0, (WIDTH - 30), HEIGHT);
            addChild(this.selectContainer);
        }

        private function makeBitmap():void {
            this.bitmap = new Bitmap();
            this.selectContainer.addChild(this.bitmap);
            this.setImage(this.Type);
        }

        private function makeNameText():void {
            this._nameText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            this._nameText.setBold(true);
            this._nameText.text = this.Xml.Name;
            this._nameText.updateMetrics();
            this._nameText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this._nameText.x = 58;
            this.selectContainer.addChild(this._nameText);
        }

        private function MakeTagline():void {
            this.makeTaglineIcon();
            this.makeTaglineText();
        }

        private function makeTaglineIcon():void {
            this.taglineIcon = new StarGraphic();
            this.taglineIcon.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
            this.taglineIcon.scaleX = 1.2;
            this.taglineIcon.scaleY = 1.2;
            this.taglineIcon.x = 58;
            this.taglineIcon.y = 26;
            this.taglineIcon.filters = [new DropShadowFilter(0, 0, 0)];
            this.selectContainer.addChild(this.taglineIcon);
        }

        private function makeTaglineText():void {
            this.taglineText = new SimpleText(14, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.taglineText.text = "Unlocked!";
            this.taglineText.updateMetrics();
            this.taglineText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.taglineText.x = ((58 + this.taglineIcon.width) + 2);
            this.taglineText.y = 24;
            this.selectContainer.addChild(this.taglineText);
        }

        private function removeToolTip():void {
            if (toolTip_ != null) {
                if (((!((toolTip_.parent == null))) && (toolTip_.parent.contains(toolTip_)))) {
                    toolTip_.parent.removeChild(toolTip_);
                }
                toolTip_ = null;
            }
        }

        private function setImage(_type:int):void {
            var _local4:BitmapData = CharMoodLibrary.getImage(_type);
            _local4 = BitmapUtil.getRectanglefromBitmap(_local4, 6, 6, (_local4.width - 12), (_local4.height - 6));
            this.bitmap.bitmapData = _local4;
            this.bitmap.x = 0;
        }

        override protected function onMouseOver(_arg1:MouseEvent):void {
            super.onMouseOver(_arg1);
            this.removeToolTip();
            toolTip_ = new MoodRectTooltip(this.Type, true);
            stage.addChild(toolTip_);
        }

        override protected function onRollOut(_arg1:MouseEvent):void {
            super.onRollOut(_arg1);
            this.removeToolTip();
        }

        private function onRemovedFromStage(_arg1:Event):void {
            this.removeToolTip();
        }
    }
}


