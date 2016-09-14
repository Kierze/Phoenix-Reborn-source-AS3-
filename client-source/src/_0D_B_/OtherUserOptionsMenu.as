//_0D_B_.OtherUserOptionsMenu

package _0D_B_ {

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.Player;
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.ui.CharObjectHeader;
import com.company.PhoenixRealmClient.util._07E_;
import com.company.util.AssetLibrary;

import flash.events.Event;
import flash.events.MouseEvent;

public class OtherUserOptionsMenu extends Menu {

        public function OtherUserOptionsMenu(_arg1:GameSprite, _arg2:Player) {
            var _local3:_0K_G_;
            super(Parameters._primaryColourDefault, 0xFFFFFF);
            this._gameSprite = _arg1;
            this._otherUserName = _arg2.name_;
            this._otherUser = _arg2;
            this._header = new CharObjectHeader(0xB3B3B3, true, this._otherUser);
            addChild(this._header);
            if (Player.isAdmin) {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 10), 0xFFFFFF, "Kick");
                _local3.addEventListener(MouseEvent.CLICK, this._kickCommand);
                _AddItem(_local3);
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 4), 0xFFFFFF, "Mute");
                _local3.addEventListener(MouseEvent.CLICK, this._muteCommand);
                _AddItem(_local3);
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 3), 0xFFFFFF, "UnMute");
                _local3.addEventListener(MouseEvent.CLICK, this._unMuteCommand);
                _AddItem(_local3);
            }
            if (((this._gameSprite.map_.allowPlayerTeleport_) && (this._otherUser.IsPlayerTargetable(this._otherUser)))) {
                _local3 = new _K_h(this._gameSprite.map_.player_);
                _local3.addEventListener(MouseEvent.CLICK, this._teleportToUser);
                _AddItem(_local3);
            }
            if ((((this._gameSprite.map_.player_.guildRank_ >= _07E_._f3)) && ((((_arg2.guildName_ == null)) || ((_arg2.guildName_.length == 0)))))) {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 10), 0xFFFFFF, "Invite");
                _local3.addEventListener(MouseEvent.CLICK, this._guildInvite);
                _AddItem(_local3);
            }
            if (((this._gameSprite.map_.player_.partyID_ != -1 && this._gameSprite.map_.player_.partyLeader) || this._gameSprite.map_.player_.partyID_ == -1) && _arg2.partyID_ == -1) {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 10), 0xFFFFFF, "Party");
                _local3.addEventListener(MouseEvent.CLICK, this._partyInvite);
                _AddItem(_local3);
            }
            if (!this._otherUser.starred_) {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 0), 0xFFFFFF, "Lock");
                _local3.addEventListener(MouseEvent.CLICK, this._lockUser);
                _AddItem(_local3);
            } else {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 1), 0xFFFFFF, "Unlock");
                _local3.addEventListener(MouseEvent.CLICK, this._unlockUser);
                _AddItem(_local3);
            }
            _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 7), 0xFFFFFF, "Trade");
            _local3.addEventListener(MouseEvent.CLICK, this._requestTrade);
            _AddItem(_local3);
            if (!this._otherUser._0M_w) {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 8), 0xFFFFFF, "Ignore");
                _local3.addEventListener(MouseEvent.CLICK, this._ignoreUser);
                _AddItem(_local3);
            } else {
                _local3 = new _0K_G_(AssetLibrary.getBitmapFromFileIndex("lofiInterfaceBig", 9), 0xFFFFFF, "Unignore");
                _local3.addEventListener(MouseEvent.CLICK, this._unIgnoreUser);
                _AddItem(_local3);
            }
        }
        public var _gameSprite:GameSprite;
        public var _otherUserName:String;
        public var _otherUser:Player;
        public var _header:CharObjectHeader;

        private function _teleportToUser(_arg1:Event):void {
            this._gameSprite.map_.player_.teleportTo(this._otherUser);
            remove();
        }

        private function _guildInvite(_arg1:Event):void {
            this._gameSprite.gsc_._H_X_(this._otherUserName);
            remove();
        }

        private function _partyInvite(_arg1:Event):void {
            this._gameSprite.gsc_.partyInvite(this._otherUserName);
            remove();
        }

        private function _lockUser(_arg1:Event):void {
            this._gameSprite.map_.party_.lockPlayer(this._otherUser);
            remove();
        }

        private function _unlockUser(_arg1:Event):void {
            this._gameSprite.map_.party_.unlockPlayer(this._otherUser);
            remove();
        }

        private function _kickCommand(_arg1:Event):void{
            this._gameSprite.gsc_.playerText(("/kick " + this._otherUser.name_));
            remove();
        }

        private function _muteCommand(_arg1:Event):void{
            this._gameSprite.gsc_.playerText(("/mute " + this._otherUser.name_));
            remove();
        }

        private function _unMuteCommand(_arg1:Event):void{
            this._gameSprite.gsc_.playerText(("/unmute " + this._otherUser.name_));
            remove();
        }

        private function _requestTrade(_arg1:Event):void {
            this._gameSprite.gsc_.requestTrade(this._otherUserName);
            remove();
        }

        private function _ignoreUser(_arg1:Event):void {
            this._gameSprite.map_.party_.ignorePlayer(this._otherUser);
            remove();
        }

        private function _unIgnoreUser(_arg1:Event):void {
            this._gameSprite.map_.party_.unignorePlayer(this._otherUser);
            remove();
        }

    }
}//package _0D_B_

