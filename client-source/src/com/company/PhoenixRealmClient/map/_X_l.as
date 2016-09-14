// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.map._X_l

package com.company.PhoenixRealmClient.map {
import _015._0C_Q_;

import _H_Z_.Background;

import _fh._zh;

import _vf.MusicHandler;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.BasicObject;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.objects.PlayerNearbyList;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.ConditionEffect;

import flash.display.Graphics;
import flash.display.IGraphicsData;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class _X_l extends MapHandler {

    private static const _D_W_:Array = ["sortVal_", "objectId_"];
    private static const _0_2:Array = [Array.NUMERIC, Array.NUMERIC];
    protected static const _01z:ColorMatrixFilter = new ColorMatrixFilter([0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 1, 0]);

    protected static var _S_Z_:ColorTransform = new ColorTransform((0xFF / 0xFF), (55 / 0xFF), (0 / 0xFF), 0);

    public function _X_l(_arg1:GameSprite) {
        this._04p = new Vector.<BasicObject>();
        this._C_X_ = new Vector.<int>();
        this.graphicsData_ = new Vector.<IGraphicsData>();
        this._u2 = [];
        this._4e = [];
        this._fr = new Vector.<Square>();
        this._8L_ = new Vector.<Square>();
        super();
        gs_ = _arg1;
        _063 = new _M_9();
        mapOverlay_ = new _0C_Q_();
        partyOverlay_ = new _zh(this);
        party_ = new PlayerNearbyList(this);
        quest_ = new Quest(this);
    }
    public var _u2:Array;
    public var _4e:Array;
    public var _fr:Vector.<Square>;
    public var _8L_:Vector.<Square>;
    private var _tf:Boolean = false;
    private var _04p:Vector.<BasicObject>;
    private var _C_X_:Vector.<int>;
    private var _1K_D_:Boolean = false;
    private var graphicsData_:Vector.<IGraphicsData>;

    override public function setProps(_arg1:int, _arg2:int, _arg3:String, _arg4:int, _arg5:Boolean, _arg6:Boolean, _arg7:String):void {
        width_ = _arg1;
        height_ = _arg2;
        name_ = _arg3;
        _vv = _arg4;
        allowPlayerTeleport_ = _arg5;
        showDisplays_ = _arg6;
        music_ = _arg7;
        MusicHandler.reload(this.music_);
    }

    override public function initialize():void {
        this.squares_.length = (this.width_ * this.height_);
        this.background_ = Background._U_q(this._vv);
        if (this.background_ != null) {
            addChild(this.background_);
        }
        addChild(this.map_);
        addChild(this._063);
        addChild(this.mapOverlay_);
        addChild(this.partyOverlay_);
    }

    override public function dispose():void {
        var _local1:Square;
        var _local2:GameObject;
        var _local3:BasicObject;
        this.gs_ = null;
        this.background_ = null;
        this.map_ = null;
        this._063 = null;
        this.mapOverlay_ = null;
        this.partyOverlay_ = null;
        for each (_local1 in this._0K_A_) {
            _local1.dispose();
        }
        this._0K_A_.length = 0;
        this._0K_A_ = null;
        this.squares_.length = 0;
        this.squares_ = null;
        for each (_local2 in this.goDict_) {
            _local2.dispose();
        }
        this.goDict_ = null;
        for each (_local3 in this.objects_) {
            _local3.dispose();
        }
        this.objects_ = null;
        this.merchLookup_ = null;
        this.player_ = null;
        this.party_ = null;
        this.quest_ = null;
        this._04p = null;
        this._C_X_ = null;
    }

    override public function update(_arg1:int, _arg2:int):void {
        var _local3:BasicObject;
        var _local4:int;
        this._tf = true;
        for each (_local3 in this.goDict_) {
            if (!_local3.update(_arg1, _arg2)) {
                this._C_X_.push(_local3.objectId_);
            }
        }
        for each (_local3 in this.objects_) {
            if (!_local3.update(_arg1, _arg2)) {
                this._C_X_.push(_local3.objectId_);
            }
        }
        this._tf = false;
        for each (_local3 in this._04p) {
            this._vj(_local3);
        }
        this._04p.length = 0;
        for each (_local4 in this._C_X_) {
            this._1a(_local4);
        }
        this._C_X_.length = 0;
        this.party_.update(_arg1, _arg2);
    }

    override public function pSTopW(_arg1:Number, _arg2:Number):Point {
        var _local4:Square;
        var _local3:Point;
        for each (_local4 in this._fr) {
            if (((!((_local4.faces_.length == 0))) && (_local4.faces_[0].face_.contains(_arg1, _arg2)))) {
                return (new Point(_local4.center_.x, _local4.center_.y));
            }
        }
        return (null);
    }

    override public function setGroundTile(_arg1:int, _arg2:int, _arg3:uint):void {
        var _local8:int;
        var _local9:int;
        var _local10:Square;
        var _local4:Square = this.getSquare(_arg1, _arg2);
        _local4._bQ_(_arg3);
        var _local5:int = (((_arg1 < (this.width_ - 1))) ? (_arg1 + 1) : _arg1);
        var _local6:int = (((_arg2 < (this.height_ - 1))) ? (_arg2 + 1) : _arg2);
        var _local7:int = (((_arg1 > 0)) ? (_arg1 - 1) : _arg1);
        while (_local7 <= _local5) {
            _local8 = (((_arg2 > 0)) ? (_arg2 - 1) : _arg2);
            while (_local8 <= _local6) {
                _local9 = (_local7 + (_local8 * this.width_));
                _local10 = this.squares_[_local9];
                if (((!((_local10 == null))) && (((_local10.props_._0H_U_) || (!((_local10.tileType_ == _arg3))))))) {
                    _local10.faces_.length = 0;
                }
                _local8++;
            }
            _local7++;
        }
    }

    override public function addObj(_arg1:BasicObject, _arg2:Number, _arg3:Number):void {
        _arg1.x_ = _arg2;
        _arg1.y_ = _arg3;
        if (this._tf) {
            this._04p.push(_arg1);
        } else {
            this._vj(_arg1);
        }
    }

    override public function removeObj(_arg1:int):void {
        if (this._tf) {
            this._C_X_.push(_arg1);
        } else {
            this._1a(_arg1);
        }
    }

    override public function draw(_arg1:View, _arg2:int):void {
        var _local6:Square;
        var _local13:GameObject;
        var _local14:BasicObject;
        var _local16:int;
        var _local17:Number;
        var _local18:Number;
        var _local19:Number;
        var _local20:Number;
        var _local21:Number;
        var _local22:Array;
        var _local23:Number;
        var _local24:Array;
        var _local25:Number;
        var _local3:Rectangle = _arg1._F_L_;
        x = -(_local3.x);
        y = -(_local3.y);
        var _local4:Number = ((-(_local3.y) - (_local3.height / 2)) / 50);
        var _local5:Point = new Point((_arg1.x_ + (_local4 * Math.cos((_arg1.angleRad_ - (Math.PI / 2))))), (_arg1.y_ + (_local4 * Math.sin((_arg1.angleRad_ - (Math.PI / 2))))));
        if (this.background_ != null) {
            this.background_.draw(_arg1, _arg2);
        }
        this._u2.length = 0;
        this._4e.length = 0;
        this._fr.length = 0;
        this._8L_.length = 0;
        var _local7:int = _arg1.maxDist_;
        var _local8:int = Math.max(0, (_local5.x - _local7));
        var _local9:int = Math.min((this.width_ - 1), (_local5.x + _local7));
        var _local10:int = Math.max(0, (_local5.y - _local7));
        var _local11:int = Math.min((this.height_ - 1), (_local5.y + _local7));
        this.graphicsData_.length = 0;
        var _local12:int = _local8;
        while (_local12 <= _local9) {
            _local16 = _local10;
            while (_local16 <= _local11) {
                _local6 = this.squares_[(_local12 + (_local16 * this.width_))];
                if (_local6 != null) {
                    _local17 = (_local5.x - _local6.center_.x);
                    _local18 = (_local5.y - _local6.center_.y);
                    _local19 = ((_local17 * _local17) + (_local18 * _local18));
                    if (_local19 <= _arg1._U_8) {
                        _local6._P_k = _arg2;
                        _local6.draw(this.graphicsData_, _arg1, _arg2);
                        this._fr.push(_local6);
                        if (_local6._0_C_ != null) {
                            this._8L_.push(_local6);
                        }
                    }
                }
                _local16++;
            }
            _local12++;
        }
        for each (_local13 in this.goDict_) {
            _local13._1D_ = false;
            if (!_local13.dead) {
                _local6 = _local13._0H_B_;
                if (!(((_local6 == null)) || (!((_local6._P_k == _arg2))))) {
                    _local13._1D_ = true;
                    _local13._0E_T_(_arg1);
                    if (_local13.props_.lowerDraw) {
                        if (_local13.props_.drawOnGround) {
                            _local13.draw(this.graphicsData_, _arg1, _arg2);
                        } else {
                            this._4e.push(_local13);
                        }
                    } else {
                        this._u2.push(_local13);
                    }
                }
            }
        }
        for each (_local14 in this.objects_) {
            _local14._1D_ = false;
            _local6 = _local14._0H_B_;
            if (!(((_local6 == null)) || (!((_local6._P_k == _arg2))))) {
                _local14._1D_ = true;
                _local14._0E_T_(_arg1);
                this._u2.push(_local14);
            }
        }
        if (this._4e.length > 0) {
            this._4e.sortOn(_D_W_, _0_2);
            for each (_local14 in this._4e) {
                _local14.draw(this.graphicsData_, _arg1, _arg2);
            }
        }
        this._u2.sortOn(_D_W_, _0_2);
        if (Parameters.ClientSaveData.drawShadows) {
            for each (_local14 in this._u2) {
                if (_local14._P_m) {
                    _local14.drawShadow(this.graphicsData_, _arg1, _arg2);
                }
            }
        }
        for each (_local14 in this._u2) {
            _local14.draw(this.graphicsData_, _arg1, _arg2);
        }
        if (this._8L_.length > 0) {
            for each (_local6 in this._8L_) {
                _local6._D_r(this.graphicsData_, _arg1, _arg2);
            }
        }
        if (((((!((this.player_ == null))) && ((this.player_._R_4 >= 0)))) && ((this.player_._R_4 < Parameters._E_S_)))) {
            _local20 = ((Parameters._E_S_ - this.player_._R_4) / Parameters._E_S_);
            _local21 = (Math.abs(Math.sin((_arg2 / 300))) * 0.75);
            _S_Z_.alphaMultiplier = (_local20 * _local21);
            this._063.transform.colorTransform = _S_Z_;
            this._063.visible = true;
            this._063.x = _local3.left;
            this._063.y = _local3.top;
        } else {
            this._063.visible = false;
        }
        var _local15:Graphics = this.map_.graphics;
        _local15.clear();
        _local15.drawGraphicsData(this.graphicsData_);
        this.map_.filters.length = 0;
        if (((!((this.player_ == null))) && (!(((this.player_.condEffects & ConditionEffect.FogFilterEffects) == 0))))) {
            _local22 = [];
            if (this.player_._EntityIsDrunkEff()) {
                _local23 = (20 + (10 * Math.sin((_arg2 / 1000))));
                _local22.push(new BlurFilter(_local23, _local23));
            }
            if (this.player_._EntityIsBlindEff()) {
                _local22.push(_01z);
            }
            this.map_.filters = _local22;
        } else {
            if (this.map_.filters.length > 0) {
                this.map_.filters = [];
            }
        }
        this.mapOverlay_.draw(_arg1, _arg2);
        this.partyOverlay_.draw(_arg1, _arg2);
    }

    public function _vj(_arg1:BasicObject):void {
        if (!_arg1.addTo(this, _arg1.x_, _arg1.y_)) {
            return;
        }
        var _local2:Dictionary = (((_arg1 is GameObject)) ? this.goDict_ : this.objects_);
        if (_local2[_arg1.objectId_] != null) {
            return;
        }
        _local2[_arg1.objectId_] = _arg1;
    }

    public function _1a(_arg1:int):void {
        var _local2:Dictionary = this.goDict_;
        var _local3:BasicObject = _local2[_arg1];
        if (_local3 == null) {
            _local2 = this.objects_;
            _local3 = _local2[_arg1];
            if (_local3 == null) {
                return;
            }
        }
        _local3.removeFromMap();
        delete _local2[_arg1];
    }

    public function getSquare(_arg1:Number, _arg2:Number):Square {
        if ((((((((_arg1 < 0)) || ((_arg1 >= this.width_)))) || ((_arg2 < 0)))) || ((_arg2 >= this.height_)))) {
            return (null);
        }
        var _local3:int = (int(_arg1) + (int(_arg2) * this.width_));
        var _local4:Square = this.squares_[_local3];
        if (_local4 == null) {
            _local4 = new Square(this, int(_arg1), int(_arg2));
            this.squares_[_local3] = _local4;
            this._0K_A_.push(_local4);
        }
        return (_local4);
    }

    public function lookupSquare(_arg1:int, _arg2:int):Square {
        if ((((((((_arg1 < 0)) || ((_arg1 >= this.width_)))) || ((_arg2 < 0)))) || ((_arg2 >= this.height_)))) {
            return (null);
        }
        return (this.squares_[(_arg1 + (_arg2 * this.width_))]);
    }

}
}//package com.company.PhoenixRealmClient.map

