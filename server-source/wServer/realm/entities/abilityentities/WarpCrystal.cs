using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wServer.networking;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class WarpCrystal : ItemEntity
    {
        public int warpuses = 0;
        private readonly Player player;

        public WarpCrystal(Player player)
            : base(player.Manager, 0x2006)
        {
            //this.warpuses = warpUsesx;
            this.player = player;
            
        }
        public override void Tick(RealmTime time)
        {
            if (player.Owner != this.Owner)
                Owner.LeaveWorld(this);
            if (player.warpUses == 2)
            {
                player.warpUses = 0;
                tP();
                Owner.LeaveWorld(this);
            }
            
            player.UpdateCount++;
            this.UpdateCount++;
        }
        public void tP()
        {
            player.Move(this.X, this.Y);
            player.UpdateCount++;
            Owner.BroadcastPacket(new GotoPacket
            {
                ObjectId = player.Id,
                Position = new Position
                {
                    X = player.X,
                    Y = player.Y
                }
            }, null);
            UpdateCount++;

        }
       
    }
}
