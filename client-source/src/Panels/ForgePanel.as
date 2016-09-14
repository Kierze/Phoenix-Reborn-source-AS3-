package Panels {
import Frames.Crafting;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Frame2HolderNoDim;
import com.company.PhoenixRealmClient.ui.Chat;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class ForgePanel extends TextPanel {

    public function ForgePanel(param1:GameSprite, param2:GameObject) {
        super(param1, "Crafting Station", "Forge");
        this.obj_ = param2;
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
    }

    public var obj_:GameObject;
    private var frame:Frame2HolderNoDim;
    private var craftFrame:Crafting;

    override protected function onButtonClick(param1:MouseEvent):void {
        if (Crafting.isClosed) {
            this.open();
        }
    }

    protected function onKeyDown(param1:KeyboardEvent):void {
        if ((param1.keyCode == Parameters.ClientSaveData.interact) && !(Chat._0G_B_) && (Crafting.isClosed)) {
            this.open();
        }
    }

    private function open():void{
        this.craftFrame = new Crafting(gs_, this.obj_);
        this.frame = new Frame2HolderNoDim(this.craftFrame);
        stage.addChild(this.frame);
    }

    protected function onAdded(param1:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    protected function onRemove(param1:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        if ((!(parent == null) && !(this.frame == null)) && this.craftFrame.open) {
            stage.removeChild(this.frame);
        }
    }
}
}
