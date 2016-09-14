// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0I_S_._09s

package _0I_S_ {
import com.company.PhoenixRealmClient.appengine.SavedCharacter;

import flash.events.Event;

public class _09s extends Event {

    public static const DELETE_CHARACTER_EVENT:String = "DELETE_CHARACTER_EVENT";

    public function _09s(_arg1:SavedCharacter) {
        super(DELETE_CHARACTER_EVENT);
        this.savedChar_ = _arg1;
    }
    public var savedChar_:SavedCharacter;
}
}//package _0I_S_

