// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_F_1._kd

package _F_1 {
import _sp.Signal;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;

import mx.core.MovieClipAsset;

public class _kd {

    public function _kd(_arg1:Class) {
        this._oT_ = new (_arg1)();
        this._ready = new Signal(_kd);
        var _local2:Loader = Loader(this._oT_.getChildAt(0));
        var _local3:LoaderInfo = _local2.contentLoaderInfo;
        _local3.addEventListener(Event.COMPLETE, this._set_);
    }
    private var _oT_:MovieClipAsset;

    private var _ready:Signal;

    public function get ready():Signal {
        return (this._ready);
    }

    private var _content:MovieClip;

    public function get content():MovieClip {
        return (this._content);
    }

    public function get _rc():MovieClipAsset {
        return (this._oT_);
    }

    private function _set_(_arg1:Event):void {
        var _local2:LoaderInfo = LoaderInfo(_arg1.target);
        _local2.removeEventListener(Event.COMPLETE, this._set_);
        this._content = MovieClip(_local2.loader.content);
        this._ready.dispatch(this);
    }

}
}//package _F_1

