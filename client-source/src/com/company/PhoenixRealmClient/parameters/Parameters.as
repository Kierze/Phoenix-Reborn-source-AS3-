// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.parameters.Parameters

package com.company.PhoenixRealmClient.parameters {

import com.company.util._0A_s;
import com.company.util.keyboardKeys;

import flash.display.DisplayObject;
import flash.net.LocalConnection;
import flash.net.SharedObject;
import flash.utils.Dictionary;

public class Parameters {

    public static const isTesting:Boolean = true;
    public static const isLocal:Boolean = true;
    public static const sendErrors:Boolean = false;
    public static const clientVersion:String = "3";
    public static const _wZ_:Boolean = true;
    public static const gamePort:int = 2050;
    public static const playerPinkColor:uint = 0xE678CC;           //something pink
    public static const playerGuildColor:uint = 0xA6FF5D;             //something light neon lime green
    public static const playerNameChosenColor:uint = 0xFCDF00;            //something yellow
    public static const playerPartyColor:uint = 0x709BFF;      //something powder blue
    public static const _F_g:int = 60;
    public static const RotationSpeed:Number = 0.003;
    public static const _E_S_:int = 20;
    public static const SendInfo:String = "";
    public static const SendClient:String = "*Client*";
    public static const SendError:String = "*Error*";
    public static const SendHelp:String = "*Help*";
    public static const SendGuild:String = "*Guild*";
    public static const SendParty:String = "*Party*";
    public static const SendChatBot:String = "!Bot";
    public static const _0u:int = 1000;
    public static const _0H_m:int = 1000;
    public static const TUT_ID:int = -1;
    public static const NEXUS_ID:int = -2;
    public static const RAND_REALM:int = -3;
    public static const NEXUS_LIMBO:int = -4;
    public static const TEST_ID:int = -6;
    public static const _K_5:Number = 18;
    public static const ToS_Url_:String = "http://www.phoenix-realms.com/TermsofUse.html";
    public static const lastUpdate:String = "http://phoenix-realms.com/index.php?threads/phoenix-realms-alpha-build-2.28/"
    public static const musicUrl_:String = _fK_();
    public static const connection:String = _fK_();
    public static const HelpCommand:String = "Help:\n" + "Use WASD to move and QE to rotate your camera.\n" + "Click to shoot! Use ZXC for special abilities.\n" + "Press O to view the Options menu.\n" + "[/commands]: A complete list of user commands.\n" + "[/pause]: When in safety, this will pause or un-pause your game.\n" + "[/who]: A list of online players in the current world.\n" + "[/tell <player name> <message>]: Sends a private message to another player.\n" + "[/ignore <player name>]: Prevents another player's messages from getting to you.\n" + "[/unignore <player name>]: Stops ignoring another player.\n" + "[/teleport <player name>]: Teleports you to another player's position.\n" + "[/trade <player name>]: Sends a trade request to another player.\n" + "[/?]: Opens this help dialog.";
    public static const RANDOM1:String = "311f80691451c71b09a13a2a6e";
    public static const RANDOM2:String = "72c5583cafb6818995cbd74b80";
    public static const RSAKey:String = "-----BEGIN PUBLIC KEY-----\n" + "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzRQGnNw5kEaIpych+U4J" + "ZtuLnMJuQKEyU1FfcyHISNkYhy1jmSMPav+7D3Qg1R6exeeM6LtXvUEQ6Fgris1J" + "UVDr5gjII0ti98LvIsF/hgTk2VOvm2QK/1OpyAxni4RZuR8OE0p0Co0yUwhTVjfN" + "5Ooh4hntfuwVtk1AZEFudA9oOqdUbNwi98M9VIf+9vJWnx2zAx+1r7Ja/JDeM3Fb" + "YW9awMw4d0fpGoN/PfZGqKdgd4jjXLuhatSu13sAU39aPZAI2ku3MQRMQcUBLxDI" + "HyEq1NA+BztASjpYr3w+bX85bWZwPOBN95O3z6hbDTv/FZj5tpkVqaVhxqBeEbaR" + "ywIDAQAB\n" + "-----END PUBLIC KEY-----";

    public static var root:DisplayObject;
    public static var ClientSaveData:Object = null;
    public static var _R_P_:int = 1;
    public static var _Q_b:int = 0;
    public static var DrawProjectiles:Boolean = true;
    public static var _0F_o:Boolean = false;
    public static var HideHUD:Boolean = false;
    public static var _hk:Boolean = true;
    private static var _ClientOptions:SharedObject = null;
    private static var _C_o:Dictionary = new Dictionary();

    public static const levelCap_:int = 90;

    public static const _primaryColourDark2:int = 0x592a0d;
    public static const _primaryColourDark:int = 0x7C3B12;
    public static const _primaryColourDefault:int = 0x994910;
    public static const _primaryColourLight:int = 0xBC5510;
    public static const _primaryColourLight2:int = 0xD35D0E;

    public static function _02Q_():String {
        return (Parameters.isTesting ? "Phoenix Realms" : "Phoenix Testing") + " Build #" + Parameters.clientVersion + (domainCheck() ? " Testing" : "");
    }

    public static function domainCheck():Boolean {
        var _local3:LocalConnection;
        var _local1:Boolean;
        _local3 = new LocalConnection();
        _local1 = !_local3.domain.indexOf("phoenix-realms.com") < 0;
        return (_local1);
    }

    public static function _fK_():String {
        if (isLocal)
        {
            return ("127.0.0.1:8088");
            //return ("40.117.41.73:8088");
        }
        if (domainCheck())
        {
            return ("40.117.41.73:8088");
            //return ("40.117.41.73:8088"); // _I_O_() -> TRUE -- Testing Enabled
        }
        //return ("127.0.0.1:8088");
        return ("40.117.41.73:8088"); // _I_O_() -> FALSE -- Testing Disabled 40.117.41.73 = VPS IP
    }

    public static function load():void {
        try
        {
            _ClientOptions = SharedObject.getLocal("PhoenixClientOptions", "/");
            ClientSaveData = _ClientOptions.data;
        }
        catch (error:Error)
        {
            ClientSaveData = {};
        }
        _fX_();
        save();
    }

    public static function save():void {
        try {
            if (_ClientOptions != null) {
                _ClientOptions.flush();
            }
        } catch (error:Error) {
        }
    }

    public static function setKey(_arg1:String, _arg2:uint):void {
        var _local3:String;
        for (_local3 in _C_o) {
            if (ClientSaveData[_local3] == _arg2) {
                ClientSaveData[_local3] = keyboardKeys.UNSET;
            }
        }
        ClientSaveData[_arg1] = _arg2;
    }

    public static function _fX_():void
    {
        AddHotkeyData("moveLeft", keyboardKeys.A);
        AddHotkeyData("moveRight", keyboardKeys.D);
        AddHotkeyData("moveUp", keyboardKeys.W);
        AddHotkeyData("moveDown", keyboardKeys.S);
        AddHotkeyData("rotateLeft", keyboardKeys.Q);
        AddHotkeyData("rotateRight", keyboardKeys.E);
        AddHotkeyData("interact", keyboardKeys.NUMBER_0);
        AddHotkeyData("FocusMove", keyboardKeys.SHIFT);
        AddHotkeyData("useInvSlot1", keyboardKeys.NUMBER_1);
        AddHotkeyData("useInvSlot2", keyboardKeys.NUMBER_2);
        AddHotkeyData("useInvSlot3", keyboardKeys.NUMBER_3);
        AddHotkeyData("useInvSlot4", keyboardKeys.NUMBER_4);
        AddHotkeyData("useInvSlot5", keyboardKeys.NUMBER_5);
        AddHotkeyData("useInvSlot6", keyboardKeys.NUMBER_6);
        AddHotkeyData("useInvSlot7", keyboardKeys.NUMBER_7);
        AddHotkeyData("useInvSlot8", keyboardKeys.NUMBER_8);
        AddHotkeyData("escapeToNexus", keyboardKeys.INSERT);
        AddHotkeyData("escapeToNexus2", keyboardKeys.F5);
        AddHotkeyData("autofireToggle", keyboardKeys.I);
        AddHotkeyData("scrollChatUp", keyboardKeys._R_0);
        AddHotkeyData("scrollChatDown", keyboardKeys._xs);
        AddHotkeyData("miniMapZoomOut", keyboardKeys._0F_K_);
        AddHotkeyData("miniMapZoomIn", keyboardKeys._0E_f);
        AddHotkeyData("resetToDefaultCameraAngle", keyboardKeys.R);
        AddHotkeyData("togglePerformanceStats", keyboardKeys.UNSET);
        AddHotkeyData("options", keyboardKeys.O);
        AddHotkeyData("toggleCentering", keyboardKeys.UNSET);
        AddHotkeyData("chat", keyboardKeys.ENTER);
        AddHotkeyData("chatCommand", keyboardKeys._jE_);
        AddHotkeyData("tell", keyboardKeys.TAB);
        AddHotkeyData("guildChat", keyboardKeys.G);
        AddHotkeyData("partyChat", keyboardKeys.P);
        AddHotkeyData("toggleFullscreen", keyboardKeys.UNSET);
        AddHotkeyData("switchTabs", keyboardKeys.B);
        AddHotkeyData("marketHotkey", keyboardKeys.UNSET);
        AddHotkeyData("useAbility1", keyboardKeys.Z);
        AddHotkeyData("useAbility2", keyboardKeys.X);
        AddHotkeyData("useAbility3", keyboardKeys.C);

        AddMiscData("playerObjectType", 782);
        AddMiscData("playMusic", true);
        AddMiscData("playSFX", true);
        AddMiscData("playPewPew", true);
        AddMiscData("centerOnPlayer", true);
        AddMiscData("preferredServer", null);
        AddMiscData("needsTutorial", true);
        AddMiscData("needsNexusTutorial", true);
        AddMiscData("needsRandomRealm", true);
        AddMiscData("cameraAngle", ((7 * Math.PI) / 4));
        AddMiscData("defaultCameraAngle", ((7 * Math.PI) / 4));
        AddMiscData("showQuestPortraits", true);
        AddMiscData("fullscreenMode", false);
        AddMiscData("showProtips", true);
        AddMiscData("protipIndex", 0);
        AddMiscData("joinDate", _0A_s._mP_());
        AddMiscData("lastDailyAnalytics", null);
        AddMiscData("allowRotation", false);
        AddMiscData("charIdUseMap", {});
        AddMiscData("drawShadows", true);
        AddMiscData("textBubbles", true);
        AddMiscData("showTradePopup", true);
        AddMiscData("paymentMethod", null);
        AddMiscData("filterLanguage", true);
        AddMiscData("showGuildInvitePopup", true);
        AddMiscData("showBeginnersOffer", false);
        AddMiscData("beginnersOfferTimeLeft", 0);
        AddMiscData("beginnersOfferShowNow", false);
        AddMiscData("beginnersOfferShowNowTime", 0);
        AddMiscData("watchForTutorialExit", false);
        AddMiscData("contextualClick", true);
        AddMiscData("inventorySwap", true);
        AddMiscData("hidePlayerChat", false);
        AddMiscData("chatStarRequirement", 0);
        AddMiscData("togglePercentage", false);
        AddMiscData("toggleBarText", true);
        AddMiscData("clickForGold", false);
        AddMiscData("rotationSpeed", 0.003);
        AddMiscData("focusSpeed", 0.3);
        AddMiscData("notif", true);
        AddMiscData("notifLocation", true);
        AddMiscData("currentSoundPack", "default");
        if (!ClientSaveData.hasOwnProperty("needsSurvey")) {
            ClientSaveData.needsSurvey = ClientSaveData.needsTutorial;
            switch (int((Math.random() * 5))) {
                case 0:
                    ClientSaveData.surveyDate = 0;
                    ClientSaveData.playTimeLeftTillSurvey = (5 * 60);
                    ClientSaveData.surveyGroup = "5MinPlaytime";
                    return;
                case 1:
                    ClientSaveData.surveyDate = 0;
                    ClientSaveData.playTimeLeftTillSurvey = (10 * 60);
                    ClientSaveData.surveyGroup = "10MinPlaytime";
                    return;
                case 2:
                    ClientSaveData.surveyDate = 0;
                    ClientSaveData.playTimeLeftTillSurvey = (30 * 60);
                    ClientSaveData.surveyGroup = "30MinPlaytime";
                    return;
                case 3:
                    ClientSaveData.surveyDate = (new Date().time + ((((1000 * 60) * 60) * 24) * 7));
                    ClientSaveData.playTimeLeftTillSurvey = (2 * 60);
                    ClientSaveData.surveyGroup = "1WeekRealtime";
                    return;
                case 4:
                    ClientSaveData.surveyDate = (new Date().time + ((((1000 * 60) * 60) * 24) * 14));
                    ClientSaveData.playTimeLeftTillSurvey = (2 * 60);
                    ClientSaveData.surveyGroup = "2WeekRealtime";
                    return;
            }
        }
    }

    private static function AddHotkeyData(_arg1:String, _arg2:uint):void
    {
        if (!ClientSaveData.hasOwnProperty(_arg1))
        {
            ClientSaveData[_arg1] = _arg2;
        }
        _C_o[_arg1] = true;
    }

    private static function AddMiscData(_arg1:String, _arg2:*):void
    {
        if (!ClientSaveData.hasOwnProperty(_arg1))
        {
            ClientSaveData[_arg1] = _arg2;
        }
    }

}
}//package com.company.PhoenixRealmClient.parameters

