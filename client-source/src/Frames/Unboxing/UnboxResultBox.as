/**
 * Created by club5_000 on 9/13/2014.
 */
package Frames.Unboxing {

import Frames.*;

import _vf.SFXHandler;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.ui.Frame2Holder;

import flash.events.Event;
import flash.events.MouseEvent;

public class UnboxResultBox extends Frame2 {

        public function UnboxResultBox(_gs:GameSprite, _items:Vector.<int>, _itemDatas:Vector.<Object>) {
            super("Unboxing...", "", 300);
            this.gs_ = _gs;
            this.unboxScroll_ = new UnboxScroll(444 + (Math.random() * 8), _items, _itemDatas);
            this.unboxScroll_.x = (this.w_ / 2) - (UnboxScroll.WIDTH / 2) - 4;
            this.unboxScroll_.y = this.h_ - 66;
            addChild(this.unboxScroll_);
            this.offsetH(UnboxScroll.HEIGHT);
            this.mystInv_ = new EmbedMysteryInv();
            this.mystInv_.x = 838;
            this.mystInv_.y = 500;
            this.gs_.addChild(this.mystInv_);

            this.unboxScroll_.addEventListener(Event.COMPLETE, onComplete);
            XButton.addEventListener(MouseEvent.CLICK, onComplete);
        }
        private var mystInv_:EmbedMysteryInv;
        private var gs_:GameSprite;
        private var unboxScroll_:UnboxScroll;

        private function onComplete(event:Event):void {
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
            this.gs_.removeChild(this.mystInv_);
            SFXHandler.play("loot_appears");
            var _local1:ItemResultBox = new ItemResultBox(this.gs_, unboxScroll_.itemTypes_[45], "unboxed", unboxScroll_.itemDatas_[45]);
            this.gs_.stage.addChild(new Frame2Holder(_local1));
        }

    }
}
