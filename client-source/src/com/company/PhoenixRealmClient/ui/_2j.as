// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._2j

package com.company.PhoenixRealmClient.ui
{
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;
import com.company.util.MoreColorUtil;
import com.company.util._O_m;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

public class _2j extends Slot
    {

        private static const _1U_:Matrix = function ():Matrix
        {
            var _local1:* = new Matrix();
            _local1.translate(10, 5);
            return (_local1);
        }();

        public function _2j(item:int, tradeable:Boolean, included:Boolean, _arg4:int, _arg5:int, _arg6:Array, _arg7:uint, data:Object)
        {
            var bitmap:BitmapData;
            var xml:XML;
            var pt:Point;
            var txt:SimpleText;
            this._W_p = new GraphicsSolidFill(16711310, 1);
            this._0y = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this._W_p);
            this._01a = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[this._0y, this._01a, GraphicHelper._H_B_];
            super(_arg4, _arg5, _arg6);
            this.id = _arg7;
            this.item_ = item;
            this.tradeable_ = tradeable;
            this.included_ = included;
            this.data_ = data;
            if (this.item_ != -1)
            {
                _O_m._03d(this, _0H_K_);
                bitmap = ObjectLibrary.getRedrawnTextureFromType(this.item_, 80, true);
                if(this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "")
                {
                    bitmap = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.item_, 80, true, this.data_);
                }
                xml = ObjectLibrary.typeToXml[this.item_];
                if (xml.hasOwnProperty("Doses"))
                {
                    bitmap = bitmap.clone();
                    txt = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
                    txt.text = String(xml.Doses);
                    txt.updateMetrics();
                    bitmap.draw(txt, _1U_);
                }
                pt = equipmentDrawOffset(this.item_, type_, false);
                this._0L_K_ = new Bitmap(bitmap);
                this._0L_K_.x = ((WIDTH / 2) - (this._0L_K_.width / 2)) + pt.x;
                this._0L_K_.y = ((HEIGHT / 2) - (this._0L_K_.height / 2)) + pt.y;
                _O_m._041(this, this._0L_K_);
            }
            if (!this.tradeable_)
            {
                transform.colorTransform = MoreColorUtil._0t;
            }
            this._k5 = this._U_e();
            addChild(this._k5);
            this.setIncluded(included);
        }
        public var id:uint;
        public var item_:int;
        public var data_:Object;
        public var tradeable_:Boolean;
        public var included_:Boolean;
        public var _0L_K_:Bitmap;
        public var _k5:Shape;
        private var _W_p:GraphicsSolidFill;
        private var _0y:GraphicsStroke;
        private var _01a:GraphicsPath;
        private var graphicsData_:Vector.<IGraphicsData>;

        public function setIncluded(_arg1:Boolean):void
        {
            this.included_ = _arg1;
            this._k5.visible = this.included_;
            if (this.included_)
            {
                _04c.color = 0xFFCD57;
            }
            else
            {
                _04c.color = Parameters._primaryColourLight;
            }
            _rC_();
        }

        private function _U_e():Shape
        {
            var _local1:Shape = new Shape();
            GraphicHelper._0L_6(this._01a);
            GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, _07i, this._01a);
            _local1.graphics.drawGraphicsData(this.graphicsData_);
            return (_local1);
        }

    }
}

