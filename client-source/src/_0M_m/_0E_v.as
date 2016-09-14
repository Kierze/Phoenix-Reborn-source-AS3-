// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0M_m._0E_v

package _0M_m {
import _00g.WebAccount;

import _qN_.Account;

import _sp.Signal;

import _zo._8C_;

import com.company.PhoenixRealmClient.appengine._02k;
import com.company.PhoenixRealmClient.util.offer.Offer;
import com.company.PhoenixRealmClient.util.offer.Offers;

public class _0E_v implements _j5 {

    private static const _Q_3:int = 2600;

    private var _0J_E_:Offers;
    private var _U_k:Signal;
    private var _Z_r:Offer;

    public function get _Z_8():Signal {
        return ((this._U_k = ((this._U_k) || (new Signal()))));
    }

    public function _002():void {
        _02k._U_t(this._E_A_(), this._y6);
    }

    public function _U_t():Offers {
        return (this._0J_E_);
    }

    private function _E_A_():String {
        switch (Account._get().gameNetwork()) {
            case WebAccount._000:
            default:
                return ("/credits");
        }
    }

    private function _y6(_arg1:_8C_):void {
        this._0J_E_ = new Offers(XML(_arg1.data_));
        this._Z_8.dispatch();
    }

}
}//package _0M_m

