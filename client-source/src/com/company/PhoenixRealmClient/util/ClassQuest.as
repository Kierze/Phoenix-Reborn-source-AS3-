// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.util._Z_B_

package com.company.PhoenixRealmClient.util {

import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.graphic.StarGraphic;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class ClassQuest {

    public static const FameGoals:Vector.<int> = new <int>[20, 150, 400, 800, 2000, 6500];
    private static const LightBlueStar:ColorTransform = new ColorTransform((138 / 0xFF), (152 / 0xFF), (222 / 0xFF));
    private static const DarkBlueStar:ColorTransform = new ColorTransform((49 / 0xFF), (77 / 0xFF), (219 / 0xFF));
    private static const RedStar:ColorTransform = new ColorTransform((193 / 0xFF), (39 / 0xFF), (45 / 0xFF));
    private static const OrangeStar:ColorTransform = new ColorTransform((247 / 0xFF), (147 / 0xFF), (30 / 0xFF));
    private static const YellowStar:ColorTransform = new ColorTransform((0xFF / 0xFF), (0xFF / 0xFF), (0 / 0xFF));
    private static const WhiteStar:ColorTransform = new ColorTransform();
    public static const StarColors:Vector.<ColorTransform> = new <ColorTransform>[LightBlueStar, DarkBlueStar, RedStar, OrangeStar, YellowStar, WhiteStar];

    public static function GetMaxClassQuests():int
    {
        return ((ObjectLibrary.playerClassObjects.length * FameGoals.length));
    }

    public static function getFameGoalsCompleted(_arg1:int):int
    {
        var count:int = 0;
        while ((count < FameGoals.length) && (_arg1 >= FameGoals[count]))
        {
            count++;
        }
        return (count);
    }

    public static function getNextFameGoal(_arg1:int, _arg2:int):int
    {
        var bestFame:int = Math.max(_arg1, _arg2);
        var count:int = 0;
        while (count < FameGoals.length)
        {
            if (FameGoals[count] > bestFame)
            {
                return (FameGoals[count]);
            }
            count++;
        }
        return (-1);
    }

    public static function StarSprite(_arg1:int):Sprite
    {
        var _local2:Sprite = ClassQuestsToStarSprite(_arg1);
        _local2.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        _local2.scaleX = 1.4;
        _local2.scaleY = 1.4;
        return (_local2);
    }

    public static function ClassQuestsToStarSprite(_arg1:int):Sprite
    {
        var _local2:Sprite = new StarGraphic();
        if (_arg1 < ObjectLibrary.playerClassObjects.length) 
        {
            _local2.transform.colorTransform = LightBlueStar;
        }
        else 
        {
            if (_arg1 < (ObjectLibrary.playerClassObjects.length * 2)) 
            {
                _local2.transform.colorTransform = DarkBlueStar;
            } 
            else 
            {
                if (_arg1 < (ObjectLibrary.playerClassObjects.length * 3)) 
                {
                    _local2.transform.colorTransform = RedStar;
                } 
                else 
                {
                    if (_arg1 < (ObjectLibrary.playerClassObjects.length * 4))
                    {
                        _local2.transform.colorTransform = OrangeStar;
                    } 
                    else 
                    {
                        if (_arg1 < (ObjectLibrary.playerClassObjects.length * 5)) 
                        {
                            _local2.transform.colorTransform = YellowStar;
                        } 
                        else 
                        {
                            if (_arg1 < (ObjectLibrary.playerClassObjects.length * 6)) 
                            {
                                _local2.transform.colorTransform = WhiteStar; //not sure if actually whitestar
                            }
                            else 
                            {
                                _local2.transform.colorTransform = new ColorTransform((0xFF / 0xFF), (0 / 0xFF), (0xFF / 0xFF));
                            }
                        }
                    }
                }
            }
        }
        return (_local2);
    }

    public static function CircledStarRankSprite(_arg1:int):Sprite
    {
        var starSprite:Sprite;
        starSprite = ClassQuestsToStarSprite(_arg1);
        var circleSprite:Sprite = new Sprite();
        circleSprite.graphics.beginFill(0, 0.4);
        var _local4:int = ((starSprite.width / 2) + 2);
        var _local5:int = ((starSprite.height / 2) + 2);
        circleSprite.graphics.drawCircle(_local4, _local5, _local4);
        starSprite.x = 2;
        starSprite.y = 1;
        circleSprite.addChild(starSprite);
        circleSprite.filters = [new DropShadowFilter(0, 0, 0, 0.5, 6, 6, 1)];
        return (circleSprite);
    }

    public static function _qf():BitmapData {
        var _local1:BitmapData = AssetLibrary.getBitmapFromFileIndex("lofiObj3", 224);
        return (TextureRedrawer.redraw(_local1, 40, true, 0));
    }

}
}//package com.company.PhoenixRealmClient.util

