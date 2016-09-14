// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._I_b

package ParticleAnimations {
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.objects.GameObject;

import flash.display.IGraphicsData;

public class ObjectEffect extends GameObject {

    public static function VisualObjectEffect(_arg1:XmlEffectProperties, _arg2:GameObject):ObjectEffect {
        switch (_arg1.id) {
            case "Healing":
                return (new HealingEffect(_arg2));
            case "Fountain":
                return (new FountainEffect(_arg2));
            case "Gas":
                return (new GasEffect(_arg2, _arg1));
            case "Vent":
                return (new VentEffect(_arg2));
            case "Bubbles":
                return (new BubbleEffect(_arg2, _arg1));
            case "XMLEffect":
                return (new XMLEffect(_arg2, _arg1));
            case "CustomParticles":
                return (new CustomParticleEffect(_arg1, _arg2));
            case "CloudParticles":
                var _local1:CustomParticleEffect = new CustomParticleEffect(_arg1, _arg2);
                _local1.cloud_ = true;
                return _local1;
            case "Orbiting":
                return (new OrbitEffect(_arg1, _arg2));
            case "FollowOrbiting":
                return (new FollowOrbitEffect(_arg1, _arg2));
            case "QuadSpaceConcentrate":
                return (new QuadSpaceConcentrate(_arg1, _arg2));
        }
        return (null);
    }

    public function ObjectEffect() {
        super(null);
        objectId_ = bitShift();
        _P_m = false;
    }

    override public function update(_arg1:int, _arg2:int):Boolean {
        return (false);
    }

    override public function draw(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void {
    }

}
}//package _0K_m

