package _02t {
import flash.display.Shape;

public class Overlay extends Shape {

        public function Overlay(){
            graphics.beginFill(0x2B2B2B, 0.8);
            graphics.drawRect(0, 0, 1024, 768);
            graphics.endFill();
        }
    }
}
