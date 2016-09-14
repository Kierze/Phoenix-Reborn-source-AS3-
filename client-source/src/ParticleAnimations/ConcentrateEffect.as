package ParticleAnimations
{
import com.company.PhoenixRealmClient.net.messages.data.Position;

import flash.geom.Point;

public class ConcentrateEffect extends ObjectEffect
    {

        public function ConcentrateEffect(centerPos:Position, position2:Position, color:int)
        {
            this.center_ = new Point(centerPos.x_, centerPos.y_);
            this.radius = new Point(position2.x_, position2.y_);
            this.color_ = color;
        }
        public var center_:Point;
        public var radius:Point;
        public var color_:int;

        override public function update(_arg1:int, _arg2:int):Boolean
        {
            var angle_:Number;
            var startPos:Point;
            var particle:Particle;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var radius_:Number = Point.distance(this.center_, this.radius);
            var initialSize:int = 300;
            var lifeTime:int = 200;
            var points:int = 24;
            var count:int = 0;
            while (count < points)
            {
                angle_ = ((count * 2) * Math.PI) / points;
                startPos = new Point(this.center_.x + (radius_ * Math.cos(angle_)), this.center_.y + (radius_ * Math.sin(angle_)));
                particle = new MovingDecayParticle(initialSize, this.color_, lifeTime, startPos, this.center_);
                map_.addObj(particle, x_, y_);
                count++;
            }
            return (false);
        }

    }
}

