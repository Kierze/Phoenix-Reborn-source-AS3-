// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.Sign

package com.company.PhoenixRealmClient.objects {
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.util.TextureRedrawer;

import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Sign extends GameObject {

    public function Sign(_arg1:XML) {
        super(_arg1);
        texture_ = null;
    }

    override protected function getTexture(_arg1:View, _arg2:int):BitmapData {
        if (texture_ != null) {
            return (texture_);
        }
        var _local3:TextField = new TextField();
        _local3.multiline = true;
        _local3.wordWrap = false;
        _local3.autoSize = TextFieldAutoSize.LEFT;
        _local3.textColor = 0xFFFFFF;
        _local3.embedFonts = true; // CHANGED - was true, changed to false so that text shows (there is a problem with embeded fonts)
        var _local4:TextFormat = new TextFormat();
        _local4.align = TextFormatAlign.CENTER;
        _local4.font = "Myriad Pro";
        _local4.size = 24;
        _local4.color = 0xFFFFFF;
        _local4.bold = true;
        _local3.defaultTextFormat = _local4;
        _local3.text = name_.split("|").join("\n");
        var _local5:BitmapData = new BitmapData(_local3.width, _local3.height, true, 0);
        _local5.draw(_local3);
        texture_ = TextureRedrawer.redraw(_local5, size_, false, 0);
        return (texture_);
    }

}
}//package com.company.PhoenixRealmClient.objects

