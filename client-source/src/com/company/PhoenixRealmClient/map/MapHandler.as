package com.company.PhoenixRealmClient.map {
import _015._0C_Q_;

import _H_Z_.Background;

import _fh._zh;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.BasicObject;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.objects.PlayerNearbyList;

import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

public class MapHandler extends Sprite {

    public function MapHandler() {
        this.goDict_ = new Dictionary();
        this.map_ = new Sprite();
        this._0K_A_ = new Vector.<Square>;
        this.squares_ = new Vector.<Square>;
        this.objects_ = new Dictionary();
        this.merchLookup_ = {};
        //this.signalRenderSwitch = new (Boolean);
        super();
    }
    public var goDict_:Dictionary;
    public var gs_:GameSprite;
    public var name_:String;
    public var player_:Player = null;
    public var showDisplays_:Boolean;
    public var music_:String;
    public var width_:int;
    public var height_:int;
    public var _vv:int;
    public var allowPlayerTeleport_:Boolean;
    public var background_:Background = null;
    public var map_:Sprite;
    public var _063:_M_9 = null;
    public var _C_K_:SidebarShadow = null;
    public var mapOverlay_:_0C_Q_ = null;
    public var partyOverlay_:_zh = null;
    public var _0K_A_:Vector.<Square>;
    public var squares_:Vector.<Square>;
    public var objects_:Dictionary;
    public var merchLookup_:Object;
    public var party_:PlayerNearbyList = null;
    // public var signalRenderSwitch:?;
    public var quest_:Quest = null;
    protected var _1fF_:Boolean = false;

    public function setProps(_arg1:int, _arg2:int, _arg3:String, _arg4:int, _arg5:Boolean, _arg6:Boolean, _arg7:String):void {
    }

    public function addObj(_arg1:BasicObject, _arg2:Number, _arg3:Number):void {
    }

    public function setGroundTile(_arg1:int, _arg2:int, _arg3:uint):void {
    }

    public function initialize():void {
    }

    public function dispose():void {
    }

    public function update(_arg1:int, _arg2:int):void {
    }

    public function pSTopW(_arg1:Number, _arg2:Number):Point {
        return (null);
    }

    public function removeObj(_arg1:int):void {
    }

    public function draw(_arg1:View, _arg2:int):void {
    }
}
}