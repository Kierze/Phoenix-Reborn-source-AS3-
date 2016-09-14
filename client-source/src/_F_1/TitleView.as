package _F_1 {
import _02t._R_f;
import _ke.Buttons;
import _qN_.Account;
import _sp.Signal;
import com.company.PhoenixRealmClient.appengine._0K_R_;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;


public class TitleView extends _05p {


    public function TitleView()
    {
        addChild(new _R_f());
        addChild(new TitleImage());
        super(TitleView);
        this._ft = new Signal(String);
    }
    public var _ft:Signal;
    private var _qR_:titleTextButton;
    private var _serversButton:titleTextButton;
    private var _creditsButton:titleTextButton;
    private var _accountButton:titleTextButton;
    private var _legendsButton:titleTextButton;
    private var _mapsButton:titleTextButton;
    private var _spritesButton:titleTextButton;
    private var versionText:SimpleText;
    private var copyrightText:SimpleText;
    private var _T_1:_0K_R_;


    override public function initialize(_arg1:_0K_R_):void
    {
        super.initialize(_arg1);
        this._T_1 = _arg1;
        this._qR_ = new titleTextButton(Buttons.PLAY, 36, true);
        if (!_T_1.servers_.length == 0 || Account._get().isRegistered())
            this._qR_.addEventListener(MouseEvent.CLICK, this._021);
        else
            this._qR_.addEventListener(MouseEvent.CLICK, this.reg_);
        addChild(this._qR_);
        this._serversButton = new titleTextButton(Buttons.SERVERS, 22, false);
        this._serversButton.addEventListener(MouseEvent.CLICK, this._021);
        addChild(this._serversButton);
        this._creditsButton = new titleTextButton(Buttons.CREDITS, 22, false);
        this._creditsButton.addEventListener(MouseEvent.CLICK, this._021);
        addChild(this._creditsButton);
        this._accountButton = new titleTextButton(Buttons.ACCOUNT, 22, false);
        this._accountButton.addEventListener(MouseEvent.CLICK, this._021);
        addChild(this._accountButton);
        this._legendsButton = new titleTextButton(Buttons.LEGENDS, 22, false);
        //this._legendsButton.addEventListener(MouseEvent.CLICK, this._021);
        this._legendsButton.visible = false; //temporary removal until legends are created
        addChild(this._legendsButton);
        this._mapsButton = new titleTextButton(Buttons.EDITOR, 22, false);
        this._mapsButton.addEventListener(MouseEvent.CLICK, this._021);
        this._mapsButton.visible = Account._get().isRegistered();
        addChild(this._mapsButton);
        this._spritesButton = new titleTextButton(Buttons.SPRITE, 22, false);
        this._spritesButton.addEventListener(MouseEvent.CLICK, this._021);
        this._spritesButton.visible = Account._get().isRegistered();
        addChild(this._spritesButton);

        this.versionText = new SimpleText(12, 0x7F7F7F, false, 0, 0, "Myriad Pro");
        this.versionText.htmlText = (Parameters.isTesting ? (Parameters.domainCheck() ? "Testing " : "") : '<font color="#ff0000">DEVELOPMENT</font> ') + "v" + Parameters.clientVersion;
        this.versionText.updateMetrics();
        this.versionText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.versionText);
        this.copyrightText = new SimpleText(12, 0x7F7F7F, false, 0, 0, "Myriad Pro");
        this.copyrightText.text = "© 2016 by Phoenix Realms.";
        this.copyrightText.updateMetrics();
        this.copyrightText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.copyrightText);

        this._qR_.x = ((1024 / 2) - (this._qR_.width / 2));
        this._qR_.y = 710;

        this._serversButton.x = (((1024 / 2) - (this._serversButton.width / 2)) - 94);
        this._serversButton.y = 720;

        this._mapsButton.x = (((1024 / 2) - (this._serversButton.width / 2)) - 180);
        this._mapsButton.y = 720;

        this._accountButton.x = (((1024 / 2) - (this._accountButton.width / 2)) + 96);
        this._accountButton.y = 720;

        /*this._legendsButton.x = (((1024 / 2) - (this._accountButton.width / 2)) + 190);
        this._legendsButton.y = 720;*/

        this._creditsButton.x = (((1024 / 2) - (this._accountButton.width / 2)) + 190);
        this._creditsButton.y = 720;

        /*this._mapsButton.x = 200;
        this._mapsButton.y = 700;*/

        this._spritesButton.x = 200 + 6;
        this._spritesButton.y = 720;


        this.versionText.y = (768 - this.versionText.height);

        this.copyrightText.x = (1024 - this.copyrightText.width);
        this.copyrightText.y = (768 - this.copyrightText.height);
    }

    private function _021(_arg1:MouseEvent):void {
        var _local2:titleTextButton = (_arg1.target as titleTextButton);
        this._ft.dispatch(_local2.name);
    }

    private function reg_(_arg1:MouseEvent):void {
        var _local2:titleTextButton = (_arg1.target as titleTextButton);
        if (_local2.name == "PLAY") {
            _local2.name = "ACCOUNT";
        }
        this._ft.dispatch(_local2.name);
    }
}
}

