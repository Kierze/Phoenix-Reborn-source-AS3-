package com.company.logo{

    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.display.BlendMode;
    import com.company.rotmg.graphics.logo.Clouds;
    import com.company.rotmg.graphics.logo.Guy;
    import flash.utils.getTimer;

    public class AnimatedLogo extends Sprite {

        private static const PERIOD:int = 2000;

        private var background_:Bitmap;
        private var overlay_:Sprite;
        private var startTime_:int = -1;

        public function AnimatedLogo(){
            this.background_ = getBackground();
            this.overlay_ = getOverlay();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        private static function getBackground():Bitmap{
            var _local1:BitmapData = new BitmapData(0x0100, 0x0100, false, 0xFF000000);
            var _local2:int = (Math.random() * int.MAX_VALUE);
            _local1.perlinNoise(_local1.width, _local1.height, 8, _local2, true, false, ((BitmapDataChannel.RED | BitmapDataChannel.GREEN) | BitmapDataChannel.BLUE), true, null);
            var _local3:ColorTransform = new ColorTransform(2, 2, 2, 1, 0, 0, 0, 0);
            _local1.colorTransform(_local1.rect, _local3);
            var _local4:BitmapData = new BitmapData((_local1.width * 2), _local1.height, false);
            _local4.copyPixels(_local1, _local1.rect, new Point(0, 0));
            _local4.copyPixels(_local1, _local1.rect, new Point(_local1.width, 0));
            _local1.dispose();
            return (new Bitmap(_local4));
        }

        private static function getOverlay():Sprite{
            var _local1:Sprite = new Sprite();
            _local1.blendMode = BlendMode.LAYER;
            _local1.addChild(new Clouds());
            var _local2:Guy = new Guy();
            _local2.x = ((_local1.width / 2) - (_local2.width / 2));
            _local2.y = ((_local1.height / 2) - (_local2.height / 2));
            _local2.blendMode = BlendMode.ERASE;
            _local1.addChild(_local2);
            _local1.x = ((800 / 2) - (_local1.width / 2));
            _local1.y = ((600 / 2) - (_local1.height / 2));
            _local1.blendMode = BlendMode.ERASE;
            var _local3:Sprite = new Sprite();
            _local3.blendMode = BlendMode.LAYER;
            _local3.graphics.beginFill(0, 1);
            _local3.graphics.drawRect(0, 0, 800, 600);
            _local3.graphics.endFill();
            _local3.addChild(_local1);
            return (_local3);
        }


        private function onAddedToStage(_arg1:Event):void{
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        private function onRemovedFromStage(_arg1:Event):void{
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        private function onEnterFrame(_arg1:Event):void{
            this.moveBackground();
        }

        private function moveBackground():void{
            var _local1:int = getTimer();
            if (this.startTime_ == -1)
            {
                this.startTime_ = _local1;
                addChild(this.background_);
                addChild(this.overlay_);
            };
            var _local2:Number = (((_local1 - this.startTime_) % PERIOD) / PERIOD);
            this.background_.x = (0x0100 * _local2);
            this.background_.y = ((600 / 2) - (this.background_.height / 2));
        }
    }
}