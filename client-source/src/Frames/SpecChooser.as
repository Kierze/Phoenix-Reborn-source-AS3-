/**
 * Created by club5_000 on 9/2/2015.
 */
package Frames {

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.PhoenixRealmClient.ui.Ability;
import com.company.PhoenixRealmClient.util.AbilityLibrary;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class SpecChooser extends Frame2 {
    public function SpecChooser(_arg1:GameSprite) {
      this.gs_ = _arg1;
      this.choice_ = new TextList(this.getClassSpecs());
      super("Learn your specialization", "Learn", Math.max(320, this.choice_.width+38));
      addTextList(this.choice_);
      offsetH(142);
      this.currentSpec_ = this.choice_._rq();
      this.resetPreviews();
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
      Button1.addEventListener(MouseEvent.CLICK, learnSpec);
      XButton.addEventListener(MouseEvent.CLICK, onClose);
    }

    private function learnSpec(event:MouseEvent):void
    {
        if (this.gs_.map_.player_ != null && this.gs_.map_.player_.level_ >= 10 && (this.gs_.map_.player_.spec_ == null || this.gs_.map_.player_.spec_ == ""))
            this.gs_.gsc_.changeSpec(this.choice_._rq());
        stage.focus = null;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onClose(event:MouseEvent):void {
      stage.focus = null;
      dispatchEvent(new Event(Event.COMPLETE));
    }

    private var gs_:GameSprite;
    private var choice_:TextList;
    private var previews_:Sprite;
    private var currentSpec_:String;
    private var specAbilities_:Dictionary = new Dictionary();

    private function onEnterFrame(event:Event):void {
      if(this.choice_._rq() != this.currentSpec_) {
        this.currentSpec_ = this.choice_._rq();
        this.resetPreviews();
      }
    }

    private function addedToStage(event:Event):void
    {
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function removedFromStage(event:Event):void
    {
      removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function getClassSpecs():Vector.<String>
    {
      var _local1:XML = ObjectLibrary.typeToXml[this.gs_.map_.player_.objectType_];
      var _local2:Vector.<String> = new Vector.<String>();
      if (_local1 == null) {
        return _local2;
      }
      for each(var _local3:XML in _local1.Specialization)
      {
        var _local4:String = _local3.@id;
        _local2.push(_local4);
        this.specAbilities_[_local4] = _local3.toString();
      }
      return _local2;
    }

    private function resetPreviews():void
    {
      if(this.previews_ != null)
      {
        if(contains(this.previews_))
        {
          removeChild(this.previews_);
        }
        this.previews_ = null;
      }
      this.previews_ = new Sprite();
      var _local1:Array = this.specAbilities_[this.currentSpec_].split(", ");
      var _local5:int = 0;
      for each(var _local2:String in _local1)
      {
        var _local3:int = AbilityLibrary.IdToType[_local2];
        var _local4:Sprite = createAbility(_local3);
        _local4.y = _local5 * 44;
        _local5++;
        this.previews_.addChild(_local4);
      }
      this.previews_.x = 8;
      this.previews_.y = this.choice_.y + this.choice_.height + 10;
      addChild(this.previews_);
    }

    private function createAbility(_arg1:int):Sprite
    {
      var _local1:Sprite = new Sprite();
      var _local2:Ability = new Ability(this.gs_, 0, _arg1, false, false);
      _local1.addChild(_local2);
      var _local3:SimpleText = new SimpleText(28, 0xFFFFFF);
      _local3.setBold(true);
      _local3.text = AbilityLibrary.getDisplayName(_arg1);
      _local3.updateMetrics();
      _local3.x = 44;
      _local3.y = 3;
      _local1.addChild(_local3);
      return _local1;
    }
  }
}
