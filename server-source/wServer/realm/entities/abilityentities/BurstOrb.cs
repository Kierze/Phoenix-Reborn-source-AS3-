using System;
using System.Collections.Generic;
using Mono.Game;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class BurstOrb : ItemEntity
    {

        private readonly float speed;
        private int remDuration = -1;
        private Position location;
        private Vector2 direction;
        private int duration;
        public int damage;
        public float radius;

        
        public BurstOrb(Player player, int duration, float spd, Position target, int damage, float radius)
            : base(player.Manager, 0x2008)
        {
            this.playerOwner = player;
            this.remDuration = duration;
            this.duration = duration;
            speed = spd;
            this.location = target;
            this.damage = damage;
            this.radius = radius;

            direction = new Vector2(target.X - player.X, target.Y - player.Y);
            direction.Normalize();
        }
        public override void Tick(RealmTime time)
        {
            if (remDuration <= 0)
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
