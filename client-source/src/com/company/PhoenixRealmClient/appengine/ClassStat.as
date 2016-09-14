// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.PhoenixRealmClient.appengine._0A_H_

package com.company.PhoenixRealmClient.appengine
{
import com.company.PhoenixRealmClient.util.ClassQuest;

public class ClassStat {

        public function ClassStat(_arg1:XML)
        {
            this.Xml = _arg1;
        }
        public var Xml:XML;

        public function bestLevel():int
        {
            return (this.Xml.BestLevel);
        }

        public function bestFame():int
        {
            return (this.Xml.BestFame);
        }

        public function getFameGoals():int
        {
            return (ClassQuest.getFameGoalsCompleted(int(this.Xml.BestFame)));
        }

    }
}//package com.company.PhoenixRealmClient.appengine

