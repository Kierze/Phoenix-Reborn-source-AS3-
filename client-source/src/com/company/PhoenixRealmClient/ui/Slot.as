// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui.Slot

package com.company.PhoenixRealmClient.ui {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicHelper;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;

public class Slot extends Sprite {

    public static const anySlot:int = 0;
    public static const swordWeaponSlot:int = 1;
    public static const daggerWeaponSlot:int = 2;
    public static const bowWeaponSlot:int = 3;
    public static const priestAbilSlot:int = 4;
    public static const knightAbilSlot:int = 5;
    public static const leatherArmorSlot:int = 6;
    public static const heavyArmorSlot:int = 7;
    public static const wandWeaponSlot:int = 8;
    public static const accessorySlot:int = 9;
    public static const potionUsablesSlot:int = 10;
    public static const wizardAbilSlot:int = 11;
    public static const paladinAbilSlot:int = 12;
    public static const rogueAbilSlot:int = 13;
    public static const robeArmorSlot:int = 14;
    public static const archerAbilSlot:int = 15;
    public static const warriorAbilSlot:int = 16;
    public static const staffWeaponSlot:int = 17;
    public static const assassinAbilSlot:int = 18;
    public static const necromancerAbilSlot:int = 19;
    public static const huntressAbilSlot:int = 20;
    public static const mysticAbilSlot:int = 21;
    public static const tricksterAbilSlot:int = 22;
    public static const sorcererAbilSlot:int = 23;
    public static const katanaWeaponSlot:int = 24;
    public static const ninjaAbilSlot:int = 25;

    public static const WIDTH:int = 40;
    public static const HEIGHT:int = 40;
    public static const BORDER:int = 4;
    private static const _0I_E_:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil._fL_(0x3F0A00));

    public static function slotTypeToString(_arg1:int):String {
        switch (_arg1) {
            case -10:
                return ("Output");
            case anySlot:
                return ("Any");
            case swordWeaponSlot:
                return ("Sword");
            case daggerWeaponSlot:
                return ("Dagger");
            case bowWeaponSlot:
                return ("Bow");
            case priestAbilSlot:
                return ("Tome");
            case knightAbilSlot:
                return ("Shield");
            case leatherArmorSlot:
                return ("Leather Armor");
            case heavyArmorSlot:
                return ("Armor");
            case wandWeaponSlot:
                return ("Wand");
            case accessorySlot:
                return ("Accessory");
            case potionUsablesSlot:
                return ("Potion");
            case wizardAbilSlot:
                return ("Spell");
            case paladinAbilSlot:
                return ("Holy Seal");
            case rogueAbilSlot:
                return ("Cloak");
            case robeArmorSlot:
                return ("Robe");
            case archerAbilSlot:
                return ("Quiver");
            case warriorAbilSlot:
                return ("Helm");
            case staffWeaponSlot:
                return ("Staff");
            case assassinAbilSlot:
                return ("Poison");
            case necromancerAbilSlot:
                return ("Skull");
            case huntressAbilSlot:
                return ("Trap");
            case mysticAbilSlot:
                return ("Orb");
            case tricksterAbilSlot:
                return ("Prism");
            case sorcererAbilSlot:
                return ("Scepter");
            case katanaWeaponSlot:
                return ("Katana");
            case ninjaAbilSlot:
                return ("Shuriken");
        }
        return ("Invalid Type!");
    }

    public function Slot(_arg1:int, _arg2:int, _arg3:Array, _equipment:Boolean = false) {
        this._04c = new GraphicsSolidFill(_equipment ? Parameters._primaryColourDefault : Parameters._primaryColourLight, 1);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[this._04c, this.path_, GraphicHelper.END_FILL];
        super();
        this.type_ = _arg1;
        this._ws = _arg2;
        this._07i = _arg3;
        this._rC_();
    }
    public var type_:int;
    public var _ws:int;
    public var _07i:Array;
    public var _0H_K_:Bitmap;
    public var equipment_:Boolean;
    protected var _04c:GraphicsSolidFill;
    protected var path_:GraphicsPath;
    private var graphicsData_:Vector.<IGraphicsData>;

    protected function equipmentDrawOffset(_arg1:int, _arg2:int, _arg3:Boolean):Point
    {
        var _local4:Point = new Point();
        switch (_arg2) {
            case accessorySlot:
                _local4.x = (((_arg1) == 2878) ? 0 : -2);
                _local4.y = ((_arg3) ? -2 : 0);
                break;
            case wizardAbilSlot:
                _local4.y = -2;
                break;
        }
        return (_local4);
    }

    protected function _rC_():void {
        var _local4:Point;
        var _local5:SimpleText;
        var _local6:Matrix;
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, this._07i, this.path_);
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
        var objectSprite:BitmapData;

        switch (this.type_)
        {
            case anySlot:
                break;
            case swordWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 48);
                break;
            case daggerWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 96);
                break;
            case bowWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 80);
                break;
            case priestAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 80);
                break;
            case knightAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 112);
                break;
            case leatherArmorSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 0);
                break;
            case heavyArmorSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 32);
                break;
            case wandWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 64);
                break;
            case accessorySlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj", 44);
                break;
            case wizardAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 64);
                break;
            case paladinAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 160);
                break;
            case rogueAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 32);
                break;
            case robeArmorSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 16);
                break;
            case archerAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 48);
                break;
            case warriorAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 96);
                break;
            case staffWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj5", 112);
                break;
            case assassinAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 128);
                break;
            case necromancerAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 0);
                break;
            case huntressAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 16);
                break;
            case mysticAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 144);
                break;
            case tricksterAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 176);
                break;
            case sorcererAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj6", 192);
                break;
            case katanaWeaponSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj3", 512);
                break;
            case ninjaAbilSlot:
                objectSprite = AssetLibrary.getBitmapFromFileIndex("lofiObj3", 547);
                break;
        }
        if (this._0H_K_ == null)
        {
            if (objectSprite != null)
            {
                _local4 = this.equipmentDrawOffset(-1, this.type_, true);
                this._0H_K_ = new Bitmap(objectSprite);
                this._0H_K_.x = (BORDER + _local4.x);
                this._0H_K_.y = (BORDER + _local4.y);
                this._0H_K_.scaleX = 4;
                this._0H_K_.scaleY = 4;
                this._0H_K_.filters = [_0I_E_];
                addChild(this._0H_K_);
            }
            else
            {
                if (this._ws > 0)
                {
                    _local5 = new SimpleText(26, Parameters._primaryColourDark, false, 0, 0, "Myriad Pro");
                    _local5.text = String(this._ws);
                    _local5.setBold(true);
                    _local5.updateMetrics();
                    objectSprite = new BitmapData(26, 30, true, 0);
                    _local6 = new Matrix();
                    objectSprite.draw(_local5, _local6);
                    this._0H_K_ = new Bitmap(objectSprite);
                    this._0H_K_.x = ((WIDTH / 2) - (_local5.width / 2));
                    this._0H_K_.y = ((HEIGHT / 2) - 18);
                    addChild(this._0H_K_);
                }
            }
        }
    }

}
}//package com.company.PhoenixRealmClient.ui

