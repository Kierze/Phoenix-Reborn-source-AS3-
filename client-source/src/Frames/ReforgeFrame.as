package Frames {
import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.GameObject;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Inventory;
import com.company.PhoenixRealmClient.ui.TooltipDivider;

import flash.events.Event;
import flash.events.MouseEvent;

public class ReforgeFrame extends Frame2 {

    public static var isClosed:Boolean = true;
    public var open:Boolean;

    public function ReforgeFrame(_gs:GameSprite, _obj:GameObject) {
        ReforgeFrame.isClosed = false;
        super("Reforge items", "Reforge", 200);
        this.gs_ = _gs;
        this.obj_ = _obj;
        this.offsetH(150);

        this.slot1_ = new Inventory(_gs, _obj, "Item", new <int>[0], 1, false, 0);
        this.slot2_ = new Inventory(_gs, _obj, "Material", new <int>[0], 1, false, 1);
        this.output_ = new Inventory(_gs, _obj, "Output", new <int>[-10], 1, false, 2);

        this.slot1_.x = 25;
        this.slot1_.y = 50;
        this.slot2_.x = this.w_ - 25 - this.slot2_.width - 10;
        this.slot2_.y = 50;
        this.output_.x = this.w_ / 2 - this.output_.width / 2 - 5;
        this.output_.y = this.h_ - 75 - this.output_.height;

        var _spacer:TooltipDivider = new TooltipDivider((this.slot2_.x - 9) - (this.slot1_.x + 9 + this.slot1_.width), Parameters._primaryColourDark);
        _spacer.x = this.slot1_.x + 9 + this.slot1_.width;
        _spacer.y = this.slot1_.y + this.slot1_.width / 2;
        var _spacer2:TooltipDivider = new TooltipDivider((this.output_.y - 9) - (this.slot1_.y + this.slot1_.width / 2), Parameters._primaryColourDark, true);
        _spacer2.x = this.slot2_.x - 9 - ((this.slot2_.x - 9) - (this.slot1_.x + 9 + this.slot1_.width)) / 2;
        _spacer2.y = this.slot1_.y + this.slot1_.width / 2;

        this.addChild(this.slot1_);
        this.addChild(this.slot2_);
        this.addChild(this.output_);
        this.addChild(_spacer);
        this.addChild(_spacer2);

        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        Button1.addEventListener(MouseEvent.CLICK, this.onCraft);
        XButton.addEventListener(MouseEvent.CLICK, this.onClose);
        Button1.x = 10;

        this.open = true;
    }
    private var gs_:GameSprite;
    private var obj_:GameObject;
    private var slot1_:Inventory;
    private var slot2_:Inventory;
    private var output_:Inventory;

    public override function onAddedToStage(e:Event):void {
        super.onAddedToStage(e);
        this.x = (600 / 2) - ((this.w_ - 6) / 2);
        this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(e:Event):void {
        this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        ReforgeFrame.isClosed = true;
        this.open = false;
    }

    private function onEnterFrame(e:Event) {
        this.slot1_.draw(new <int>[this.obj_.equipment_[0]]);
        this.slot2_.draw(new <int>[this.obj_.equipment_[1]]);
        this.output_.draw(new <int>[this.obj_.equipment_[2]]);
    }

    private function onClose(param1:MouseEvent):void {
        Crafting.isClosed = true;
        this.open = false;
        stage.focus = null;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onCraft(param1:MouseEvent):void {
        this.gs_.gsc_.craftItems(this.obj_.objectId_);
    }
}
}