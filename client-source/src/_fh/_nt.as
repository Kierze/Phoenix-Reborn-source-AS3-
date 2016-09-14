// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_fh._nt

package _fh {
import Tooltips.QuestPortrait;
import Tooltips.QuestTooltip;
import Tooltips.TooltipBase;

import com.company.PhoenixRealmClient.map.Quest;
import com.company.PhoenixRealmClient.map.View;
import com.company.PhoenixRealmClient.map._X_l;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.events.MouseEvent;
import flash.utils.getTimer;

public class _nt extends _rB_ {

    public function _nt(_arg1:_X_l) {
        super(16352321, 12919330, true);
        this.map_ = _arg1;
    }
    public var map_:_X_l;

    override public function draw(_arg1:int, _arg2:View):void {
        var _local4:Boolean;
        var _local5:Boolean;
        var _local3:GameObject = this.map_.quest_.getObject(_arg1);
        if (_local3 != go_) {
            _bz(_local3);
            _V_B_(this.getToolTip(_local3, _arg1));
        } else {
            if (go_ != null) {
                _local4 = (_fO_ is QuestTooltip);
                _local5 = this._01(_arg1);
                if (_local4 != _local5) {
                    _V_B_(this.getToolTip(_local3, _arg1));
                }
            }
        }
        super.draw(_arg1, _arg2);
    }

    public function refreshToolTip():void {
        _V_B_(this.getToolTip(go_, getTimer()));
    }

    private function getToolTip(_arg1:GameObject, _arg2:int):TooltipBase {
        if ((((_arg1 == null)) || ((_arg1.texture_ == null)))) {
            return (null);
        }
        if (this._01(_arg2)) {
            return (new QuestTooltip(go_));
        }
        if (Parameters.ClientSaveData.showQuestPortraits) {
            return (new QuestPortrait(_arg1));
        }
        return (null);
    }

    private function _01(_arg1:int):Boolean {
        var _local2:Quest = this.map_.quest_;
        return (((_68) || (_local2.isNew(_arg1))));
    }

    override protected function onMouseOver(_arg1:MouseEvent):void {
        super.onMouseOver(_arg1);
        this.refreshToolTip();
    }

    override protected function onMouseOut(_arg1:MouseEvent):void {
        super.onMouseOut(_arg1);
        this.refreshToolTip();
    }

}
}//package _fh

