// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.Projectile

package com.company.PhoenixRealmClient.objects {
import ParticleAnimations.DecayParticle;
import ParticleAnimations.HitEffect;

import com.company.PhoenixRealmClient.engine3d._0I_4;
import com.company.PhoenixRealmClient.map.Square;
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.map._X_l;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.tutorial.Tutorial;
import com.company.PhoenixRealmClient.tutorial.doneAction;
import com.company.PhoenixRealmClient.util.AbilityLibrary;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.PhoenixRealmClient.util._04d;
import com.company.PhoenixRealmClient.util._7t;
import com.company.PhoenixRealmClient.util._wW_;
import com.company.util.GraphicHelper;
import com.company.util.Trig;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.Dictionary;

public class Projectile extends BasicObject {

    private static var projsDict:Dictionary = new Dictionary();

    public static function getProjectileId_(_arg1:int, _arg2:uint):int {
        return (projsDict[((_arg2 << 24) | _arg1)]);
    }

    public static function newProjectile_(_arg1:int, _arg2:uint):int {
        var _local3:int = bitShift();
        projsDict[((_arg2 << 24) | _arg1)] = _local3;
        return (_local3);
    }

    public static function removeProjReference_(_arg1:int, _arg2:uint):void {
        delete projsDict[((_arg2 << 24) | _arg1)];
    }

    public static function dispose():void {
        projsDict = new Dictionary();
    }

    public function Projectile() {
        this._ey = new _0I_4(100);
        this._0L_7 = new Point();
        this._08V_ = new Vector3D();
        this._J_4 = new GraphicsGradientFill(GradientType.RADIAL, [0, 0], [0.5, 0], null, new Matrix());
        this._P_C_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
        super();
    }
    public var props_:ObjectProperties;
    public var containerProps:ObjectProperties;
    public var descs:ProjectileDescriptors;
    public var texture_:BitmapData;
    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var bulletType_:uint;
    public var _jr:Boolean;
    public var _0H_n:Boolean;
    public var damage_:int;
    public var penetration_:int;
    public var addLifetime_:int = 0;
    public var _P_B_:String;
    public var _R_i:Number;
    public var _J_Y_:Number;
    public var startTime_:int;
    public var angle_:Number = 0;
    public var _08H_:Dictionary;
    public var _ey:_0I_4;
    protected var _J_4:GraphicsGradientFill;
    protected var _P_C_:GraphicsPath;
    private var _0L_7:Point;
    private var _08V_:Vector3D;

    override public function addTo(_arg1:_X_l, _arg2:Number, _arg3:Number):Boolean {
        var _local4:Player;
        this._R_i = _arg2;
        this._J_Y_ = _arg3;
        if (!super.addTo(_arg1, _arg2, _arg3)) {
            return (false);
        }
        if (((!(this.containerProps.flying_)) && (_0H_B_.sink_))) {
            z_ = 0.1;
        } else {
            _local4 = (_arg1.goDict_[this.ownerId_] as Player);
            if (((!((_local4 == null))) && ((_local4._0F_ > 0)))) {
                z_ = (0.5 - (0.4 * (_local4._0F_ / Parameters._K_5)));
            }
        }
        return (true);
    }

    override public function removeFromMap():void {
        super.removeFromMap();
        removeProjReference_(this.ownerId_, this.bulletId_);
        this._08H_ = null;
        _wW_._ay(this);
    }

    override public function update(_arg1:int, _arg2:int):Boolean {
        var _local5:Vector.<uint>;
        var _local7:Boolean;
        var _local8:int;
        var _local9:Boolean;
        var _local3:int = (_arg1 - this.startTime_);

        if (_local3 > (this.descs.lifetime_ + addLifetime_))
        {
            return (false);
        }
        var _local4:Point = this._0L_7;
        this._W_d(_local3, _local4);
        if (!this.moveTo(_local4.x, _local4.y) || (_0H_B_.tileType_ == 0xFF))
        {
            if (this._0H_n)
            {
                map_.gs_.gsc_.squareHit(_arg1, this.bulletId_, this.ownerId_);
            }
            else
            {
                if (_0H_B_.obj_ != null)
                {
                    _local5 = _7t._tD_(this.texture_);
                    map_.addObj(new HitEffect(_local5, 100, 3, this.angle_, this.descs.speed_), _local4.x, _local4.y);
                }
            }
            return (false);
        }
        if ((_0H_B_.obj_ != null && (!_0H_B_.obj_.props_.isEnemy_ || !this._jr)) && (_0H_B_.obj_.props_.enemyOccupySquare_ || (!this.descs.passesCover && _0H_B_.obj_.props_.occupySquare_))) {
            if (this._0H_n)
            {
                map_.gs_.gsc_.otherHit(_arg1, this.bulletId_, this.ownerId_, _0H_B_.obj_.objectId_);
            }
            else
            {
                _local5 = _7t._tD_(this.texture_);
                map_.addObj(new HitEffect(_local5, 100, 3, this.angle_, this.descs.speed_), _local4.x, _local4.y);
            }
            return (false);
        }
        var entity:GameObject = this.projHitTest(_local4.x, _local4.y);
        if (entity != null)
        {
            _local7 = false;
            if (this._0H_n)
            {
                _local7 = true;
            }
            else if (this.ownerId_ == map_.player_.objectId_)
            {
                _local7 = true;
            }
            else if (entity == map_.player_)
            {
                _local7 = true;
            }
            if (_local7 && !map_.player_._EntityIsPausedEff())
            {
                _local8 = GameObject.CalculateDamage(this.damage_, this.descs.penetration_, entity.defense_, entity.resilience_, this.descs.armorPiercing, entity.condEffects);
                _local9 = false;
                if (entity.HP_ <= _local8)
                {
                    _local9 = true;
                    if (entity.props_.isEnemy_)
                    {
                        doneAction(map_.gs_, Tutorial._05O_);
                    }
                }
                if (entity == map_.player_)
                {
                    map_.gs_.gsc_.playerHit(this.bulletId_, this.ownerId_);
                    map_.gs_.gsc_.sendVisibullet(this.damage_, this.penetration_, this.ownerId_, this.bulletId_, this.descs.armorPiercing);
                    entity.postDamageEffects(this.containerType_, 0, this.descs.effects_, false, this);
                }
                else
                {
                    if (entity.props_.isEnemy_)
                    {
                        map_.gs_.gsc_.enemyHit(_arg1, this.bulletId_, entity.objectId_, _local9, _local8);
                        //entity.postDamageEffects(this.containerType_, _local8, this.descs.effects_, _local9, this);
                    }
                    else
                    {
                        if (!this.descs.multiHit)
                        {
                            map_.gs_.gsc_.otherHit(_arg1, this.bulletId_, this.ownerId_, entity.objectId_);
                        }
                    }
                }
            }
            if (this.descs.multiHit)
            {
                this._08H_[entity] = true;
            }
            else
            {
                return (false);
            }
        }
        return (true);
    }

    override public function draw(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void {
        var _local6:uint;
        var _local7:uint;
        if (!Parameters.DrawProjectiles) {
            return;
        }
        var _local4:BitmapData = this.texture_;
        if (Parameters._Q_b != 0) {
            switch (Parameters._Q_b) {
                case 1:
                    _local6 = 16777100;
                    _local7 = 0xFFFFFF;
                    break;
                case 2:
                    _local6 = 16777100;
                    _local7 = 16777100;
                    break;
                case 3:
                    _local6 = 0xFF0000;
                    _local7 = 0xFF0000;
                    break;
                case 4:
                    _local6 = 0xFF;
                    _local7 = 0xFF;
                    break;
                case 5:
                    _local6 = 0xFFFFFF;
                    _local7 = 0xFFFFFF;
                    break;
                case 6:
                    _local6 = 0;
                    _local7 = 0;
                    break;
            }
            _local4 = TextureRedrawer.redraw(_local4, 120, true, _local7);
        }
        var _local5:Number = (((this.props_.rotation_ == 0)) ? 0 : (_arg3 / this.props_.rotation_));
        this._08V_.x = x_;
        this._08V_.y = y_;
        this._08V_.z = z_;
        this._ey.draw(_arg1, this._08V_, (((this.angle_ - _arg2.angleRad_) + this.props_.angleCorrection) + _local5), _arg2.wToS_, _arg2, _local4);
        if (this.descs.particleTrail) {
            map_.addObj(new DecayParticle(100, this.descs.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
            map_.addObj(new DecayParticle(100, this.descs.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
            map_.addObj(new DecayParticle(100, this.descs.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
        }
    }

    override public function drawShadow(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void {
        if (!Parameters.DrawProjectiles) {
            return;
        }
        var _local4:Number = (this.props_.shadowSize / 400);
        var _local5:Number = (30 * _local4);
        var _local6:Number = (15 * _local4);
        this._J_4.matrix.createGradientBox((_local5 * 2), (_local6 * 2), 0, (_bY_[0] - _local5), (_bY_[1] - _local6));
        _arg1.push(this._J_4);
        this._P_C_.data.length = 0;
        this._P_C_.data.push((_bY_[0] - _local5), (_bY_[1] - _local6), (_bY_[0] + _local5), (_bY_[1] - _local6), (_bY_[0] + _local5), (_bY_[1] + _local6), (_bY_[0] - _local5), (_bY_[1] + _local6));
        _arg1.push(this._P_C_);
        _arg1.push(GraphicHelper.END_FILL);
    }

    public function reset(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:Number, _arg6:int, fromAbility:Boolean = false):void {
        var _local8:Number;
        clear();
        this.containerType_ = _arg1;
        this.bulletType_ = _arg2;
        this.ownerId_ = _arg3;
        this.bulletId_ = _arg4;
        this.angle_ = Trig._V_r(_arg5);
        this.startTime_ = _arg6;
        objectId_ = newProjectile_(this.ownerId_, this.bulletId_);
        z_ = 0.5;

        if(!fromAbility)
        {
            this.containerProps = ObjectLibrary.typeToObjectProperties[this.containerType_];
        }

        else
        {
            this.containerProps = AbilityLibrary.Props[this.containerType_];
        }

        this.descs = this.containerProps.projectiles[_arg2];
        this.props_ = ObjectLibrary.idToObjectProperties(this.descs.objectId_);


        _P_m = (this.props_.shadowSize > 0);
        var _local7:TextureFromXML = ObjectLibrary.typeToTexture[this.props_.type_];
        this.texture_ = _local7.getTexture(objectId_);
        this._0H_n = this.containerProps.isEnemy_;
        this._jr = !(this._0H_n);
        this._P_B_ = this.containerProps.oldSound;
        this._08H_ = ((this.descs.multiHit) ? new Dictionary() : null);
        if (this.descs.size_ >= 0) {
            _local8 = this.descs.size_;
        } else {
            if(!fromAbility) {
                _local8 = ObjectLibrary._P_N_(this.containerType_);
            } else {
                _local8 = 100;
            }
        }
        this._ey._H_9((8 * (_local8 / 100)));
        this.damage_ = 0;
    }

    public function damageIs(_arg1:int):void {
        this.damage_ = _arg1;
    }

    public function additiveLifeTimeMS(_arg1:int):void{
        this.addLifetime_ = _arg1;
    }

    public function moveTo(_arg1:Number, _arg2:Number):Boolean {
        var _local3:Square = map_.getSquare(_arg1, _arg2);
        if (_local3 == null) {
            return (false);
        }
        x_ = _arg1;
        y_ = _arg2;
        _0H_B_ = _local3;
        return (true);
    }

    public function projHitTest(_arg1:Number, _arg2:Number):GameObject {
        var _local5:GameObject;
        var _local6:Number;
        var _local7:Number;
        var _local8:Number;
        var _local3:Number = Number.MAX_VALUE;
        var _local4:GameObject;
        for each (_local5 in map_.goDict_)
        {
            if (!_local5._EntityIsInvincibleEff())
            {
                if (!_local5._EntityIsStasisEff())
                {
                    if ((this._jr && _local5.props_.isEnemy_) || (this._0H_n && _local5.props_.isPlayer))
                    {
                        if (!((_local5.dead) || (_local5._EntityIsPausedEff())))
                        {
                            _local6 = (((_local5.x_ > _arg1)) ? (_local5.x_ - _arg1) : (_arg1 - _local5.x_));
                            _local7 = (((_local5.y_ > _arg2)) ? (_local5.y_ - _arg2) : (_arg2 - _local5.y_));
                            if (!(_local6 > _local5.radius_ || _local7 > _local5.radius_))
                            {
                                if (!(this.descs.multiHit && this._08H_[_local5] != null))
                                {
                                    if (_local5 == map_.player_)
                                    {
                                        return (_local5);
                                    }
                                    _local8 = Math.sqrt((_local6 * _local6) + (_local7 * _local7));
                                    if (_local8 < _local3)
                                    {
                                        _local3 = _local8;
                                        _local4 = _local5;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return (_local4);
    }

    private function _W_d(_arg1:int, _arg2:Point):void {
        var _local5:Number;
        var _local6:Number;
        var _local7:Number;
        var _local8:Number;
        var _local9:Number;
        var _local10:Number;
        var _local11:Number;
        var _local12:Number;
        var _local13:Number;
        var _local14:Number;
        _arg2.x = this._R_i;
        _arg2.y = this._J_Y_;
        var _local3:Number = (_arg1 * (this.descs.speed_ / 10000));
        var _local4:Number = ((((this.bulletId_ % 2)) == 0) ? 0 : Math.PI);
        if (this.descs.wavy) {
            _local5 = (6 * Math.PI);
            _local6 = (Math.PI / 64);
            _local7 = (this.angle_ + (_local6 * Math.sin((_local4 + ((_local5 * _arg1) / 1000)))));
            _arg2.x = (_arg2.x + (_local3 * Math.cos(_local7)));
            _arg2.y = (_arg2.y + (_local3 * Math.sin(_local7)));
        } else {
            if (this.descs.parametric) {
                _local8 = (((_arg1 / (this.descs.lifetime_ + addLifetime_)) * 2) * Math.PI);
                _local9 = (Math.sin(_local8) * (((this.bulletId_ % 2)) ? 1 : -1));
                _local10 = (Math.sin((2 * _local8)) * ((((this.bulletId_ % 4)) < 2) ? 1 : -1));
                _local11 = Math.sin(this.angle_);
                _local12 = Math.cos(this.angle_);
                _arg2.x = (_arg2.x + (((_local9 * _local12) - (_local10 * _local11)) * this.descs.magnitude));
                _arg2.y = (_arg2.y + (((_local9 * _local11) + (_local10 * _local12)) * this.descs.magnitude));
            } else {
                if (this.descs.boomerang) {
                    _local13 = (((this.descs.lifetime_ + addLifetime_) * (this.descs.speed_ / 10000)) / 2);
                    if (_local3 > _local13) {
                        _local3 = (_local13 - (_local3 - _local13));
                    }
                }
                _arg2.x = (_arg2.x + (_local3 * Math.cos(this.angle_)));
                _arg2.y = (_arg2.y + (_local3 * Math.sin(this.angle_)));
                if (this.descs.amplitude != 0) {
                    _local14 = (this.descs.amplitude * Math.sin((_local4 + ((((_arg1 / (this.descs.lifetime_ + addLifetime_)) * this.descs.frequency) * 2) * Math.PI))));
                    _arg2.x = (_arg2.x + (_local14 * Math.cos((this.angle_ + (Math.PI / 2)))));
                    _arg2.y = (_arg2.y + (_local14 * Math.sin((this.angle_ + (Math.PI / 2)))));
                }
            }
        }
    }

}
}//package com.company.PhoenixRealmClient.objects

