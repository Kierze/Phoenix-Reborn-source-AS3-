package com.company.PhoenixRealmClient.game {
import Packets.fromServer.MapInfoPacket;

import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.net.GameConnection;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.tutorial.Tutorial;

import flash.display.Sprite;

public class GameView extends Sprite {

    public var isEditor:Boolean;
    public var tutorial_:Tutorial;
    public var mui_:_07a;
    public var lastUpdate_:int = 0;
    public var moveRecords_:_uw;
    //public var map:MapHandler;
    public var camera_:View;
    public var gsc_:GameConnection;

    public function GameView() {
        this.moveRecords_ = new _uw();
        this.camera_ = new View();
        super();
    }
    public function initialize():void{
    }
    public function setFocus(_arg1:GameObject):void{
    }
    public function applyMapInfo(_arg1:MapInfoPacket):void{
    }
    public function evalIsNotInCombatMapArea():Boolean{
        return (false);
    }
}
}
