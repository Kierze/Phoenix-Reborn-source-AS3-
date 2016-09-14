using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class StormCloud : ItemEntity
    {
        
        private int remDuration = -1;
        public int damage;
        public float radius;
        int firerate;
        int r = 0;
        Enemy target;
        int penetration;

        public StormCloud(Player player, int duration, int damage, int firerate, float radius, int penetration)
            : base(player.Manager, 0x2009)
        {
            this.playerOwner = player;
            this.remDuration = duration;
            this.damage = damage;
            this.radius = radius;
            this.firerate = 10 / firerate;
            this.Size = 0;
            this.penetration = penetration;

            ApplyConditionEffect(new ConditionEffect
            {
                Effect = ConditionEffectIndex.Invincible,
                DurationMS = -1
            });
        }
        public override void Tick(RealmTime time)
        {
            r++;
            if (remDuration <= 0)
            {
                Owner.LeaveWorld(this);
            }
            else
                remDuration -= time.ElaspedMsDelta;

            if (r % firerate == 0)
            {
                target = this.GetNearestEntity(radius, false,
                                    enemy =>
                                        enemy is Enemy) as Enemy;
                if (target != null)
                {
                    Owner.BroadcastPacket(new ShowEffectPacket
                    {
                        EffectType = EffectType.Lightning,
                        TargetId = this.Id,
                        Color = new ARGB(0xffC2F0FF),
                        PosA = new Position
                        {
                            X = target.X,
                            Y = target.Y
                        },
                        PosB = new Position { X = 350 }
                    }, null);
                    target.Damage(playerOwner, time, damage, penetration, false,  null);
                }
            }
            if (Size < 100)
            {
                Size += 10;
            }

            UpdateCount++;
        }
    }
}
