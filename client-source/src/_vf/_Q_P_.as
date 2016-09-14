// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_vf._Q_P_

package _vf {
import com.company.PhoenixRealmClient.parameters.Parameters;

import flash.media.SoundTransform;

public class _Q_P_ {

    public static function load():void {
        var _4w:SoundTransform = new SoundTransform(((Parameters.ClientSaveData.playSFX) ? 1 : 0));
    }

    public static function _2c(_arg1:Boolean):void {
        //GA.global().trackEvent("sound", ((_arg1) ? "soundOn" : "soundOff"));
        Parameters.ClientSaveData.playSFX = _arg1;
        Parameters.save();
        SFXHandler._02r();
    }

}
}//package _vf

