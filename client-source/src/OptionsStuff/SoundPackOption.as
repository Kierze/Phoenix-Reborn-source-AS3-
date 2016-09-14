/**
 * Created by Fabian on 14.09.2015.
 */
package OptionsStuff {
import _G_A_.GameContext;

import com.company.PhoenixRealmClient.appengine.AppEngine;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Button;
import com.company.PhoenixRealmClient.ui.PurchaseButton;
import com.company.PhoenixRealmClient.ui.ScrollBar;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.ui.SimpleText;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class SoundPackOption extends DialogOption {

    private const WIDTH:int = 520;
    private const HEIGHT:int = 330;

    private var items:List;
    private var title:SimpleText;

    private var infoHolder:Sprite;
    private var scrollBar:ScrollBar;
    private var selectButton:Button;
    private var purchaseButton:PurchaseButton;

    private var packTitle:SimpleText;
    private var description:SimpleText;
    private var containsSoundsText:SimpleText;
    private var containsMusicText:SimpleText;

    public function SoundPackOption(optionsKey:String) {
        super(optionsKey);
        this.items = new List(300, 299);
        this.items.y = 30;
        addChild(this.items);

        this.infoHolder = new Sprite();
        this.infoHolder.x = 305;
        this.infoHolder.y = 30;
        addChild(this.infoHolder);

        var infoMask:Shape = new Shape();
        infoMask.x = 300;
        infoMask.y = 30;
        infoMask.graphics.beginFill(0, 1.0);
        infoMask.graphics.drawRect(0, 0, 200, 300);
        infoMask.graphics.endFill();
        addChild(infoMask);

        this.infoHolder.mask = infoMask;

        this.scrollBar = new ScrollBar(16, height - 50);
        this.scrollBar.x = width - 20;
        this.scrollBar.y = 40;
        this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
        addChild(this.scrollBar);

        this.title = new SimpleText(21, 0x000000, false, WIDTH);
        this.title.setBold(true);
        this.title.htmlText = "<p align='center'>SELECT SOUNDPACK</p>";
        addChild(this.title);

        this.packTitle = new SimpleText(18, 0xffffff, false, 190);
        this.packTitle.x = 5;
        this.packTitle.y = 5;
        this.packTitle.wordWrap = true;
        this.packTitle.multiline = true;
        this.packTitle.setBold(true);
        this.infoHolder.addChild(this.packTitle);

        this.description = new SimpleText(16, 0xffffff, false, 190);
        this.description.x = 5;
        this.description.wordWrap = true;
        this.description.multiline = true;
        this.infoHolder.addChild(this.description);

        this.containsSoundsText = new SimpleText(16, 0xffffff, false, 190);
        this.containsSoundsText.x = 5;
        this.containsSoundsText.wordWrap = true;
        this.containsSoundsText.multiline = true;
        this.infoHolder.addChild(this.containsSoundsText);

        this.containsMusicText = new SimpleText(16, 0xffffff, false, 190);
        this.containsMusicText.x = 5;
        this.containsMusicText.wordWrap = true;
        this.containsMusicText.multiline = true;
        this.infoHolder.addChild(this.containsMusicText);

        this.selectButton = new Button(21, "Select", 170);
        this.selectButton.x = 15;
        this.selectButton.addEventListener(MouseEvent.CLICK, this.onSelectClick);
        this.infoHolder.addChild(this.selectButton);

        this.purchaseButton = new PurchaseButton("Buy for ", 21, 0, Currency.CREDITS, 170);
        this.purchaseButton.x = 15;
        this.infoHolder.addChild(this.purchaseButton);

        this.items.selectionChanged.add(onSelectionChanged);

        for each (var pack:XML in GameContext.getInjector().getInstance(AppEngine).parameters.SoundPacks.SoundPack) {
            var item:ListItem = new ListItem(pack);
            this.items.add(item);

            if (Parameters.ClientSaveData[optionsKey] == pack.@id) {
                item.select();
            }
        }

        graphics.beginFill(0xffffff, 1.0);
        graphics.drawRect(0,0, WIDTH, 30);
        graphics.endFill();
        graphics.beginFill(0x000000, 1.0);
        graphics.drawRect(0, 30, WIDTH, HEIGHT - 30);
        graphics.endFill();
        graphics.lineStyle(1, 0xffffff);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);

        graphics.lineStyle(2, 0xffffff);
        graphics.moveTo(300, 30);
        graphics.lineTo(300, HEIGHT - 0.5);
    }

    override public function get height():Number {
        return HEIGHT;
    }

    override public function get width():Number {
        return WIDTH;
    }

    override public function value():* {
        return this.items.selectedItem.xml.@id.toString();
    }

    private function onSelectionChanged(data:XML):void {
        this.packTitle.text = data.@displayId;
        this.description.text = data.Description;

        this.containsSoundsText.text = data.hasOwnProperty("Sounds") ? "Contains custom sounds." : "Does not contain custom sounds.";
        this.containsMusicText.text = data.hasOwnProperty("Music") ? "Contains custom music." : "Does not contain custom music.";

        this.containsSoundsText.setColor(data.hasOwnProperty("Sounds") ? 0x00ff00 : 0xff0000);
        this.containsMusicText.setColor(data.hasOwnProperty("Music") ? 0x00ff00 : 0xff0000);

        this.packTitle.updateMetrics();
        this.description.updateMetrics();
        this.containsSoundsText.updateMetrics();
        this.containsMusicText.updateMetrics();

        this.description.y = this.packTitle.y + this.packTitle.textHeight + 20;
        this.containsSoundsText.y = this.description.y + this.description.textHeight + 20;
        this.containsMusicText.y = this.containsSoundsText.y + this.containsSoundsText.textHeight + 20;

        if (this.purchaseButton.visible) {
            this.purchaseButton.setPrice(100, Currency.CREDITS);
            this.purchaseButton.y = this.containsMusicText.y + this.containsMusicText.textHeight + 20;
            this.selectButton.y = this.purchaseButton.y + this.purchaseButton.height + 5;
        }
        else {
            this.selectButton.y = this.containsMusicText.y + this.containsMusicText.textHeight + 20;
        }

        this.scrollBar._fA_(HEIGHT - 30, this.infoHolder.height);
    }

    private function onScroll(event:Event):void {
        var changeVal:Number = this.scrollBar._Q_D_();
        if(isNaN(changeVal)) {
            this.infoHolder.y = 30;
            return;
        }
        this.infoHolder.y = 30 + (-changeVal * (this.infoHolder.height - (HEIGHT - 45)));
    }

    private function onSelectClick(event:MouseEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}


import _sp.Signal;

import com.company.PhoenixRealmClient.ui.ScrollBar;
import com.company.ui.SimpleText;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class List extends Sprite {

    private var w:int;
    private var h:int;
    private var state:Object;
    private var items:Vector.<ListItem>;
    private var m_selectedItem:ListItem;
    private var scrollBar:ScrollBar;
    private var itemHolder:Sprite;

    public var selectionChanged:Signal;

    public function List(width:int, height:int) {
        this.w = width;
        this.h = height;
        this.state = {"nextHeight":5};
        this.items = new Vector.<ListItem>();
        this.selectionChanged = new Signal(XML);
        this.scrollBar = new ScrollBar(16, height - 20);
        this.scrollBar.x = width - 20;
        this.scrollBar.y = 5;
        this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
        addChild(this.scrollBar);

        this.itemHolder = new Sprite();
        addChild(this.itemHolder);

        var mask:Shape = new Shape();
        mask.graphics.beginFill(0x000000, 0.0);
        mask.graphics.drawRect(-0.5, -0.5, this.w + 1, this.h + 1);
        mask.graphics.endFill();
        addChild(mask);
        this.itemHolder.mask = mask;
    }

    public function add(item:ListItem):void {
        this.items.push(item);
        internalAdd(item);
        this.state.nextHeight = (this.items.length * item.HEIGHT) + ((this.items.length + 1) * 5);
    }

    public function get selectedItem():ListItem {
        return m_selectedItem;
    }

    private function internalAdd(item:ListItem):void {
        this.itemHolder.addChild(item);
        item.clicked.add(onClicked);
        item.x = 5;
        item.y = this.state.nextHeight;
        this.scrollBar._fA_(this.h, this.state.nextHeight);
    }

    private function onClicked(selected:ListItem):void {
        if (this.m_selectedItem && (selected != this.m_selectedItem))
            this.m_selectedItem.deselect();
        this.m_selectedItem = selected;
        this.selectionChanged.dispatch(this.m_selectedItem.xml);
    }

    private function onScroll(event:Event):void {
        var changeVal:Number = this.scrollBar._Q_D_();
        if(isNaN(changeVal)) {
            return;
        }
        this.itemHolder.y = -changeVal * (this.itemHolder.height - (this.h - 10));
    }
}

class ListItem extends Sprite {

    public const WIDTH:int = 270;
    public const HEIGHT:int = 50;

    public var clicked:Signal;
    
    private var over:Boolean;
    private var selected:Boolean;
    private var text:SimpleText;

    public var xml:XML;

    public function ListItem(item:XML) {
        this.clicked = new Signal(ListItem);
        this.xml = item;

        this.text = new SimpleText(21, 0xffffff);
        this.text.setBold(true);
        this.text.text = item.@displayId;
        this.text.updateMetrics();
        this.text.x = 10;
        this.text.y = 10;
        addChild(this.text);

        addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
        draw();
    }

    private function draw():void {
        graphics.clear();
        graphics.beginFill(getColor(0), 1.0);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.endFill();
        graphics.lineStyle(1, getColor(1));
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.lineStyle();

        if (this.selected) {
            graphics.lineStyle(1, getColor(1));
            graphics.beginFill(getColor(1));
            graphics.moveTo(WIDTH - 30, 0);
            graphics.lineTo(WIDTH, 30);
            graphics.lineTo(WIDTH, 0);
            graphics.lineTo(WIDTH - 30, 0);
            graphics.endFill();

            graphics.lineStyle(3, 0xffffff);
            graphics.moveTo(WIDTH - 15, 10);
            graphics.lineTo(WIDTH - 10, 15);
            graphics.lineTo(WIDTH - 3, 3);
        }
    }

    public function deselect():void {
        this.selected = false;
        draw();
    }

    public function select():void {
       onClick(null);
    }

    private function onClick(event:MouseEvent):void {
        this.selected = true;
        this.clicked.dispatch(this);
        draw();
    }

    private function onRollOver(event:MouseEvent):void {
        this.over = true;
        draw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.over = false;
        draw();
    }

    private function getColor(dwType:int):uint {
        switch (dwType) {
            case 0:
                return this.over ? 0x8A8A8A :
                       this.selected ? 0x666666 : 0x000000;
            case 1:
                return this.selected || this.over ? 0x00AAFF : 0xFFFFFF;
        }
        return 0;
    }
}
