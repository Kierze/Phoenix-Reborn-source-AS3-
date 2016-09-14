// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m._7g

package ParticleAnimations {
import _0_P_.AnimateFromXML;

import com.company.PhoenixRealmClient.objects.TextureFromXML;

public class TextureDatasFromXML {

    public function TextureDatasFromXML(_arg1:XML) {
        this.id_ = _arg1.@id;
        this._Y_D_ = new TextureFromXML(_arg1);
        if (_arg1.hasOwnProperty("Size")) {
            this.size_ = Number(_arg1.Size);
        }
        if (_arg1.hasOwnProperty("Z")) {
            this.z_ = Number(_arg1.Z);
        }
        if (_arg1.hasOwnProperty("Duration")) {
            this.duration_ = Number(_arg1.Duration);
        }
        if (_arg1.hasOwnProperty("Animation")) {
            this._fe = new AnimateFromXML(_arg1);
        }
    }
    public var id_:String;
    public var _Y_D_:TextureFromXML;
    public var size_:int = 100;
    public var z_:Number = 0;
    public var duration_:Number = 0;
    public var _fe:AnimateFromXML = null;
}
}//package _0K_m

