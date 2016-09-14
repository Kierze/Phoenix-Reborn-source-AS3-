// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._l2

package ParticleAnimations {
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.util._04d;

public class DeadEffect extends ObjectEffect {

    public function DeadEffect(_arg1:GameObject, _arg2:int) {
        this.go_ = _arg1;
        this.color_ = _arg2;
    }
    public var go_:GameObject;
    public var color_:int;

    override public function update(_arg1:int, _arg2:int):Boolean {
        if (this.go_.map_ == null) {
            return (false);
        }
        x_ = this.go_.x_;
        y_ = this.go_.y_;
        var _local3:int = 10;
        var _local4:int;
        while (_local4 < _local3) {
            map_.addObj(new DecayParticle(100, this.color_, 400, 0.75, _04d._F_e(4), _04d._F_e(4)), x_, y_);
            _local4++;
        }
        return (false);
    }

}
}//package _0K_m

