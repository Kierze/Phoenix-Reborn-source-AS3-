// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7.QuestTooltip

package Tooltips {
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.ui.CharObjectHeader;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class QuestTooltip extends TooltipBase {

    public function QuestTooltip(_arg1:GameObject) {
        super(6036765, 1, 16549442, 1, false);
        this.text_ = new SimpleText(22, 16549442, false, 0, 0, "Myriad Pro");
        this.text_.setBold(true);
        this.text_.text = "Quest!";
        this.text_.updateMetrics();
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];
        this.text_.x = 0;
        this.text_.y = 0;
        addChild(this.text_);
        this._id = new CharObjectHeader(0xB3B3B3, true, _arg1);
        this._id.x = 0;
        this._id.y = 32;
        addChild(this._id);
        filters = [];
    }
    public var _id:CharObjectHeader;
    private var text_:SimpleText;
}
}//package _E_7

