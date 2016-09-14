// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_00g._02U_

package _00g {
import _qN_._px;

import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util._zR_;

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class _02U_ extends _px {

    override public function execute():void {
        var _local1:_zR_;
        Parameters.ClientSaveData.paymentMethod = _local1;
        Parameters.save();
        _local1 = _zR_._8N_(paymentMethod);
        var _local2:String = _local1._T_R_(_0J_E_.tok, _0J_E_.exp, offer);
        navigateToURL(new URLRequest(_local2), "_blank");
        if (mediator) {
            mediator.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

}
}//package _00g

