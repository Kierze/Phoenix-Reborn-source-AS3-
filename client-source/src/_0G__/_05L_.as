// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0G__._05L_

package _0G__ {
import Packets.fromServer.DeathPacket;

import _W_D_._0I_H_;
import _W_D_._G_J_;

import com.company.PhoenixRealmClient.parameters.Parameters;

public class _05L_ {

    [Inject]
    public var _0K_K_:DeathPacket;
    [Inject]
    public var _R_g:_0I_H_;
    [Inject]
    public var _0I_s:_G_J_;

    public function execute():void {
        this._0I_s._sr = true;
        this._0I_s.info = this._0K_K_;
        this._0I_s._Z__ = this._R_g._T_1.accountId_;
        this._0I_s._J_u = this._0K_K_.charId_;
        Parameters.ClientSaveData.needsRandomRealm = false;
        Parameters.save();
    }

}
}//package _0G__

