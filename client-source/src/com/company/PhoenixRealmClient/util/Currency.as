package com.company.PhoenixRealmClient.util {
    public class Currency {

        public static const INVALID:int = -1;
        public static const CREDITS:int = 0;
        public static const FAME:int = 1;
        public static const GUILDFAME:int = 2;
        public static const SILVER:int = 3;
        public static const GUILDGOLD:int = 4;

        public static function getCurrencyName(_arg1:int):String {
            switch (_arg1) {
                case CREDITS:
                    return ("Gold");
                case FAME:
                    return ("Fame");
                case GUILDFAME:
                    return ("Guild Fame");
                case SILVER:
                    return ("Silve");
                case GUILDGOLD:
                    return ("Guild Gold");
                default:
                    return("");
            }
        }

    }
}

