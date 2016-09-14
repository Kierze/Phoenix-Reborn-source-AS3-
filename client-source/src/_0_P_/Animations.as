// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0_P_.Animations

package _0_P_ {

import flash.display.BitmapData;

public class Animations {

    public function Animations(_arg1:AnimateFromXML) {
        this.animateFromXml_ = _arg1;
    }
    public var animateFromXml_:AnimateFromXML;
    public var frameTimes:Vector.<int> = null;
    public var runningAnim:RunningAnimation = null;

    public function getTexture(_arg1:int):BitmapData {
        var animationTimer:AnimationTimer;
        var _local4:BitmapData;
        var _local5:int;
        if (this.frameTimes == null) {
            this.frameTimes = new Vector.<int>();
            for each (animationTimer in this.animateFromXml_.animations_) {
                this.frameTimes.push(animationTimer.startPeriod(_arg1));
            }
        }
        if (this.runningAnim != null) {
            _local4 = this.runningAnim.getTexture(_arg1);
            if (_local4 != null) {
                return (_local4);
            }
            this.runningAnim = null;
        }
        var _local3:int = 0;
        while (_local3 < this.frameTimes.length) {
            if (_arg1 > this.frameTimes[_local3]) {
                _local5 = this.frameTimes[_local3];
                animationTimer = this.animateFromXml_.animations_[_local3];
                this.frameTimes[_local3] = animationTimer.continuePeriod(_arg1);
                if (!((animationTimer.prob_ != 1) && (Math.random() > animationTimer.prob_))) {
                    this.runningAnim = new RunningAnimation(animationTimer, _local5);
                    return (this.runningAnim.getTexture(_arg1));
                }
            }
            _local3++;
        }
        return (null);
    }

}
}//package _0_P_

import _0_P_.AnimationFrame;
import _0_P_.AnimationTimer;

import flash.display.BitmapData;

class RunningAnimation {

    public var animationData_:AnimationTimer;
    public var start_:int;
    public var frameId_:int;
    public var frameStart_:int;
    public var texture_:BitmapData;

    public function RunningAnimation(_arg1:AnimationTimer, _arg2:int) {
        this.animationData_ = _arg1;
        this.start_ = _arg2;
        this.frameId_ = 0;
        this.frameStart_ = _arg2;
        this.texture_ = null;
    }

    public function getTexture(_arg1:int):BitmapData {
        var frame:AnimationFrame = this.animationData_.frames_[this.frameId_];
        while ((_arg1 - this.frameStart_) > frame.time_) {
            if (this.frameId_ >= (this.animationData_.frames_.length - 1)) {
                return (null);
            }
            this.frameStart_ = (this.frameStart_ + frame.time_);
            this.frameId_++;
            frame = this.animationData_.frames_[this.frameId_];
            this.texture_ = null;
        }
        if (this.texture_ == null) {
            this.texture_ = frame.texture_.getTexture((Math.random() * 100));
        }
        return (this.texture_);
    }

}

