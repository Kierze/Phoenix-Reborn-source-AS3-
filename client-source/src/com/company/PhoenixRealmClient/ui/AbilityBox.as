/**
 * Created by club5_000 on 9/1/2015.
 */
package com.company.PhoenixRealmClient.ui {

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.util.GraphicHelper;

import com.company.PhoenixRealmClient.objects.Player;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;

public class AbilityBox extends Sprite {

        private var _vV_:GraphicsSolidFill;
        private var outlineFill_:GraphicsSolidFill;
        private var _0y:GraphicsStroke;
        private var path_:GraphicsPath;
        private var graphicsData_:Vector.<IGraphicsData>;
        private var ability1_:Ability;
        private var ability2_:Ability;
        private var ability3_:Ability;
        private var gs_:GameSprite;

        public function AbilityBox(_arg1:GameSprite) {
            this.gs_ = _arg1;
            this.outlineFill_ = new GraphicsSolidFill(Parameters._primaryColourDark, 4);
            this._0y = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
            this._vV_ = new GraphicsSolidFill(Parameters._primaryColourDefault, 1);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[_0y, _vV_, path_, GraphicHelper.END_FILL, GraphicHelper._H_B_];

            this.ability1_ = new Ability(gs_, 0, -1);
            this.ability1_.x = -80;
            this.ability1_.y = 5;
            addChild(this.ability1_);

            this.ability2_ = new Ability(gs_, 1, -1);
            this.ability2_.x = -35;
            this.ability2_.y = 5;
            addChild(this.ability2_);

            this.ability3_ = new Ability(gs_, 2, -1);
            this.ability3_.x = 10;
            this.ability3_.y = 5;
            addChild(this.ability3_);

            this.draw();
        }

        public function draw() {
            GraphicHelper._0L_6(this.path_);
            GraphicHelper.drawUI(-85, 0, 140, 50, 4, [1, 1, 1, 1], this.path_);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);

            this.ability1_.draw();
            this.ability2_.draw();
            this.ability3_.draw();
        }
    }
}
