/**
 * Created by club5_000 on 1/21/2016.
 */
package Frames.Unboxing {
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextFormatAlign;

public class UnboxSquare extends Sprite {
    public function UnboxSquare(_item:int, _itemData:Object=null, _id:int=0) {
        this.itemType_ = _item;
        this.itemData_ = _itemData;
        this.id_ = _id;
        addIcon();
    }
    public var itemType_:int;
    public var itemData_:Object;
    public var background:Sprite;
    public var itemBitmap_:Bitmap;
    public var itemName_:SimpleText;
    public var id_:int;

    private function addIcon() {
        var _local1:XML = ObjectLibrary.typeToXml[this.itemType_];
        var _local2:Number = 5;
        if (_local1.hasOwnProperty("ScaleValue")) {
            _local2 = _local1.ScaleValue;
        }
        var _local5:uint = 0x9E9E00;
        if(this.itemData_ != null && this.itemData_.hasOwnProperty("NameColor")) {
            _local5 = this.itemData_.NameColor;
            if(_local5 == 0xFFFFFF) {
                _local5 = 0x9E9E00;
            }
        }
        this.background = new Sprite();
        this.background.graphics.beginFill(_local5);
        this.background.graphics.drawRect(0, 0, 75, 75);
        this.background.graphics.endFill();
        this.background.addChild(new EmbedUnboxSquare());
        addChild(this.background);
        var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.itemType_, 60, true, true, _local2);
        if(this.itemData_ != null && this.itemData_.hasOwnProperty("TextureFile") && this.itemData_.TextureFile != "") {
            _local3 = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.itemType_, 60, true, this.itemData_, true, _local2);
        }
        _local3 = BitmapUtil.getRectanglefromBitmap(_local3, 4, 4, (_local3.width - 8), (_local3.height - 8)); //check this just to be sure
        this.itemBitmap_ = new Bitmap(_local3);
        this.itemBitmap_.x = (75 / 2) - (this.itemBitmap_.width / 2);
        this.itemBitmap_.y = (50 / 2) - (this.itemBitmap_.height / 2);
        addChild(this.itemBitmap_);
        this.itemName_ = new SimpleText(10, 0x000000, false, 77, 0, "CHIP SB");
        this.itemName_.setBold(true);
        this.itemName_.setAlign(TextFormatAlign.CENTER);
        this.itemName_.text = ObjectLibrary.typeToDisplayId[this.itemType_];
        this.itemName_.wordWrap = true;
        if (this.itemData_ != null && this.itemData_.hasOwnProperty("Name") && this.itemData_.Name != "") {
            this.itemName_.text = this.itemData_.Name;
        }
        if (this.itemData_ != null && this.itemData_.hasOwnProperty("NamePrefix") && this.itemData_.NamePrefix != "") {
            this.itemName_.text = this.itemData_.NamePrefix + " " + this.itemName_.text;
        }
        this.itemName_.updateMetrics();
        this.itemName_.y = (25 / 2 + 50) - (this.itemName_.textHeight / 2) - 3;
        this.itemName_.x = -1;
        addChild(this.itemName_);
    }
}
}
