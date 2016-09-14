// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.objects.ObjectLibrary

package com.company.PhoenixRealmClient.objects {
import _0_P_.AnimateFromXML;

import com.company.PhoenixRealmClient.net.messages.data.StatData;
import com.company.PhoenixRealmClient.ui.Slot;
import com.company.PhoenixRealmClient.util.TextureRedrawer;
import com.company.PhoenixRealmClient.util.xButtonSquare;
import com.company.util.AssetLibrary;
import com.company.util.ConversionUtil;

import flash.display.BitmapData;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

public class ObjectLibrary {

    public static const typeToObjectProperties:Dictionary = new Dictionary();
    public static const typeToXml:Dictionary = new Dictionary();
    public static const idToType:Dictionary = new Dictionary();
    public static const typeToDisplayId:Dictionary = new Dictionary();
    public static const typeToTexture:Dictionary = new Dictionary();
    public static const typeToTopTexture:Dictionary = new Dictionary();
    public static const typeToAnimate:Dictionary = new Dictionary();
    public static const nullProperties:ObjectProperties = new ObjectProperties(null);
    public static const objLibrary:Object =
    {
        "CaveWall":CaveWall,
        "Character":Character,
        "CharacterChanger":CharacterChanger,
        "ClosedVaultChest":ClosedVaultChest,
        "ConnectedWall":ConnectedWall,
        "Container":Container,
        "DoubleWall":DoubleWall,
        "Forge":Forge,
        "GameObject":GameObject,
        "GuildBoard":GuildBoard,
        "GuildChronicle":GuildChronicle,
        "GuildHallPortal":GuildHallPortal,
        "GuildMerchant":GuildMerchant,
        "GuildRegister":GuildRegister,
        "InteractNPC":InteractNPC,
        "MarketplaceGround":MarketplaceGround,
        "Merchant":Merchant,
        "MoneyChanger":MoneyChanger,
        "NameChanger":NameChanger,
        "Player":Player,
        "Portal":Portal,
        "Projectile":Projectile,
        "Reforge":Reforge,
        "Sign":Sign,
        "SpiderWeb":SpiderWeb,
        "Stalagmite":Stalagmite,
        "Wall":Wall
    }

    public static var playerClassObjects:Vector.<XML> = new Vector.<XML>();
    public static var availableClasses:Dictionary = new Dictionary();
    public static var hexableObjects:Vector.<XML> = new Vector.<XML>();
    public static var _9x:Dictionary = new Dictionary();
    public static var itemObjects:Vector.<String> = new Vector.<String>();

    public static function parse(_arg1:XML):void {
        var xml:XML;
        var id:String;
        var displayId:String;
        var type:int;
        var _local6:Boolean;
        var _locClassCount:int;
        for each (xml in _arg1.Object) {
            id = String(xml.@id);
            displayId = id;
            if (xml.hasOwnProperty("DisplayId"))
            {
                displayId = xml.DisplayId;
            }
            if (xml.hasOwnProperty("Group"))
            {
                if (xml.Group == "Hexable")
                {
                    hexableObjects.push(xml);
                }
            }
            type = int(xml.@type);
            typeToObjectProperties[type] = new ObjectProperties(xml);
            typeToXml[type] = xml;
            idToType[id] = type;
            typeToDisplayId[type] = displayId;
            if (String(xml.Class) == "Equipment")
            {
                itemObjects.push(String(xml.@id));
            }
            if (String(xml.Class) == "Player")
            {
                var _locIsPlaceholder:Boolean = false;

                _9x[type] = String(xml.@id).substr(0, 2);
                _local6 = false;
                _locClassCount = 0;
                while (_locClassCount < playerClassObjects.length)
                {
                    if (int(playerClassObjects[_locClassCount].@type) == type)
                    {
                        playerClassObjects[_locClassCount] = xml;
                        _local6 = true;
                    }
                    _locClassCount++;
                }
                if (!_local6)
                {
                    playerClassObjects.push(xml);
                }
                for each(var _locSpecXML:XML in xml.Specialization)
                {
                    if (_locSpecXML.@id == "Placeholder") _locIsPlaceholder = true;
                }
                if (!_locIsPlaceholder) availableClasses[int(xml.@type)] = xml;
            }
            typeToTexture[type] = new TextureFromXML(xml);
            if (xml.hasOwnProperty("Top"))
            {
                typeToTopTexture[type] = new TextureFromXML(XML(xml.Top));
            }
            if (xml.hasOwnProperty("Animation"))
            {
                typeToAnimate[type] = new AnimateFromXML(xml);
            }
        }
    }

    public static function typeToId(_arg1:int):String {
        var _local2:XML = typeToXml[_arg1];
        if (_local2 == null) {
            return (null);
        }
        return (String(_local2.@id));
    }

    public static function idToObjectProperties(_arg1:String):ObjectProperties {
        var _local2:int = idToType[_arg1];
        return (typeToObjectProperties[_local2]);
    }

    public static function idToXml(_arg1:String):XML {
        var _local2:int = idToType[_arg1];
        return (typeToXml[_local2]);
    }

    public static function positionXButtonSquare(_arg1:int):xButtonSquare{
        var button:xButtonSquare = new xButtonSquare();
        button.y = 4;
        button.x = ((_arg1 - button.width) - 5);
        return (button);
    }

    public static function _075(_arg1:int):GameObject {
        var _local2:XML = typeToXml[_arg1];
        var _local3:String = _local2.Class;
        var _local4:Class = ((objLibrary[_local3]) || (deserializeObjectClass(_local3)));
        //var _local4:GameObject = new (_local3)(_local2);
        return (new (_local4)(_local2));
    }

    private static function deserializeObjectClass(_arg1:String):Class {
        var _local2:String = ("com.company.PhoenixRealmClient.objects." + _arg1);
        return ((getDefinitionByName(_local2) as Class));
    }

    public static function getTextureFromType(_arg1:int):BitmapData {
        var _local2:TextureFromXML = typeToTexture[_arg1];
        if (_local2 == null) {
            return (null);
        }
        return (_local2.getTexture());
    }

    public static function getRedrawnTextureFromType(_arg1:int, _arg2:int, _arg3:Boolean, _arg4:Boolean = true, _arg5:Number = 5):BitmapData {
        var _local6:TextureFromXML = typeToTexture[_arg1];
        var _local7:BitmapData = _local6.getTexture();
        if (_local7 == null) {
            _local7 = AssetLibrary.getBitmapFromFileIndex("lofiObj3", 0xFF);
        }
        var _local8:BitmapData = _local6.mask_;
        if (_local8 == null) {
            return (TextureRedrawer.redraw(_local7, _arg2, _arg3, 0, _arg4, _arg5));
        }
        var _local9:XML = typeToXml[_arg1];
        var _local10:int = ((_local9.hasOwnProperty("Tex1")) ? int(_local9.Tex1) : 0);
        var _local11:int = ((_local9.hasOwnProperty("Tex2")) ? int(_local9.Tex2) : 0);
        _local7 = TextureRedrawer.resize(_local7, _local8, _arg2, _arg3, _local10, _local11);
        _local7 = TextureRedrawer.outlineGlow(_local7, 0);
        return (_local7);
    }

    public static function getRedrawnTextureFromTypeCustom(_arg1:int, _arg2:int, _arg3:Boolean, _arg4:Object, _arg5:Boolean = true, _arg6:Number = 5):BitmapData {
        var _local6:TextureFromXML = typeToTexture[_arg1];
        var _local7:BitmapData = AssetLibrary.getBitmapFromFileIndex(_arg4.TextureFile, int(_arg4.TextureIndex));
        if (_local7 == null) {
            _local7 = AssetLibrary.getBitmapFromFileIndex("lofiObj3", 0xFF);
        }
        var _local8:BitmapData = _local6.mask_;
        if (_local8 == null) {
            return (TextureRedrawer.redraw(_local7, _arg2, _arg3, 0, _arg5, _arg6));
        }
        var _local9:XML = typeToXml[_arg1];
        var _local10:int = ((_local9.hasOwnProperty("Tex1")) ? int(_local9.Tex1) : 0);
        var _local11:int = ((_local9.hasOwnProperty("Tex2")) ? int(_local9.Tex2) : 0);
        _local7 = TextureRedrawer.resize(_local7, _local8, _arg2, _arg3, _local10, _local11);
        _local7 = TextureRedrawer.outlineGlow(_local7, 0);
        return (_local7);
    }

    public static function _P_N_(_arg1:int):int {
        var _local2:XML = typeToXml[_arg1];
        if (!_local2.hasOwnProperty("Size")) {
            return (100);
        }
        return (int(_local2.Size));
    }

    public static function getSlotType(_arg1:int):int {
        var _local2:XML = typeToXml[_arg1];
        if (_local2 == null || !_local2.hasOwnProperty("SlotType")) {
            return (-1);
        }
        return (int(_local2.SlotType));
    }

    public static function checkEquipSlotTypes(_arg1:int, _arg2:Player):Boolean {
        if (_arg1 == -1) {
            return (false);
        }
        var itemXml:XML = typeToXml[_arg1];
        var slotType:int = int(itemXml.SlotType.toString());
        var count:uint = 0;
        while (count < 4) {
            if (_arg2.inventorySlotTypes_[count] == slotType) {
                return (true);
            }
            count++;
        }
        return (false);
    }

    public static function objectIsForPlayer(_arg1:int, _arg2:Player):Boolean
    {
        if (_arg2 == null)
        {
            return (true);
        }
        var objectXml:XML = typeToXml[_arg1];
        if ((objectXml == null) || !(objectXml.hasOwnProperty("SlotType")))
        {
            return (false);
        }
        if (objectXml.Activate == "UnlockSkin" && objectXml.Activate.hasOwnProperty("@skinType"))
        {
            var _skin:XML = ObjectLibrary.typeToXml[int(objectXml.Activate.@skinType)];
            if (_skin == null || !_skin.hasOwnProperty("PlayerClassType") || int(_skin.PlayerClassType) != _arg2.objectType_)
                return false;
        }
        var slotType:int = objectXml.SlotType;
        if (slotType == Slot.potionUsablesSlot)
        {
            return (true);
        }
        var count:int = 0;
        while (count < _arg2.inventorySlotTypes_.length)
        {
            if (_arg2.inventorySlotTypes_[count] == slotType)
            {
                return (true);
            }
            count++;
        }
        return (false);
    }

    public static function checkLevelRequirement(_arg1:int, player:Player):Boolean
    {
        if(_arg1 == -1)
        {
            return true;
        }
        var objectXml:XML = typeToXml[_arg1];
        if(player == null || objectXml == null || !(objectXml.hasOwnProperty("LevelReq")))
        {
            return true;
        }
        return player.level_ >= int(objectXml.LevelReq);
    }

    public static function checkSoulbound(_arg1:int, _arg2:Object = null):Boolean
    {
        var objectXml:XML = typeToXml[_arg1];
        return ((objectXml != null) && ((objectXml.hasOwnProperty("Soulbound")) || ((_arg2 != null) && (_arg2.hasOwnProperty("Soulbound")) && (_arg2.Soulbound == true))));
    }

    public static function getClassesThatUseObject(_arg1:int):Vector.<String>
    {
        var classType:XML;
        var _local6:Vector.<int>;
        var count:int;
        var objectXml:XML = typeToXml[_arg1];
        if ((objectXml == null) || !(objectXml.hasOwnProperty("SlotType")))
        {
            return (null);
        }
        var slotType:int = objectXml.SlotType;
        if (objectXml.Activate == "UnlockSkin" && objectXml.Activate.hasOwnProperty("@skinType"))
        {
            var _skin:XML = ObjectLibrary.typeToXml[int(objectXml.Activate.@skinType)];
            if (_skin != null && _skin.hasOwnProperty("PlayerClassType"))
                return new <String>[typeToDisplayId[int(_skin.PlayerClassType)]];
        }
        if ((slotType == Slot.potionUsablesSlot) || (slotType == Slot.accessorySlot))
        {
            return (null);
        }
        var _local4:Vector.<String> = new Vector.<String>();

        for each (classType in playerClassObjects)
        {
            _local6 = ConversionUtil.StringCommaSplitToIntVector(classType.SlotTypes);
            count = 0;
            while (count < _local6.length)
            {
                if (_local6[count] == slotType)
                {
                    _local4.push(typeToDisplayId[int(classType.@type)]);
                    break;
                }
                count++;
            }
        }
        return (_local4);
    }

    public static function _S_d(_arg1:int, player:Player):Boolean
    {
        var _local4:XML;
        if (player == null)
        {
            return (true);
        }
        var objectXml:XML = typeToXml[_arg1];
        for each (_local4 in objectXml.EquipRequirement)
        {
            if (!checkStatsEquipRequirement(_local4, player))
            {
                return (false);
            }
        }
        return (true);
    }

    public static function checkStatsEquipRequirement(_arg1:XML, _arg2:Player):Boolean {
        var _local3:int;
        if (_arg1.toString() == "Stat") {
            _local3 = int(_arg1.@value);
            switch (int(_arg1.@stat)) {
                case StatData.MaximumHP:
                    return ((_arg2.maxHP_ >= _local3));
                case StatData.MaximumMP:
                    return ((_arg2.maxMP_ >= _local3));
                case StatData.Level:
                    return ((_arg2.level_ >= _local3));
                case StatData.Attack:
                    return ((_arg2.attack_ >= _local3));
                case StatData.Defense:
                    return ((_arg2.defense_ >= _local3));
                case StatData.Speed:
                    return ((_arg2.speed_ >= _local3));
                case StatData.Vitality:
                    return ((_arg2.vitality_ >= _local3));
                case StatData.Wisdom:
                    return ((_arg2.wisdom_ >= _local3));
                case StatData.Dexterity:
                    return ((_arg2.dexterity_ >= _local3));
                case StatData.Aptitude:
                    return ((_arg2.aptitude_ >= _local3));
                case StatData.Resilience:
                    return ((_arg2.resilience_ >= _local3));
                case StatData.Penetration:
                    return ((_arg2.penetration_ >= _local3));
            }
        }
        return (false);
    }

    public static function searchItems(_arg1:String):Vector.<int>
    {
        var filterFunction:Function = function(item:String, index:int, vec:Vector.<String>):Boolean
        {
            if(item.toLowerCase().indexOf(_arg1.toLowerCase()) != -1)
            {
                return true;
            }
            return false;
        };
        var ret:Vector.<int> = new Vector.<int>();
        var eacherFunction:Function = function(item:String, index:int, vec:Vector.<String>):void
        {
            ret.push(idToType[item]);
        };
        itemObjects.filter(filterFunction).forEach(eacherFunction);
        return ret;
    }

}
}//package com.company.PhoenixRealmClient.objects

