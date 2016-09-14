// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m.XMLEffect

package ParticleAnimations {
import com.company.PhoenixRealmClient.objects.GameObject;

public class XMLEffect extends ObjectEffect {

    public function XMLEffect(_arg1:GameObject, _arg2:XmlEffectProperties) {
        this.go_ = _arg1;
        this._textureDatas = AnimateParticlesFromXML.particles_[_arg2.particle];
        this._cooldown = _arg2.cooldown;
        this._time = 0;
    }
    private var go_:GameObject;
    private var _textureDatas:TextureDatasFromXML;
    private var _cooldown:Number;
    private var _time:Number;

    override public function update(_arg1:int, _arg2:int):Boolean {
        if (this.go_.map_ == null) {
            return (false);
        }
        var timeSeconds:Number = (_arg2 / 1000);
        this._time = (this._time - timeSeconds);
        if (this._time >= 0) {
            return (true);
        }
        this._time = this._cooldown;
        map_.addObj(new CustomParticle(this._textureDatas), this.go_.x_, this.go_.y_);
        return (true);
    }

}
}//package _0K_m

