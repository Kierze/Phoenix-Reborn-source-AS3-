using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class StoneGuard : ItemEntity
    {
        public StoneGuard(Player player)
            : base(player.Manager, 0x2011)
        {
            this.playerOwner = player;
            hittable = true;
            targeted = true;

        }
        public override void Tick(RealmTime time)
        {
        }
    }
}
