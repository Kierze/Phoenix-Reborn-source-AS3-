// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_015._O_P_

package _015 {
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;

public class StatusText extends Sprite implements _0J_p {

    public const _07O_:int = 40;

    public function StatusText(object:GameObject, text:String, color:uint, lifeTime:int, startTimeOffset:int = 0) {
        this.gameObject = object;
        this.position = new Point(0, (((-(object.texture_.height) * (object.size_ / 100)) * 5) - 20));
        this.color_ = color;
        this.lifetime_ = lifeTime;
        this.startTimeOffset = startTimeOffset;
        var _local6:SimpleText = new SimpleText(24, color, false, 0, 0, "Myriad Pro");
        _local6.setBold(true);
        _local6.text = text;
        _local6.updateMetrics();
        _local6.filters = [new GlowFilter(0, 1, 4, 4, 2, 1)];
        _local6.x = (-(_local6.width) / 2);
        _local6.y = (-(_local6.height) / 2);
        addChild(_local6);
        visible = false;
    }
    public var gameObject:GameObject;
    public var position:Point;
    public var color_:uint;
    public var lifetime_:int;
    public var startTimeOffset:int;
    private var startTime_:int = 0;

    public function draw(_arg1:View, _arg2:int):Boolean {
        var _local3:int;
        if (this.startTime_ == 0) {
            this.startTime_ = (_arg2 + this.startTimeOffset);
        }
        if (_arg2 < this.startTime_) {
            visible = false;
            return (true);
        }
        _local3 = (_arg2 - this.startTime_);
        if ((((_local3 > this.lifetime_)) || (((!((this.gameObject == null))) && ((this.gameObject.map_ == null)))))) {
            return (false);
        }
        if ((((this.gameObject == null)) || (!(this.gameObject._1D_)))) {
            visible = false;
            return (true);
        }
        visible = true;
        x = ((((this.gameObject) != null) ? this.gameObject._bY_[0] : 0) + (((this.position) != null) ? this.position.x : 0));
        var _local4:Number = ((_local3 / this.lifetime_) * this._07O_);
        y = (((((this.gameObject) != null) ? this.gameObject._bY_[1] : 0) + (((this.position) != null) ? this.position.y : 0)) - _local4);
        return (true);
    }

}
}//package _015

