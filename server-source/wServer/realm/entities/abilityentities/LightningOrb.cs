using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class LightningOrb : ItemEntity
    {

        private readonly float speed;
        private int remDuration = -1;
        private Position location;
        private Vector2 direction;
        private int duration;



        public LightningOrb(Player player, int duration, float spd, Position target)
            : base(player.Manager, 0x2007)
        {
            this.playerOwner = player;
            this.remDuration = duration;
            this.duration = duration;
            speed = spd;
            this.location = target;

            direction = new Vector2(target.X - player.X, target.Y - player.Y);
            direction.Normalize();
            ApplyConditionEffect(new ConditionEffect
            {
                Effect = ConditionEffectIndex.Invincible,
                DurationMS = -1
            });

        }
        public override void Tick(RealmTime time)
        {
            
            if (remDuration <= 0 && Owner != null)
            {
                Owner.LeaveWorld(this);
            }
            
            else
                remDuration -= time.ElaspedMsDelta;
            if (remDuration > duration - 1000)
            {
                this.ValidateAndMove(
                       X + direction.X * speed * time.ElaspedMsDelta / 1000,
                       Y + direction.Y * speed * time.ElaspedMsDelta / 1000
                       );      
            }
            this.UpdateCount++;
        }
    }
}
