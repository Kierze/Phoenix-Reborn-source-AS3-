using Mono.Game;
using System.Collections.Generic;
using wServer.networking;
using wServer.networking.svrPackets;


namespace wServer.realm.entities
{
    internal class ChaosOrb : ItemEntity
    {

        private readonly float speed;
        private int remDuration = -1;
        private Position location;
        private Vector2 direction;
        private int duration;
        public int damage;
        public float radius;
        private int penetration = 50;
        public int charges = 0;
        int r = 0;
        bool deathstarted = false;
        List<Packet> pkts = new List<Packet>();
        List<Enemy> enemies = new List<Enemy>();

        public ChaosOrb(Player player, int duration, float spd, Position target, int damage, float radius)
            : base(player.Manager, 0x2010)
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
            ApplyConditionEffect(new ConditionEffect
            {
                Effect = ConditionEffectIndex.Invincible,
                DurationMS = -1
            });
        }
        public override void Tick(RealmTime time)
        {

            if (remDuration <= 0 || charges >= 5 || deathstarted)
            {
                deathstarted = true;
                r++;
                if (charges > 0)
                {
                    if (r % 1 == 0)
                    {
                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffC2F0FF),
                            PosA = new Position { X = radius }
                        });
                        Owner.AOE(new Position { X = X, Y = Y }, radius, false, enemy =>
                        {
                            enemies.Add(enemy as Enemy);
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.Lightning,
                                TargetId = Id,
                                Color = new ARGB(0xffC2F0FF),
                                PosA = new Position
                                {
                                    X = enemy.X,
                                    Y = enemy.Y
                                },
                                PosB = new Position { X = 350 }
                            });
                        });
                        playerOwner.BroadcastSync(pkts, p => this.Dist(p) < 25);
                        foreach (var i in enemies)
                        {
                            i.Damage(playerOwner, time, damage, penetration, false, null);
                        }
                        charges--;
                    }
                }
                else
                {
                    Owner.LeaveWorld(this);
                }
                
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
            UpdateCount++;
        }
    }
}
