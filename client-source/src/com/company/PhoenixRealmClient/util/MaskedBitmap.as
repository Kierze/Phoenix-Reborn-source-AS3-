// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util._J_H_

package com.company.PhoenixRealmClient.util {
import com.company.util.BitmapUtil;

import flash.display.BitmapData;

public class MaskedBitmap {

    public function MaskedBitmap(_arg1:BitmapData, _arg2:BitmapData) {
        this.image_ = _arg1;
        this.mask_ = _arg2;
    }
    public var image_:BitmapData;
    public var mask_:BitmapData;

    public function width():int {
        return (this.image_.width);
    }

    public function height():int {
        return (this.image_.height);
    }

    public function mirror(_arg1:int = 0):MaskedBitmap
    {
        var mirrorMain:BitmapData = BitmapUtil.mirror(this.image_, _arg1);
        var mirrorMask:BitmapData = (((this.mask_ == null)) ? null : BitmapUtil.mirror(this.mask_, _arg1));
        return (new MaskedBitmap(mirrorMain, mirrorMask));
    }

    public function _F_9():Number
    {
        return (BitmapUtil._F_9(this.image_));
    }

}
}//package com.company.PhoenixRealmClient.util

