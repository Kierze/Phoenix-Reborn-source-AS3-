// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0C_P_._0I_j

package OptionsStuff {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.util.MoreColorUtil;

import flash.events.Event;

public class _0I_j extends _0_i {

    public function _0I_j(_arg1:String, _arg2:Vector.<String>, _arg3:Array, _arg4:String, _arg5:String, _arg6:Function, _arg7:Boolean = false) {
        super(_arg1, _arg4, _arg5);
        this.callback_ = _arg6;
        this._O_T_ = new _pw(_arg2, _arg3, Parameters.ClientSaveData[_W_Y_]);
        this._O_T_.addEventListener(Event.CHANGE, this._bR_);
        addChild(this._O_T_);
        this._J_r(_arg7);
    }
    private var callback_:Function;
    private var _O_T_:_pw;
    private var _0F_N_:Boolean;

    override public function refresh():void {
        this._O_T_.setValue(Parameters.ClientSaveData[_W_Y_]);
    }

    public function _J_r(_arg1:Boolean):void {
        this._0F_N_ = _arg1;
        transform.colorTransform = ((this._0F_N_) ? MoreColorUtil._3f : MoreColorUtil.identity);
        mouseEnabled = !(this._0F_N_);
        mouseChildren = !(this._0F_N_);
    }

    private function _bR_(_arg1:Event):void {
        Parameters.ClientSaveData[_W_Y_] = this._O_T_.value();
        Parameters.save();
        if (this.callback_ != null) {
            this.callback_();
        }
    }

}
}//package _0C_P_

