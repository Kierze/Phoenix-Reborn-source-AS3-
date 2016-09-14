/**
 * Created by Roxy on 10/25/2015.
 */
package Frames
{

import Packets.fromServer.CheckMoodsReturnPacket;

import _sp.Signal;

import com.company.PhoenixRealmClient.util.CharMoodLibrary;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class MoodRectList extends Sprite
    {

        public function MoodRectList(_arg1:CheckMoodsReturnPacket)
        {
            var openMood:UnlockedMoodRect;
            var closeMood:LockedMoodRect;
            super();
            this.moodList = _arg1;
            //this.screen_ = _arg2;
            this.newCharacter = new Signal();
            var _local3:int = 4;
            var _local4:int = 4;

            var counter:int = 0;
            var countMax:int = this.moodList.unlockedMoods.length;
            while (counter < countMax)
            {
                if (this.moodList.unlockedMoods[counter])
                {
                    openMood = new UnlockedMoodRect(counter);
                    openMood.addEventListener(MouseEvent.MOUSE_DOWN, this.ChooseMoodRect);
                    openMood.x = _local3;
                    openMood.y = _local4;
                    addChild(openMood);
                    _local4 = (_local4 + (UnlockedMoodRect.HEIGHT + 4));
                }
                else
                {
                    if (CharMoodLibrary.TypeToXML[counter].hasOwnProperty("Secret")) continue;

                    closeMood = new LockedMoodRect(counter);
                    closeMood.x = _local3;
                    closeMood.y = _local4;
                    addChild(closeMood);
                    _local4 = (_local4 + (LockedMoodRect.HEIGHT + 4));
                }
                counter++
            }
        }
        public var newCharacter:Signal;
        public var deleteCharacter:Signal;
        private var moodList:CheckMoodsReturnPacket;
        /*
        private var screen_:_05p;

        private function onCancel(_arg1:Event):void
        {
            var _local2:_qO_ = (_arg1.currentTarget as _qO_);
            this.screen_.removeChild(_local2);
        }
        */

        private function ChooseMoodRect(_arg1:Event):void
        {
            this.newCharacter.dispatch();
        }

    }
}
