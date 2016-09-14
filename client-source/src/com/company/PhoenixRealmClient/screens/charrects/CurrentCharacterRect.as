// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.screens.charrects.CurrentCharacterRect

package com.company.PhoenixRealmClient.screens.charrects {
import Tooltips.CharacterRectTooltip;
import Tooltips.TooltipBase;

import _0I_S_._09s;

import _S_K_._u3;

import _sp.Signal;

import com.company.PhoenixRealmClient.appengine.ClassStat;
import com.company.PhoenixRealmClient.appengine.SavedCharacter;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.ClassQuest;
import com.company.PhoenixRealmClient.util._lJ_;
import com.company.graphic.DeleteXGraphic;
import com.company.graphic.StarGraphic;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class CurrentCharacterRect extends CharacterRect {

    private static var toolTip_:TooltipBase = null;

    public function CurrentCharacterRect(_arg1:String, _arg2:SavedCharacter, _arg3:ClassStat) {
        super(Parameters._primaryColourLight, Parameters._primaryColourLight2);
        this._name = _arg1;
        this.character = _arg2;
        this.characterStats = _arg3;
        this.playerXML = ObjectLibrary.typeToXml[this.character.objectType()];
        this.makeSelectContainer();
        this.makeBitmap();
        this.makeClassNameText();
        this.makeTagline();
        this.makeDeleteButton();
        this.selected = new _u3(this.selectContainer, MouseEvent.CLICK).mapTo(this.character);
        this.deleteCharacter = new _u3(this.deleteButton, MouseEvent.CLICK).mapTo(this.character);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var _name:String;
    public var character:SavedCharacter;
    public var characterStats:ClassStat;
    public var playerXML:XML;
    public var selected:Signal;
    public var deleteCharacter:Signal;
    private var selectContainer:DisplayObjectContainer;
    private var bitmap:Bitmap;
    private var classNameText:SimpleText;
    private var taglineIcon:Sprite;
    private var taglineText:SimpleText;
    private var deleteButton:Sprite;

    private function makeSelectContainer():void {
        this.selectContainer = new Sprite();
        Sprite(this.selectContainer).graphics.beginFill(0xFF00FF, 0);
        Sprite(this.selectContainer).graphics.drawRect(0, 0, (WIDTH - 30), HEIGHT);
        addChild(this.selectContainer);
    }

    private function makeBitmap():void {
        this.bitmap = new Bitmap();
        this.selectContainer.addChild(this.bitmap);
        this.setImage(_lJ_.RIGHT, _lJ_._sS_, 0);
    }

    private function makeClassNameText():void
    {
        var matched:Boolean = false;
        this.classNameText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.classNameText.setBold(true);
        if (character.spec() != null && character.spec() != "")
        {
            for each (var spec:XML in playerXML.Specialization)
            {
                if (spec.@id == character.spec())
                {
                    this.classNameText.text = ((spec.@name + " ") + this.character.level());
                    matched = true;
                    break;
                }
            }
        }

        if (!matched) this.classNameText.text = ((this.playerXML.@id + " ") + this.character.level());

        this.classNameText.updateMetrics();
        this.classNameText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.classNameText.x = 58;
        this.selectContainer.addChild(this.classNameText);
    }

    private function makeTagline():void {
        var _local1:int = this.getNextStarFame();
        if (_local1 > 0) {
            this.makeTaglineIcon();
            this.makeTaglineText(_local1);
        }
    }

    private function getNextStarFame():int {
        return (ClassQuest.getNextFameGoal(((this.characterStats == null) ? 0 : this.characterStats.bestFame()), this.character.fame()));
    }

    private function makeTaglineIcon():void {
        this.taglineIcon = new StarGraphic();
        this.taglineIcon.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
        this.taglineIcon.scaleX = 1.2;
        this.taglineIcon.scaleY = 1.2;
        this.taglineIcon.x = 58;
        this.taglineIcon.y = 26;
        this.taglineIcon.filters = [new DropShadowFilter(0, 0, 0)];
        this.selectContainer.addChild(this.taglineIcon);
    }

    private function makeTaglineText(_arg1:int):void {
        this.taglineText = new SimpleText(14, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.taglineText.text = (((("Class Quest: " + this.character.fame()) + " of ") + _arg1) + " Fame");
        this.taglineText.updateMetrics();
        this.taglineText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.taglineText.x = ((58 + this.taglineIcon.width) + 2);
        this.taglineText.y = 24;
        this.selectContainer.addChild(this.taglineText);
    }

    private function makeDeleteButton():void {
        this.deleteButton = new DeleteXGraphic();
        this.deleteButton.addEventListener(MouseEvent.MOUSE_DOWN, this.onDeleteDown);
        this.deleteButton.x = 383;
        this.deleteButton.y = ((HEIGHT / 2) - (this.deleteButton.height / 2));
        addChild(this.deleteButton);
    }

    private function removeToolTip():void {
        if (toolTip_ != null) {
            if (((!((toolTip_.parent == null))) && (toolTip_.parent.contains(toolTip_)))) {
                toolTip_.parent.removeChild(toolTip_);
            }
            toolTip_ = null;
        }
    }

    private function setImage(_arg1:int, _arg2:int, _arg3:Number):void {
        var _local4:BitmapData = SavedCharacter.getImage(this.character, this.playerXML, _arg1, _arg2, _arg3, true, true);
        _local4 = BitmapUtil.getRectanglefromBitmap(_local4, 6, 6, (_local4.width - 12), (_local4.height - 6));
        this.bitmap.bitmapData = _local4;
        this.bitmap.x = 0;
    }

    override protected function onMouseOver(_arg1:MouseEvent):void {
        super.onMouseOver(_arg1);
        this.removeToolTip();
        toolTip_ = new CharacterRectTooltip(this._name, this.character._iJ_, this.characterStats);
        stage.addChild(toolTip_);
    }

    override protected function onRollOut(_arg1:MouseEvent):void {
        super.onRollOut(_arg1);
        this.removeToolTip();
    }

    private function onRemovedFromStage(_arg1:Event):void {
        this.removeToolTip();
    }

    private function onDeleteDown(_arg1:MouseEvent):void {
        _arg1.stopImmediatePropagation();
        dispatchEvent(new _09s(this.character));
    }

}
}//package com.company.PhoenixRealmClient.screens.charrects

