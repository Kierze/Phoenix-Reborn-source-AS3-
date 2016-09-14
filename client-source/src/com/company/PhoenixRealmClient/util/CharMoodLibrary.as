/**
 * Created by Roxy on 10/24/2015.
 */
package com.company.PhoenixRealmClient.util {

import com.company.PhoenixRealmClient.objects.ObjectProperties;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.utils.Dictionary;

public class CharMoodLibrary {
        public static const Props:Dictionary = new Dictionary();
        public static const NameToXML:Dictionary = new Dictionary();
        public static const TypeToXML:Dictionary = new Dictionary();
        public static const NameToType:Dictionary = new Dictionary();
        public static const TypeToName:Dictionary = new Dictionary();

        public static function parse(_xmls:XML):void
        {
            for each (var _charMood:XML in _xmls.CharMood)
            {
                var _name:String = _charMood.Name;
                var _type:int = int(_charMood.@type);
                NameToXML[_name] = _charMood;
                TypeToXML[_type] = _charMood;
                NameToType[_name] = _type;
                TypeToName[_type] = _name;
                Props[_type] = new ObjectProperties(_charMood);
            }
        }

        public static function getImage(_type:int):BitmapData
        {
            var _xml:XML = TypeToXML[_type];

            if (_xml == null) return null;
            if (!_xml.hasOwnProperty("Texture")) return null;

            var _textureData:XMLList = _xml.Texture;
            return AssetLibrary.getBitmapFromFileIndex(_textureData.File, int(_textureData.Index));
        }
    }
}
