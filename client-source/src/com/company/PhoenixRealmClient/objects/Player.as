package com.company.PhoenixRealmClient.objects
{
import ParticleAnimations.HealingEffect;
import ParticleAnimations.LevelUpEffect;
import ParticleAnimations.ObjectEffect;
import ParticleAnimations.PotionEffect;
import ParticleAnimations.XmlEffectProperties;

import _015.StatusText;

import _vf.SFXHandler;

import com.company.PhoenixRealmClient.map.Square;
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.tutorial.Tutorial;
import com.company.PhoenixRealmClient.tutorial.doneAction;
import com.company.PhoenixRealmClient.ui.Inventory;
import com.company.PhoenixRealmClient.util.AbilityLibrary;
import com.company.PhoenixRealmClient.util.ClassQuest;
import com.company.PhoenixRealmClient.util.ConditionEffect;
import com.company.PhoenixRealmClient.util.MaskedBitmap;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.PhoenixRealmClient.util._lJ_;
import com.company.PhoenixRealmClient.util._wW_;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.ConversionUtil;
import com.company.util.GraphicHelper;
import com.company.util.IntPoint;
import com.company.util.MoreColorUtil;
import com.company.util.PointUtil;
import com.company.util.Trig;
import com.company.util._G_;

import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.getTimer;

public class Player extends Character
{

    public static const _0G_S_:int = 10000;
    public static var isAdmin:Boolean = false;
    public var focusingMove:Boolean = false;
    private static const _A_u:Vector.<Point> = new <Point>[new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1)];
    private static const _Q_a:Number = 0.4;
    private static const _I_5:Matrix = new Matrix(1, 0, 0, 1, 2, 4);
    private static const _0G_b:Matrix = new Matrix(1, 0, 0, 1, 20, 0);
    private static const _playerMoveSpeedConstant:Number = 0.007;
    private static const _playerMSSubtrahend:Number = 0.0096;
    private static const _playerFireRateConstant:Number = 0.0020;
    private static const _playerFRSubtrahend:Number = 0.010;
    private static const _baseAttackDamageConstant:Number = 1;
    private static const _baseADSubtrahend:Number = 2;


    private static var _06g:Point = new Point();

    public static function FromString(_arg1:String, _arg2:XML):Player
    {
        var _local3:int = int(_arg2.ObjectType);
        var _local4:XML = ObjectLibrary.typeToXml[_local3];
        var _local5:Player = new Player(_local4);
        _local5.name_ = _arg1;
        _local5.level_ = int(_arg2.Level);
        _local5.exp_ = int(_arg2.Exp);
        _local5.equipment_ = ConversionUtil.StringCommaSplitToIntVector(_arg2.Equipment);
        _local5.maxHP_ = int(_arg2.MaxHitPoints);
        _local5.HP_ = int(_arg2.HitPoints);
        _local5.maxMP_ = int(_arg2.MaxMagicPoints);
        _local5.MP_ = int(_arg2.MagicPoints);
        _local5.attack_ = int(_arg2.Attack);
        _local5.defense_ = int(_arg2.Defense);
        _local5.speed_ = int(_arg2.Speed);
        _local5.dexterity_ = int(_arg2.Dexterity);
        _local5.vitality_ = int(_arg2.Vitality);
        _local5.wisdom_ = int(_arg2.Wisdom);
        _local5.tex1Id_ = int(_arg2.Tex1);
        _local5.tex2Id_ = int(_arg2.Tex2);
        _local5.setSkin(int(_arg2.Skin));
        _local5.spec_ = _arg2.Specialization;
        _local5.mood_ = _arg2.Mood;
        _local5.aptitude_ = int(_arg2.Aptitude);
        _local5.resilience_ = int(_arg2.Resilience);
        _local5.penetration_ = int(_arg2.Penetration);
        return (_local5);
    }

    private static function _091(_arg1:Number, _arg2:View):int
     {
        var _local4:int;
        var _local3:Number = Trig._V_r((_arg1 - _arg2.angleRad_));
        if ((((_local3 > (Math.PI / 4))) && ((_local3 < ((3 * Math.PI) / 4))))) {
            _local4 = _lJ_.DOWN;
        } else {
            if ((((_local3 <= (Math.PI / 4))) && ((_local3 >= (-(Math.PI) / 4))))) {
                _local4 = _lJ_.RIGHT;
            } else {
                if ((((_local3 < (-(Math.PI) / 4))) && ((_local3 > ((-3 * Math.PI) / 4))))) {
                    _local4 = _lJ_.UP;
                } else {
                    _local4 = _lJ_.LEFT;
                }
            }
        }
        return (_local4);
    }

    public function Player(_arg1:XML) {
        this._06x = new IntPoint();
        super(_arg1);
        this._maxATT = int(_arg1.Attack.@max);
        this._maxDEF = int(_arg1.Defense.@max);
        this._maxSPD = int(_arg1.Speed.@max);
        this._maxDEX = int(_arg1.Dexterity.@max);
        this._maxVIT = int(_arg1.Vitality.@max);
        this._maxWIS = int(_arg1.Wisdom.@max);
        this._maxMAXHP = int(_arg1.MaxHitPoints.@max);
        this._maxMAXMP = int(_arg1.MaxMagicPoints.@max);
        this._maxAP = int(_arg1.Aptitude.@max);
        this._maxRES = int(_arg1.Resilience.@max);
        this._maxPEN = int(_arg1.Penetration.@max);
        _qm = new Dictionary();
        unusualEffects_ = new Vector.<ObjectEffect>();
        abilities.push(-1, -1, -1);
        abilityCooldowns.push(0, 0, 0);
        abilityActiveDurations.push(0, 0, 0);
    }
    public var accountId_:int = -1;
    public var credits_:int = 0;
    public var numStars_:int = 0;
    public var fame_:int = 0;
    public var _silver:int = 0;
    public var NameChosen:Boolean = false;
    public var _Hh:Boolean = false;
    public var _0L_o:int = 0;
    public var _n8:int = -1;
    public var _2v:int = -1;
    public var guildName_:String = null;
    public var guildRank_:int = -1;
    public var partyID_:int = -1;
    public var partyLeader:Boolean = false;
    public var _N_n:Boolean = false;
    public var inParty:Boolean = false;
    public var _R_4:int = -1;
    public var maxMP_:int = 200;
    public var MP_:Number = 0;
    public var _7V_:int = 1000;
    public var exp_:int = 0;
    public var attack_:int = 0;
    public var speed_:int = 0;
    public var dexterity_:int = 0;
    public var vitality_:int = 0;
    public var wisdom_:int = 0;
    public var aptitude_:int = 0;
    //public var resilience_:int = 0; //Moved to GameObject.as
    public var penetration_:int = 0;
    public var _P_7:int = 0;
    public var _0D_G_:int = 0;

    public var _attBonus:int = 0;
    public var _defBonus:int = 0;
    public var _spdBonus:int = 0;
    public var _vitBonus:int = 0;
    public var _wisBonus:int = 0;
    public var _dexBonus:int = 0;
    public var _aptitudeBonus:int = 0;
    public var _resBonus:int = 0;
    public var _penBonus:int = 0;

    public var _gz:int = 0;

    public var _maxATT:int = 0;
    public var _maxDEF:int = 0;
    public var _maxSPD:int = 0;
    public var _maxDEX:int = 0;
    public var _maxVIT:int = 0;
    public var _maxWIS:int = 0;
    public var _maxMAXHP:int = 0;
    public var _maxMAXMP:int = 0;
    public var _maxAP:int = 0;
    public var _maxRES:int = 0;
    public var _maxPEN:int = 0;

    public var starred_:Boolean = false;
    public var _0M_w:Boolean = false;
    public var distSqFromThisPlayer_:Number = 0;
    public var _y4:int = 0;
    public var _0m:int = 0;
    public var nextTeleportAt_:int = 0;
    public var inventory:Inventory;
    public var _K_X_:BitmapData = null;
    public var usiShukAbil:Boolean = false;
    public var canNexus:Boolean = true;
    public var abilities:Vector.<int> = new Vector.<int>();
    public var abilityCooldowns:Vector.<int> = new Vector.<int>();
    public var abilityActiveDurations:Vector.<int> = new Vector.<int>();
    public var abilityToggles:Vector.<Boolean> = new Vector.<Boolean>();
    protected var _ky:Number = 0;
    protected var _D_k:Point = null;
    protected var _W_V_:Number = 1;
    protected var _nE_:HealingEffect = null;
    protected var _0D_8:Merchant = null;
    private var _sd:BitmapData = null;
    private var _7U_:Boolean = true;
    private var _06x:IntPoint;
    private var _F_k:GraphicsSolidFill = null;
    private var _03i:GraphicsPath = null;
    private var _Y_e:GraphicsSolidFill = null;
    private var _K_Y_:GraphicsPath = null;
    private var prevEffect_:String = "";
    private var effString_:String = "";
    private var unusualEffects_:Vector.<ObjectEffect> = null;

    override public function moveTo(_arg1:Number, _arg2:Number):Boolean
    {
        var _local3:Boolean = super.moveTo(_arg1, _arg2);
        this._0D_8 = this._0I_U_();
        return (_local3);
    }

    override public function update(_arg1:int, _arg2:int):Boolean
    {
        var _local3:Number;
        var _local4:Number;
        var _local5:Number;
        var _local6:int;
        if(prevEffect_ != effString_)
        {
            prevEffect_ = effString_;
            for each(var _effect:ObjectEffect in unusualEffects_)
            {
                map_.removeObj(_effect.objectId_);
            }
            this.unusualEffects_ = new Vector.<ObjectEffect>();
            var _effXML:XML = XML(this.effString_);
            if(_effXML.name() == "Effects")
            {
                for each(var _childEff:XML in _effXML.children())
                {
                    var _newEff:ObjectEffect = ObjectEffect.VisualObjectEffect(new XmlEffectProperties(_childEff), this);
                    if(_newEff != null)
                    {
                        this.unusualEffects_.push(_newEff);
                    }
                }
            }
            else
            {
                var _newEff:ObjectEffect = ObjectEffect.VisualObjectEffect(new XmlEffectProperties(XML(this.effString_)), this);
                if(_newEff != null)
                {
                    this.unusualEffects_.push(_newEff);
                }
            }
            for each(var _effect:ObjectEffect in unusualEffects_)
            {
                map_.addObj(_effect, x_, y_);
            }
        }
        if (_EntityIsHealingEff()&& !_EntityIsPausedEff())
        {
            if (this._nE_ == null)
            {
                this._nE_ = new HealingEffect(this);
                map_.addObj(this._nE_, x_, y_);
            }
        }
        else
        {
            if (this._nE_ != null)
            {
                map_.removeObj(this._nE_.objectId_);
                this._nE_ = null;
            }
        }
        if (map_.player_ == this && _EntityIsPausedEff())
        {
            return (true);
        }
        if (this._D_k != null)
        {
            _local3 = Parameters.ClientSaveData.cameraAngle;
            if (this._ky != 0 && !map_.gs_.camera_.fixedRot_)
            {
                _local3 = (_local3 + ((_arg2 * Parameters.ClientSaveData.rotationSpeed) * this._ky));
                Parameters.ClientSaveData.cameraAngle = _local3;
            }
            if (this._D_k.x != 0 || this._D_k.y != 0)
            {
                _local4 = this.GetPlayerMoveSpeed();
                _local5 = Math.atan2(this._D_k.y, this._D_k.x);
                moveVec_.x = (_local4 * Math.cos((_local3 + _local5)));
                moveVec_.y = (_local4 * Math.sin((_local3 + _local5)));
            }
            else
            {
                moveVec_.x = 0;
                moveVec_.y = 0;
            }
            if (_0H_B_ != null && _0H_B_.props_.push_)
            {
                moveVec_.x = (moveVec_.x - (_0H_B_.props_.animate_.dx_ / 1000));
                moveVec_.y = (moveVec_.y - (_0H_B_.props_.animate_.dy_ / 1000));
            }
            this._2((x_ + (_arg2 * moveVec_.x)), (y_ + (_arg2 * moveVec_.y)));
        }
        else
        {
            if (!super.update(_arg1, _arg2))
            {
                return (false);
            }
        }
        if ((((map_.player_ == this && _0H_B_.props_.maxDamage_ > 0) && (_0H_B_.lastDamage_ + 500) < _arg1) && !_EntityIsInvincibleEff()) && (_0H_B_.obj_ == null || !_0H_B_.obj_.props_.protectFromGroundDamage_))
        {
            _local6 = map_.gs_.gsc_.getNextDamage(_0H_B_.props_.minDamage_, _0H_B_.props_.maxDamage_);
            postDamageEffects(-1, _local6, null, (HP_ <= _local6), null);
            map_.gs_.gsc_.groundDamage(_arg1, x_, y_);
            _0H_B_.lastDamage_ = _arg1;
        }
        return (true);
    }

    public function setEffect(_arg1:String):void
    {
        this.effString_ = _arg1;
    }

    override protected function generateNameBitmapData(_arg1:SimpleText):BitmapData
    {
        if (this.inParty)
        {
            _arg1.setColor(Parameters.playerPartyColor);
        }
        else if (this._N_n)
        {
            _arg1.setColor(Parameters.playerGuildColor);
        }
        else if (this.NameChosen)
        {
            _arg1.setColor(Parameters.playerNameChosenColor);
        }
        var output:BitmapData = new BitmapData((_arg1.width + 20), 64, true, 0);
        output.draw(_arg1, _0G_b);
        output.applyFilter(output, output.rect, PointUtil._P_5, new GlowFilter(0, 1, 3, 3, 2, 1));

        var starSprite:Sprite = ClassQuest.CircledStarRankSprite(this.numStars_);
        output.draw(starSprite, _I_5);
        return (output);
    }

    override public function draw(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void
    {
        super.draw(_arg1, _arg2, _arg3);
        if (this != map_.player_)
        {
            if (!Parameters._0F_o)
            {
                if (this != this.map_.player_)
                {
                    if (!this._EntityIsInvisibleEff())
                    {
                        _oL_(_arg1, _arg2);
                    }
                }
                else
                {
                    _oL_(_arg1, _arg2);
                }
            }
        }
        else
        {
            if (this._R_4 >= 0)
            {
                this._071(_arg1, _arg2, _arg3);
            }
        }
    }

    override protected function getTexture(_arg1:View, _arg2:int):BitmapData
    {
        var _local10:int;
        var _local11:Dictionary;
        var _local12:Number;
        var _local13:int;
        var _local14:ColorTransform;
        var _local3:Number = 0;
        var _local4:int = _lJ_._sS_;
        if (_arg2 < (_W_J_ + this._y4))
        {
            _N_V_ = _M_r;
            _local3 = (((_arg2 - _W_J_) % this._y4) / this._y4);
            _local4 = _lJ_._E_w;
        }
        else
        {
            if ((moveVec_.x != 0) || (moveVec_.y != 0))
            {
                _local10 = (3.5 / this.GetPlayerMoveSpeed());
                if ((moveVec_.y != 0) || (moveVec_.x != 0))
                {
                    _N_V_ = Math.atan2(moveVec_.y, moveVec_.x);
                }
                _local3 = ((_arg2 % _local10) / _local10);
                _local4 = _lJ_._m1;
            }
        }
        if (this.playerIsHexed() && this._7U_)
        {
            this._Q_K_();
        }
        if (!this.playerIsHexed() && !this._7U_)
        {
            this._ur();
        }
        var _local5:MaskedBitmap = _yN_.imageFromFacing(_N_V_, _arg1, _local4, _local3);
        if (_arg1._kN_)
        {
            _local5 = new MaskedBitmap(_1g(), null);
        }
        var _local6:int = tex1Id_;
        var _local7:int = tex2Id_;
        var _local8:BitmapData;
        if (this._0D_8 != null)
        {
            _local11 = _qm[this._0D_8];
            if (_local11 == null)
            {
                _qm[this._0D_8] = new Dictionary();
            }
            else
            {
                _local8 = _local11[_local5];
            }
            _local6 = this._0D_8.getTex1Id(tex1Id_);
            _local7 = this._0D_8.getTex2Id(tex2Id_);
            this.previewSkin(this._0D_8.getSkinId(skinId_, this));
        }
        else
        {
            _local8 = _qm[_local5];
            this.previewSkin(-1);
        }
        if (_local8 == null)
        {
            _local8 = TextureRedrawer.resize(_local5.image_, _local5.mask_, size_, false, _local6, _local7);
            if (this._0D_8 != null)
            {
                _qm[this._0D_8][_local5] = _local8;
            }
            else
            {
                _qm[_local5] = _local8;
            }
        }
        if (HP_ < (maxHP_ * 0.2))
        {
            _local12 = int(Math.abs(Math.sin(_arg2 / 200)) * 10) / 10;
            _local13 = 128;
            _local14 = new ColorTransform(1, 1, 1, 1, (_local12 * _local13), (-(_local12) * _local13), (-(_local12) * _local13));
            _local8 = _G_._B_2(_local8, _local14);
        }
        var _local9:BitmapData = _qm[_local8];
        if (_local9 == null)
        {
            _local9 = TextureRedrawer.outlineGlow(_local8, this._2v == -1 ? 0 : this._2v);
            _qm[_local8] = _local9;
        }
        if (_EntityIsPausedEff() || _EntityIsStasisEff())
        {
            _local9 = _G_._R_9(_local9, _oj);
        }
        else
        {
            if (_EntityIsInvisibleEff())
            {
                if (this != this.map_.player_)
                {
                    _local9 = _G_._0C_m(_local9, 0);
                }
                else
                {
                    _local9 = _G_._0C_m(_local9, 0.4);
                }
            }
        }
        return (_local9);
    }

    override public function getPortrait():BitmapData {
        var _local1:MaskedBitmap;
        var _local2:int;
        if (_tm == null)
        {
            _local1 = _yN_.imageFromDir(_lJ_.RIGHT, _lJ_._sS_, 0);
            _local2 = ((4 / _local1.image_.width) * 100);
            _tm = TextureRedrawer.resize(_local1.image_, _local1.mask_, _local2, true, tex1Id_, tex2Id_);
            _tm = TextureRedrawer.outlineGlow(_tm, 0);
        }
        return (_tm);
    }

    override public function setAttack(_arg1:int, _arg2:Number):void
    {
        var _local3:XML = ObjectLibrary.typeToXml[_arg1];
        if (_local3 == null || !_local3.hasOwnProperty("RateOfFire"))
        {
            return;
        }
        var _local4:Number = Number(_local3.RateOfFire);
        this._y4 = ((1 / this.GetPlayerFireRate()) * (1 / _local4));
        super.setAttack(_arg1, _arg2);
    }

    override public function toString():String
    {
        return ("<Char>" + "<Name>" + name_ + "</Name>" + "<ObjectType>" + objectType_ + "</ObjectType>" + "<Level>" + level_ + "</Level>" + "<Exp>" + this.exp_ + "</Exp>" + "<Equipment>" + equipment_ + "</Equipment>" + "<MaxHitPoints>" + maxHP_ + "</MaxHitPoints>" + "<HitPoints>" + HP_ + "</HitPoints>" + "<MaxMagicPoints>" + this.maxMP_ + "</MaxMagicPoints>" + "<MagicPoints>" + this.MP_ + "</MagicPoints>" + "<Attack>" + this.attack_ + "</Attack>" + "<Defense>" + defense_ + "</Defense>" + "<Speed>" + this.speed_ + "</Speed>" + "<Vitality>" + this.vitality_ + "</Vitality>" + "<Wisdom>" + this.wisdom_ + "</Wisdom>" + "<Dexterity>" + this.dexterity_ + "</Dexterity>" + "<Aptitude>" + this.aptitude_ + "</Aptitude>" + "<Resilience>" + resilience_ + "</Resilience>" + "<Penetration>" + this.penetration_ + "</Penetration>" + "</Char>");
    }

    public function MoveFromInput(horizontalRotation:Number, horizontalMove:Number, verticalMove:Number):void
    {
        var _local4:Number;
        if (this._D_k == null)
        {
            this._D_k = new Point();
        }
        this._ky = horizontalRotation;
        this._D_k.x = horizontalMove;
        this._D_k.y = verticalMove;
        if (_EntityIsConfusedEff())
        {
            _local4 = this._D_k.x;
            this._D_k.x = -(this._D_k.y);
            this._D_k.y = -(_local4);
            this._ky = -(this._ky); //inverts rotation
        }
    }

    public function _F_S_(_arg1:int):void
    {
        this.credits_ = _arg1;
    }

    public function setSilver(_arg1:int):void
    {
        this._silver = _arg1;
    }

    public function _Y_C_(_arg1:String):void
    {
        var _local3:GameObject;
        var _local4:Player;
        var _local5:Boolean;
        this.guildName_ = _arg1;
        var _local2:Player = map_.player_;
        if (_local2 == this)
        {
            for each (_local3 in map_.goDict_)
            {
                _local4 = (_local3 as Player);
                if ((_local4 != null) && (_local4 != this))
                {
                    _local4._Y_C_(_local4.guildName_);
                }
            }
        }
        else
        {
            _local5 = (((_local2 != null && _local2.guildName_ != null) && _local2.guildName_ != "") && _local2.guildName_ == this.guildName_);
            if (_local5 != this._N_n)
            {
                this._N_n = _local5;
                _U_g = null;
            }
        }
    }

    public function UpdateParty(_arg1:int):void
    {
        var _local3:GameObject;
        var _local4:Player;
        var _local5:Boolean;
        this.partyID_ = _arg1;
        var _local2:Player = map_.player_;
        if (_local2 == this)
        {
            for each (_local3 in map_.goDict_)
            {
                _local4 = (_local3 as Player);
                if ((_local4 != null) && (_local4 != this))
                {
                    _local4.UpdateParty(_local4.partyID_);
                }
            }
        }
        else
        {
            _local5 = _local2 != null && _local2.partyID_ != -1 && _local2.partyID_ == this.partyID_;
            if (_local5 != this.inParty)
            {
                this.inParty = _local5;
                _U_g = null;
            }
        }
    }

    public function IsPlayerTargetable(_arg1:Player):Boolean
    {
        if (_arg1._EntityIsPausedEff() || _arg1._EntityIsInvisibleEff())
        {
            return (false);
        }
        return (true);
    }

    public function _Z_C_():int
    {
        var _local1:int = getTimer();
        return (Math.max(0, (this.nextTeleportAt_ - _local1)));
    }

    public function teleportTo(_arg1:Player):Boolean
    {
        if (_EntityIsPausedEff())
        {
            map_.gs_.textBox_.addText(Parameters.SendError, "Can not teleport while paused.");
            return (false);
        }
        var _local2:int = this._Z_C_();
        if (_local2 > 0)
        {
            map_.gs_.textBox_.addText(Parameters.SendError, (("You can not teleport for another " + int(((_local2 / 1000) + 1))) + " seconds."));
            return (false);
        }
        if (!this.IsPlayerTargetable(_arg1))
        {
            if (_arg1._EntityIsInvisibleEff())
            {
                map_.gs_.textBox_.addText(Parameters.SendError, (("Can not teleport to " + _arg1.name_) + " while they are invisible."));
            }
            map_.gs_.textBox_.addText(Parameters.SendError, ("Can not teleport to " + _arg1.name_));
            return (false);
        }
        map_.gs_.gsc_.teleport(_arg1.objectId_);
        this.nextTeleportAt_ = (getTimer() + _0G_S_);
        return (true);
    }

    public function _playerLevelUpEff(_arg1:String):void
    {
        this._LevelUpParticles();
        map_.mapOverlay_.addChild(new StatusText(this, _arg1, 0xFF00, 2000));
    }

    public function _playerLvlUpTextSound(_arg1:Boolean):void
    {
        SFXHandler.play("level_up");
        if (_arg1)
        {
            this._playerLevelUpEff("New Class Unlocked!");
        }
        else
        {
            this._playerLevelUpEff("Level Up!");
        }
    }

    public function _LevelUpParticles():void
    {
        map_.addObj(new LevelUpEffect(this, 0xFF00FF00, 20), x_, y_);
    }

    public function _oK_():void
    {
        map_.addObj(new PotionEffect(this, 0xFFFFFF), x_, y_);
    }

    public function _XPGainText(_arg1:int):void
    {
        if (level_ != Parameters.levelCap_)
        {
            map_.mapOverlay_.addChild(new StatusText(this, (("+" + _arg1) + "XP"), 0xFF00, 1000));
        }
        else return;
    }

    public function _2(_arg1:Number, _arg2:Number):Boolean
    {
        this._u0(_arg1, _arg2, _06g);
        return (this.moveTo(_06g.x, _06g.y));
    }

    public function _u0(_arg1:Number, _arg2:Number, _arg3:Point):void
    {
        if (_EntityIsParalyzedEff())
        {
            _arg3.x = x_;
            _arg3.y = y_;
            return;
        }
        var _local4:Number = (_arg1 - x_);
        var _local5:Number = (_arg2 - y_);
        if ((((_local4 < _Q_a) && (_local4 > -(_Q_a))) && (_local5 < _Q_a)) && (_local5 > -(_Q_a)))
        {
            this._A_y(_arg1, _arg2, _arg3);
            return;
        }
        var _local6:Number = Math.atan2(_local4, _local5);
        var _local7:Number = (_Q_a / Math.max(Math.abs(_local4), Math.abs(_local5)));
        var _local8:Number = 0;
        _arg3.x = x_;
        _arg3.y = y_;
        var _local9:Boolean = false;
        while (!_local9)
        {
            if ((_local8 + _local7) >= 1)
            {
                _local7 = (1 - _local8);
                _local9 = true;
            }
            this._A_y((_arg3.x + (_local4 * _local7)), (_arg3.y + (_local5 * _local7)), _arg3);
            _local8 = (_local8 + _local7);
        }
    }

    public function _A_y(_arg1:Number, _arg2:Number, _arg3:Point):void
    {
        var _local6:Number;
        var _local7:Number;
        var _local4:Boolean = (((x_ % 0.5) == 0 && _arg1 != x_) || (int(x_ / 0.5) != int(_arg1 / 0.5)));
        var _local5:Boolean = (((y_ % 0.5) == 0 && _arg2 != y_) || (int(y_ / 0.5) != int(_arg2 / 0.5)));
        if ((!_local4 && !_local5) || this._M_S_(_arg1, _arg2))
        {
            _arg3.x = _arg1;
            _arg3.y = _arg2;
            return;
        }
        if (_local4)
        {
            _local6 = ((_arg1 > x_) ? int(_arg1 * 2) / 2 : int(x_ * 2) / 2);
            if (int(_local6) > int(x_))
            {
                _local6 = (_local6 - 0.01);
            }
        }
        if (_local5)
        {
            _local7 = ((_arg2) > y_) ? (int(_arg2 * 2) / 2) : (int(y_ * 2) / 2);
            if (int(_local7) > int(y_))
            {
                _local7 = (_local7 - 0.01);
            }
        }
        if (!_local4)
        {
            _arg3.x = _arg1;
            _arg3.y = _local7;
            return;
        }
        if (!_local5)
        {
            _arg3.x = _local6;
            _arg3.y = _arg2;
            return;
        }
        var _local8:Number = ((_arg1 > x_) ? _arg1 - _local6 : _local6 - _arg1);
        var _local9:Number = ((_arg2 > y_) ? _arg2 - _local7 : _local7 - _arg2);
        if (_local8 > _local9)
        {
            if (this._M_S_(_arg1, _local7))
            {
                _arg3.x = _arg1;
                _arg3.y = _local7;
                return;
            }
            if (this._M_S_(_local6, _arg2))
            {
                _arg3.x = _local6;
                _arg3.y = _arg2;
                return;
            }
        }
        else
        {
            if (this._M_S_(_local6, _arg2))
            {
                _arg3.x = _local6;
                _arg3.y = _arg2;
                return;
            }
            if (this._M_S_(_arg1, _local7))
            {
                _arg3.x = _arg1;
                _arg3.y = _local7;
                return;
            }
        }
        _arg3.x = _local6;
        _arg3.y = _local7;
    }

    public function _M_S_(_arg1:Number, _arg2:Number):Boolean
    {
        var _local3:Square = map_.getSquare(_arg1, _arg2);
        if (_0H_B_ != _local3 && (_local3 == null || !_local3._0C_D_()))
        {
            return (false);
        }
        var _local4:Number = _arg1 - int(_arg1);
        var _local5:Number = _arg2 - int(_arg2);
        if (_local4 < 0.5)
        {
            if (this._g7((_arg1 - 1), _arg2))
            {
                return (false);
            }
            if (_local5 < 0.5)
            {
                if (this._g7(_arg1, (_arg2 - 1)) || this._g7((_arg1 - 1), (_arg2 - 1)))
                {
                    return (false);
                }
            }
            else
            {
                if (_local5 > 0.5)
                {
                    if (this._g7(_arg1, (_arg2 + 1)) || this._g7((_arg1 - 1), (_arg2 + 1)))
                    {
                        return (false);
                    }
                }
            }
        }
        else
        {
            if (_local4 > 0.5)
            {
                if (this._g7((_arg1 + 1), _arg2))
                {
                    return (false);
                }
                if (_local5 < 0.5)
                {
                    if (this._g7(_arg1, (_arg2 - 1)) || this._g7((_arg1 + 1), (_arg2 - 1)))
                    {
                        return (false);
                    }
                }
                else
                {
                    if (_local5 > 0.5)
                    {
                        if (this._g7(_arg1, (_arg2 + 1)) || this._g7((_arg1 + 1), (_arg2 + 1)))
                        {
                            return (false);
                        }
                    }
                }
            }
            else
            {
                if (_local5 < 0.5)
                {
                    if (this._g7(_arg1, (_arg2 - 1)))
                    {
                        return (false);
                    }
                }
                else
                {
                    if (_local5 > 0.5)
                    {
                        if (this._g7(_arg1, (_arg2 + 1)))
                        {
                            return (false);
                        }
                    }
                }
            }
        }
        return (true);
    }

    public function _g7(_arg1:Number, _arg2:Number):Boolean
    {
        var _local3:Square = map_.lookupSquare(_arg1, _arg2);
        return ((((((_local3 == null)) || ((_local3.tileType_ == 0xFF)))) || (((!((_local3.obj_ == null))) && (_local3.obj_.props_.fullOccupy)))));
    }

    public function _01w():void
    {
        var _local1:Square = map_.getSquare(x_, y_);
        if (_local1.props_._rr) {
            _0F_ = Math.min((_0F_ + 1), Parameters._K_5);
            this._W_V_ = (0.1 + ((1 - (_0F_ / Parameters._K_5)) * (_local1.props_.speed_ - 0.1)));
        } else {
            _0F_ = 0;
            this._W_V_ = _local1.props_.speed_;
        }
    }

    public function GetPlayerFireRate():Number
    {
        var _fireRate:Number = (_playerFireRateConstant + (((this.dexterity_ / 1000) / 1.4) * (_playerFRSubtrahend - _playerFireRateConstant)));

        if (_EntityIsBerserkEff())
        {
            _fireRate *= 1.5;
        }
        if (_EntityIsDazedEff())
        {
            _fireRate *= 0.6667;
        }
        return (_fireRate);
    }

    public function useAbility(_arg1:int, _arg2:Number, _arg3:Number):void
    {
        var _local1:int = abilities[_arg1];
        if(abilities[_arg1] == -1)
        {
            SFXHandler.play("error");
            map_.gs_.textBox_.addText(Parameters.SendError, "You do not have that ability yet!");
            return;
        }
        var _local2:XML = AbilityLibrary.TypeToXML[_local1];
        if(_local2.hasOwnProperty("MpCost") && MP_ < int(_local2.MpCost))
        {
            SFXHandler.play("no_mana");
            return;
        }
        var _local4:Point = map_.pSTopW(_arg2, _arg3);
        if (_local4 == null) {
            SFXHandler.play("error");
            return;
        }
        if (abilityCooldowns[_arg1] > 0 || abilityActiveDurations[_arg1]) {
            SFXHandler.play("error");
            return;
        }

        if (_arg1 == 1 && level_ < 20){
            map_.gs_.textBox_.addText(Parameters.SendError, "You need to reach level 20 to use this ability!");
            return;
        }

        if (_arg1 == 2 && level_ < 40){
            map_.gs_.textBox_.addText(Parameters.SendError, "You need to reach level 40 to use this ability!");
            return;
        }

        map_.gs_.gsc_.useAbility(0, _arg1, _local4.x, _local4.y);
    }

    /*
    public function useAltWeapon(_arg1:Number, _arg2:Number):void // a.k.a. ability abilities useability useitem
    {
        var _local7:XML;
        var _local8:int;
        var _local10:Number;
        if (map_ == null || _EntityIsPausedEff()) {
            return;
        }
        var _local3:int = equipment_[1];
        if (_local3 == -1) {
            return;
        }
        var _local4:XML = ObjectLibrary._Q_F_[_local3];
        if (_local4 == null || !_local4.hasOwnProperty("Usable")) {
            return;
        }
        var _local5:int = int(_local4.MpCost);
        if (_local5 > this.MP_) {
            SFXHandler.play("no_mana");
            return;
        }
        var _local6:Point = map_.pSTopW(_arg1, _arg2);
        if (_local6 == null) {
            SFXHandler.play("error");
            return;
        }
        for each (_local7 in _local4.Activate) {
            if (_local7.toString() == "Teleport") {
                if (!this._M_S_(_local6.x, _local6.y)) {
                    SFXHandler.play("error");
                    return;
                }
            }
        }
        if (usiShukAbil) {
            return;
        }
        _local8 = getTimer();
        var _local19:XML = ObjectLibrary._Q_F_[equipment_[3]];
        if (_local8 < this._0m) {
            SFXHandler.play("error");
            return;
        }
        var _local9 = 500;
        if (_local4.hasOwnProperty("Cooldown")) {
            _local9 = (Number(_local4.Cooldown) * 1000);
        }
        if (_local19 != null && _local19.hasOwnProperty("BypassCool")) {
            _local9 = 0;
        }
        this._0m = (_local8 + _local9);
        map_.gs_.gsc_.useItem(_local8, objectId_, 1, _local3, _local6.x, _local6.y);
        SFXHandler.play("use_key", 0.75, false);
        if (_local4.Activate == "Shoot") {
            _local10 = Math.atan2(_arg2, _arg1);
            this.PlayerFireProjectile(_local8, _local3, _local4, (Parameters.data_.cameraAngle + _local10), false, 1);
        }
        if (_local4.Activate == "ShurikenAbility") {
            this.usiShukAbil = true;
        }
    }

    public function shukAbil(_arg1:Number, _arg2:Number):void {

        if (!usiShukAbil)
            return;

        var _local3:int = equipment_[1];
        var _local4:XML = ObjectLibrary._Q_F_[_local3];
        var _local6:Point = map_.pSTopW(_arg1, _arg2);
        var _local8:int;

        if (_local3 == -1) {
            return;
        }
        if (_local6 == null) {
            return;
        }
        _local8 = getTimer();

        this.usiShukAbil = false;

        map_.gs_.gsc_.useItem(_local8, objectId_, 1, _local3, _local6.x, _local6.y);

        var _local5:int = int(_local4.MpEndCost);
        var _local10:Number = Math.atan2(_arg2, _arg1);
        if (_local5 > this.MP_) {
            SFXHandler.play("error");
        } else {
            this.PlayerFireProjectile(_local8, _local3, _local4, (Parameters.data_.cameraAngle + _local10), false, 1);
        }
    }
    */ //old ability code and shuriken reference

    public function _O_7(_arg1:Number):void
    {
        this._playerWeaponShoot(Parameters.ClientSaveData.cameraAngle + _arg1);
    }

    public function _7b():String
    {
        return (ObjectLibrary.typeToDisplayId[objectType_]);
    }

    public function playerIsHexed():Boolean
    {
        return ((condEffects & ConditionEffect.hexedEffect_) != 0);
    }

    override public function drawShadow(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void
    {
        if(this != this.map_.player_ && this._EntityIsInvisibleEff())
        {
            return;
        }
        super.drawShadow(_arg1, _arg2, _arg3);
    }

    protected function _071(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void
    {
        var _local8:Number;
        var _local9:Number;
        if (this._K_Y_ == null)
        {
            this._F_k = new GraphicsSolidFill();
            this._03i = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
            this._Y_e = new GraphicsSolidFill(2542335);
            this._K_Y_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
        }
        if (this._R_4 <= Parameters._E_S_)
        {
            _local8 = ((Parameters._E_S_ - this._R_4) / Parameters._E_S_);
            this._F_k.color = MoreColorUtil._oH_(0x545454, 0xFF0000, (Math.abs(Math.sin((_arg3 / 300))) * _local8));
        }
        else
        {
            this._F_k.color = 0x545454;
        }
        var _local4:int = 20;
        var _local5:int = 4;
        var _local6:int = 6;
        var _local7:Vector.<Number> = this._03i.data;
        _local7.length = 0;
        _local7.push((_bY_[0] - _local4), (_bY_[1] + _local5), (_bY_[0] + _local4), (_bY_[1] + _local5), (_bY_[0] + _local4), ((_bY_[1] + _local5) + _local6), (_bY_[0] - _local4), ((_bY_[1] + _local5) + _local6));
        _arg1.push(this._F_k);
        _arg1.push(this._03i);
        _arg1.push(GraphicHelper.END_FILL);
        if (this._R_4 > 0)
        {
            _local7 = this._K_Y_.data;
            _local9 = (((this._R_4 / 100) * 2) * _local4);
            _local7.length = 0;
            _local7.push((_bY_[0] - _local4), (_bY_[1] + _local5), ((_bY_[0] - _local4) + _local9), (_bY_[1] + _local5), ((_bY_[0] - _local4) + _local9), ((_bY_[1] + _local5) + _local6), (_bY_[0] - _local4), ((_bY_[1] + _local5) + _local6));
            _arg1.push(this._Y_e);
            _arg1.push(this._K_Y_);
            _arg1.push(GraphicHelper.END_FILL);
        }
    }

    protected function _ei():BitmapData
    {
        if (this._sd == null)
        {
            this._sd = AssetLibrary.getBitmapFromFileIndex("lofiChar8x8", int((Math.random() * 239)));
        }
        return (this._sd);
    }

    private function _0I_U_():Merchant
    {
        var _local3:Point;
        var _local4:Merchant;
        var _local1:int = ((((x_ - int(x_))) > 0.5) ? 1 : -1);
        var _local2:int = ((((y_ - int(y_))) > 0.5) ? 1 : -1);
        for each (_local3 in _A_u)
        {
            this._06x.x_ = (x_ + (_local1 * _local3.x));
            this._06x.y_ = (y_ + (_local2 * _local3.y));
            _local4 = map_.merchLookup_[this._06x];
            if (_local4 != null)
            {
                return ((((PointUtil._bm(_local4.x_, _local4.y_, x_, y_) < 1)) ? _local4 : null));
            }
        }
        return (null);
    }

    private function GetPlayerMoveSpeed():Number
    {
        //var _moveSpeed:Number = (_playerMoveSpeedConstant + ((this.speed_ / 75) * (_playerMSSubtrahend - _playerMoveSpeedConstant)));
        var _moveSpeed:Number = (_playerMoveSpeedConstant + ((this.speed_ / 1000) * (_playerMSSubtrahend - _playerMoveSpeedConstant))) * this._W_V_;
        var focusingSpeed:Number;

        if ((Parameters.ClientSaveData.focusSpeed / 2 == 0.1 || Parameters.ClientSaveData.focusSpeed / 3 == 0.1 || Parameters.ClientSaveData.focusSpeed / 4 == 0.1 || Parameters.ClientSaveData.focusSpeed / 5 == 0.1 || Parameters.ClientSaveData.focusSpeed / 6 == 0.1) && Parameters.ClientSaveData.focusSpeed < 0.7) focusingSpeed = Parameters.ClientSaveData.focusSpeed / 2;
        else focusingSpeed = 0.2;

        if (focusingMove) _moveSpeed  = _moveSpeed * (focusingSpeed * 2);

        if ((_EntityIsSpeedyEff() && _EntityIsSlowedEff()) || (!_EntityIsSpeedyEff() && !_EntityIsSlowedEff()))
        {
            return _moveSpeed;
        }
        else if (_EntityIsSpeedyEff())
        {
            return (_moveSpeed * 1.5);
        }
        else if (_EntityIsSlowedEff())
        {
            return (_moveSpeed * 0.5);
        }
        else
        {
            return _moveSpeed;
        }

    }

    private function GetPlayerAttackDamage():Number
    {
        var _attackDamage:Number = _baseAttackDamageConstant + ((this.attack_ / 1000) / 1.5);
        //max = 1 + 0.75 = 1.75x damage :thumbs_up_emoji:
        if (_EntityIsDamagingEff())
        {
            _attackDamage *= 1.5;
        }
        if (_EntityIsWeakEff())
        {
            _attackDamage *= 0.6667;
        }
        return (_attackDamage);
    }

    private function _ur():void
    {
        var _local1:TextureFromXML = ObjectLibrary.typeToTexture[objectType_];
        texture_ = _local1.texture_;
        mask_ = _local1.mask_;
        _yN_ = _local1._yN_;
        this._7U_ = true;
    }

    private function _Q_K_():void
    {
        var _local1:Vector.<XML> = ObjectLibrary.hexableObjects;
        var _local2:uint = Math.floor((Math.random() * _local1.length));
        var _local3:int = _local1[_local2].@type;
        var _local4:TextureFromXML = ObjectLibrary.typeToTexture[_local3];
        texture_ = _local4.texture_;
        mask_ = _local4.mask_;
        _yN_ = _local4._yN_;
        this._7U_ = false;
    }

    private function _playerWeaponShoot(_arg1:Number):void
    {
        var itemData_:Object = this.equipData_[0];
        if (map_ == null || _EntityIsStunnedEff() || _EntityIsPausedEff())
        {
            return;
        }
        var _local2:int = equipment_[0];
        if (_local2 == -1)
        {
            map_.gs_.textBox_.addText(Parameters.SendError, "You do not have a weapon equipped!");
            return;
        }
        var _local3:XML = ObjectLibrary.typeToXml[_local2];
        var _local4:int = getTimer();
        var _local5:Number = Number(_local3.RateOfFire);
        if (_local3.RateOfFire == 0 || !(_local3.hasOwnProperty("RateOfFire")))
        {
            _local5 = Number(0.000000001);
        }
        if (itemData_ != null && itemData_.hasOwnProperty("FireRate") && itemData_.FireRate != 0)
        {
            _local5 = (Number(_local3.RateOfFire) * Number(itemData_.FireRate)) + Number(0.000000001);
        }
        this._y4 = ((1 / this.GetPlayerFireRate()) * (1 / _local5));
        if (_local4 < (_W_J_ + this._y4))
        {
            return;
        }
        doneAction(map_.gs_, Tutorial._9Z_);
        _M_r = _arg1;
        _W_J_ = _local4;
        this.PlayerFireProjectile(_W_J_, _local2, _local3, _M_r, true, 0);
    }

    private function PlayerFireProjectile(_arg1:int, _arg2:int, _arg3:XML, _arg4:Number, _arg5:Boolean, _arg6:int):void
    {
        var _local12:uint;
        var _local13:Projectile;
        var _local14:int;
        var _local15:int;
        var _local16:Number;
        var _local17:int;
        var _lifetimeMS:int;

        var _local6:int = ((_arg3.hasOwnProperty("NumProjectiles")) ? int(_arg3.NumProjectiles) : 1);
        var _local7:Number = (((_arg3.hasOwnProperty("ArcGap")) ? Number(_arg3.ArcGap) : 11.25) * Trig._km);
        var _local8:Vector.<Projectile> = new Vector.<Projectile>();
        var _local9:Number = (_local7 * (_local6 - 1));
        var _local10:Number = (_arg4 - (_local9 / 2));
        var _local11:int = 0;
        var itemData_:Object = this.equipData_[_arg6];
        while (_local11 < _local6)
        {
            _local12 = _true();
            _local13 = (_wW_._B_1(Projectile) as Projectile);
            _local13.reset(_arg2, 0, objectId_, _local12, _local10, _arg1);

            _local14 = int(_local13.descs.minDamage_);
            _local15 = int(_local13.descs.maxDamage_);
            if(itemData_ != null && itemData_.hasOwnProperty("DmgPercentage") && itemData_.DmgPercentage != 0)
            {
                var _local18:int = int(itemData_.DmgPercentage);
                _local14 += (_local14 * (_local18 / 100));
                _local15 += (_local15 * (_local18 / 100));
            }

            if(itemData_ != null && itemData_.hasOwnProperty("Range") && itemData_.Range != 0)
            {
                var _speed:int = int(_local13.descs.speed_);
                var plusRange:Number = Number(itemData_.Range);
                _lifetimeMS = int((plusRange * 10000) / _speed);
            }
            else
            {
                _lifetimeMS = 0;
            }

            _local16 = ((_arg5) ? this.GetPlayerAttackDamage() : 1);
            _local17 = (map_.gs_.gsc_.getNextDamage(_local14, _local15) * _local16);
            if (_arg1 > (map_.gs_.moveRecords_.lastClearTime_ + 600))
            {
                _local17 = 0;
            }
            _local13.damageIs(_local17);
            _local13.additiveLifeTimeMS(_lifetimeMS);
            if ((_local11 == 0) && !(_local13._P_B_ == null))
            {
                SFXHandler.play(_local13._P_B_, 0.75, false); //SFX Handling for Shooting!
            }
            map_.addObj(_local13, (x_ + (Math.cos(_arg4) * 0.3)), (y_ + (Math.sin(_arg4) * 0.3)));
            map_.gs_.gsc_.playerShoot(_arg1, _local13);
            _local10 = (_local10 + _local7);
            _local11++;
        }
    }

}
}//package com.company.PhoenixRealmClient.objects

