// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0_P_._C_n

package _0_P_ {
import com.company.PhoenixRealmClient.objects.TextureFromXML;

public class AnimationFrame {

    public function AnimationFrame(_arg1:XML) {
        this.time_ = int((Number(_arg1.@time) * 1000));
        this.texture_ = new TextureFromXML(_arg1);
    }
    public var time_:int;
    public var texture_:TextureFromXML;
}
}//package _0_P_

