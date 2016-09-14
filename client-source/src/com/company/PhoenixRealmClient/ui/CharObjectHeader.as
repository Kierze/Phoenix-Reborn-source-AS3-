package com.company.PhoenixRealmClient.ui
{
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class CharObjectHeader extends Sprite
    {

        public function CharObjectHeader(_arg1:uint, _arg2:Boolean, _arg3:GameObject) //renamed from PlayerCharHeader because arg3 determines if it's a player or another GameObject
        {
            this.forPlayer = _arg2;
            this.color_ = _arg1;
            this._tm = new Bitmap();
            this._tm.x = -4;
            this._tm.y = -4;
            addChild(this._tm);
            if (this.forPlayer)
            {
                this.nameText_ = new SimpleText(13, _arg1, false, 0, 0, "Myriad Pro");
            }
            else
            {
                this.nameText_ = new SimpleText(13, _arg1, false, 66, 20, "Myriad Pro");
                this.nameText_.setBold(true);
            }
            this.nameText_.x = 32;
            this.nameText_.y = 6;
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.nameText_);
            this.draw(_arg3);
        }
        public var forPlayer:Boolean;
        public var go_:GameObject;
        private var _tm:Bitmap;
        private var nameText_:SimpleText;
        private var _L_P_:Sprite;
        private var color_:uint;
        private var _0M_a:uint = 0xFFFFFF;
        private var _lB_:String = null;
        private var _K_7:Boolean = false;
        private var _H_g:ColorTransform = null;

        public function draw(_arg1:GameObject, _arg2:ColorTransform = null):void {
            this.go_ = _arg1;
            visible = !((this.go_ == null));
            if (!visible) {
                return;
            }
            this._tm.bitmapData = this.go_.getPortrait();
            var color:uint = this.color_;
            var text:String;
            var _forPlayer:Boolean;
            var player:Player = (this.go_ as Player);
            var specName:String;
            if (player != null) {
                if (player.inParty) {
                    color = Parameters.playerPartyColor;
                } else if (player._N_n) {
                    color = Parameters.playerGuildColor;
                } else if (player.NameChosen) {
                    color = Parameters.playerNameChosenColor;
                }
            }
            if (this.forPlayer)
            {
                _forPlayer = true;
                if (this.go_.name_ != null && this.go_.name_ != "")
                {
                    if (this.go_.spec_ != null && this.go_.spec_ != "")
                    {
                        for each (var spec:XML in ObjectLibrary.typeToXml[this.go_.objectType_].Specialization)
                        {
                            if (this.go_.spec_ == spec.@id)
                            {
                                specName = spec.@name;
                                break;
                            }
                        }
                    }
                    else
                    {
                        specName = "";
                    }

                    if (specName != null && specName != "") text = "<b>" + this.go_.name_ + "</b> (" + specName;
                    else text = ((("<b>" + this.go_.name_) + "</b> (")  + ObjectLibrary.typeToDisplayId[this.go_.objectType_]);

                    if (this.go_.level_ < 1) {
                        text = (text + ")");
                    } else {
                        text = (text + ((" " + this.go_.level_) + ")"));
                    }
                }
                else
                {
                    text = (("<b>" + ObjectLibrary.typeToDisplayId[this.go_.objectType_]) + "</b>");
                }
            }
            else
            {
                if (this.go_.name_ == null || this.go_.name_ == "")
                {
                    text = ObjectLibrary.typeToDisplayId[this.go_.objectType_];
                }
                else
                {
                    text = this.go_.name_;
                }
            }
            this._0E_J_(color, text, _forPlayer, _arg2);
        }

        private function _0E_J_(_arg1:uint, _arg2:String, _arg3:Boolean, _arg4:ColorTransform):void
        {
            if (((_arg1 == this._0M_a && _arg2 == this._lB_) && _arg3 == this._K_7) && _arg4 == this._H_g) return;

            this.nameText_.setColor(_arg1);
            if (_arg3) this.nameText_.htmlText = _arg2;
            else this.nameText_.text = _arg2;

            this.nameText_.updateMetrics();
            if (this._H_g != null || _arg4 != null)
            {
                transform.colorTransform = (_arg4 == null ? MoreColorUtil.identity : _arg4);
            }
            this._0M_a = _arg1;
            this._lB_ = _arg2;
            this._K_7 = _arg3;
            this._H_g = _arg4;
        }

    }
}//package com.company.PhoenixRealmClient.ui

