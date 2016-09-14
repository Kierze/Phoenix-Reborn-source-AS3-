package {
import _05G_._X_G_;

import _0_p._L_y;

import _9u._074;

import _C_5._tt;

import _C__._07U_;

import _G_A_.GameContext;
import _G_A_._F_y;

import _I_j._V_4;

import _R_Q_._0K_S_;

import _T_o._083;

import _U_._K_a;

import _U_5._D_c;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.Dispatcher;
import com.company.PhoenixRealmClient.util.loadEmbeds;

import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.*;
import flash.system.Capabilities;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#000000")]
    //[SWF(width="1024", height="768", frameRate="60", backgroundColor="#000000")] //25% more size let's see what happens.
    public class WebMain extends Sprite {

        public static var primStage:Stage;
        public static var instance:WebMain;

        protected var context:_L_y;

        public function WebMain() {
            instance = this;
            this.randomizeLoaderHeader();
            if (stage)
            {
                this.setup();
            } else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            }
        }

        private function onAddedToStage(_arg1:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.setup();
        }

        public function randomizeLoaderHeader():void{
            var _local1:int;
            while (_local1 < 21)
            {
                this.loaderInfo.bytes[_local1] = uint((Math.random() * 0xFF));
                _local1++;
            }
            this.loaderInfo.bytes[2] = 234;
        }

        private function setup():void {
            primStage = stage;
            this._4y();
            this._i1();
            new loadEmbeds().load();
            stage.scaleMode = StageScaleMode.EXACT_FIT;
            this.context.getInjector.getInstance(_D_c).dispatch();
            _06p();
        }
        private function _4y():void {
            Parameters.root = stage.root;
        }
        private function _i1():void {
            this.context = new GameContext();
            this.context.getInjector.map(LoaderInfo)._q3(root.stage.root.loaderInfo);
            var _local1:Dispatcher = new Dispatcher(this);
            this.context.getInjector.map(Dispatcher)._q3(_local1);
            this.context.extend(_07U_).extend(_083)
                    .configure(_F_y).configure(_074)
                    .configure(_tt).configure(_K_a)
                    .configure(_0K_S_).configure(_V_4)
                    .configure(_X_G_)
                    .configure(this);
        }

        private static function _06p():void {
            if (Capabilities.playerType == "Desktop") {
                Parameters.ClientSaveData.fullscreenMode = false;
                Parameters.save();
            }
        }
    }
}

