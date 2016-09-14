using System.Collections.Generic;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class AcidBomb : ItemEntity
    {
        private const int LIFETIME = 10;

        private readonly Player player;
        private readonly float radius;
        private readonly ActivateAbility abil;

        private int p;
        private int t;

        public AcidBomb(Player player, ActivateAbility abil)
            : base(player.Manager, 0x2013)
        {
            this.abil = abil;
            this.radius = abil.Radius;
            this.player = player;
        }

        public override void Tick(RealmTime time)
        {
            if (t / 600 == p)
            {
                p++;
                if (p == LIFETIME * 2)
                {
                    Explode(time);
                    return;
                }
            }
            t += time.ElaspedMsDelta;

            bool monsterNearby = false;
            this.AOE(radius /2, false, enemy => monsterNearby = true);
            if (monsterNearby)
                Explode(time);
        }

        private void Explode(RealmTime time)
        {
            Owner.BroadcastPacket(new ShowEffectPacket
            {
                EffectType = EffectType.AreaBlast,
                Color = new ARGB(0xffddff00),
                TargetId = Id,
                PosA = new Position { X = radius }
            }, null);
            this.AOE(radius, false, enemy =>
            {
                player.poisons.Add(new Poison((enemy as Enemy), abil));
            });
            Owner.LeaveWorld(this);
        }
        }
}
