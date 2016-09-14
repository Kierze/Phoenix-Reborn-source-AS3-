// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.ui._0A_t

package com.company.PhoenixRealmClient.ui {
import com.company.PhoenixRealmClient.parameters.Parameters;
import com.company.PhoenixRealmClient.util.ClassQuest;

import flash.display.Sprite;
import flash.text.engine.ContentElement;
import flash.text.engine.ElementFormat;
import flash.text.engine.GraphicElement;
import flash.text.engine.GroupElement;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;

public class _0A_t {

    private static var _0I_T_:_vi = new _vi();

    public function _0A_t(_arg1:int, _arg2:String, _arg3:int, _arg4:int, _arg5:String, _arg6:Boolean, _arg7:String)
    {
        this.time_ = _arg1;
        this.name_ = _arg2;
        if (_arg4 >= 0)
        {
            this._L_P_ = ClassQuest.CircledStarRankSprite(_arg4);
        }
        this.recipient_ = _arg5;
        this._E_B_ = _arg6;
        this.text_ = _arg7;
    }
    public var time_:int;
    public var name_:String;
    public var _L_P_:Sprite = null;
    public var recipient_:String;
    public var _E_B_:Boolean;
    public var text_:String;

    public function _0H_u():TextBlock
    {
        var _local1:Vector.<ContentElement> = new <ContentElement>[];
        var _playerColor:ElementFormat = _0I_T_.PlayerColour;
        var _local3:ElementFormat = _0I_T_.BlackColour;
        var _textColor:ElementFormat = _0I_T_.TextColour;
        var _name:String = this.name_;

        switch (this.name_)
        {
            case Parameters.SendInfo:
                _name = "";
                _textColor = _0I_T_.InfoColour;
                break;
            case Parameters.SendClient:
                _name = "";
                _textColor = _0I_T_.ClientColour;
                break;
            case Parameters.SendHelp:
                _name = "";
                _textColor = _0I_T_.HelpColour;
                break;
            case Parameters.SendError:
                _textColor = _0I_T_.ErrorColour;
                _name = "";
                break;
            case Parameters.SendChatBot:
                _name = "HatBot";
                _textColor = _0I_T_.ChatBotColour;
                break;
        }
        if (this.name_.charAt(0) == "#")
        {
            _name = this.name_.substr(1);
            _playerColor = _0I_T_.EnemyColour;
        }
        if (this.name_.charAt(0) == "@")
        {
            _name = this.name_.substr(1);
            _playerColor = _0I_T_.SAdminColour;
        }
        if (this.recipient_ == Parameters.SendGuild)
        {
            _textColor = _0I_T_.GuildColour;
        }
        else if (this.recipient_ == Parameters.SendParty)
        {
            _playerColor = _0I_T_.PartyNameColour;
            _textColor = _0I_T_.PartyTextColour;
        }
        else
        {
            if (this.recipient_ != "")
            {
                _playerColor = _0I_T_.TellColour;
                _textColor = _0I_T_.TellColour;
                if (!this._E_B_)
                {
                    _local1.push(new TextElement("To: ", _0I_T_.TellColour));
                    _playerColor = _0I_T_.TellColour;
                    _name = this.recipient_;
                    this._L_P_ = null;
                }
            }
        }
        if (this._L_P_ != null)
        {
            this._L_P_.y = 3;
            _local1.push(new GraphicElement(this._L_P_, (this._L_P_.width + 2), this._L_P_.height, _0I_T_.TextColour));
        }
        if (_name != "") {
            _local1.push(new TextElement(("<" + _name + ">"), _playerColor), new TextElement(" ", _local3));
        }
        if (_name == "")
        {
            var _local7:Array = this.text_.split("{c}");
            for each (var _local8:String in _local7)
            {
                if (_local8.indexOf("{/c}") != -1)
                {
                    var _local9:String = _local8.substr(0, _local8.indexOf("{/c}"));
                    _textColor = _vi.createColor(uint(_local9));
                    _local8 = _local8.substr(_local8.indexOf("{/c}") + 4);
                }
                _local1.push(new TextElement(_local8, _textColor));
            }
        }
        else
        {
            _local1.push(new TextElement(this.text_, _textColor));
        }
        var _local6:GroupElement = new GroupElement(_local1);
        return (new TextBlock(_local6));
    }

}
}//package com.company.PhoenixRealmClient.ui

