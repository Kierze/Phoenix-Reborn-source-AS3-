// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_E_7.CharacterRectTooltip

package Tooltips {
import com.company.PhoenixRealmClient.appengine.ClassStat;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.CharObjectHeader;
import com.company.PhoenixRealmClient.ui.Inventory;
import com.company.PhoenixRealmClient.ui.StatsBar;
import com.company.PhoenixRealmClient.ui.TooltipDivider;
import com.company.PhoenixRealmClient.util.ClassQuest;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class CharacterRectTooltip extends TooltipBase {

    public function CharacterRectTooltip(_arg1:String, _arg2:XML, _arg3:ClassStat)
    {
        super(Parameters._primaryColourDefault, 1, 0xFFFFFF, 1);
        var _local4:int = int(_arg2.ObjectType);
        var _local5:XML = ObjectLibrary.typeToXml[_local4];
        this.player_ = Player.FromString(_arg1, _arg2);
        this._02y = new CharObjectHeader(0xB3B3B3, true, this.player_);
        addChild(this._02y);
        this._023 = new StatsBar(176, 16, 14693428, 0x260400, "HP");
        this._023.x = 6;
        this._023.y = 40;
        addChild(this._023);
        this._F_C_ = new StatsBar(176, 16, 6325472, 0x260400, "MP");
        this._F_C_.x = 6;
        this._F_C_.y = 64;
        addChild(this._F_C_);
        this._e9 = new Inventory(null, this.player_, "Player Inventory", this.player_.inventorySlotTypes_, 12, false);
        this._e9.x = 8;
        this._e9.y = 88;
        addChild(this._e9);
        this._qc = new TooltipDivider(90, Parameters._primaryColourDark);
        this._qc.x = 6;
        this._qc.y = 228;
        addChild(this._qc);
        var _local6:int = (((_arg3 == null)) ? 0 : _arg3.getFameGoals());
        this._05h = new SimpleText(14, 6206769, false, 0, 0, "CHIP SB");
        this._05h.text = ((((((_local6 + " of " + ClassQuest.FameGoals.length + " Class Quests Completed\n") + "Best Level Achieved: ") + (((_arg3) != null) ? _arg3.bestLevel() : 0)) + "\n") + "Best Fame Achieved: ") + (((_arg3) != null) ? _arg3.bestFame() : 0));
        this._05h.updateMetrics();
        this._05h.filters = [new DropShadowFilter(0, 0, 0)];
        this._05h.x = 8;
        this._05h.y = (height - 2);
        addChild(this._05h);
        var _local7:int = ClassQuest.getNextFameGoal((((_arg3 == null)) ? 0 : _arg3.bestFame()), 0);
        if (_local7 > 0) {
            this._U_n = new SimpleText(15, 16549442, false, 174, 0, "CHIP SB");
            this._U_n.text = (((("Next Goal: Earn " + _local7) + " Fame\n") + "  with a ") + _local5.@id);
            this._U_n.updateMetrics();
            this._U_n.filters = [new DropShadowFilter(0, 0, 0)];
            this._U_n.x = 8;
            this._U_n.y = (height - 2);
            addChild(this._U_n);
        }
    }
    public var player_:Player;
    private var _02y:CharObjectHeader;
    private var _023:StatsBar;
    private var _F_C_:StatsBar;
    private var _e9:Inventory;
    private var _qc:TooltipDivider;
    private var _05h:SimpleText;
    private var _U_n:SimpleText;

    override public function draw():void {
        this._023.draw(this.player_.HP_, this.player_.maxHP_, this.player_._P_7, this.player_._maxMAXHP);
        this._F_C_.draw(this.player_.MP_, this.player_.maxMP_, this.player_._0D_G_, this.player_._maxMAXMP);
        this._e9.draw(this.player_.equipment_);
        this._qc._rs((width - 10), Parameters._primaryColourDark);
        super.draw();
    }

}
}//package _E_7

