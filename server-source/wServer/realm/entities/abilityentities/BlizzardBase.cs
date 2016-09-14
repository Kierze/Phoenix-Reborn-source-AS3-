using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class BlizzardBase : ItemEntity
    {
        
        private int remDuration = -1;
        private Position location;
        private int duration;
        private int effduration;
        public int damage;
        private int penetration = 50;
        public float radius;
        int r = 10;


        public BlizzardBase(Player player, int duration, int effduration, Position target, int damage, float radius)
            : base(player.Manager, 0x2012)
        {
            playerOwner = player;
            remDuration = duration * 1000;
            this.duration = duration;
            location = target;
            this.damage = damage;
            this.radius = radius;
            this.effduration = effduration;
        }
        public override void Tick(RealmTime time)
        {
            r++;
            if (r % 20 == 0)
            {
                this.AOE(radius, false, enemy =>
                {
                    if (enemy != null)
                        (enemy as Enemy).Damage(playerOwner, time, damage, penetration, false, null);
                    
                        enemy.ApplyConditionEffect(
                               new ConditionEffect
                               {
                                   Effect = ConditionEffectIndex.Slowed,
                                   DurationMS = 2000
                               });
                    
                });
                
            }
            if (r % 10 == 0)
            {
                playerOwner.BroadcastSync(new ShowEffectPacket
                {
                    EffectType = EffectType.AreaBlast,
                    TargetId = Id,
                    Color = new ARGB(0xffC2F0FF),
                    PosA = new Position { X = radius }
                }, p => this.Dist(p) < 25);
            }
            if (remDuration <= 0)
            {
                this.AOE(radius, false, enemy =>
                {
                    if (enemy != null)
                    {
                        (enemy as Enemy).Damage(playerOwner, time, damage, penetration, false, null);

                        enemy.ApplyConditionEffect(
                               new ConditionEffect
                               {
                                   Effect = ConditionEffectIndex.Paralyzed,
                                   DurationMS = effduration
                               });
                    }

                });
                Owner.LeaveWorld(this);
            }
            else
                remDuration -= time.ElaspedMsDelta;
            UpdateCount++;
        }
    }
}
