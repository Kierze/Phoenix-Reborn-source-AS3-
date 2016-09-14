// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_d._A_R_

package Frames {
import _00g._0H_i;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Button;
import com.company.PhoenixRealmClient.util._zR_;

import flash.display.Shape;
import flash.events.MouseEvent;

public class buyMoneyFrame extends Frame {

    private static const titleText:String = "Support the game and buy Realm Gold";
    private static const button1Text:String = "";
    private static const cancelButtonText:String = "Cancel";
    private static const gAnalyticsString:String = "/money";
    private static const payMethodString:String = "Payment Method";
    private static const _Y_2:String = "Gold Amount";
    private static const _jA_:String = "Buy Now";
    private static const WIDTH:int = 550;

    public function buyMoneyFrame(_arg1:_0H_i)
    {
        super(titleText, button1Text, cancelButtonText, gAnalyticsString, WIDTH);
        this.mediator = _arg1;
        this._08Z_();
    }
    private var mediator:_0H_i;
    private var _8K_:TextList;
    private var _9c:_4a;
    private var _0B_q:Button;

    private function _08Z_():void {
        this._sO_();
        this._U_u();
        this._1A_();
        Button2.addEventListener(MouseEvent.CLICK, this.onCancel);
    }

    private function _sO_():void {
        if (!this.mediator._02Z_) {
            return;
        }
        this._mN_();
        addHeaderText(payMethodString);
        addTextList(this._8K_);
        offsetH(14);
        this._yQ_(0x7F7F7F, 536, 2, 10);
        offsetH(6);
    }

    private function _mN_():void {
        var _local1:Vector.<String> = this._0M_J_();
        this._8K_ = new TextList(_local1);
        this._8K_.setSelected(Parameters.ClientSaveData.paymentMethod);
    }

    private function _0M_J_():Vector.<String> {
        var _local2:_zR_;
        var _local1:Vector.<String> = new Vector.<String>();
        for each (_local2 in _zR_._X__) {
            _local1.push(_local2.label_);
        }
        return (_local1);
    }

    private function _yQ_(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void {
        var _local5:Shape = new Shape();
        _local5.graphics.beginFill(_arg1);
        _local5.graphics.drawRect(_arg4, 0, (_arg2 - (_arg4 * 2)), _arg3);
        _local5.graphics.endFill();
        addDisplayObject(_local5, 0);
    }

    private function _U_u():void {
        this._9c = new _4a(this.mediator._0J_E_, this.mediator._yI_, this.mediator._Q_W_);
        this._9c._d0(this.mediator._d0);
        addHeaderText(_Y_2);
        addDisplayObject(this._9c);
    }

    private function _1A_():void {
        this._0B_q = new Button(16, _jA_);
        this._0B_q.addEventListener(MouseEvent.CLICK, this._Z_P_);
        this._0B_q.x = 8;
        this._0B_q.y = (h_ - 50);
        addChild(this._0B_q);
    }

    protected function _Z_P_(_arg1:MouseEvent):void {
        setAllButtonsGray();
        if (this._8K_ != null) {
            this.mediator.paymentMethod = this._8K_._rq();
        }
        this.mediator.offer = this._9c._iU_().offer;
        this.mediator._8i();
    }

    protected function onCancel(_arg1:MouseEvent):void {
        stage.focus = null;
        this.mediator.cancel();
    }

}
}//package _0D_d

