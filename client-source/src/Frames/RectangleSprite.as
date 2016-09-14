/**
 * Created by Roxy on 10/23/2015.
 */
package Frames {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class RectangleSprite extends Sprite {

        public function RectangleSprite(color:uint, overColor:uint, width:int, height:int) {
            this.color_ = color;
            this.overColor_ = overColor;
            this.width_ = width;
            this.height_ = height;
            this.box_ = new Shape();
            this.drawBox(false);
            addChild(this.box_);
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        }
        public var width_:int;
        public var height_:int;

        private var color_:uint;
        private var overColor_:uint;
        private var box_:Shape;

        private function drawBox(_arg1:Boolean):void {
            var _local2:Graphics = this.box_.graphics;
            _local2.clear();
            _local2.beginFill(_arg1 ? this.overColor_ : this.color_);
            _local2.drawRect(0, 0, width_, height_);
            _local2.endFill();
        }

        protected function onMouseOver(_arg1:MouseEvent):void {
            this.drawBox(true);
        }

        protected function onRollOut(_arg1:MouseEvent):void {
            this.drawBox(false);
        }

    }
}
