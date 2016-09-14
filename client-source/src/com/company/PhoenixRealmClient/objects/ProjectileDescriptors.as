package com.company.PhoenixRealmClient.objects {

import com.company.PhoenixRealmClient.util.ConditionEffect;

import flash.utils.Dictionary;

//import com.company.PhoenixRealmClient.util.*;

    public class ProjectileDescriptors {

        public function ProjectileDescriptors(_arg1:XML) {
            var _local2:XML;
            var formula_:XML;
            super();
            this.bulletType_ = int(_arg1.@id);
            this.objectId_ = _arg1.ObjectId;
            this.lifetime_ = int(_arg1.LifetimeMS);

            this.speed_ = int(_arg1.Speed);

            this.size_ = ((_arg1.hasOwnProperty("Size")) ? Number(_arg1.Size) : -1);
            if (_arg1.hasOwnProperty("Damage")) {
                this.minDamage_ = (this.maxDamage_ = int(_arg1.Damage));
            }
            else
            {
                this.minDamage_ = int(_arg1.MinDamage);
                this.maxDamage_ = int(_arg1.MaxDamage);
            }

            if (_arg1.hasOwnProperty("Penetration"))
            {
                this.penetration_ = int(_arg1.Penetration);
            }
            else
            {
                this.penetration_  = 0;
            }

            for each (_local2 in _arg1.ConditionEffect) {
                if (this.effects_ == null) {
                    this.effects_ = new Vector.<uint>();
                }
                this.effects_.push(ConditionEffect.CondEffectfromString(String(_local2)));
            }
            this.multiHit = _arg1.hasOwnProperty("MultiHit");
            this.passesCover = _arg1.hasOwnProperty("PassesCover");
            this.armorPiercing = _arg1.hasOwnProperty("ArmorPiercing");
            this.particleTrail = _arg1.hasOwnProperty("ParticleTrail");
            this.trailColor_ = ((this.particleTrail) ? Number(_arg1.ParticleTrail) : Number(0xFF00FF));
            if (this.trailColor_ == 0) {
                this.trailColor_ = 0xFF00FF;
            }
            this.wavy = _arg1.hasOwnProperty("Wavy");
            this.parametric = _arg1.hasOwnProperty("Parametric");
            this.boomerang = _arg1.hasOwnProperty("Boomerang");
            this.amplitude = ((_arg1.hasOwnProperty("Amplitude")) ? Number(_arg1.Amplitude) : 0);
            this.frequency = ((_arg1.hasOwnProperty("Frequency")) ? Number(_arg1.Frequency) : 1);
            this.magnitude = ((_arg1.hasOwnProperty("Magnitude")) ? Number(_arg1.Magnitude) : 3);

            for each (formula_ in _arg1.Formula)
            {
                if (Formulas == null) Formulas = new Dictionary();

                var attribute:String = String(formula_);
                Formulas[attribute] = new Formula(formula_);
            }
        }
        public var bulletType_:int;
        public var objectId_:String;
        public var lifetime_:int;
        public var speed_:int;
        public var size_:int;
        public var minDamage_:int;
        public var maxDamage_:int;
        public var penetration_:int;
        public var effects_:Vector.<uint> = null;
        public var multiHit:Boolean;
        public var passesCover:Boolean;
        public var armorPiercing:Boolean;
        public var particleTrail:Boolean;
        public var trailColor_:int = 0xFF00FF;
        public var wavy:Boolean;
        public var parametric:Boolean;
        public var boomerang:Boolean;
        public var amplitude:Number;
        public var frequency:Number;
        public var magnitude:Number;

        public var Formulas:Dictionary;
    }
}

