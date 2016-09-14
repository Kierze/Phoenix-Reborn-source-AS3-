/**
 * Created by Roxy on 10/23/2015.
 */
package Frames
{
import Packets.fromServer.CheckMoodsReturnPacket;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.ui.ScrollBar;

import flash.events.Event;
import flash.events.MouseEvent;

public class MoodChooser extends Frame
    {
        public function MoodChooser(_arg1:GameSprite, _arg2:CheckMoodsReturnPacket)
        {
            this.gs_ = _arg1;
            this._data = _arg2;
            super("Choose your character's mood!", "", "Cancel", "/moodChange", Math.max(320, this.choice_.width+38));
            //offsetH(142);
            buildMoodsList();
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
            Button2.addEventListener(MouseEvent.CLICK, onClose);
        }

        public var _data:CheckMoodsReturnPacket;
        public var _scrollBar:ScrollBar;
        public var _list:MoodChooserList;

        private function buildScroll():void{
            this._scrollBar = new ScrollBar(16, 299);
            this._scrollBar.x = 274;
            this._scrollBar.y = 113;
            this._scrollBar._fA_(399, this._list.height);
            this._scrollBar.addEventListener(Event.CHANGE, this.Scroll);
            addChild(this._scrollBar);
        }

        private function buildMoodsList():void
        {
            this._list = new MoodChooserList(this._data);
            this._list.x = 14;
            this._list.y = 108;
            if (this._list.height > 300) {
                this.buildScroll();
            }
            addChild(this._list);
        }

        private function Scroll(_arg1:Event):void {
            this._list.listScroll((-(this._scrollBar._Q_D_()) * (this._list.height - 400)));
        }

        private function onClose(event:MouseEvent):void {
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private var gs_:GameSprite;
        private var choice_:TextList;
        private var currentSpec_:String;

        private function onEnterFrame(event:Event):void {
            if(this.choice_._rq() != this.currentSpec_) {
                this.currentSpec_ = this.choice_._rq();
            }
        }

        private function addedToStage(event:Event):void {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function removedFromStage(event:Event):void {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
    }
}
