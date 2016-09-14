/**
 * Created by club5_000 on 9/1/2015.
 */
package com.company.PhoenixRealmClient.util {

import com.company.PhoenixRealmClient.objects.ObjectProperties;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.utils.Dictionary;

public class AbilityLibrary {
        public static const Props:Dictionary = new Dictionary();
        public static const IdToXML:Dictionary = new Dictionary();
        public static const TypeToXML:Dictionary = new Dictionary();
        public static const IdToType:Dictionary = new Dictionary();
        public static const TypeToId:Dictionary = new Dictionary();

        public static function parse(file:XML):void
        {
            for each (var xml:XML in file.Ability)
            {
                var Id:String = xml.@id;
                var Type:int = int(xml.@type);
                IdToXML[Id] = xml;
                TypeToXML[Type] = xml;
                IdToType[Id] = Type;
                TypeToId[Type] = Id;
                Props[Type] = new ObjectProperties(xml);
            }
        }

        public static function getIcon(_arg1:int):BitmapData
        {
            var _local1:XML = TypeToXML[_arg1];
            if(_local1 == null)
            {
                return null;
            }
            if(!_local1.hasOwnProperty("Texture"))
            {
                return null;
            }
            var _local2:XMLList = _local1.Texture;
            return AssetLibrary.getBitmapFromFileIndex(_local2.File, int(_local2.Index));
        }

        public static function getDisplayName(_arg1:int):String
        {
            var _local1:XML = TypeToXML[_arg1];
            if(_local1 == null)
            {
                return "";
            }
            if(_local1.hasOwnProperty("DisplayId"))
            {
                return String(_local1.DisplayId);
            }
            else
            {
                return TypeToId[_arg1];
            }
        }
    }
}
