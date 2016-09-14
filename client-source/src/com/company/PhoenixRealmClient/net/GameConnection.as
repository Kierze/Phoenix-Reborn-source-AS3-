package com.company.PhoenixRealmClient.net
{
import Frames.ItemResultBox;
import Frames.MoodChooser;
import Frames.TextInputForm;
import Frames.Unboxing.UnboxResultBox;

import Packets.fromClient.*;
import Packets.fromServer.*;

import Panels.InvitedToGuildPanel;
import Panels.PartyInvitePanel;
import Panels.TradeRequestPanel;

import ParticleAnimations.AoeEffect;
import ParticleAnimations.AreaBlastEffect;
import ParticleAnimations.BlastWaveEffect;
import ParticleAnimations.ConcentrateEffect;
import ParticleAnimations.DeadEffect;
import ParticleAnimations.DiffuseEffect;
import ParticleAnimations.FlowEffect;
import ParticleAnimations.LightningEffect;
import ParticleAnimations.ObjectEffect;
import ParticleAnimations.PotionEffect;
import ParticleAnimations.StreamEffect;
import ParticleAnimations.TeleportEffect;
import ParticleAnimations.ThrowEffect;
import ParticleAnimations.TrailEffect;
import ParticleAnimations.TrapEffect;

import _015.StatusText;
import _015._6T_;

import _0L_C_.Notif;
import _0L_C_.TwoButtonDialog;
import _0L_C_._02d;
import _0L_C_._aZ_;
import _0L_C_._gE_;

import _0M_H_._W_O_;
import _0M_H_._sN_;

import _8Q_._1l;

import _9R_._3E_;
import _9R_._D_X_;
import _9R_._J_F_;
import _9R_._j_;

import _G_A_.GameContext;

import _U_5._06a;
import _U_5._zz;

import _qN_.Account;

import _vf.MusicHandler;
import _vf.SFXHandler;

import _yY_.BeachBallEffect;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.map._X_l;
import com.company.PhoenixRealmClient.map._pf;
import com.company.PhoenixRealmClient.net.messages.data.ObjectStatusData;
import com.company.PhoenixRealmClient.net.messages.data.StatData;
import com.company.PhoenixRealmClient.net.messages.data._0H_9;
import com.company.PhoenixRealmClient.net.messages.data._iZ_;
import com.company.PhoenixRealmClient.objects.*;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.Ability;
import com.company.PhoenixRealmClient.ui.AbilityBox;
import com.company.PhoenixRealmClient.ui.Frame2Holder;
import com.company.PhoenixRealmClient.ui.FrameHolder;
import com.company.PhoenixRealmClient.ui._B_N_;
import com.company.PhoenixRealmClient.util.Currency;
import com.company.PhoenixRealmClient.util._wW_;
import com.company.net.Packet;
import com.company.net.ServerConnection;
import com.company.util.Random;
import com.company.util._L_2;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.Base64;
import com.hurlant.util.der.PEM;

import flash.display.BitmapData;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

public class GameConnection
    {

        public static const FAILURE:int = 0;
        public static const CREATE_SUCCESS:int = 31;
        public static const CREATE:int = 36;
        public static const PLAYERSHOOT:int = 38;
        public static const MOVE:int = 7;
        public static const PLAYERTEXT:int = 69;
        public static const TEXT:int = 25;
        public static const SHOOT:int = 13;
        public static const DAMAGE:int = 47;
        public static const UPDATE:int = 26;
        public static const PACKET:int = 11;
        public static const NOTIFICATION:int = 63;
        public static const NEW_TICK:int = 62;
        public static const INVSWAP:int = 65;
        public static const USEITEM:int = 30;
        public static const SHOW_EFFECT:int = 56;
        public static const HELLO:int = 17;
        public static const GOTO:int = 52;
        public static const INVDROP:int = 35;
        public static const INVRESULT:int = 4;
        public static const RECONNECT:int = 39;
        public static const PING:int = 6;
        public static const PONG:int = 16;
        public static const MAPINFO:int = 60;
        public static const LOAD:int = 45;
        public static const PIC:int = 28;
        public static const SETCONDITION:int = 10;
        public static const TELEPORT:int = 49;
        public static const USEPORTAL:int = 3;
        public static const DEATH:int = 41;
        public static const BUY:int = 50;
        public static const BUYRESULT:int = 27;
        public static const AOE_:int = 68;
        public static const GROUNDDAMAGE:int = 64;
        public static const PLAYERHIT:int = 24;
        public static const ENEMYHIT:int = 76;
        public static const AOEACK:int = 59;
        public static const SHOOTACK:int = 22;
        public static const OTHERHIT:int = 66;
        public static const SQUAREHIT:int = 51;
        public static const GOTOACK:int = 14;
        public static const EDITACCOUNTLIST:int = 53;
        public static const ACCOUNTLIST:int = 46;
        public static const QUESTOBJID:int = 34;
        public static const CHOOSENAME:int = 33;
        public static const NAMERESULT:int = 20;
        public static const CREATEGUILD:int = 15;
        public static const CREATEGUILDRESULT:int = 58;
        public static const GUILDREMOVE:int = 78;
        public static const GUILDINVITE:int = 8;
        public static const ALLYSHOOT:int = 74;
        public static const MULTISHOOT:int = 19;
        public static const REQUESTTRADE:int = 21;
        public static const TRADEREQUESTED:int = 61;
        public static const TRADESTART:int = 67;
        public static const CHANGETRADE:int = 37;
        public static const TRADECHANGED:int = 23;
        public static const ACCEPTTRADE:int = 57;
        public static const CANCELTRADE:int = 1;
        public static const TRADEDONE:int = 12;
        public static const TRADEACCEPTED:int = 18;
        public static const CLIENTSTAT:int = 75;
        public static const CHECKCREDITS:int = 48;
        public static const ESCAPE:int = 42;
        public static const FILE_:int = 55;
        public static const INVITEDTOGUILD:int = 77;
        public static const JOINGUILD:int = 5;
        public static const CHANGEGUILDRANK:int = 40;
        public static const PLAYSOUND:int = 44;
        public static const GLOBAL_NOTIFICATION:int = 9;
        public static const VISIBULLET:int = 80;
        public static const SWITCHMUSIC:int = 83;
        public static const CRAFT:int = 84;
        public static const INVITEDTOPARTY:int = 85;
        public static const JOINPARTY:int = 86;
        public static const PARTYINVITE:int = 87;
        public static const ITEMSELECTSTART:int = 88;
        public static const ITEMSELECTRESULT:int = 89;
        public static const ITEMRESULT:int = 90;
        public static const GETTEXTINPUT:int = 91;
        public static const TEXTINPUTRESULT:int = 92;
        public static const MARKETTRADE:int = 93;
        public static const MARKETTRADERESULT:int = 94;
        public static const MARKETCREATE:int = 95;
        public static const USEABILITY:int = 96;
        public static const CHANGESPEC:int = 97;
        public static const CHANGEMOOD:int = 98;
        public static const CHECKMOODS:int = 99;
        public static const CHECKMOODSRETURN:int = 100;
        public static const CAMERAUPDATE:int = 101;
        public static const UNBOXRESULT:int = 102;
        private static const _vb:Vector.<uint> = new <uint>[14802908, 0xFFFFFF, 0x545454];
        private static const _Z_y:Vector.<uint> = new <uint>[5644060, 16549442, 13484223];
        private static const _0A_F_:Vector.<uint> = new <uint>[2493110, 61695, 13880567];
        private static const _pS_:Vector.<uint> = new <uint>[0x3E8A00, 10944349, 13891532];
        private static const partyColors:Vector.<uint> = new <uint>[0x5656B7, 0x7474F7, 13880567];

        // Dynamic Bubble Colours
        private var colourChosen:String = "default";
        private const default_:Vector.<uint> = new <uint>[14802908, 0xFFFFFF, 0x545454]; // We need to add the default colours here.

        // Colors of the rainbow.
        private const red:Vector.<uint> = new <uint>[Colours.RED1, Colours.RED2, Colours.WHITE];
        private const orange:Vector.<uint> = new <uint>[Colours.ORANGE1, Colours.ORANGE2, Colours.WHITE];
        private const yellow:Vector.<uint> = new <uint>[Colours.YELLOW1, Colours.YELLOW2, Colours.WHITE];
        private const green:Vector.<uint> = new <uint>[Colours.GREEN1, Colours.GREEN2, Colours.WHITE];
        private const blue:Vector.<uint> = new <uint>[Colours.BLUE1, Colours.BLUE2, Colours.WHITE];

        private static var _0L_b:int = int.MIN_VALUE;//-2147483648

        public function GameConnection(_arg1:GameSprite, _arg2:Server, _arg3:int, _arg4:Boolean, _arg5:int, _arg6:int, _arg7:ByteArray, _arg8:String)
        {
            this.gs_ = _arg1;
            this.server_ = _arg2;
            this.gameId_ = _arg3;
            this._96 = _arg4;
            this.charId_ = _arg5;
            this.keyTime_ = _arg6;
            this.key_ = _arg7;
            this._2B_ = _arg8;
            this.Conn = new ServerConnection(false);
            this.Conn.DefineMsg(FAILURE, FailurePacket, this._GetFailurePacket);
            this.Conn.DefineMsg(CREATE_SUCCESS, CreateSuccessPacket, this._GetCreateSuccessPacket);
            this.Conn.DefineMsg(CREATE, CreatePacket, null);
            this.Conn.DefineMsg(PLAYERSHOOT, PlayerShootPacket, null);
            this.Conn.DefineMsg(MOVE, MovePacket, null);
            this.Conn.DefineMsg(PLAYERTEXT, PlayerTextPacket, null);
            this.Conn.DefineMsg(TEXT, TextPacket, this._GetTextPacket);
            this.Conn.DefineMsg(SHOOT, ShootPacket, this._GetShootPacket);
            this.Conn.DefineMsg(DAMAGE, DamagePacket, this._GetDamagePacket);
            this.Conn.DefineMsg(UPDATE, UpdatePacket, this._GetUpdatePacket);
            this.Conn.DefineMsg(PACKET, Packet, null);
            this.Conn.DefineMsg(NOTIFICATION, NotificationPacket, this._GetNotificationPacket);
            this.Conn.DefineMsg(GLOBAL_NOTIFICATION, GlobalNotificationPacket, this._GetGlobalNotificationPacket);
            this.Conn.DefineMsg(NEW_TICK, NewTickPacket, this._GetNewTickPacket);
            this.Conn.DefineMsg(INVSWAP, InvSwapPacket, null);
            this.Conn.DefineMsg(USEITEM, UseItemPacket, null);
            this.Conn.DefineMsg(SHOW_EFFECT, ShowEffectPacket, this._GetShowEffectPacket);
            this.Conn.DefineMsg(HELLO, HelloPacket, null);
            this.Conn.DefineMsg(GOTO, GotoPacket, this._GetGotoPacket);
            this.Conn.DefineMsg(INVDROP, InvDropPacket, null);
            this.Conn.DefineMsg(INVRESULT, InvResultPacket, this._GetInvResultPacket);
            this.Conn.DefineMsg(RECONNECT, ReconnectPacket, this._GetReconnectPacket);
            this.Conn.DefineMsg(PING, PingPacket, this._GetPingPacket);
            this.Conn.DefineMsg(PONG, PongPacket, null);
            this.Conn.DefineMsg(MAPINFO, MapInfoPacket, this._GetMapInfoPacket);
            this.Conn.DefineMsg(LOAD, LoadPacket, null);
            this.Conn.DefineMsg(PIC, PicPacket, this._GetPicPacket);
            this.Conn.DefineMsg(SETCONDITION, SetConditionPacket, null);
            this.Conn.DefineMsg(TELEPORT, TeleportPacket, null);
            this.Conn.DefineMsg(USEPORTAL, UsePortalPacket, null);
            this.Conn.DefineMsg(DEATH, DeathPacket, this._GetDeathPacket);
            this.Conn.DefineMsg(BUY, BuyPacket, null);
            this.Conn.DefineMsg(BUYRESULT, BuyResultPacket, this._GetBuyResultPacket);
            this.Conn.DefineMsg(AOE_, AOEPacket, this._GetAOEPacket);
            this.Conn.DefineMsg(GROUNDDAMAGE, GroundDamagePacket, null);
            this.Conn.DefineMsg(PLAYERHIT, PlayerHitPacket, null);
            this.Conn.DefineMsg(ENEMYHIT, EnemyHitPacket, null);
            this.Conn.DefineMsg(AOEACK, AOEAckPacket, null);
            this.Conn.DefineMsg(SHOOTACK, ShootAckPacket, null);
            this.Conn.DefineMsg(OTHERHIT, OtherHitPacket, null);
            this.Conn.DefineMsg(SQUAREHIT, SquareHitPacket, null);
            this.Conn.DefineMsg(GOTOACK, GotoAckPacket, null);
            this.Conn.DefineMsg(EDITACCOUNTLIST, EditAccountListPacket, null);
            this.Conn.DefineMsg(ACCOUNTLIST, AccountListPacket, this._GetAccountListPacket);
            this.Conn.DefineMsg(QUESTOBJID, QuestObjIdPacket, this._GetQuestObjIdPacket);
            this.Conn.DefineMsg(CHOOSENAME, ChooseNamePacket, null);
            this.Conn.DefineMsg(NAMERESULT, NameResultPacket, this._GetNameResultPacket);
            this.Conn.DefineMsg(CREATEGUILD, CreateGuildPacket, null);
            this.Conn.DefineMsg(CREATEGUILDRESULT, CreateGuildResultPacket, this._GetCreateGuildResultPacket);
            this.Conn.DefineMsg(GUILDREMOVE, GuildRemovePacket, null);
            this.Conn.DefineMsg(GUILDINVITE, GuildInvitePacket, null);
            this.Conn.DefineMsg(ALLYSHOOT, AllyShootPacket, this._GetAllyShootPacket);
            this.Conn.DefineMsg(MULTISHOOT, MultiShootPacket, this._GetMultiShootPacket);
            this.Conn.DefineMsg(REQUESTTRADE, RequestTradePacket, null);
            this.Conn.DefineMsg(TRADEREQUESTED, TradeRequestedPacket, this._GetTradeRequestedPacket);
            this.Conn.DefineMsg(TRADESTART, TradeStartPacket, this._GetTradeStartPacket);
            this.Conn.DefineMsg(CHANGETRADE, ChangeTradePacket, null);
            this.Conn.DefineMsg(TRADECHANGED, TradeChangedPacket, this._GetTradeChangedPacket);
            this.Conn.DefineMsg(ACCEPTTRADE, AcceptTradePacket, null);
            this.Conn.DefineMsg(CANCELTRADE, CancelTradePacket, null);
            this.Conn.DefineMsg(TRADEDONE, TradeDonePacket, this._GetTradeDonePacket);
            this.Conn.DefineMsg(TRADEACCEPTED, TradeAcceptedPacket, this._GetTradeAcceptedPacket);
            this.Conn.DefineMsg(CLIENTSTAT, ClientStatPacket, this._GetClientStatPacket);
            this.Conn.DefineMsg(CHECKCREDITS, CheckCreditsPacket, null);
            this.Conn.DefineMsg(ESCAPE, EscapePacket, null);
            this.Conn.DefineMsg(FILE_, FilePacket, this._GetFilePacket);
            this.Conn.DefineMsg(INVITEDTOGUILD, InvitedToGuildPacket, this._GetInvitedToGuildPacket);
            this.Conn.DefineMsg(JOINGUILD, JoinGuildPacket, null);
            this.Conn.DefineMsg(CHANGEGUILDRANK, ChangeGuildRankPacket, null);
            this.Conn.DefineMsg(PLAYSOUND, PlaySoundPacket, this._GetPlaySoundPacket);

            this.Conn.DefineMsg(CRAFT, CraftPacket, null);
            this.Conn.DefineMsg(VISIBULLET, VisibulletPacket, null);
            this.Conn.DefineMsg(SWITCHMUSIC, SwitchMusicPacket, this._GetSwitchMusicPacket);
            this.Conn.DefineMsg(INVITEDTOPARTY, InvitedToPartyPacket, this._GetInvitedToPartyPacket);
            this.Conn.DefineMsg(JOINPARTY, JoinPartyPacket, null);
            this.Conn.DefineMsg(PARTYINVITE, PartyInvitePacket, null);
            this.Conn.DefineMsg(ITEMSELECTSTART, ItemSelectStartPacket, this._GetItemSelectStartPacket);
            this.Conn.DefineMsg(ITEMSELECTRESULT, ItemSelectResultPacket, null);
            this.Conn.DefineMsg(ITEMRESULT, ItemResultPacket, this._GetItemResultPacket);
            this.Conn.DefineMsg(GETTEXTINPUT, GetTextInputPacket, this._GetTextInputPacket);
            this.Conn.DefineMsg(TEXTINPUTRESULT, TextInputResultPacket, null);
            this.Conn.DefineMsg(MARKETTRADE, MarketTradePacket, null);
            this.Conn.DefineMsg(MARKETTRADERESULT, MarketTradeResultPacket, this._GetMarketTradeResultPacket)
            this.Conn.DefineMsg(MARKETCREATE, MarketCreatePacket, null);
            this.Conn.DefineMsg(USEABILITY, UseAbilityPacket, null);
            this.Conn.DefineMsg(CHANGESPEC, ChangeSpecPacket, null);
            this.Conn.DefineMsg(CHANGEMOOD, ChangeMoodPacket, null);
            this.Conn.DefineMsg(CHECKMOODS, CheckMoodsPacket, null);
            this.Conn.DefineMsg(CHECKMOODSRETURN, CheckMoodsReturnPacket, this._GetCheckMoodsReturnPacket);
            this.Conn.DefineMsg(CAMERAUPDATE, CameraUpdatePacket, this._GetCameraUpdatePacket);
            this.Conn.DefineMsg(UNBOXRESULT, UnboxResultPacket, this._GetUnboxResultPacket);

            this.Conn.addEventListener(Event.CONNECT, this.OnConnect);
            this.Conn.addEventListener(Event.CLOSE, this.OnClose);
            this.Conn.addEventListener(ErrorEvent.ERROR, this.OnError);
        }
        public var gs_:GameSprite;
        public var server_:Server;
        public var gameId_:int;
        public var _96:Boolean;
        public var charId_:int;
        public var keyTime_:int;
        public var key_:ByteArray;
        public var _2B_:String;
        public var lastTickId_:int = -1;
        public var _0l:_17 = null;
        public var Conn:ServerConnection = null;
        public var outstandingBuy_:netCurrency = null;
        private var entityId:int = -1;
        private var _P_A_:Boolean = true;
        private var _7G_:Random = null;
        private var _0c:Timer;
        private var conTimes:int = 1;

        private var notifBox_:Notif;

        public function connect():void
        {
            this.gs_.textBox_.addText(Parameters.SendClient, ("Connecting to " + this.server_.name_));
            if (Parameters._wZ_)
            {
                this.Conn._7s("rc4", _L_2._Z_S_("311f80691451c71b09a13a2a6e"));
                this.Conn._wH_("rc4", _L_2._Z_S_("72c5583cafb6818995cbd74b80"));
            }
            this.Conn.connect(this.server_.address_, this.server_.port_);
        }

        public function getNextDamage(_arg1:uint, _arg2:uint):uint
        {
            return (this._7G_._0M_K_(_arg1, _arg2));
        }

        public function _9G_():void
        {
            if (this._0l == null)
            {
                this._0l = new _17();
            }
        }

        public function _rT_():void
        {
            if (this._0l != null)
            {
                this._0l = null;
            }
        }

        public function playerShoot(_arg1:int, _arg2:Projectile):void
        {
            var _local3:PlayerShootPacket = (this.Conn._Y_E_(PLAYERSHOOT) as PlayerShootPacket);
            _local3.time_ = _arg1;
            _local3.bulletId_ = _arg2.bulletId_;
            _local3.containerType_ = _arg2.containerType_;
            _local3.startingPos_.x_ = _arg2.x_;
            _local3.startingPos_.y_ = _arg2.y_;
            _local3.angle_ = _arg2.angle_;
            this.Conn.sendMessage(_local3);
        }

        public function playerHit(_arg1:int, _arg2:int):void
        {
            var _local3:PlayerHitPacket = (this.Conn._Y_E_(PLAYERHIT) as PlayerHitPacket);
            _local3.bulletId_ = _arg1;
            _local3.objectId_ = _arg2;
            this.Conn.sendMessage(_local3);
        }

        public function enemyHit(_arg1:int, _arg2:int, _arg3:int, _arg4:Boolean, _arg5:int):void
        {
            var _local5:EnemyHitPacket = (this.Conn._Y_E_(ENEMYHIT) as EnemyHitPacket);
            _local5.time_ = _arg1;
            _local5.bulletId_ = _arg2;
            _local5.targetId_ = _arg3;
            _local5.kill_ = _arg4;
            _local5.dmg_ = _arg5;
            this.Conn.sendMessage(_local5);
        }

        public function otherHit(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void
        {
            var _local5:OtherHitPacket = (this.Conn._Y_E_(OTHERHIT) as OtherHitPacket);
            _local5.time_ = _arg1;
            _local5.bulletId_ = _arg2;
            _local5.objectId_ = _arg3;
            _local5.targetId_ = _arg4;
            this.Conn.sendMessage(_local5);
        }

        public function squareHit(_arg1:int, _arg2:int, _arg3:int):void
        {
            var _local4:SquareHitPacket = (this.Conn._Y_E_(SQUAREHIT) as SquareHitPacket);
            _local4.time_ = _arg1;
            _local4.bulletId_ = _arg2;
            _local4.objectId_ = _arg3;
            this.Conn.sendMessage(_local4);
        }

        public function aoeAck(_arg1:int, _arg2:Number, _arg3:Number):void
        {
            var _local4:AOEAckPacket = (this.Conn._Y_E_(AOEACK) as AOEAckPacket);
            _local4.time_ = _arg1;
            _local4.position_.x_ = _arg2;
            _local4.position_.y_ = _arg3;
            this.Conn.sendMessage(_local4);
        }

        public function groundDamage(_arg1:int, _arg2:Number, _arg3:Number):void
        {
            var _local4:GroundDamagePacket = (this.Conn._Y_E_(GROUNDDAMAGE) as GroundDamagePacket);
            _local4.time_ = _arg1;
            _local4.position_.x_ = _arg2;
            _local4.position_.y_ = _arg3;
            this.Conn.sendMessage(_local4);
        }

        public function _eC_(_arg1:int):void
        {
            var _local2:ShootAckPacket = (this.Conn._Y_E_(SHOOTACK) as ShootAckPacket);
            _local2.time_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function playerText(_arg1:String):void
        {
            var _local2:PlayerTextPacket = (this.Conn._Y_E_(PLAYERTEXT) as PlayerTextPacket);
            _local2.text_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        /*public function invSwap(_arg1:int, _arg2:Number, _arg3:Number, _arg4:int, _arg5:int, _arg6:int, _arg7:int, _arg8:int, _arg9:int):void {
            var _local10:InvSwap_ = (this._08._Y_E_(INVSWAP) as InvSwap_);
            _local10.time_ = _arg1;
            _local10.position_.x_ = _arg2;
            _local10.position_.y_ = _arg3;
            _local10.slotObject1_.objectId_ = _arg4;
            _local10.slotObject1_.slotId_ = _arg5;
            _local10.slotObject1_.objectType_ = _arg6;
            _local10.slotObject2_.objectId_ = _arg7;
            _local10.slotObject2_.slotId_ = _arg8;
            _local10.slotObject2_.objectType_ = _arg9;
            this._08.sendMessage(_local10);
        }*/

        public function invSwap(_arg1:Player, _arg2:GameObject, _arg3:int, _arg4:int, _arg5:GameObject, _arg6:int, _arg7:int):Boolean
        {
            if (!gs_)
            {
                return (false);
            }
            var _local8:InvSwapPacket = (this.Conn._Y_E_(INVSWAP) as InvSwapPacket);
            _local8.time_ = gs_.lastUpdate_;
            _local8.position_.x_ = _arg1.x_;
            _local8.position_.y_ = _arg1.y_;
            _local8.slotObject1_.objectId_ = _arg2.objectId_;
            _local8.slotObject1_.slotId_ = _arg3;
            _local8.slotObject1_.objectType_ = _arg4;
            _local8.slotObject2_.objectId_ = _arg5.objectId_;
            _local8.slotObject2_.slotId_ = _arg6;
            _local8.slotObject2_.objectType_ = _arg7;
            this.Conn.sendMessage(_local8);
            var _local9:int = _arg2.equipment_[_arg3];
            var _local10:Object = _arg2.equipData_[_arg3];
            _arg2.equipData_[_arg3] = _arg5.equipData_[_arg6];
            _arg2.equipment_[_arg3] = _arg5.equipment_[_arg6];
            _arg5.equipment_[_arg6] = _local9;
            _arg5.equipData_[_arg6] = _local10;
            SFXHandler.play("inventory_move_item");
            return (true);
        }

        public function _8q(_arg1:int, _arg2:int, _arg3:int):void
        {
            var _local4:InvDropPacket = (this.Conn._Y_E_(INVDROP) as InvDropPacket);
            _local4.slotObject_.objectId_ = _arg1;
            _local4.slotObject_.slotId_ = _arg2;
            _local4.slotObject_.objectType_ = _arg3;
            this.Conn.sendMessage(_local4);
        }

        public function useItem(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:Number, _arg6:Number):void
        {
            var _local7:UseItemPacket = (this.Conn._Y_E_(USEITEM) as UseItemPacket);
            _local7.time_ = _arg1;
            _local7.slotObject_.objectId_ = _arg2;
            _local7.slotObject_.slotId_ = _arg3;
            _local7.slotObject_.objectType_ = _arg4;
            _local7.itemUsePos_.x_ = _arg5;
            _local7.itemUsePos_.y_ = _arg6;
            this.Conn.sendMessage(_local7);
        }

        public function _6v(_arg1:uint, _arg2:Number):void
        {
            var _local3:SetConditionPacket = (this.Conn._Y_E_(SETCONDITION) as SetConditionPacket);
            _local3.conditionEffect_ = _arg1;
            _local3.conditionDuration_ = _arg2;
            this.Conn.sendMessage(_local3);
        }

        public function move(_arg1:int, _arg2:Player):void
        {
            var _local7:int;
            var _local8:int;
            var _local3:Number = -1;
            var _local4:Number = -1;
            if (((!((_arg2 == null))) && (!(_arg2._EntityIsPausedEff()))))
            {
                _local3 = _arg2.x_;
                _local4 = _arg2.y_;
            }
            var _local5:MovePacket = (this.Conn._Y_E_(MOVE) as MovePacket);
            _local5.tickId_ = _arg1;
            _local5.time_ = this.gs_.lastUpdate_;
            _local5.newPosition_.x_ = _local3;
            _local5.newPosition_.y_ = _local4;
            var _local6:int = this.gs_.moveRecords_.lastClearTime_;
            _local5.records_.length = 0;
            if ((((_local6 >= 0)) && (((_local5.time_ - _local6) > 125))))
            {
                _local7 = Math.min(10, this.gs_.moveRecords_.records_.length);
                _local8 = 0;
                while (_local8 < _local7)
                {
                    if (this.gs_.moveRecords_.records_[_local8].time_ >= (_local5.time_ - 25)) break;
                    _local5.records_.push(this.gs_.moveRecords_.records_[_local8]);
                    _local8++;
                }
            }
            this.gs_.moveRecords_.clear(_local5.time_);
            this.Conn.sendMessage(_local5);
            _arg2._01w();
        }

        public function teleport(_arg1:int):void
        {
            var _local2:TeleportPacket = (this.Conn._Y_E_(TELEPORT) as TeleportPacket);
            _local2.objectId_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function usePortal(_arg1:int):void
        {
            var _local2:UsePortalPacket = (this.Conn._Y_E_(USEPORTAL) as UsePortalPacket);
            _local2.objectId_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function buy(_arg1:int):void
        {
            if (this.outstandingBuy_ != null)
            {
                return;
            }
            var _local2:SellableObject = this.gs_.map_.goDict_[_arg1];
            if (_local2 == null)
            {
                return;
            }
            var _local3:Boolean;
            if (_local2.currency_ == Currency.CREDITS)
            {
                _local3 = ((((this.gs_.charList_.converted_) || ((this.gs_.map_.player_.credits_ > 100)))) || ((_local2.price_ > this.gs_.map_.player_.credits_)));
            }
            this.outstandingBuy_ = new netCurrency(_local2.soldObjectInternalName(), _local2.price_, _local2.currency_, _local3);
            var _local4:BuyPacket = (this.Conn._Y_E_(BUY) as BuyPacket);
            _local4.objectId_ = _arg1;
            this.Conn.sendMessage(_local4);
        }

        public function _S__(_arg1:int):void
        {
            var _local2:GotoAckPacket = (this.Conn._Y_E_(GOTOACK) as GotoAckPacket);
            _local2.time_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _eH_(_arg1:int, _arg2:Boolean, _arg3:int):void
        {
            var _local4:EditAccountListPacket = (this.Conn._Y_E_(EDITACCOUNTLIST) as EditAccountListPacket);
            _local4.accountListId_ = _arg1;
            _local4.add_ = _arg2;
            _local4.objectId_ = _arg3;
            this.Conn.sendMessage(_local4);
        }

        public function _K_Q_(_arg1:String):void
        {
            var _local2:ChooseNamePacket = (this.Conn._Y_E_(CHOOSENAME) as ChooseNamePacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _S_W_(_arg1:String):void
        {
            var _local2:CreateGuildPacket = (this.Conn._Y_E_(CREATEGUILD) as CreateGuildPacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function guildRemove(_arg1:String):void
        {
            var _local2:GuildRemovePacket = (this.Conn._Y_E_(GUILDREMOVE) as GuildRemovePacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _H_X_(_arg1:String):void
        {
            var _local2:GuildInvitePacket = (this.Conn._Y_E_(GUILDINVITE) as GuildInvitePacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function partyInvite(_arg1:String):void
        {
            var _local2:PartyInvitePacket = (this.Conn._Y_E_(PARTYINVITE) as PartyInvitePacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function requestTrade(_arg1:String):void
        {
            var _local2:RequestTradePacket = (this.Conn._Y_E_(REQUESTTRADE) as RequestTradePacket);
            _local2.name_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _rQ_(_arg1:Vector.<Boolean>):void
        {
            var _local2:ChangeTradePacket = (this.Conn._Y_E_(CHANGETRADE) as ChangeTradePacket);
            _local2.offer_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _E_i(_arg1:Vector.<Boolean>, _arg2:Vector.<Boolean>):void
        {
            var _local3:AcceptTradePacket = (this.Conn._Y_E_(ACCEPTTRADE) as AcceptTradePacket);
            _local3.myOffer_ = _arg1;
            _local3.yourOffer_ = _arg2;
            this.Conn.sendMessage(_local3);
        }

        public function selectItem(_arg1:int):void
        {
            var _local3:ItemSelectResultPacket = (this.Conn._Y_E_(ITEMSELECTRESULT) as ItemSelectResultPacket);
            _local3.slot_ = _arg1;
            this.Conn.sendMessage(_local3);
        }

        public function textInputResult(_arg1:Boolean, _arg2:String, _arg3:String):void
        {
            var _local3:TextInputResultPacket = (this.Conn._Y_E_(TEXTINPUTRESULT) as TextInputResultPacket);
            _local3.success_ = _arg1;
            _local3.action_ = _arg2;
            _local3.input_ = _arg3;
            this.Conn.sendMessage(_local3);
        }

        public function marketTrade(_arg1:int):void
        {
            var _local3:MarketTradePacket = (this.Conn._Y_E_(MARKETTRADE) as MarketTradePacket);
            _local3.tradeId_ = _arg1;
            this.Conn.sendMessage(_local3);
        }

        public function marketCreate(_arg1:Vector.<int>, _arg2:Vector.<int>, _arg3:Vector.<Object>):void
        {
            var _local3:MarketCreatePacket = (this.Conn._Y_E_(MARKETCREATE) as MarketCreatePacket);
            _local3.includedSlots_ = _arg1;
            _local3.requestItems_ = _arg2;
            _local3.requestData_ = _arg3;
            this.Conn.sendMessage(_local3);
        }

        public function __set():void
        {
            this.Conn.sendMessage(this.Conn._Y_E_(CANCELTRADE));
        }

        public function _0J_l():void
        {
            this.Conn.sendMessage(this.Conn._Y_E_(CHECKCREDITS));
        }

        public function _M_6():void
        {
            if (this.entityId == -1)
            {
                return;
            }
            if(this.server_.name_ == "Nexus")
            {
                this.gs_.textBox_.addText(Parameters.SendInfo, "You are already in the nexus!");
                return;
            }
            if(!this.gs_.map_.player_.canNexus)
            {
                this.gs_.textBox_.addText(Parameters.SendInfo, "You cannot nexus now!");
                return;
            }
            //this._08.sendMessage(this._08._Y_E_(ESCAPE));
            var _local2:_j_ = new _j_(new Server("Nexus", this.server_.address_, this.server_.port_), -2, this._96, this.charId_, 0, new ByteArray());
            this.gs_.dispatchEvent(_local2);
        }

        public function joinGuild(_arg1:String):void
        {
            var _local2:JoinGuildPacket = (this.Conn._Y_E_(JOINGUILD) as JoinGuildPacket);
            _local2.guildName_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function joinParty(_arg1:int):void
        {
            var _local2:JoinPartyPacket = (this.Conn._Y_E_(JOINPARTY) as JoinPartyPacket);
            _local2.partyID_ = _arg1;
            this.Conn.sendMessage(_local2);
        }

        public function _k8(_arg1:String, _arg2:int):void
        {
            var _local3:ChangeGuildRankPacket = (this.Conn._Y_E_(CHANGEGUILDRANK) as ChangeGuildRankPacket);
            _local3.name_ = _arg1;
            _local3.guildRank_ = _arg2;
            this.Conn.sendMessage(_local3);
        }

        public function craftItems(_arg1:int):void
        {
            var _loc2_:CraftPacket = this.Conn._Y_E_(CRAFT) as CraftPacket;
            _loc2_.objectId_ = _arg1;
            this.Conn.sendMessage(_loc2_);
        }

        public function sendVisibullet(_damage:int, _penetration:int, _enemyId:int, _bulletId:int, _armorPiercing:Boolean):void
        {
            var _packet:VisibulletPacket = this.Conn._Y_E_(VISIBULLET) as VisibulletPacket;
            _packet.damage_ = _damage;
            _packet.penetration_ = _penetration;
            _packet.enemyId_ = _enemyId;
            _packet.bulletId_ = _bulletId;
            _packet.armorPiercing_ = _armorPiercing;
            this.Conn.sendMessage(_packet);
        }

        public function useAbility(_arg1:int, _arg2:int, _arg3:Number, _arg4:Number):void {
            var _local7:UseAbilityPacket = (this.Conn._Y_E_(USEABILITY) as UseAbilityPacket);
            _local7.time_ = _arg1;
            _local7.ability_ = _arg2;
            _local7.itemUsePos_.x_ = _arg3;
            _local7.itemUsePos_.y_ = _arg4;
            this.Conn.sendMessage(_local7);
        }

        public function changeSpec(_arg1:String):void {
            var _local1:ChangeSpecPacket = (this.Conn._Y_E_(CHANGESPEC) as ChangeSpecPacket);
            _local1.specName_ = _arg1;
            this.Conn.sendMessage(_local1);
        }

        public function changeMood(_arg1:String):void {
            var output:ChangeMoodPacket = (this.Conn._Y_E_(CHANGEMOOD) as ChangeMoodPacket);
            output.moodName_ = _arg1;
            this.Conn.sendMessage(output);
        }

        public function checkMoods():void{
            var output:CheckMoodsPacket =  (this.Conn._Y_E_(CHECKMOODS) as CheckMoodsPacket);
            this.Conn.sendMessage(output);
        }

        private function _sM_():void
        {
            _zz.instance.dispatch();
        }

        private function create():void
        {
            var _local1:CreatePacket = (this.Conn._Y_E_(CREATE) as CreatePacket);
            _local1.objectType_ = Parameters.ClientSaveData.playerObjectType;
            this.Conn.sendMessage(_local1);
        }

        private function load():void
        {
            var _local1:LoadPacket = (this.Conn._Y_E_(LOAD) as LoadPacket);
            _local1.charId_ = this.charId_;
            this.Conn.sendMessage(_local1);
        }

        private function _J_X_(_arg1:String):String
        {
            var _local2:RSAKey = PEM.readRSAPublicKey(Parameters.RSAKey);
            var _local3:ByteArray = new ByteArray();
            _local3.writeUTFBytes(_arg1);
            var _local4:ByteArray = new ByteArray();
            _local2.encrypt(_local3, _local4, _local3.length);
            return (Base64.encodeByteArray(_local4));
        }

        private function _GetCreateSuccessPacket(_arg1:CreateSuccessPacket):void
        {
            this.entityId = _arg1.objectId_;
            this.charId_ = _arg1.charId_;
            this.gs_.initialize();
            this._96 = false;
        }

        private function _GetDamagePacket(packet:DamagePacket):void
        {
            var projId:int;
            var map:_X_l = this.gs_.map_;
            var proj:Projectile;
            if ((packet.objectId_ >= 0) && (packet.bulletId_ > 0))
            {
                projId = Projectile.getProjectileId_(packet.objectId_, packet.bulletId_);
                proj = (map.objects_[projId] as Projectile);

                if (proj != null && !proj.descs.multiHit) //Removes the listed projectile from the client collision if not MultiHit
                {
                    map.removeObj(projId);
                }
            }
            var target:GameObject = map.goDict_[packet.targetId_];
            if (target != null)
            {
                target.postDamageEffects(-1, packet.damageAmount_, packet.effects_, packet.kill_, proj);
            }
        }

        private function _GetShootPacket(packet:ShootPacket):void
        {

            var isOwner:Boolean = (packet.ownerId_ == this.entityId);
            var _local3:GameObject = this.gs_.map_.goDict_[packet.ownerId_];
            if (_local3 == null || _local3.dead)
            {
                if (isOwner)
                {
                    this._eC_(-1);
                }
                return;
            }
            var proj:Projectile = (_wW_._B_1(Projectile) as Projectile);
            var player:Player = this.gs_.map_.player_;
            proj.reset(packet.containerType_, 0, packet.ownerId_, packet.bulletId_, packet.angle_, this.gs_.lastUpdate_, packet.fromAbility_);
            proj.damageIs(packet.damage_);
            if (packet.hasFormula_) proj = Formula.CalculateProjectileFormulas(proj, (player.aptitude_ + player._aptitudeBonus));
            this.gs_.map_.addObj(proj, packet.startingPos_.x_, packet.startingPos_.y_);
            if (isOwner)
            {
                this._eC_(this.gs_.lastUpdate_);
            }
        }

        private function _GetAllyShootPacket(_arg1:AllyShootPacket):void
        {
            var _local2:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
            if ((((_local2 == null)) || (_local2.dead)))
            {
                return;
            }
            var _local3:Projectile = (_wW_._B_1(Projectile) as Projectile);
            _local3.reset(_arg1.containerType_, 0, _arg1.ownerId_, _arg1.bulletId_, _arg1.angle_, this.gs_.lastUpdate_);
            _local3.damageIs(_arg1.dmg_);
            this.gs_.map_.addObj(_local3, _local2.x_, _local2.y_);
            _local2.setAttack(_arg1.containerType_, _arg1.angle_);
        }

        private function _GetMultiShootPacket(_arg1:MultiShootPacket):void
        {
            var proj:Projectile;
            var angle:Number;
            var owner:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
            if (owner == null || owner.dead)
            {
                this._eC_(-1);
                return;
            }
            var count:int = 0;
            while (count < _arg1.numShots_)
            {
                proj = (_wW_._B_1(Projectile) as Projectile);
                angle = (_arg1.angle_ + (_arg1.angleInc_ * count));
                proj.reset(owner.objectType_, _arg1.bulletType_, _arg1.ownerId_, ((_arg1.bulletId_ + count) % 0x0100), angle, this.gs_.lastUpdate_);
                proj.damageIs(_arg1.damage_);
                this.gs_.map_.addObj(proj, _arg1.startingPos_.x_, _arg1.startingPos_.y_);
                count++;
            }
            this._eC_(this.gs_.lastUpdate_);
            owner.setAttack(owner.objectType_, (_arg1.angle_ + (_arg1.angleInc_ * ((_arg1.numShots_ - 1) / 2))));
        }

        private function _GetTradeRequestedPacket(_arg1:TradeRequestedPacket):void
        {
            if (Parameters.ClientSaveData.showTradePopup)
            {
                this.gs_.HudView._U_T_._j(new TradeRequestPanel(this.gs_, _arg1.name_));
            }
            this.gs_.textBox_.addText("", ((((_arg1.name_ + " wants to ") + 'trade with you.  Type "/trade ') + _arg1.name_) + '" to trade.'));
        }

        private function _GetTradeStartPacket(_arg1:TradeStartPacket):void
        {
            this.gs_.HudView._0L_v(_arg1);
        }

        private function _GetItemSelectStartPacket(_arg1:ItemSelectStartPacket):void
        {
            this.gs_.HudView.selectItem(_arg1);
        }


        private function _GetTradeChangedPacket(_arg1:TradeChangedPacket):void
        {
            this.gs_.HudView._ss(_arg1);
        }

        private function _GetTradeDonePacket(_arg1:TradeDonePacket):void
        {
            this.gs_.HudView._A_a();
            this.gs_.textBox_.addText("", _arg1.description_);
        }

        private function _GetTradeAcceptedPacket(_arg1:TradeAcceptedPacket):void
        {
            this.gs_.HudView._mH_(_arg1);
        }

        private function _lu(_arg1:_0H_9):void
        {
            var _local2:_X_l = this.gs_.map_;
            var _local3:GameObject = ObjectLibrary._075(_arg1.objectType_);
            if (_local3 == null)
            {
                return;
            }
            var _local4:ObjectStatusData = _arg1._zM_;
            _local3.setObjectId(_local4.objectId_);
            _local2.addObj(_local3, _local4.pos_.x_, _local4.pos_.y_);
            if (_local3.objectId_ == this.entityId)
            {
                _local2.player_ = (_local3 as Player);
            }
            this._9s(_local4, 0, -1);
            if (((((_local3.props_.static_) && (_local3.props_.occupySquare_))) && (!(_local3.props_.noMiniMap))))
            {
                this.gs_.HudView.Minimap_._0A_R_(_local3.x_, _local3.y_, _local3);
            }
        }

        private function _GetUpdatePacket(_arg1:UpdatePacket):void
        {
            var _local3:int;
            var _local4:_iZ_;
            var _local2:Packet = this.Conn._Y_E_(PACKET);
            this.Conn.sendMessage(_local2);
            _local3 = 0;
            while (_local3 < _arg1.tiles_.length)
            {
                _local4 = _arg1.tiles_[_local3];
                this.gs_.map_.setGroundTile(_local4.x_, _local4.y_, _local4.type_);
                this.gs_.HudView.Minimap_.setGroundTile(_local4.x_, _local4.y_, _local4.type_);
                _local3++;
            }
            _local3 = 0;
            while (_local3 < _arg1.newObjs_.length)
            {
                this._lu(_arg1.newObjs_[_local3]);
                _local3++;
            }
            _local3 = 0;
            while (_local3 < _arg1.drops_.length)
            {
                this.gs_.map_.removeObj(_arg1.drops_[_local3]);
                _local3++;
            }
        }

        private function _GetNotificationPacket(_arg1:NotificationPacket):void
        {
            var _local2:GameObject = this.gs_.map_.goDict_[_arg1.objectId_];
            if (_local2 != null)
            {
                this.gs_.map_.mapOverlay_.addChild(new StatusText(_local2, _arg1.text_, _arg1.color_, 2000));
                if ((((_local2 == this.gs_.map_.player_)) && ((_arg1.text_ == "Quest Complete!"))))
                {
                    this.gs_.map_.quest_.completed();
                }
            }
        }

        private function _GetGlobalNotificationPacket(_arg1:GlobalNotificationPacket):void
        {
            var _local1:Object = JSON.parse(_arg1.text);
            switch (_local1.type) {
                case "yellow":
                    _sN_.instance.dispatch(_1l._0v);
                    return;
                case "red":
                    _sN_.instance.dispatch(_1l._05c);
                    return;
                case "green":
                    _sN_.instance.dispatch(_1l._h2);
                    return;
                case "purple":
                    _sN_.instance.dispatch(_1l._M_C_);
                    return;
                case "showKeyUI":
                    _W_O_.instance.dispatch();
                    return;
                case "notif":
                    if (Parameters.ClientSaveData.notif)
                        this.notif_(_arg1);
                    return;
                case "beginnersPackage":
                    return;
            }
        }

        private function notif_(_arg1:GlobalNotificationPacket):void
        {
            this.notifBox_ = new Notif(_arg1, this.gs_);
            this.gs_.addChild(this.notifBox_);
        }

        private function _GetNewTickPacket(_arg1:NewTickPacket):void
        {
            var _local3:ObjectStatusData;
            if (this._0l != null)
            {
                this._0l._06m();
            }
            var _local2:_X_l = this.gs_.map_;
            this.move(_arg1.tickId_, _local2.player_);
            for each (_local3 in _arg1.statuses_)
            {
                this._9s(_local3, _arg1.tickTime_, _arg1.tickId_);
            }
            this.lastTickId_ = _arg1.tickId_;
        }

        private function _GetShowEffectPacket(_arg1:ShowEffectPacket):void
        {
            var _local3:GameObject;
            var _local4:ObjectEffect;
            var _local5:Point;
            var _local6:Point;
            var _local2:_X_l = this.gs_.map_;
            switch (_arg1.effectType_) {
                case ShowEffectPacket.Potion:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local2.addObj(new PotionEffect(_local3, _arg1.color_), _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Teleport:
                    _local2.addObj(new TeleportEffect(), _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.Stream:
                    _local4 = new StreamEffect(_arg1.pos1_, _arg1.pos2_, _arg1.color_);
                    _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.Throw:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    _local5 = (((_local3) != null) ? new Point(_local3.x_, _local3.y_) : _arg1.pos2_._point());
                    _local4 = new ThrowEffect(_local5, _arg1.pos1_._point(), _arg1.color_);
                    _local2.addObj(_local4, _local5.x, _local5.y);
                    return;
                case ShowEffectPacket.AreaBlast:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new AreaBlastEffect(_local3, _arg1.pos1_.x_, _arg1.color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Dead:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new DeadEffect(_local3, _arg1.color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Trail:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new TrailEffect(_local3, _arg1.pos1_, _arg1.color_);
                    _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.Diffuse:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new DiffuseEffect(_local3, _arg1.pos1_, _arg1.pos2_, _arg1.color_);
                    _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.Flow:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new FlowEffect(_arg1.pos1_, _local3, _arg1.color_);
                    _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.Trap:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new TrapEffect(_local3, _arg1.pos1_.x_, _arg1.color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Lightning:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new LightningEffect(_local3, _arg1.pos1_, _arg1.color_, _arg1.pos2_.x_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Concentrate:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new ConcentrateEffect(_arg1.pos1_, _arg1.pos2_, _arg1.color_);
                    _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.BlastWave:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local4 = new BlastWaveEffect(_local3, _arg1.pos1_, _arg1.pos2_.x_, _arg1.color_);
                    _local2.addObj(_local4, _local3.x_, _local3.y_);
                    return;
                case ShowEffectPacket.Earthquake:
                    this.gs_.camera_._uE_();
                    return;
                case ShowEffectPacket.Flashing:
                    _local3 = _local2.goDict_[_arg1.targetObjectId_];
                    if (_local3 == null) break;
                    _local3._B_t = new FlashingEffect(getTimer(), _arg1.color_, _arg1.pos1_.x_, _arg1.pos1_.y_);
                    return;
                case ShowEffectPacket.BeachBall:
                    _local5 = _arg1.pos1_._point();
                    _local6 = _arg1.pos2_._point();
                    _local4 = new BeachBallEffect(_arg1.pos2_._point(), _arg1.pos1_._point());
                    _local2.addObj(_local4, _local5.x, _local5.y);
                    return;
            }
        }

        private function _GetGotoPacket(_arg1:GotoPacket):void
        {
            this._S__(this.gs_.lastUpdate_);
            var _local2:GameObject = this.gs_.map_.goDict_[_arg1.objectId_];
            if (_local2 == null) {
                return;
            }
            _local2._gk(_arg1.pos_.x_, _arg1.pos_.y_, this.gs_.lastUpdate_);
        }

        private function _066(_arg1:GameObject, _arg2:Vector.<StatData>, _arg3:Boolean):void
        {
            var _local4:StatData;
            var _local8:int;
            var _local9:int;
            for each (_local4 in _arg2)
            {
                _local8 = _local4._h;
                switch (_local4._0F_4)
                {
                    case StatData.MaximumHP:
                        _arg1.maxHP_ = _local8;
                        break;
                    case StatData.HP:
                        _arg1.HP_ = _local8;
                        break;
                    case StatData.Size:
                        _arg1.size_ = _local8;
                        break;
                    case StatData.MaximumMP:
                        (_arg1 as Player).maxMP_ = _local8;
                        break;
                    case StatData.MP:
                        (_arg1 as Player).MP_ = _local8;
                        break;
                    case StatData.ExperienceGoal:
                        (_arg1 as Player)._7V_ = _local8;
                        break;
                    case StatData.Experience:
                        (_arg1 as Player).exp_ = _local8;
                        break;
                    case StatData.Level:
                        _arg1.level_ = _local8;
                        break;
                    case StatData.Attack:
                        (_arg1 as Player).attack_ = _local8;
                        break;
                    case StatData.Defense:
                        _arg1.defense_ = _local8;
                        break;
                    case StatData.Speed:
                        (_arg1 as Player).speed_ = _local8;
                        break;
                    case StatData.Dexterity:
                        (_arg1 as Player).dexterity_ = _local8;
                        break;
                    case StatData.Vitality:
                        (_arg1 as Player).vitality_ = _local8;
                        break;
                    case StatData.Wisdom:
                        (_arg1 as Player).wisdom_ = _local8;
                        break;
                    case StatData.Effects:
                        _arg1.condEffects = _local8;
                        break;
                    case StatData.InvData_0:
                    case StatData.InvData_1:
                    case StatData.InvData_2:
                    case StatData.InvData_3:
                    case StatData.InvData_4:
                    case StatData.InvData_5:
                    case StatData.InvData_6:
                    case StatData.InvData_7:
                    case StatData.InvData_8:
                    case StatData.InvData_9:
                    case StatData.InvData_10:
                    case StatData.InvData_11:
                        _arg1.equipData_[(_local4._0F_4 - StatData.InvData_0)] = JSON.parse(_local4._3x);
                        break;
                    case StatData.Inventory_0:
                    case StatData.Inventory_1:
                    case StatData.Inventory_2:
                    case StatData.Inventory_3:
                    case StatData.Inventory_4:
                    case StatData.Inventory_5:
                    case StatData.Inventory_6:
                    case StatData.Inventory_7:
                    case StatData.Inventory_8:
                    case StatData.Inventory_9:
                    case StatData.Inventory_10:
                    case StatData.Inventory_11:
                        _arg1.equipment_[(_local4._0F_4 - StatData.Inventory_0)] = _local8;
                        break;
                    case StatData.Stars:
                        (_arg1 as Player).numStars_ = _local8;
                        break;
                    case StatData.Name:
                        if (_arg1.name_ != _local4._3x) {
                            _arg1.name_ = _local4._3x;
                            _arg1._U_g = null;
                        }
                        break;
                    case StatData.Texture_1:
                        _arg1.setTex1(_local8);
                        break;
                    case StatData.Texture_2:
                        _arg1.setTex2(_local8);
                        break;
                    case StatData.MerchantMerchandiseType:
                        (_arg1 as Merchant).setMerchandiseType(_local8);
                        break;
                    case StatData.Credits:
                        (_arg1 as Player)._F_S_(_local8);
                        break;
                    case StatData.SellablePrice:
                        (_arg1 as SellableObject).setPrice(_local8);
                        break;
                    case StatData.PortalUsable:
                        (_arg1 as Portal)._09S_ = !((_local8 == 0));
                        break;
                    case StatData.AccountId:
                        (_arg1 as Player).accountId_ = _local8;
                        break;
                    case StatData.CurrentFame:
                        (_arg1 as Player).fame_ = _local8;
                        break;
                    case StatData.SellablePriceCurrency:
                        (_arg1 as SellableObject)._gF_(_local8);
                        break;
                    case StatData.ObjectConnection:
                        _arg1._O_l = _local8;
                        break;
                    case StatData.MerchantRemainingCount:
                        (_arg1 as Merchant)._1I_ = _local8;
                        (_arg1 as Merchant)._z5 = 0;
                        break;
                    case StatData.MerchantRemainingMinute:
                        (_arg1 as Merchant)._gt = _local8;
                        (_arg1 as Merchant)._z5 = 0;
                        break;
                    case StatData.MerchantDiscount:
                        (_arg1 as Merchant)._S_I_ = _local8;
                        (_arg1 as Merchant)._z5 = 0;
                        break;
                    case StatData.SellableRankRequirement:
                        (_arg1 as SellableObject).setRankReq(_local8);
                        break;
                    case StatData.HPBoost:
                        (_arg1 as Player)._P_7 = _local8;
                        break;
                    case StatData.MPBoost:
                        (_arg1 as Player)._0D_G_ = _local8;
                        break;
                    case StatData.AttackBonus:
                        (_arg1 as Player)._attBonus = _local8;
                        break;
                    case StatData.DefenseBonus:
                        (_arg1 as Player)._defBonus = _local8;
                        break;
                    case StatData.SpeedBonus:
                        (_arg1 as Player)._spdBonus = _local8;
                        break;
                    case StatData.VitalityBonus:
                        (_arg1 as Player)._vitBonus = _local8;
                        break;
                    case StatData.WisdomBonus:
                        (_arg1 as Player)._wisBonus = _local8;
                        break;
                    case StatData.DexterityBonus:
                        (_arg1 as Player)._dexBonus = _local8;
                        break;
                    case StatData.OwnerAccountId:
                        (_arg1 as Container)._75(_local8);
                        break;
                    case StatData.NameChangerStar:
                        (_arg1 as NameChanger)._Y__(_local8);
                        break;
                    case StatData.NameChosen:
                        (_arg1 as Player).NameChosen = !((_local8 == 0));
                        _arg1._U_g = null;
                        break;
                    case StatData.Fame:
                        (_arg1 as Player)._0L_o = _local8;
                        break;
                    case StatData.FameGoal:
                        (_arg1 as Player)._n8 = _local8;
                        break;
                    case StatData.Glowing:
                        (_arg1 as Player)._2v = _local8;
                        break;
                    case StatData.SinkOffset:
                        if (!_arg3) {
                            (_arg1 as Player)._0F_ = _local8;
                        }
                        break;
                    case StatData.AltTextureIndex:
                        _arg1._5w(_local8);
                        break;
                    case StatData.Guild:
                        (_arg1 as Player)._Y_C_(_local4._3x);
                        break;
                    case StatData.GuildRank:
                        (_arg1 as Player).guildRank_ = _local8;
                        break;
                    case StatData.OxygenBar:
                        (_arg1 as Player)._R_4 = _local8;
                        break;
                    case StatData.XpBoost:
                        (_arg1 as Player)._gz = _local8;
                        break;
                    case StatData.Skin:
                        _arg1.setSkin(_local8);
                        break;
                    //case StatData.VACANT: // 67
                    //    break;
                    //case StatData.VACANT: // 68
                    //    break;
                    case StatData.Silver:
                        (_arg1 as Player).setSilver(_local8);
                        break;
                    case StatData.CanNexus:
                        (_arg1 as Player).canNexus = _local8 != 0;
                        break;
                    case StatData.Party:
                        (_arg1 as Player).UpdateParty(_local8);
                        break;
                    case StatData.PartyLeader:
                        (_arg1 as Player).partyLeader = _local8 != 0;
                        break;
                    case StatData.Effect:
                        (_arg1 as Player).setEffect(_local4._3x);
                        break;
                    case StatData.Ability_1:
                    case StatData.Ability_2:
                    case StatData.Ability_3:
                        (_arg1 as Player).abilities[int(_local4._0F_4 - StatData.Ability_1)] = _local8;
                        break;
                    case StatData.AbilityCD_1:
                    case StatData.AbilityCD_2:
                    case StatData.AbilityCD_3:
                        (_arg1 as Player).abilityCooldowns[int(_local4._0F_4 - StatData.AbilityCD_1)] = _local8;
                        break;
                    case StatData.Specialization:
                        _arg1.spec_ = _local4._3x;
                        break;
                    case StatData.Mood:
                        _arg1.mood_ = _local4._3x;
                        break;
                    case StatData.Aptitude:
                        (_arg1 as Player).aptitude_ = _local8;
                        break;
                    case StatData.AptitudeBonus:
                        (_arg1 as Player)._aptitudeBonus = _local8;
                        break;
                    case StatData.Resilience:
                        _arg1.resilience_ = _local8;
                        break;
                    case StatData.ResilienceBonus:
                        (_arg1 as Player)._resBonus = _local8;
                        break;
                    case StatData.Penetration:
                        (_arg1 as Player).penetration_ = _local8;
                        break;
                    case StatData.PenetrationBonus:
                        (_arg1 as Player)._penBonus = _local8;
                        break;
                    case StatData.AbilityAD_1:
                    case StatData.AbilityAD_2:
                    case StatData.AbilityAD_3:
                        (_arg1 as Player).abilityActiveDurations[int(_local4._0F_4 - StatData.AbilityAD_1)] = _local8;
                        break;
                    case StatData.AbilityToggle:
                        for (var count:int = 0; count < 3; count++)
                        {
                            (_arg1 as Player).abilityToggles[count] = ((_local8 & uint(1 << count)) != 0);
                        }
                        break;
                    case StatData.ChatBubbleColour:
                        colourChosen = _local4._3x;
                        break;
                }
            }
        }

        private function _9s(_arg1:ObjectStatusData, _arg2:int, _arg3:int):void
        {
            var _local8:int;
            var _local9:int;
            var _local10:Array;
            var _local4:_X_l = this.gs_.map_;
            var _local5:GameObject = _local4.goDict_[_arg1.objectId_];
            if (_local5 == null)
            {
                return;
            }
            var _local6 = (_arg1.objectId_ == this.entityId);
            if (((!((_arg2 == 0))) && (!(_local6))))
            {
                _local5._0I_u(_arg1.pos_.x_, _arg1.pos_.y_, _arg2, _arg3);
            }
            var _local7:Player = (_local5 as Player);
            if (_local7 != null)
            {
                _local8 = _local7.level_;
                _local9 = _local7.exp_;
            }
            this._066(_local5, _arg1._086, _local6);
            if (((!((_local7 == null))) && (!((_local8 == -1)))))
            {
                if (_local7.level_ > _local8)
                {
                    if (_local6)
                    {
                        _local10 = this.gs_.charList_._B_7(_local7.objectType_, _local7.level_);
                        _local7._playerLvlUpTextSound(!((_local10.length == 0)));
                    }
                    else
                    {
                        _local7._playerLevelUpEff("Level Up!");
                    }
                }
                else
                {
                    if (_local7.exp_ > _local9)
                    {
                        _local7._XPGainText((_local7.exp_ - _local9));
                    }
                }
            }
        }

        // TODO: kek
        // Dynamic Bubble Colours
        private function _GetTextPacket(_arg1:TextPacket):void
        {
            var _local6:Player = this.gs_.map_.player_;
            var gameObject:GameObject;
            var colour:Vector.<uint>;
            var text:String = _arg1.text_;
            var _local5:Boolean = (_arg1.numStars_ == -1 || _arg1.objectId_ == -1);
            if ((_arg1.numStars_ < Parameters.ClientSaveData.chatStarRequirement) && !(_CheckSelfPlayerName(_arg1.name_, _local6)) && !(_local5) && !(this.chatCheck(_arg1.recipient_)) && _arg1.name_.charAt(0) != "@")
            {
                return;
            }

            if ((_arg1.cleanText_.length > 0 && _arg1.objectId_ != this.entityId) && Parameters.ClientSaveData.filterLanguage)
            {
                text = _arg1.cleanText_;
            }

            if (_arg1.objectId_ >= 0)
            {
                gameObject = this.gs_.map_.goDict_[_arg1.objectId_];
                if (gameObject != null)
                {
                    colour = _vb;
                    if (gameObject.props_.isEnemy_)
                    {
                        colour = _Z_y;
                    }
                    else
                    {
                        if (_arg1.recipient_ == Parameters.SendGuild)
                        {
                            colour = _pS_;
                        }
                        else if (_arg1.recipient_ == Parameters.SendParty)
                        {
                            colour = partyColors;
                        }
                        else
                        {
                            if(colourChosen != "default_")
                            {
                                colour = this[colourChosen.toString()]
                            }
                            else
                            {
                                colour = default_;
                            }
                        }
                    }
                    this.gs_.map_.mapOverlay_.addSpeechBalloon(new _6T_(gameObject, text, colour[0], 1, colour[1], 1, colour[2], _arg1.bubbleTime_, false, true));
                }
            }
            if ((text) || !Parameters.ClientSaveData.hidePlayerChat || (this.chatCheck(_arg1.name_)))
            {
                this.gs_.textBox_._ro(_arg1.name_, _arg1.objectId_, _arg1.numStars_, _arg1.recipient_, text);
            }
        }

        private function _CheckSelfPlayerName(_arg1:String, _arg2:Player):Boolean
        {
            return _arg1 == _arg2.name_;
        }

        private function chatCheck(_arg1:String):Boolean
        {
            return (_arg1.length > 0 && (_arg1.charAt(0) == "*" || _arg1.charAt(0) == "#" || _arg1.charAt(0) == "@" || _arg1.charAt(0) == "!"));
        }

        private function _GetInvResultPacket(_arg1:InvResultPacket):void
        {
            if (_arg1.result_ != 0)
            {
                this._v6();
            }
        }

        private function _v6():void
        {
            SFXHandler.play("error");

            this.gs_.HudView._02y.playerInventory.refresh();
            this.gs_.HudView._02y.InvEquips.refresh();
            this.gs_.HudView._U_T_.redraw();
        }

        private function _GetReconnectPacket(_arg1:ReconnectPacket):void
        {
            var _local2:_j_ = new _j_(new Server(_arg1.name_, _arg1.host_ != "" ? _arg1.host_ : this.server_.address_, _arg1.host_ != "" ? _arg1.port_ : this.server_.port_), _arg1.gameId_, this._96, this.charId_, _arg1.keyTime_, _arg1.key_);
            this.gs_.dispatchEvent(_local2);
        }

        private function _GetPingPacket(_arg1:PingPacket):void
        {
            var _local2:PongPacket = (this.Conn._Y_E_(PONG) as PongPacket);
            _local2.serial_ = _arg1.serial_;
            _local2.time_ = getTimer();
            this.Conn.sendMessage(_local2);
        }

        private function _7N_(_arg1:String):void
        {
            var _local2:XML = XML(_arg1);
            _pf._nY_(_local2);
            ObjectLibrary.parse(_local2);
        }

        private function _GetMapInfoPacket(_arg1:MapInfoPacket):void
        {
            var _local2:String;
            var _local3:String;
            for each (_local2 in _arg1.clientXML_)
            {
                this._7N_(_local2);
            }
            for each (_local3 in _arg1.extraXML_)
            {
                this._7N_(_local3);
            }
            this.gs_._S_z(_arg1);
            this._7G_ = new Random(_arg1.fp_);
            if (this._96)
            {
                this.create();
            }
            else
            {
                this.load();
            }
        }

        private function _GetPicPacket(_arg1:PicPacket):void
        {
            this.gs_.addChild(new _B_N_(_arg1.bitmapData_));
        }

        private function _GetDeathPacket(_arg1:DeathPacket):void
        {
            MusicHandler.reload("Death");
            var _local2:BitmapData = new BitmapData(1024, 768);
            _local2.draw(this.gs_);
            _arg1.background = _local2;
            if (this.gs_.isEditor)
            {
                return;
            }
            GameContext.getInjector().getInstance(_06a).dispatch(_arg1);
        }

        private function _GetBuyResultPacket(_arg1:BuyResultPacket):void
        {
            if (_arg1.result_ == BuyResultPacket._dV_)
            {
                if (this.outstandingBuy_ != null)
                {
                    this.outstandingBuy_.gaCurrencyTrack();
                }
            }
            this.outstandingBuy_ = null;
            switch (_arg1.result_)
            {
                case BuyResultPacket._7a:
                    this.gs_.stage.addChild(new _02d());
                    return;
                case BuyResultPacket._0I_C_:
                    this.gs_.stage.addChild(new _aZ_());
                    return;
                case BuyResultPacket._83_e:
                    this.gs_.stage.addChild(new _gE_());
                    return;
                default:
                    this.gs_.textBox_.addText((((_arg1.result_ == BuyResultPacket._dV_)) ? Parameters.SendInfo : Parameters.SendError), _arg1.resultString_);
            }
        }

        private function _GetAccountListPacket(_arg1:AccountListPacket):void
        {
            if (_arg1.accountListId_ == 0)
            {
                this.gs_.map_.party_.setStars(_arg1);
            }
            if (_arg1.accountListId_ == 1)
            {
                this.gs_.map_.party_.setIgnores(_arg1);
            }
        }

        private function _GetCheckMoodsReturnPacket(_arg1:CheckMoodsReturnPacket):void
        {
            //TODO: make this open the MoodChooser Frame as clicking the MoodChooser button would send a CheckMoods packet
            if (_arg1 != null)
            {
                new MoodChooser(this.gs_, _arg1);
            }
        }

        private function _GetQuestObjIdPacket(_arg1:QuestObjIdPacket):void
        {
            this.gs_.map_.quest_.setObject(_arg1.objectId_);
        }

        private function _GetAOEPacket(packet:AOEPacket):void
        {
            var _local5:int;
            var _local6:Vector.<uint>;
            var player:Player = this.gs_.map_.player_;
            if (player == null)
            {
                this.aoeAck(this.gs_.lastUpdate_, 0, 0);
                return;
            }
            var effect:AoeEffect = new AoeEffect(packet.pos_._point(), packet.radius_, 0xFF0000);
            this.gs_.map_.addObj(effect, packet.pos_.x_, packet.pos_.y_);
            if (((player._EntityIsInvincibleEff()) || (player._EntityIsPausedEff())))
            {
                this.aoeAck(this.gs_.lastUpdate_, player.x_, player.y_);
                return;
            }
            var withinRange:Boolean = (player.getDist(packet.pos_) < packet.radius_);
            if (withinRange)
            {
                _local5 = GameObject.CalculateDamage(packet.damage_, packet.penetration_, player.defense_, player.resilience_, false, player.condEffects);
                _local6 = null;
                if (packet.effect_ != 0)
                {
                    _local6 = new Vector.<uint>();
                    _local6.push(packet.effect_);
                }
                player.postDamageEffects(packet.origType_, _local5, _local6, false, null);
            }
            this.aoeAck(this.gs_.lastUpdate_, player.x_, player.y_);
        }

        private function _GetNameResultPacket(_arg1:NameResultPacket):void
        {
            this.gs_.dispatchEvent(new _3E_(_arg1));
        }

        private function _GetCreateGuildResultPacket(_arg1:CreateGuildResultPacket):void
        {
            if (_arg1.errorText_ != "")
                this.gs_.textBox_.addText(_arg1.success_ ? "" : Parameters.SendError, _arg1.errorText_);
            this.gs_.dispatchEvent(new _J_F_(_arg1.success_, _arg1.errorText_));
        }

        private function _GetMarketTradeResultPacket(_arg1:MarketTradeResultPacket):void
        {
            if (_arg1.errorText_ != "")
                this.gs_.textBox_.addText(_arg1.success_ ? "" : Parameters.SendError, _arg1.errorText_);
            this.gs_.dispatchEvent(new _J_F_(_arg1.success_, _arg1.errorText_, _J_F_.market_));
        }

        private function _GetUnboxResultPacket(_arg1:UnboxResultPacket):void
        {
            var _local1:UnboxResultBox = new UnboxResultBox(this.gs_, _arg1.items_, _arg1.datas_);
            this.gs_.stage.addChild(new Frame2Holder(_local1));
        }

        private function _GetClientStatPacket(_arg1:ClientStatPacket):void
        {
            Account._get().reportIntStat(_arg1.name_, _arg1.value_);
        }

        private function _GetFilePacket(_arg1:FilePacket):void
        {
            new FileReference().save(_arg1.file_, _arg1.filename_);
        }

        private function _GetInvitedToGuildPacket(_arg1:InvitedToGuildPacket):void
        {
            if (Parameters.ClientSaveData.showGuildInvitePopup)
            {
                this.gs_.HudView._U_T_._j(new InvitedToGuildPanel(this.gs_, _arg1.name_, _arg1.guildName_));
            }
            this.gs_.textBox_.addText("", (((((("You have been invited by " + _arg1.name_) + " to join the guild ") + _arg1.guildName_) + '.\n  If you wish to join type "/join ') + _arg1.guildName_) + '"'));
        }

        private function _GetInvitedToPartyPacket(_arg1:InvitedToPartyPacket):void
        {
            if (Parameters.ClientSaveData.showGuildInvitePopup)
            {
                this.gs_.HudView._U_T_._j(new PartyInvitePanel(this.gs_, _arg1.name_, _arg1.partyID_));
            }
            this.gs_.textBox_.addText("", "You have been invited by " + _arg1.name_ + " to join a party.\nIf you wish to join, type \"/party join " + _arg1.name_ + "\"");
        }

        private function _GetPlaySoundPacket(_arg1:PlaySoundPacket):void
        {
            var _local2:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
            if (_local2 == null)
            {
                return;
            }
            _local2._05M_(_arg1.soundId_);
        }

        private function _P_p(_arg1:int):void
        {
            this._0c = new Timer((_arg1 * 1000), 1);
            this._0c.addEventListener(TimerEvent.TIMER_COMPLETE, this._F_z);
            this._0c.start();
        }

        private function _GetFailurePacket(_arg1:FailurePacket):void
        {
            switch (_arg1.errorId_)
            {
                case FailurePacket._00Z_:
                    this._ee(_arg1);
                    return;
                case FailurePacket._C_w:
                    this._0H_6(_arg1);
                    return;
                case FailurePacket._oo:
                    this._0K_Z_(_arg1);
                    return;
                case FailurePacket._0G_:
                    this._0z_K_(_arg1);
                    return;
                case FailurePacket._Rf_:
                    this._ga1(_arg1);
                    return;
                default:
                    this._0M_G_(_arg1);
            }
        }

        private function _ga1(_arg1:FailurePacket):void
        {
            this._P_A_ = false;
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
        }

        private function _0z_K_(_arg1:FailurePacket):void
        {
            var _local2:TwoButtonDialog = new TwoButtonDialog("Guest accounts have been disabled for improved security.", "Anti-Guest Guard", "Ok", null, "/noGuests");
            _local2.addEventListener(TwoButtonDialog.BUTTON1_EVENT, this._Y_h);
            this.gs_.stage.addChild(_local2);
            this._P_A_ = false;
        }

        private function _0K_Z_(_arg1:FailurePacket):void
        {
            this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
            this.gs_.map_.player_.nextTeleportAt_ = 0;
        }

        private function _0H_6(_arg1:FailurePacket):void
        {
            this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
            this._P_A_ = false;
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
        }

        private function _ee(_arg1:FailurePacket):void
        {
            var _local2:TwoButtonDialog = new TwoButtonDialog(((("Client version: " + Parameters.clientVersion) + "\nServer version: ") + _arg1.errorDescription_ + "\n\nFind the latest client on the <font color='#7777EE'><a href='http://phoenix-realms.com'>Forums</a></font>"), "Invalid Client", "Ok", null, "/clientUpdate");
            _local2.addEventListener(TwoButtonDialog.BUTTON1_EVENT, this._Y_h);
            this.gs_.stage.addChild(_local2);
            this._P_A_ = false;
        }

        private function _0M_G_(_arg1:FailurePacket):void
        {
            this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
        }

        private function _H_8():void
        {
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
        }

        private function _GetSwitchMusicPacket(_arg1:SwitchMusicPacket):void
        {
            MusicHandler.reload(_arg1.music_);
        }

        private function _GetItemResultPacket(_arg1:ItemResultPacket):void
        {
            var _local1:ItemResultBox = new ItemResultBox(this.gs_, _arg1.item_, "acquired", JSON.parse(_arg1.data_));
            this.gs_.stage.addChild(new Frame2Holder(_local1));
        }

        private function _GetTextInputPacket(_arg1:GetTextInputPacket):void
        {
            var _local1:TextInputForm = new TextInputForm(this.gs_, _arg1.name_, _arg1.action_);
            this.gs_.stage.addChild(new FrameHolder(_local1));
        }

        private function _GetCameraUpdatePacket(_arg1:CameraUpdatePacket):void {
            this.gs_.camera_.offsetX_ = _arg1.cameraOffsetX_;
            this.gs_.camera_.offsetY_ = _arg1.cameraOffsetY_;
            if(_arg1.fixedCamera_) {
                this.gs_.camera_.setFixedPos(_arg1.cameraPos_.x_, _arg1.cameraPos_.y_);
            } else {
                this.gs_.camera_.fixed_ = false;
            }
            if(_arg1.fixedCameraRot_) {
                this.gs_.camera_.setFixedRot(_arg1.cameraRot_ * Math.PI / 180);
            } else if(this.gs_.camera_.fixedRot_) {
                this.gs_.camera_.fixedRot_ = false;
                Parameters.ClientSaveData.cameraAngle = this.gs_.camera_.prevRot_;
            }
        }

        private function OnConnect(_arg1:Event):void
        {
            this.gs_.textBox_.addText(Parameters.SendClient, "Connected!");
            var _local2:HelloPacket = (this.Conn._Y_E_(HELLO) as HelloPacket);
            _local2.copyright_ = "6d450d6aee98e461f0280a196593eebbfb8227a7";
            _local2.buildVersion_ = Parameters.clientVersion;
            _local2.gameId_ = this.gameId_;
            _local2.guid_ = this._J_X_(Account._get().guid());
            _local2.password_ = this._J_X_(Account._get().password());
            _local2.secret_ = this._J_X_(Account._get().secret());
            _local2.keyTime_ = this.keyTime_;
            _local2.key_.length = 0;
            if (this.key_ != null) {
                _local2.key_.writeBytes(this.key_);
            }
            _local2._2B_ = (((this._2B_ == null)) ? "" : this._2B_);
            _local2._8U_ = Account._get().entrytag();
            _local2._yt = Account._get().gameNetwork();
            _local2._J_k = Account._get().gameNetworkUserId();
            _local2.playPlatform = Account._get().playPlatform();
            this.Conn.sendMessage(_local2);
        }

        private function OnClose(_arg1:Event):void
        {
            if (this.entityId != -1)
            {
                this.gs_.dispatchEvent(new Event(Event.COMPLETE));
                return;
            }
            else
            {
                if (this._P_A_)
                {
                    if (this.conTimes < 5)
                    {
                        this._P_p(this.conTimes++);
                    }
                    else
                    {
                        this._P_p(this.conTimes);
                    }
                    this.gs_.textBox_.addText(Parameters.SendError, "Connection failed!  Retrying...");
                }
            }
        }

        private function _F_z(_arg1:TimerEvent):void
        {
            this.connect();
        }

        private function OnError(_arg1:ErrorEvent):void
        {
            this.gs_.textBox_.addText(Parameters.SendError, _arg1.text);
        }

        private function _Y_h(_arg1:Event):void
        {
            var _local2:TwoButtonDialog = (_arg1.currentTarget as TwoButtonDialog);
            _local2.parent.removeChild(_local2);
            this.gs_.dispatchEvent(new _D_X_());
        }
    }
}