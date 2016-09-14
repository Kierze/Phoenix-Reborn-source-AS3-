/**
 * Created by Roxy on 10/24/2015.
 */
package Frames
{
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class ObjectTooltipHeader extends Sprite {

        public function ObjectTooltipHeader(_arg1:uint, _arg2:Boolean, _arg3:BitmapData, _arg4:String) {
            this._boldText = _arg2;
            this._color = _arg1;
            this._bitmapData = _arg3;
            this._text = _arg4;

            this._image = new Bitmap();
            this._image.x = -4;
            this._image.y = -4;
            addChild(this._image);

            if (this._boldText) {
                this.nameText_ = new SimpleText(13, _arg1, false, 0, 0, "Myriad Pro");
            } else {
                this.nameText_ = new SimpleText(13, _arg1, false, 66, 20, "Myriad Pro");
                this.nameText_.setBold(true);
            }
            this.nameText_.x = 32;
            this.nameText_.y = 6;
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.nameText_);

            this._draw();
        }
        public var _boldText:Boolean;
        private var _text:String;
        private var _bitmapData:BitmapData;
        private var _image:Bitmap;
        private var nameText_:SimpleText;
        private var _color:uint;

        private var _BaseColor:uint = 0xFFFFFF;
        private var _BaseString:String = null;
        private var _BaseHtmlBool:Boolean = false;
        private var _BaseTransform:ColorTransform = null;

        public function _draw(_arg2:ColorTransform = null):void
        {
            this._image.bitmapData = this._bitmapData;
            var _htmlText:String;
            if (this._boldText)
            {
                _htmlText = "<b>" + this._text + "</b>";
            }
            else
            {
                _htmlText = this._text;
            }
            this._textData(this._color, _htmlText, this._boldText, _arg2);
        }

        private function _textData(_color:uint, _text:String, _useHtml:Boolean, _colorTransform:ColorTransform):void {
            if ((((_color == this._BaseColor) && (_text == this._BaseString)) && (_useHtml == this._BaseHtmlBool)) && (_colorTransform == this._BaseTransform)) {
                return;
            }
            this.nameText_.setColor(_color);

            if (_useHtml)
            {
                this.nameText_.htmlText = _text;
            }
            else
            {
                this.nameText_.text = _text;
            }

            this.nameText_.updateMetrics();

            if (_colorTransform != null) {
                transform.colorTransform = (_colorTransform);
            }
            this._BaseColor = _color;
            this._BaseString = _text;
            this._BaseHtmlBool = _useHtml;
            this._BaseTransform = _colorTransform;
        }

    }
}
