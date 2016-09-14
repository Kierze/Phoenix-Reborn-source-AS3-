/**
 * Created by Thelzar on 7/1/2014.
 */

package _0L_C_ {
import flash.events.Event;

public class _gE_ extends TwoButtonDialog {

        public function _gE_() {
            super("You do not have enough Silver for this item.  " + "You gain Silver when you kill enemies " + "in the Realm.", "Not Enough Silver", "Ok", null, "/notEnoughSilver");
            addEventListener(BUTTON1_EVENT, this._G1_);
        }

        public function _G1_(_arg1:Event):void {
            parent.removeChild(this);
        }
    }
}
