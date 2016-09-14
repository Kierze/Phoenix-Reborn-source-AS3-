// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._C_e

package ParticleAnimations {
import com.company.PhoenixRealmClient.net.messages.data.Position;
import com.company.PhoenixRealmClient.objects.GameObject;

import flash.geom.Point;

public class DiffuseEffect extends ObjectEffect {

    public function DiffuseEffect(_arg1:GameObject, _arg2:Position, _arg3:Position, _arg4:int) {
        this.center_ = new Point(_arg2.x_, _arg2.y_);
        this._H_S_ = new Point(_arg3.x_, _arg3.y_);
        this.color_ = _arg4;
    }
    public var center_:Point;
    public var _H_S_:Point;
    public var color_:int;

    override public function update(_arg1:int, _arg2:int):Boolean {
        var _local7:Number;
        var _local8:Point;
        var _local9:Particle;
        x_ = this.center_.x;
        y_ = this.center_.y;
        var _local3:Number = Point.distance(this.center_, this._H_S_);
        var _local4:int = 100;
        var _local5:int = 24;
        var _local6:int = 0;
        while (_local6 < _local5)
        {
            _local7 = (((_local6 * 2) * Math.PI) / _local5);
            _local8 = new Point((this.center_.x + (_local3 * Math.cos(_local7))), (this.center_.y + (_local3 * Math.sin(_local7))));
            _local9 = new MovingDecayParticle(_local4, this.color_, (100 + (Math.random() * 200)), this.center_, _local8);

            map_.addObj(_local9, x_, y_);
            _local6++;
        }
        return (false);
    }

}
}//package _0K_m

