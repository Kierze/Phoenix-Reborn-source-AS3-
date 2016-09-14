// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0K_m.CustomParticleEffect

package ParticleAnimations {

import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class OrbitEffect extends ObjectEffect {

        public function OrbitEffect(_arg1:XmlEffectProperties, _arg2:GameObject) {
            this.host = _arg2;
            this._properties = _arg1;
            this.angle_ = this._properties.angleOffset;
            if (this._properties.bitmapFile)
            {
                this.bitmapData = AssetLibrary.getBitmapFromFileIndex(this._properties.bitmapFile, this._properties.bitmapIndex);
                this.bitmapData = TextureRedrawer.redraw(this.bitmapData, this._properties.size, true, 0);
            }
            else
            {
                this.bitmapData = TextureRedrawer.redrawSolidSquare(this._properties.color, this._properties.size);
            }
        }
        private var particle_:OrbitObject;
        private var host:GameObject;
        private var angle_:Number = 0;
        private var time:Number = 0;
        private var _properties:XmlEffectProperties;
        private var bitmapData:BitmapData;

        override public function update(_arg1:int, _arg2:int):Boolean
        {
            var _local3:Number = (_arg1 / 1000);
            var _local4:Number = (_arg2 / 1000);
            if (this.host.map_ == null)
            {
                return (false);
            }
            x_ = this.host.x_;
            y_ = this.host.y_;
            z_ = (this.host.z_ + this._properties.zOffset);
            this.time = (this.time + _local4);

            if (this.particle_ == null) //Initialize the particle
            {
                this.particle_ = new OrbitObject(this.bitmapData);
                this.particle_.lX_ = 0;
                this.particle_.lY_ = 0;
                map_.addObj(this.particle_, x_, y_);
                this.particle_.z_ = this._properties.zOffset;
            }

            this.angle_ += this._properties.speed * _local4;
            this.angle_ = this.angle_ % 360;
            this.particle_.lX_ = this._properties.radius * Math.cos(this.angle_ * Math.PI / 180);
            this.particle_.lY_ = -this._properties.radius * Math.sin(this.angle_ * Math.PI / 180);
            this.particle_.x_ = this.x_ + this.particle_.lX_;
            this.particle_.y_ = this.y_ + this.particle_.lY_;
            this.particle_._0H_B_ = map_.getSquare(this.particle_.x_, this.particle_.y_);
            return (true);
        }

        override public function removeFromMap():void
        {
            if(this.particle_ != null)
            {
                map_.removeObj(this.particle_.objectId_);
            }
            super.removeFromMap();
        }

    }
}//package _0K_m

