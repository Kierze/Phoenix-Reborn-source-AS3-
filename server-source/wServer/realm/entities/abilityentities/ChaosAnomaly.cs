using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class ChaosAnomaly : ItemEntity
    {
        private static readonly Random rand = new Random();

        private readonly int duration;
        private int r = 0;
        private readonly Vector2 ent;
        private readonly Player player;
        private readonly float speed;
        private readonly float radius;
        private readonly float damage;
        private readonly int penetration;
        private int remDuration = -1;
        private Vector2 direction;


        public ChaosAnomaly(Player player, int duration, Position target, float tps, float dist, float aoeRadius, float damage, int penetration)
            : base(player.Manager, 0x2006)
        {
            this.ent = new Vector2(this.X, this.Y);
            this.player = player;
            this.duration = duration;
            this.radius = aoeRadius;
            this.damage = damage;
            this.remDuration = duration;
            this.penetration = penetration;
            speed = tps;
            direction = new Vector2(target.X - player.X, target.Y - player.Y);
            direction.Normalize();
        }
        public void dmgEnemy(RealmTime time)
        {
            if (remDuration > 0)
            {
                this.AOE(radius/2, false, enemy =>
                {
                    if (enemy != null)
                        (enemy as Enemy).Damage(player, time, (int)damage, penetration, true, null);
                });
            }
        }

        public override void Tick(RealmTime time)
        {
            if (remDuration == 0)
            {
                Owner.LeaveWorld(this);
                remDuration = -1;
            }
            else
                remDuration -= time.ElaspedMsDelta;
            r++;
            this.ValidateAndMove(
                    X + direction.X * speed * time.ElaspedMsDelta / 1000,
                    Y + direction.Y * speed * time.ElaspedMsDelta / 1000
                    );
            if (r % 2 == 0)
            {
                dmgEnemy(time);
            }
            this.UpdateCount++;
        }
    }
}
