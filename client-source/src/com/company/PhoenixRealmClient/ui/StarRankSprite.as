// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._0G_h

package com.company.PhoenixRealmClient.ui {
import com.company.PhoenixRealmClient.util.ClassQuest;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;

public class StarRankSprite extends Sprite
{

    public function StarRankSprite(_arg1:int, _arg2:Boolean, _arg3:Boolean)
    {
        this.big = _arg2;
        if (_arg3)
        {
            this.RankText = new SimpleText(((this.big) ? 18 : 16), 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.RankText.setBold(this.big);
            this.RankText.text = "Rank: ";
            this.RankText.updateMetrics();
            this.RankText.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.RankText);
        }
        mouseEnabled = false;
        mouseChildren = false;
        this.draw(_arg1);
    }
    public var sprite:Sprite = null;
    public var big:Boolean;
    private var numStars_:int = -1;
    private var RankText:SimpleText = null;

    public function draw(_arg1:int):void
    {
        var starSprite:Sprite;
        if (_arg1 == this.numStars_)
        {
            return;
        }
        this.numStars_ = _arg1;
        if ((this.sprite != null) && (contains(this.sprite)))
        {
            removeChild(this.sprite);
        }
        if (this.numStars_ < 0)
        {
            return;
        }
        this.sprite = new Sprite();
        var starsText:SimpleText = new SimpleText(((this.big) ? 18 : 16), 0xB3B3B3, false, 0, 0, "Myriad Pro");
        starsText.setBold(this.big);
        starsText.text = this.numStars_.toString();
        starsText.updateMetrics();
        starsText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.sprite.addChild(starsText);

        starSprite = ((this.big) ? ClassQuest.StarSprite(this.numStars_) : ClassQuest.ClassQuestsToStarSprite(this.numStars_));
        starSprite.x = (starsText.width + 2);
        this.sprite.addChild(starSprite);
        starSprite.y = (int(((starsText.height / 2) - (starSprite.height / 2))) + 1);

        var nextX:int = (starSprite.x + starSprite.width);
        this.sprite.graphics.clear();
        this.sprite.graphics.beginFill(0, 0.4);
        this.sprite.graphics.drawRoundRect(-2, (starSprite.y - 3), (nextX + 6), (starSprite.height + 8), 12, 12);
        this.sprite.graphics.endFill();
        addChild(this.sprite);
        if (this.RankText != null)
        {
            addChild(this.RankText);
            this.sprite.x = this.RankText.width;
        }
    }

}
}//package com.company.PhoenixRealmClient.ui

