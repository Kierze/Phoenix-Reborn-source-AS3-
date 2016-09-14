package _F_1 {
import flash.utils.*;

import mx.core.*;

[Embed(source="_dy.swf", symbol="_F_1._dy")]
public class _dy extends MovieClipLoaderAsset {
    {
        _03m = null;
    }
    private static var _03m:ByteArray = null;

    public function _dy() {
        this._2M_ = _S_G_;
        super();
        initialWidth = 20480 / 20;
        initialHeight = 15360 / 20;
    }
    public var _2M_:Class;

    public override function get movieClipData():ByteArray {
        if (_03m == null) {
            _03m = ByteArray(new this._2M_());
        }
        return _03m;
    }
}
}
