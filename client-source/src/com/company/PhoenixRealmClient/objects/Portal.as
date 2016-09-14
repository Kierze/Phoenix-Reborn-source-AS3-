// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.Portal

package com.company.PhoenixRealmClient.objects {

import Panels.EnterPortalPanel;
import Panels.Panel;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.map.View;

import flash.display.IGraphicsData;

public class Portal extends GameObject implements IPanelProvider {

    public function Portal(_arg1:XML) {
        super(_arg1);
        UsesPanel = true;
        this._0J_A_ = _arg1.hasOwnProperty("NexusPortal");
        this._xq = _arg1.hasOwnProperty("LockedPortal");
    }
    public var _0J_A_:Boolean;
    public var _xq:Boolean;
    public var _09S_:Boolean = true;

    override public function draw(_arg1:Vector.<IGraphicsData>, _arg2:View, _arg3:int):void {
        super.draw(_arg1, _arg2, _arg3);
        if (this._0J_A_) {
            _oL_(_arg1, _arg2);
        }
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new EnterPortalPanel(_arg1, this));
    }

}
}//package com.company.PhoenixRealmClient.objects

