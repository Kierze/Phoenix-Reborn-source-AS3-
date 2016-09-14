using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.logic.behaviors
{
    internal class CopyDamageRecord : Behavior
    {
        private float dist;
        private string targetName_;

        private double sinceCopy_ = 0.0;
        private ushort targetId_ = ushort.MaxValue;
        private float range_;

        public CopyDamageRecord(string target, float range = 40.0f)
        {
            this.targetName_ = target;
            this.range_ = range;
        }

        protected override void OnStateEntry(Entity host, RealmTime time, ref object state)
        {
            state = 0;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            //sinceCopy_ += time.thisTickCounts;
            //if (sinceCopy_ < 1.0)
            //{
            //    return;
            //}
            //sinceCopy_ = 0.0;

            if (targetId_ == ushort.MaxValue)
            {
                targetId_ = host.Manager.GameData.IdToObjectType[this.targetName_];
            }

            Entity[] target = (host.GetNearestEntities(range_, targetId_).ToArray());
            if (target.FirstOrDefault() == null)
            {
                targetId_ = ushort.MaxValue;
                return;
            }

            for (var i = 0; i < target.Count(); i++)
            {
                if ((host as Enemy).DamageCounter.Total == (target[i] as Enemy).DamageCounter.Total)
                {
                    return;
                }
                (target[i] as Enemy).SetDamageCounter((host as Enemy).DamageCounter, (target[i] as Enemy));   
            }
            return;
        }
    }
}