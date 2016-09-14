// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.Character

package com.company.PhoenixRealmClient.objects {
import _vf.SFXHandler;

public class Character extends GameObject {

    public function Character(_arg1:XML) {
        super(_arg1);
        this.hitSound = ((_arg1.hasOwnProperty("HitSound")) ? String(_arg1.HitSound) : "monster/default_hit");
        SFXHandler.load(this.hitSound);
        this.deathSound = ((_arg1.hasOwnProperty("DeathSound")) ? String(_arg1.DeathSound) : "monster/default_death");
        SFXHandler.load(this.deathSound);
    }
    public var _07K_:int = 0;
    public var damageType_:uint = 0;
    public var hitSound:String;
    public var deathSound:String;

    override public function postDamageEffects(_arg1:int, _arg2:int, _arg3:Vector.<uint>, _arg4:Boolean, _arg5:Projectile):void {
        super.postDamageEffects(_arg1, _arg2, _arg3, _arg4, _arg5);
        if (dead) {
            SFXHandler.play(this.deathSound);
        } else {
            SFXHandler.play(this.hitSound);
        }
    }

}
}//package com.company.PhoenixRealmClient.objects

