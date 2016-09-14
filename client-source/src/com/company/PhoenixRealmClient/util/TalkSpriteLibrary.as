package com.company.PhoenixRealmClient.util
{
import com.company.PhoenixRealmClient.objects.ObjectProperties;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.utils.Dictionary;

public class TalkSpriteLibrary
    {
        public static const Props:Dictionary = new Dictionary();
        public static const IdToXML:Dictionary = new Dictionary();
        public static const TypeToXML:Dictionary = new Dictionary();
        public static const IdToType:Dictionary = new Dictionary();
        public static const TypeToId:Dictionary = new Dictionary();

        public static function parse(_arg1:XML):void
        {
            for each (var xml:XML in _arg1.Talksprite)
            {
                var id:String = xml.@id;
                var type:int = int(xml.@type);
                IdToXML[id] = xml;
                TypeToXML[type] = xml;
                IdToType[id] = type;
                TypeToId[type] = id;
                Props[type] = new ObjectProperties(xml);
            }
        }

        public static function getDefaultIcon(_arg1:int):BitmapData
        {
            var xml:XML = TypeToXML[_arg1];
            if(xml == null)
            {
                return null;
            }
            if(!xml.hasOwnProperty("Texture"))
            {
                return null;
            }
            var textureXml:XMLList = xml.Texture;
            return AssetLibrary.getBitmapFromFileIndex(textureXml.File, int(textureXml.Index));
        }
    }
}
