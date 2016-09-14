// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.map.SidebarShadow

package com.company.PhoenixRealmClient.map {
import com.company.util.GraphicHelper;

import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.display.Sprite;

public class SidebarShadow extends Sprite {

    private const _U_G_:GraphicsGradientFill = new GraphicsGradientFill(GradientType.LINEAR, [0, 0], [0, 0.5], [0, 0xFF], GraphicHelper._0L_0(10, 768));
    private const _006:GraphicsPath = GraphicHelper._wj(0, 0, 10, 768);

    public function SidebarShadow() {
        this._0B_Y_ = new <IGraphicsData>[_U_G_, _006, GraphicHelper.END_FILL];
        graphics.drawGraphicsData(this._0B_Y_);
    }
    private var _0B_Y_:Vector.<IGraphicsData>;
}
}//package com.company.PhoenixRealmClient.map

