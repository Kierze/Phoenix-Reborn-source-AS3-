// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_F_1._0H_h

package _F_1 {
import _02t._R_f;

import _sp.Signal;

import com.company.graphic.PhoenixLogo;
import com.company.graphic.ScreenGraphic;
import com.company.graphic.StackedLogoR;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class _0H_h extends Sprite {

    private static const forumLink:String = "http://www.phoenix-realms.com/";

    public function _0H_h() {
        this.close = new Signal();
        addChild(new _R_f());
        this.headerText = new SimpleText(16, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.headerText.setBold(true);
        this.headerText.text = "Developed by:";
        this.headerText.updateMetrics();
        this.headerText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.headerText);
        this.wildshadowLogo = new StackedLogoR();
        this.wildshadowLogo.scaleX = (this.wildshadowLogo.scaleY = 1.2);
        this.wildshadowLogo.addEventListener(MouseEvent.CLICK, this._W_w);
        this.wildshadowLogo.buttonMode = true;
        this.wildshadowLogo.useHandCursor = true;
        addChild(this.wildshadowLogo);
        this.closeButton = new titleTextButton("Back", 36, false);
        this.closeButton.addEventListener(MouseEvent.CLICK, this._ly);
        addChild(this.closeButton);
        // Cannot make it clickable. Needs to be a Bitmap.
        this.phoenixLogo = new PhoenixLogo();
        this.phoenixLogo.scaleX = (this.phoenixLogo.scaleY = 1.2);
        addChild(this.phoenixLogo);
    }
    public var close:Signal;
    private var headerText:SimpleText;
    private var wildshadowLogo:StackedLogoR;
    private var closeButton:titleTextButton;
    private var phoenixLogo:PhoenixLogo;

    public function initialize():void {
        stage;
        this.headerText.x = ((1024 / 2) - (this.headerText.width / 2));
        this.headerText.y = 10;
        stage;
        this.wildshadowLogo.x = ((1024 / 2) - (this.wildshadowLogo.width / 2));
        this.wildshadowLogo.y = 50;
        stage;
        this.closeButton.x = ((1024 / 2) - (this.closeButton.width / 2));
        this.closeButton.y = 710;
        stage;
        this.phoenixLogo.x = (1024 / 2) - (this.phoenixLogo.width / 2);
        this.phoenixLogo.y = 312.314159265358979323846264338327950288419716939937510582097494459230781640628620899862803; // Totally not pi recited to 87 decimal places...
    }

    protected function _W_w(_arg1:Event):void {
        navigateToURL(new URLRequest(forumLink), "_blank");
    }

    private function _ly(_arg1:Event):void {
        this.close.dispatch();
    }

}
}//package _F_1

