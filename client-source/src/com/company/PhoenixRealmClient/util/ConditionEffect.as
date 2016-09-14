// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util.ConditionEffect

package com.company.PhoenixRealmClient.util {
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.geom.Matrix;

public class ConditionEffect  //Currently condition effects are stored as an integer on the character! This integer represents a bitwise array of booleans.
                                //Since ints have only 32 bits, this technically limits us to 32 status effects.
                                //This should be changed later.
{

    public static const _Nothing:uint = 0;
    public static const _Dead:uint = 1;
    public static const _Quiet:uint = 2;
    public static const _Weak:uint = 3;
    public static const _Slowed:uint = 4;
    public static const _Sick:uint = 5;
    public static const _Dazed:uint = 6;
    public static const _Stunned:uint = 7;
    public static const _Blind:uint = 8;
    public static const _Hallucinating:uint = 9;
    public static const _Drunk:uint = 10;
    public static const _Confused:uint = 11;
    public static const _StunImmune:uint = 12;
    public static const _Invisible:uint = 13;
    public static const _Paralyzed:uint = 14;
    public static const _Speedy:uint = 15;
    public static const _Bleeding:uint = 16;
    public static const _NotUsed:uint = 17;
    public static const _Healing:uint = 18;
    public static const _Damaging:uint = 19;
    public static const _Berserk:uint = 20;
    public static const _Paused:uint = 21;
    public static const _Stasis:uint = 22;
    public static const _StasisImmune:uint = 23;
    public static const _Invincible:uint = 24;
    public static const _Invulnerable:uint = 25;
    public static const _Armored:uint = 26;
    public static const _ArmorBroken:uint = 27;
    public static const _Hexed:uint = 28;

    public static const deadEffect_:uint = (1 << (_Dead - 1));
    public static const quietEffect_:uint = (1 << (_Quiet - 1));
    public static const weakEffect_:uint = (1 << (_Weak - 1));
    public static const slowedEffect_:uint = (1 << (_Slowed - 1));
    public static const sickEffect_:uint = (1 << (_Sick - 1));
    public static const dazedEffect_:uint = (1 << (_Dazed - 1));
    public static const stunnedEffect_:uint = (1 << (_Stunned - 1));
    public static const blindEffect_:uint = (1 << (_Blind - 1));
    public static const hallucinatingEffect_:uint = (1 << (_Hallucinating - 1));
    public static const drunkEffect_:uint = (1 << (_Drunk - 1));
    public static const confusedEffect:uint = (1 << (_Confused - 1));
    public static const stunImmuneEffect_:uint = (1 << (_StunImmune - 1));
    public static const invisibleEffect_:uint = (1 << (_Invisible - 1));
    public static const paralyzedEffect_:uint = (1 << (_Paralyzed - 1));
    public static const speedyEffect_:uint = (1 << (_Speedy - 1));
    public static const bleedingEffect_:uint = (1 << (_Bleeding - 1));
    public static const notUsedEffect_:uint = (1 << (_NotUsed - 1));
    public static const healingEffect_:uint = (1 << (_Healing - 1));
    public static const damagingEffect_:uint = (1 << (_Damaging - 1));
    public static const berserkEffect_:uint = (1 << (_Berserk - 1));
    public static const pausedEffect_:uint = (1 << (_Paused - 1));
    public static const stasisEffect_:uint = (1 << (_Stasis - 1));
    public static const stasisImmuneEffect_:uint = (1 << (_StasisImmune - 1));
    public static const invincibleEffect_:uint = (1 << (_Invincible - 1));
    public static const invulnerableEffect_:uint = (1 << (_Invulnerable - 1));
    public static const armoredEffect_:uint = (1 << (_Armored - 1));
    public static const armorBrokenEffect_:uint = (1 << (_ArmorBroken - 1));
    public static const hexedEffect_:uint = (1 << (_Hexed - 1));
    public static const FogFilterEffects:uint = ((drunkEffect_ | blindEffect_) | pausedEffect_);
    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 6, 6, 2, BitmapFilterQuality.LOW, false, false);
    private static var _K_3:Object = null;
    private static var _ua:Object = null;

    public var name_:String;
    public var bit_:uint;
    public var iconOffsets_:Array;

    public static const _06j:uint = (
        quietEffect_ |
        weakEffect_ |
        slowedEffect_ |
        sickEffect_ |
        dazedEffect_ |
        stunnedEffect_ |
        blindEffect_ |
        hallucinatingEffect_ |
        drunkEffect_ |
        confusedEffect |
        paralyzedEffect_ |
        speedyEffect_ |
        bleedingEffect_ |
        healingEffect_ |
        damagingEffect_ |
        berserkEffect_ |
        invulnerableEffect_ |
        armoredEffect_ |
        armorBrokenEffect_
    );

    public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[
        new ConditionEffect("Nothing", 0, null),
        new ConditionEffect("Dead", deadEffect_, null),
        new ConditionEffect("Quiet", quietEffect_, [32]),
        new ConditionEffect("Weak", weakEffect_, [34, 35, 36, 37]),
        new ConditionEffect("Slowed", slowedEffect_, [1]),
        new ConditionEffect("Sick", sickEffect_, [39]),
        new ConditionEffect("Dazed", dazedEffect_, [44]),
        new ConditionEffect("Stunned", stunnedEffect_, [45]),
        new ConditionEffect("Blind", blindEffect_, [41]),
        new ConditionEffect("Hallucinating", hallucinatingEffect_, [42]),
        new ConditionEffect("Drunk", drunkEffect_, [43]),
        new ConditionEffect("Confused", confusedEffect, [2]),
        new ConditionEffect("Stun Immume", stunImmuneEffect_, null),
        new ConditionEffect("Invisible", invisibleEffect_, null),
        new ConditionEffect("Paralyzed", paralyzedEffect_, [53, 54]),
        new ConditionEffect("Speedy", speedyEffect_, [0]),
        new ConditionEffect("Bleeding", bleedingEffect_, [46]),
        new ConditionEffect("Not Used", notUsedEffect_, null),
        new ConditionEffect("Healing", healingEffect_, [47]),
        new ConditionEffect("Damaging", damagingEffect_, [49]),
        new ConditionEffect("Berserk", berserkEffect_, [50]),
        new ConditionEffect("Paused", pausedEffect_, null),
        new ConditionEffect("Stasis", stasisEffect_, null),
        new ConditionEffect("Stasis Immune", stasisImmuneEffect_, null),
        new ConditionEffect("Invincible", invincibleEffect_, null),
        new ConditionEffect("Invulnerable", invulnerableEffect_, [17]),
        new ConditionEffect("Armored", armoredEffect_, [16]),
        new ConditionEffect("Armor Broken", armorBrokenEffect_, [55]),
        new ConditionEffect("Hexed", hexedEffect_, [42])
    ];
    public function ConditionEffect(_arg1:String, _arg2:uint, _arg3:Array) {
        this.name_ = _arg1;
        this.bit_ = _arg2;
        this.iconOffsets_ = _arg3;
    }

    public static function CondEffectfromString(_arg1:String):uint {
        var _local2:uint;
        if (_K_3 == null) {
            _K_3 = {};
            _local2 = 0;
            while (_local2 < effects_.length) {
                _K_3[effects_[_local2].name_] = _local2;
                _local2++;
            }
        }
        return (_K_3[_arg1]);
    }

    public static function _a4(_arg1:uint, _arg2:Vector.<BitmapData>, _arg3:int):void {
        var _local4:uint;
        var _local5:uint;
        var _local6:Vector.<BitmapData>;
        while (_arg1 != 0) {
            _local4 = (_arg1 & (_arg1 - 1));
            _local5 = (_arg1 ^ _local4);
            _local6 = GetIconData(_local5);
            if (_local6 != null) {
                _arg2.push(_local6[(_arg3 % _local6.length)]);
            }
            _arg1 = _local4;
        }
    }

    private static function GetIconData(_arg1:uint):Vector.<BitmapData> {
        var _local2:Matrix;
        var _local3:uint;
        var _local4:Vector.<BitmapData>;
        var _local5:int;
        var _local6:BitmapData;
        if (_ua == null) {
            _ua = {};
            _local2 = new Matrix();
            _local2.translate(4, 4);
            _local3 = 0;
            while (_local3 < effects_.length) {
                _local4 = null;
                if (effects_[_local3].iconOffsets_ != null) {
                    _local4 = new Vector.<BitmapData>();
                    _local5 = 0;
                    while (_local5 < effects_[_local3].iconOffsets_.length) {
                        _local6 = new BitmapData(16, 16, true, 0);
                        _local6.draw(AssetLibrary.getBitmapFromFileIndex("lofiInterface2", effects_[_local3].iconOffsets_[_local5]), _local2);
                        _local6 = TextureRedrawer.outlineGlow(_local6, 0xFFFFFFFF);
                        _local6.applyFilter(_local6, _local6.rect, PointUtil._P_5, GLOW_FILTER);
                        _local4.push(_local6);
                        _local5++;
                    }
                }
                _ua[effects_[_local3].bit_] = _local4;
                _local3++;
            }
        }
        return (_ua[_arg1]);
    }

}
}

