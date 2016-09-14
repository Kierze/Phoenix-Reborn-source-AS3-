/**
 * Created by vooolox on 07-2-2016.
 */
package Frames {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.TextButton;
import com.company.PhoenixRealmClient.util.xButtonSquare;
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

public class Frame2 extends Sprite
{

    public function Frame2(_arg1:String, button1Text:String, _arg5:int = 288) {
        this.frameTextInputBoxes = new Vector.<TextInput>();
        this.frameTextButtons_ = new Vector.<TextButton>();
        this.primaryColorLight = new GraphicsSolidFill(Parameters._primaryColourLight, 1);
        this.primaryColorDark = new GraphicsSolidFill(Parameters._primaryColourDark, 1);
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this._graphicsStroke = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.path1_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.path2_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[primaryColorDark, path2_, GraphicHelper.END_FILL, primaryColorLight, path1_, GraphicHelper.END_FILL, _graphicsStroke, path2_, GraphicHelper._H_B_];
        super();
        this.w_ = _arg5;
        this.frameTitle = new SimpleText(12, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.frameTitle.text = _arg1;
        this.frameTitle.updateMetrics();
        this.frameTitle.filters = [new DropShadowFilter(0, 0, 0)];
        this.frameTitle.x = 5;
        this.frameTitle.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(this.frameTitle);
        this.Button1 = new TextButton(18, true, button1Text);
        if (button1Text != "") {
            this.Button1.buttonMode = true;
            this.Button1.x = (this.w_ / 2) - (Button1.width / 2);
            addChild(this.Button1);
        }
        this.XButton = new xButtonSquare();
        this.XButton.x = ((this.w_ - this.XButton.width) - 15);
        addChild(this.XButton);
        filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var frameTitle:SimpleText;
    public var Button1:TextButton;
    public var XButton:xButtonSquare;
    public var frameTextInputBoxes:Vector.<TextInput>;
    public var frameTextButtons_:Vector.<TextButton>;
    protected var w_:int = 288;
    protected var h_:int = 100;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var primaryColorLight:GraphicsSolidFill;
    private var primaryColorDark:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var _graphicsStroke:GraphicsStroke;
    private var path1_:GraphicsPath;
    private var path2_:GraphicsPath;

    public function addTextInputBox(_arg1:TextInput):void {
        this.frameTextInputBoxes.push(_arg1);
        addChild(_arg1);
        _arg1.y = (this.h_ - 60);
        _arg1.x = 17;
        this.h_ = (this.h_ + TextInput.HEIGHT);
    }

    public function addTextButton(_arg1:TextButton):void
    {
        this.frameTextButtons_.push(_arg1);
        addChild(_arg1);
        _arg1.y = (this.h_ - 66);
        _arg1.x = 17;
        this.h_ = (this.h_ + 20);
    }

    public function addDisplayObject(_arg1:DisplayObject, _arg2:int = 8):void
    {
        addChild(_arg1);
        _arg1.y = (this.h_ - 66);
        _arg1.x = _arg2;
        this.h_ = (this.h_ + _arg1.height);
    }

    public function addLabel(_arg1:String):void
    {
        var _local2:SimpleText;
        _local2 = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        _local2.text = _arg1;
        _local2.updateMetrics();
        _local2.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(_local2);
        _local2.y = (this.h_ - 66);
        _local2.x = 17;
        this.h_ = (this.h_ + 20);
    }

    public function addHeaderText(_arg1:String):void {
        var _local2:SimpleText = new SimpleText(20, 0xB2B2B2, false, 0, 0, "Myriad Pro");
        _local2.text = _arg1;
        _local2.setBold(true);
        _local2.updateMetrics();
        _local2.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        addChild(_local2);
        _local2.y = (this.h_ - 60);
        _local2.x = 15;
        this.h_ = (this.h_ + 40);
    }

    public function addCheckBox(_arg1:CheckBox):void {
        addChild(_arg1);
        _arg1.y = (this.h_ - 66);
        _arg1.x = 17;
        this.h_ = (this.h_ + 44);
    }

    public function addTextList(_arg1:TextList):void {
        addChild(_arg1);
        _arg1.y = (this.h_ - 66);
        _arg1.x = 18;
        _arg1.buttonMode = true;
        this.h_ = (this.h_ + _arg1.height);
    }

    public function offsetH(_arg1:int):void
    {
        this.h_ = (this.h_ + _arg1);
    }

    public function setAllButtonsGray():void {
        var _local1:TextButton;
        mouseEnabled = false;
        mouseChildren = false;
        for each (_local1 in this.frameTextButtons_)
        {
            _local1.SetTextColor(0xB3B3B3);
        }
        this.Button1.SetTextColor(0xB3B3B3);
    }

    public function setAllButtonsWhite():void {
        var _local1:TextInput;
        var _local2:TextButton;
        var _local5:TextButton;
        mouseEnabled = true;
        mouseChildren = true;
        for each (_local1 in this.frameTextInputBoxes) {
        }
        for each (_local5 in this.frameTextButtons_) {
            _local2 = _local5;
            _local2.SetTextColor(0xFFFFFF);
        }
        this.Button1.SetTextColor(0xFFFFFF);
    }

    public function draw():void {
        this.graphics.clear();
        GraphicHelper._0L_6(this.path1_);
        GraphicHelper.drawUI(-6, -6, this.w_, (20 + 12), 4, [1, 1, 0, 0], this.path1_);
        GraphicHelper._0L_6(this.path2_);
        GraphicHelper.drawUI(-6, -6, this.w_, this.h_, 4, [1, 1, 1, 1], this.path2_);
        (this.Button1.y = (this.h_ - 48));
        this.graphics.drawGraphicsData(this.graphicsData_);
    }

    public function onAddedToStage(_arg1:Event):void {
        this.draw();
        stage;
        (x = ((1024 / 2) - ((this.w_ - 6) / 2)));
        stage;
        (y = ((768 / 2) - (height / 2)));
        if (this.frameTextInputBoxes.length > 0) {
            (stage.focus = this.frameTextInputBoxes[0].inputText_);
        }
    }

    private function onRemovedFromStage(_arg1:Event):void {
    }

}
}

