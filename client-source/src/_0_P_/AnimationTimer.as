// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0_P_._3Y_

package _0_P_ {


public class AnimationTimer {

    public function AnimationTimer(_arg1:XML) {
        var _local2:XML;
        this.frames_ = new Vector.<AnimationFrame>();
        super();
        if (("@prob" in _arg1)) {
            this.prob_ = Number(_arg1.@prob);
        }
        this.period_ = int((Number(_arg1.@period) * 1000));
        this.periodJitter_ = int((Number(_arg1.@periodJitter) * 1000));
        this.sync_ = (String(_arg1.@sync) == "true");
        for each (_local2 in _arg1.Frame) {
            this.frames_.push(new AnimationFrame(_local2));
        }
    }
    public var prob_:Number = 1;
    public var period_:int;
    public var periodJitter_:int;
    public var sync_:Boolean = false;
    public var frames_:Vector.<AnimationFrame>;

    public function startPeriod(_arg1:int):int {
        if (this.sync_) {
            return int(_arg1 / this.period_) * this.period_;
        }
        return (_arg1 + this.resetPeriod()) + (200 * Math.random());
    }

    public function continuePeriod(_arg1:int):int {
        if (this.sync_) {
            return (int(_arg1 / this.period_) * this.period_) + this.period_;
        }
        return _arg1 + this.resetPeriod();
    }

    private function resetPeriod():int {
        if (this.periodJitter_ == 0) {
            return (this.period_);
        }
        return (this.period_ - this.periodJitter_) + ((2 * Math.random()) * this.periodJitter_);
    }

}
}//package _0_P_

