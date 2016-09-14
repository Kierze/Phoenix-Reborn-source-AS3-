// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0_P_._0F_7

package _0_P_ {


public class AnimateFromXML {

    public function AnimateFromXML(_arg1:XML) {
        var _local2:XML;
        this.animations_ = new Vector.<AnimationTimer>();
        super();
        for each (_local2 in _arg1.Animation) {
            this.animations_.push(new AnimationTimer(_local2));
        }
    }
    public var animations_:Vector.<AnimationTimer>;
}
}//package _0_P_

