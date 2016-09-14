using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wServer.realm.worlds.dungeons
{
    public class OryxChamber : World
    {
        public OryxChamber()
        {
            Identifier = "OryxChamber";
            Name = "Oryx's Chamber";
            Background = 0;
            SetMusic("dungeon/Oryx Castle");
            AllowTeleport = false;
        }

        protected override void Init()
        {
            base.FromWorldMap(typeof(RealmManager).Assembly.GetManifestResourceStream("wServer.realm.worlds.dungeons.oryxChamber.wmap"));
        }
    }
}
