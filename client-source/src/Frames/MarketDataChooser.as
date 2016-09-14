/**
 * Created by club5_000 on 9/13/2014.
 */
package Frames {
import Tooltips.EquipmentToolTip;

import _ke._U_c;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;

public class MarketDataChooser extends Frame {

        public function MarketDataChooser(_gs:GameSprite, _item:int) {
            super("Add item to trade", "Cancel", "OK", "/itemResult");
            this.gs_ = _gs;
            this.itemType_ = _item;
            this.canceled_ = false;
            this.addIcon();
        }

        public var canceled_:Boolean;
        public var itemType_:int;
        public var itemData_:Object;
        private var gs_:GameSprite;
        private var itemBitmap_:Bitmap;
        private var toolTip_:EquipmentToolTip;
        private var strangePart_:TextInput;
        private var strangifier_:TextInput;
        private var strange_:CheckBox;
        private var unusual_:CheckBox;
        private var effect_:TextInput;

        private function addIcon() {
            var _local1:XML = ObjectLibrary.typeToXml[this.itemType_];
            var _local2:Number = 5;
            if (_local1.hasOwnProperty("ScaleValue")) {
                _local2 = _local1.ScaleValue;
            }
            var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.itemType_, 60, true, true, _local2);
            if(this.itemData_ != null && this.itemData_.hasOwnProperty("TextureFile") && this.itemData_.TextureFile != "") {
                _local3 = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.itemType_, 60, true, this.itemData_, true, _local2);
            }
            _local3 = BitmapUtil.getRectanglefromBitmap(_local3, 4, 4, (_local3.width - 8), (_local3.height - 8));
            this.itemBitmap_ = new Bitmap(_local3);
            this.itemBitmap_.scaleX = this.itemBitmap_.scaleY = 2;
            //this.itemBitmap_.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            //this.itemBitmap_.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            //this.itemBitmap_.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStage);
            this.addDisplayObject(this.itemBitmap_, this.w_ / 2 - this.itemBitmap_.width / 2 - 10);

            this.strangePart_ = new TextInput("Strange Part", false, "");
            this.strangifier_ = new TextInput("Item Name", false, "");
            this.strange_ = new CheckBox("Strange", false, "");
            this.unusual_ = new CheckBox("Unusual", false, "");
            this.effect_ = new TextInput("Unusual Effect", false, "");

            if(_local1.@id == "Strange Part") {
                this.addTextInputBox(this.strangePart_);
            }
            if(_local1.@id == "Strangifier") {
                this.addTextInputBox(this.strangifier_);
            }
            if(_local1.hasOwnProperty("Projectile")) {
                this.addCheckBox(this.strange_);
            }
            if(_local1.hasOwnProperty("Activate") && _local1.Activate == "UnlockSkin") {
                this.addCheckBox(this.unusual_);
                this.addTextInputBox(this.effect_);
            }

            Button1.addEventListener(MouseEvent.CLICK, this.onClose);
            Button2.addEventListener(MouseEvent.CLICK, this.onComplete)
        }

        private function removeTooltip() {
            if (toolTip_ != null) {
                if (toolTip_.parent != null) {
                    toolTip_.parent.removeChild(toolTip_);
                }
                toolTip_ = null;
            }
        }

        private function onMouseOver(e:MouseEvent) {
            if(this.toolTip_ == null) {
                this.toolTip_ = new EquipmentToolTip(this.itemType_, this.gs_.map_.player_, -1, _U_c.NPC, 1, false, this.itemData_);
                stage.addChild(this.toolTip_);
            }
        }

        private function onMouseOut(e:MouseEvent) {
            this.removeTooltip();
        }

        private function onRemovedFromStage(e:Event) {
            this.removeTooltip();
        }

        private function onClose(e:Event) {
            stage.focus = null;
            this.canceled_ = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onComplete(event:MouseEvent):void {
            stage.focus = null;
            this.itemData_ = {};
            if(this.strangePart_.parent != null) {
                this.itemData_.NamePrefix = this.strangePart_.text();
            }
            if(this.strangifier_.parent != null) {
                this.itemData_.NamePrefix = this.strangifier_.text();
                this.itemData_.NameColor = 0xFF5A28;
            }
            if(this.strange_.parent != null) {
                if(this.strange_._u6()) {
                    this.itemData_.NamePrefix = "Strange";
                    this.itemData_.NameColor = 0xFF5A28;
                    this.itemData_.Strange = true;
                    this.itemData_.Kills = 0;
                }
            }
            if(this.unusual_.parent != null && this.unusual_._u6()) {
                this.itemData_.NamePrefix = "Unusual";
                this.itemData_.NameColor = 0x8000FF;
                if(this.effect_.parent != null && this.effect_.text() != "") {
                    this.itemData_.Effect = this.effect_.text();
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}
