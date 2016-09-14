/**
 * Created by Roxy on 10/25/2015.
 */
package Frames
{
import Packets.fromServer.CheckMoodsReturnPacket;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

public class MoodChooserList extends Sprite
    {

        public static const WIDTH:int = 400;
        public static const HEIGHT:int = 315;

        public var list_:Sprite = new Sprite;

        public function MoodChooserList(_arg1:CheckMoodsReturnPacket/*, _arg2:_05p */)
        {
            var _local3:Shape;
            var _local4:Graphics;
            super();
            this.list_ = new MoodRectList(_arg1);
            addChild(this.list_);
            if (height > 300) {
                _local3 = new Shape();
                _local4 = _local3.graphics;
                _local4.beginFill(0);
                _local4.drawRect(0, 0, WIDTH, HEIGHT);
                _local4.endFill();
                addChild(_local3);
                mask = _local3;
            }
        }

        public function listScroll(_arg1:Number):void
        {
            this.list_.y = _arg1;
        }
    }
}
