// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._9h

package ParticleAnimations {
import com.company.PhoenixRealmClient.net.messages.data.Position;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.util._04d;

import flash.geom.Point;

public class LightningEffect extends ObjectEffect {

    public function LightningEffect(_arg1:GameObject, _arg2:Position, _arg3:int, _arg4:int) {
        this.start_ = new Point(_arg1.x_, _arg1.y_);
        this.end_ = new Point(_arg2.x_, _arg2.y_);
        this.color_ = _arg3;
        this._wp = _arg4;
    }
    public var start_:Point;
    public var end_:Point;
    public var color_:int;
    public var _wp:int;

    override public function update(_arg1:int, _arg2:int):Boolean {
        var _local6:Point;
        var _local7:Particle;
        var _local8:Number;
        x_ = this.start_.x;
        y_ = this.start_.y;
        var _local3:Number = Point.distance(this.start_, this.end_);
        var _local4:int = (_local3 * 3);
        var _local5:int;
        while (_local5 < _local4) {
            _local6 = Point.interpolate(this.start_, this.end_, (_local5 / _local4));
            _local7 = new DecayParticle(this._wp, this.color_, (1000 - ((_local5 / _local4) * 900)), 0.5, 0, 0);
            _local8 = Math.min(_local5, (_local4 - _local5));
            map_.addObj(_local7, (_local6.x + _04d._F_e(((_local3 / 200) * _local8))), (_local6.y + _04d._F_e(((_local3 / 200) * _local8))));
            _local5++;
        }
        return (false);
    }

}
}//package _0K_m

