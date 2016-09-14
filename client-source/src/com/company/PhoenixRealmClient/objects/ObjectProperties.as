// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.ObjectProperties

package com.company.PhoenixRealmClient.objects {
import _vf.SFXHandler;

import flash.utils.Dictionary;

public class ObjectProperties {

    public function ObjectProperties(_arg1:XML) {
        var _local2:XML;
        var _local3:XML;
        var _local4:int;
        this.projectiles = new Dictionary();
        super();
        if (_arg1 == null) {
            return;
        }
        this.type_ = int(_arg1.@type);
        this.id_ = String(_arg1.@id);
        this.displayId = this.id_;
        if (_arg1.hasOwnProperty("DisplayId")) {
            this.displayId = _arg1.DisplayId;
        }
        this.shadowSize = ((_arg1.hasOwnProperty("ShadowSize")) ? _arg1.ShadowSize : 100);
        this.isPlayer = _arg1.hasOwnProperty("Player");
        this.isEnemy_ = _arg1.hasOwnProperty("Enemy");
        this.drawOnGround = _arg1.hasOwnProperty("DrawOnGround");
        if (this.drawOnGround || _arg1.hasOwnProperty("DrawUnder"))
        {
            this.lowerDraw = true;
        }
        this.occupySquare_ = _arg1.hasOwnProperty("OccupySquare");
        this.fullOccupy = _arg1.hasOwnProperty("FullOccupy");
        this.enemyOccupySquare_ = _arg1.hasOwnProperty("EnemyOccupySquare");
        this.static_ = _arg1.hasOwnProperty("Static");
        this.noMiniMap = _arg1.hasOwnProperty("NoMiniMap");
        this.protectFromGroundDamage_ = _arg1.hasOwnProperty("ProtectFromGroundDamage");
        this.protectFromSink_ = _arg1.hasOwnProperty("ProtectFromSink");
        this.flying_ = _arg1.hasOwnProperty("Flying");
        this.showName = _arg1.hasOwnProperty("ShowName");
        this.dontFaceAttacks = _arg1.hasOwnProperty("DontFaceAttacks");
        if (_arg1.hasOwnProperty("Z")) {
            this.z_ = Number(_arg1.Z);
        }
        if (_arg1.hasOwnProperty("Color")) {
            this.color_ = uint(_arg1.Color);
        }
        if (_arg1.hasOwnProperty("Size")) {
            this.minSize = (this.maxSize = _arg1.Size);
        } else {
            if (_arg1.hasOwnProperty("MinSize")) {
                this.minSize = _arg1.MinSize;
            }
            if (_arg1.hasOwnProperty("MaxSize")) {
                this.maxSize = _arg1.MaxSize;
            }
            if (_arg1.hasOwnProperty("SizeStep")) {
                this.sizeStep = _arg1.SizeStep;
            }
        }
        this.oldSound = ((_arg1.hasOwnProperty("OldSound")) ? String(_arg1.OldSound) : null);
        for each (_local2 in _arg1.Projectile)
        {
            _local4 = int(_local2.@id);
            this.projectiles[_local4] = new ProjectileDescriptors(_local2);
        }
        this.angleCorrection = ((_arg1.hasOwnProperty("AngleCorrection")) ? ((Number(_arg1.AngleCorrection) * Math.PI) / 4) : 0);
        this.rotation_ = ((_arg1.hasOwnProperty("Rotation")) ? _arg1.Rotation : 0);
        if (_arg1.hasOwnProperty("BloodProb")) {
            this.bloodProb = Number(_arg1.BloodProb);
        }
        if (_arg1.hasOwnProperty("BloodColor")) {
            this.bloodColor = uint(_arg1.BloodColor);
        }
        if (_arg1.hasOwnProperty("ShadowColor")) {
            this.shadowColor = uint(_arg1.ShadowColor);
        }
        for each (_local3 in _arg1.Sound) {
            if (this.sounds == null) {
                this.sounds = {};
            }
            this.sounds[int(_local3.@id)] = _local3.toString();
        }
        if (_arg1.hasOwnProperty("Portrait")) {
            this.portrait = new TextureFromXML(XML(_arg1.Portrait));
        }
        if (_arg1.hasOwnProperty("WhileMoving")) {
            this.whileMoving = new WhileMovingProperties(XML(_arg1.WhileMoving));
        }
    }
    public var type_:int;
    public var id_:String;
    public var displayId:String;
    public var shadowSize:int;
    public var isPlayer:Boolean = false;
    public var isEnemy_:Boolean = false;
    public var drawOnGround:Boolean = false;
    public var lowerDraw:Boolean = false;
    public var occupySquare_:Boolean = false;
    public var fullOccupy:Boolean = false;
    public var enemyOccupySquare_:Boolean = false;
    public var static_:Boolean = false;
    public var noMiniMap:Boolean = false;
    public var protectFromGroundDamage_:Boolean = false;
    public var protectFromSink_:Boolean = false;
    public var z_:Number = 0;
    public var flying_:Boolean = false;
    public var color_:uint = 0xFFFFFF;
    public var showName:Boolean = false;
    public var dontFaceAttacks:Boolean = false;
    public var bloodProb:Number = 0;
    public var bloodColor:uint = 0xFF0000;
    public var shadowColor:uint = 0;
    public var sounds:Object = null;
    public var portrait:TextureFromXML = null;
    public var minSize:int = 100;
    public var maxSize:int = 100;
    public var sizeStep:int = 5;
    public var whileMoving:WhileMovingProperties = null;
    public var oldSound:String = null;
    public var projectiles:Dictionary;
    public var angleCorrection:Number = 0;
    public var rotation_:Number = 0;

    public function loadSounds():void {
        var _local1:String;
        if (this.sounds == null) {
            return;
        }
        for each (_local1 in this.sounds) {
            SFXHandler.load(_local1);
        }
    }

    public function getSize():int {
        if (this.minSize == this.maxSize) {
            return (this.minSize);
        }
        var _local1:int = ((this.maxSize - this.minSize) / this.sizeStep);
        return ((this.minSize + (int((Math.random() * _local1)) * this.sizeStep)));
    }

}
}//package com.company.PhoenixRealmClient.objects

class WhileMovingProperties {

    public var z_:Number = 0;
    public var flying_:Boolean = false;

    public function WhileMovingProperties(_arg1:XML) {
        if (_arg1.hasOwnProperty("Z")) {
            this.z_ = Number(_arg1.Z);
        }
        this.flying_ = _arg1.hasOwnProperty("Flying");
    }
}

