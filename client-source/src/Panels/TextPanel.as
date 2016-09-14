// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_R_v._X_i

package Panels {
import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.ui.Button;
import com.company.ui.SimpleText;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class TextPanel extends Panel {

    public function TextPanel(_arg1:GameSprite, _arg2:String, _arg3:String) {
        super(_arg1);
        this._P_V_ = new SimpleText(18, 0xFFFFFF, false, WIDTH, 0, "Myriad Pro");
        this._P_V_.setBold(true);
        this._P_V_.htmlText = (('<p align="center">' + _arg2) + "</p>");
        this._P_V_.wordWrap = true;
        this._P_V_.multiline = true;
        this._P_V_.autoSize = TextFieldAutoSize.CENTER;
        this._P_V_.filters = [new DropShadowFilter(0, 0, 0)];
        this._P_V_.y = 6;
        addChild(this._P_V_);
        this._ek = new Button(16, _arg3);
        this._ek.addEventListener(MouseEvent.CLICK, this.onButtonClick);
        this._ek.x = ((WIDTH / 2) - (this._ek.width / 2));
        this._ek.y = ((HEIGHT - this._ek.height) - 4);
        addChild(this._ek);
    }
    protected var _ek:Button;
    private var _P_V_:SimpleText;

    protected function onButtonClick(_arg1:MouseEvent):void {
    }

}
}//package _R_v

