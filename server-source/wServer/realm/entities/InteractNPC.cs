using System.Collections.Generic;
using System.Xml.Linq;
using wServer.realm.terrain;

namespace wServer.realm.entities
{
    public class InteractNPC : Entity
    {
        public InteractNPC(RealmManager manager, ushort objType)
            : base(manager, objType)
        {
            CharName = ObjectDesc.CharName;
            CharTitle = ObjectDesc.CharTitle;
        }

        public string CharName { get; private set; }
        public string CharTitle { get; private set; }
        public bool IsMerchant { get; private set; }

        protected override void ExportStats(IDictionary<StatsType, object> stats)
        {
            base.ExportStats(stats);
        }

        public override void Tick(RealmTime time)
        {
            base.Tick(time);
        }
    }
}