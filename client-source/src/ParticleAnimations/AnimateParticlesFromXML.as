// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._0H_Y_

package ParticleAnimations {
public class AnimateParticlesFromXML {

    public static const particles_:Object = {};

    public function AnimateParticlesFromXML(_arg1:XML):void {
        var _local2:XML;
        for each (_local2 in _arg1.Particle) {
            particles_[_local2.@id] = new TextureDatasFromXML(_local2);
        }
    }

}
}//package _0K_m

