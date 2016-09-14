// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_F_1.CurrentCharacterScreen

package _F_1 {
import Frames.AccNameChooseRect;

import _02t._R_f;

import _0L_C_.TwoButtonDialog;
import _0L_C_.chooseNameNeedRegisterDialog;

import _S_K_._u3;

import _nA_._ax;

import _qN_.Account;

import _sp.Signal;

import com.company.PhoenixRealmClient.appengine._0K_R_;
import com.company.PhoenixRealmClient.ui.ScrollBar;
import com.company.PhoenixRealmClient.ui.TextButton;
import com.company.PhoenixRealmClient.ui._0B_v;
import com.company.PhoenixRealmClient.ui._1B_v;
import com.company.ui.SimpleText;

import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;

public class CurrentCharacterScreen extends _05p {

        public function CurrentCharacterScreen() {
            addChild(new _R_f());
            if (Account._get().isRegistered()) {
                this._qR_ = new titleTextButton("Play", 36, true);
                this.classesButton = new titleTextButton("Classes", 22, false);
            } else {
                this._qR_ = new titleTextButton("", 0, true);
                this.classesButton = new titleTextButton("", 0, false);
            }
            this._p6 = new titleTextButton("Main", 22, false);
            super(CurrentCharacterScreen);
            this._n7 = new Signal();
            this.newCharacter = new Signal();
            this.close = new _u3(this._p6, MouseEvent.CLICK);
            this._1V_ = new _u3(this.classesButton, MouseEvent.CLICK);
            this.chooseName = new Signal();
            this._D_u = new Signal();
        }
        public var close:Signal;
        public var _n7:Signal;
        public var newCharacter:Signal;
        public var _1V_:Signal;
        public var chooseName:Signal;
        public var _D_u:Signal;
        public var _lR_:_ax;
        private var model:_0K_R_;
        private var nameText_:SimpleText;
        private var _ChooseName:TextButton;
        private var _GoldFame:_0B_v;
        private var _Silver:_1B_v;
        private var _graveyardText:TextButton; //:SimpleText;
        private var _charactersText:TextButton; //:SimpleText;
        private var _NewsText:SimpleText;
        private var _X_0:CharsAndNews;
        private var _X_1:CharsAndNews;
        private var _77:Number;
        private var _qR_:titleTextButton;
        private var _p6:titleTextButton;
        private var classesButton:titleTextButton;
        private var _boundaries:Shape;
        private var _scrollBar:ScrollBar;
        private var curState:int = 1;

        public function _u_():void {
            this._lR_ = new _ax();
            this._lR_.x = 39;
            this._lR_.y = 33;
            addChild(this._lR_);
        }

        override public function initialize(_arg1:_0K_R_):void {
            super.initialize(_arg1);
            this.model = _arg1;
            this.buildUI(_arg1);
        }

        private function buildUI(_arg1:_0K_R_):void{
            this.buildName();
            this.buildCurrencies();
            this.buildNewsText();
            this.buildNewsSection();
            this.buildBoundaries();
            this.buildCharacterText();
            var _local2:News = new News(_arg1, 2);
            if (_local2.isDeath()){
                this.buildGraveText();
            }
            this.buildCharacters();
            this.buildNavBar();
            if (!_arg1._hv) {
                this.buildChooseName();
            }
        }

        internal function _str7249():Rectangle{
            var _local1:Rectangle = new Rectangle();
            if (stage){
                _local1 = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            }
            return (_local1);
        }

        private function buildNavBar():void{
            this._qR_.addEventListener(MouseEvent.CLICK, this._04P_);
            this._qR_.x = ((1024 / 2) - (this._qR_.width / 2));
            this._qR_.y = 710;
            addChild(this._qR_);
            this._p6.x = (((1024 / 2) - (this._p6.width / 2)) - 94);
            this._p6.y = 720;
            addChild(this._p6);
            this.classesButton.x = (((1024 / 2) - (this.classesButton.width / 2)) + 96);
            this.classesButton.y = 720;
            addChild(this.classesButton);
        }
        private function buildName():void{
            this.nameText_ = new SimpleText(22, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.nameText_.setBold(true);
            this.nameText_.text = this.model.name_;
            this.nameText_.updateMetrics();
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.nameText_.y = 24;
            this.nameText_.x = ((this._str7249().width / 2) - (this.nameText_.width / 2));
            addChild(this.nameText_);
        }
        private function buildChooseName():void{
            this._ChooseName = new TextButton(16, false, "");
            this._ChooseName.text_.setBold(true);
            this._ChooseName.text_.text = "choose name";
            this._ChooseName.text_.updateMetrics();
            this._ChooseName.addEventListener(MouseEvent.CLICK, this.clickNameChoose);
            this._ChooseName.y = 50;
            this._ChooseName.text_.autoSize = TextFieldAutoSize.CENTER;
            this._ChooseName.x = ((this._str7249().width / 2) - (this._ChooseName.width / 2));
            addChild(this._ChooseName);
        }
        private function buildCurrencies():void{
            buildGoldFame();
            buildSilver();
        }
        private function buildGoldFame():void{
            this._GoldFame = new _0B_v();
            this._GoldFame.draw(this.model.credits_, this.model.fame_);
            this._GoldFame.x = this._str7249().width;
            this._GoldFame.y = 20;
            addChild(this._GoldFame);
        }
        private function buildSilver():void{
            this._Silver = new _1B_v();
            this._Silver.draw(this.model._silver);
            this._Silver.x = this._str7249().width;
            this._Silver.y = 44;
            addChild(this._Silver);
        }
        private function buildNewsText():void{
            this._NewsText = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this._NewsText.setBold(true);
            this._NewsText.text = "News";
            this._NewsText.updateMetrics();
            this._NewsText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this._NewsText.x = 475;
            this._NewsText.y = 79;
            addChild(this._NewsText);
        }
        private function buildBoundaries():void{
            this._boundaries = new Shape();
            this._boundaries.graphics.clear();
            this._boundaries.graphics.lineStyle(2, 0xEE9327);
            this._boundaries.graphics.moveTo(0, 106);
            this._boundaries.graphics.lineTo(this._str7249().width, 106);
            this._boundaries.graphics.lineStyle();
            addChild(this._boundaries);
        }
        private function buildCharacterText():void{
            this._charactersText = new TextButton(18, false, "", true);
            this._charactersText.text_.setBold(true);
            this._charactersText.text_.text = "Characters";
            this._charactersText.text_.textColor = 0xB3B3B3;
            this._charactersText.text_.updateMetrics();
            this._charactersText.x = 18;
            this._charactersText.y = 79;
            this._charactersText.addEventListener(MouseEvent.CLICK, this.selectChar)
            addChild(this._charactersText);
        }
        private function buildGraveText():void{
            this._graveyardText = new TextButton(18, false, "", true);
            this._graveyardText.text_.setBold(true);
            this._graveyardText.text_.text = "Graveyard";
            this._graveyardText.text_.textColor = 0xB3B3B3;
            this._graveyardText.text_.updateMetrics();
            this._graveyardText.x = 18 + 150;
            this._graveyardText.y = 79;
            this._graveyardText.addEventListener(MouseEvent.CLICK, this.selectGraveyard);
            addChild(this._graveyardText);
        }
        private function buildScroll():void{
            this._scrollBar = new ScrollBar(16, 600);
            this._scrollBar.x = 443;
            this._scrollBar.y = 113;
            this._scrollBar._fA_(399, this._X_0.height);
            this._scrollBar.addEventListener(Event.CHANGE, this.Scroll);
            addChild(this._scrollBar);
        }

        private function buildCharacters():void{
            this.curState = CharsAndNews.charState;
            this._X_0 = new CharsAndNews(this.model, this, CharsAndNews.charState);
            this._X_0.x = 14;
            this._X_0.y = 108;
            this._77 = this._X_0.height;
            if (this._77 > 600) {
                this.buildScroll();
            }
            addChild(this._X_0);
        }
        private function buildGraveyard():void{
            this.curState = CharsAndNews.graveState;
            this._X_0 = new CharsAndNews(this.model, this, CharsAndNews.graveState);
            this._X_0.x = 10;
            this._X_0.y = 108;
            this._77 = this._X_0.height;
            if (this._77 > 600) {
                this.buildScroll();
            }
            addChild(this._X_0);
        }
        private function buildNewsSection():void{
            this._X_1 = new CharsAndNews(this.model, this, 3);
            this._X_1.x = 460;
            this._X_1.y = 108;
            addChild(this._X_1);
        }

        private function swap():void{
            if (this._X_0 != null) {
                removeChild(this._X_0);
                this._X_0 = null;
            }
            if (this._scrollBar != null) {
                removeChild(this._scrollBar);
                this._scrollBar = null;
            }
        }
        private function selectChar(_arg1:MouseEvent):void{
            if (this.curState != CharsAndNews.charState){
                this.swap();
                this.buildCharacters();
            }
        }
        private function selectGraveyard(_arg1:MouseEvent):void{
            if (this.curState != CharsAndNews.graveState){
                this.swap();
                this.buildGraveyard();
            }
        }

        private function clickNameChoose(_arg1:Event):void
        {
            var _local3:chooseNameNeedRegisterDialog;
            if (!Account._get().isRegistered()) {
                _local3 = new chooseNameNeedRegisterDialog();
                _local3.addEventListener(TwoButtonDialog.BUTTON1_EVENT, this._4);
                _local3.addEventListener(TwoButtonDialog.BUTTON2_EVENT, this.onDialogRegister);
                addChild(_local3);
                return;
            }
            var _local2:AccNameChooseRect = new AccNameChooseRect();
            _local2.addEventListener(Event.COMPLETE, this._0G_V_);
            addChild(_local2);
        }

        private function _0G_V_(_arg1:Event):void {
            this.chooseName.dispatch();
        }

        private function _4(_arg1:Event):void {
            var _local2:TwoButtonDialog = (_arg1.currentTarget as TwoButtonDialog);
            removeChild(_local2);
        }

        private function onDialogRegister(_arg1:Event):void {
            var _local2:TwoButtonDialog = (_arg1.currentTarget as TwoButtonDialog);
            removeChild(_local2);
            _0j();
        }

        private function Scroll(_arg1:Event):void {
            this._X_0.listScroll((-(this._scrollBar._Q_D_()) * (this._77 - 600)));
        }

        private function _04P_(_arg1:Event):void {
            if (this.model.numChars_ == 0 && this.model.hasAvailableCharSlot()) {
                this.newCharacter.dispatch();
            } else {
                this._D_u.dispatch();
            }
        }

    }
}//package _F_1

