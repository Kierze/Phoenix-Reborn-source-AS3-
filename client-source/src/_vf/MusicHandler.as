// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_vf.MusicHandler

package _vf {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.greensock.TweenMax;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;

public class MusicHandler {

    private var currentSoundChannel:SoundChannel = null;
    private var currentSound:Sound;
    private var currentTween:TweenMax;
    private var previous:MusicHandler;

    private static var loadedMusic:Dictionary;
    private static var domain:String;
    private static var currentMusic:MusicHandler;

    public static var currentName:String;

    function MusicHandler(name:String) {
        if (currentName == name) return;
        currentName = name;
        var currentSoundPath:String = Parameters.ClientSaveData.currentSoundPack + "/" + name + ".mp3";

        if (loadedMusic[currentSoundPath] == null || (loadedMusic[currentSoundPath] != null && loadedMusic[currentSoundPath].bytesLoaded <= 0 && loadedMusic[currentSoundPath].url == null)) {
            currentSound = new Sound();
            currentSound.load(new URLRequest(domain + currentSoundPath));
            if (name != "MainTheme")
                loadedMusic[currentSoundPath] = currentSound;
        }
        else {
            currentSound = loadedMusic[currentSoundPath];
        }

        if (currentMusic != null) {
            if(currentMusic.currentSound.url == currentSound.url) return;
            previous = currentMusic;
            previous.abort();
            if (previous.currentSoundChannel != null)
                currentTween = TweenMax.to(previous.currentSoundChannel, 1.3, {volume:Parameters.ClientSaveData.playMusic ? 0.05 : 0, onComplete:load});
            else
                load();
        }
        else {
            load();
        }
        currentMusic = this;
    }

    public static function reload(url:String):void {
        if (domain == null) {
            domain = "http://" + Parameters._fK_() + "/music/";
            loadedMusic = new Dictionary();
        }
        new MusicHandler(url);
    }

    private function load():void {
        if (previous != null) {
            previous.stopAll();
        }
        try {
            currentSoundChannel = currentSound.play(0, int.MAX_VALUE, new SoundTransform(((Parameters.ClientSaveData.playMusic) ? 0.05 : 0)));
            currentTween = TweenMax.to(currentSoundChannel, 1.3, {
                volume: Parameters.ClientSaveData.playMusic ? 0.65 : 0,
                "onComplete": done
            });
        } catch(e:Error) { trace(e); }
    }

    private function stopAll():void {
        if(currentSoundChannel != null)
            currentSoundChannel.stop();
        if(previous != null)
            previous.stopAll();
    }

    private function abort():void {
        if (currentTween != null)
            currentTween.kill();
    }

    private function done():void {
        currentTween = null;
    }

    public static function _continue(_arg1:Boolean):void {
        Parameters.ClientSaveData.playMusic = _arg1;
        Parameters.save();
        if (currentMusic && currentMusic.currentSoundChannel) {
            currentMusic.currentSoundChannel.soundTransform = new SoundTransform(((Parameters.ClientSaveData.playMusic) ? 0.65 : 0));
        }
    }
}
}//package _vf

