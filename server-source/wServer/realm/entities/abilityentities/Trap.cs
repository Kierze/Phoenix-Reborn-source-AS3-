using System.Collections.Generic;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    internal class Trap : StaticObject
    {
        private const int LIFETIME = 10;

        private readonly int dmg, penetration, duration;
        private readonly ConditionEffectIndex effect;
        private readonly Player player;
        private readonly float radius;

        private int p, t;

        public Trap(Player player, float radius, int dmg, int penetration, ConditionEffectIndex eff, float effDuration)
            : base(player.Manager, 0x0711, LIFETIME*1000, true, true, false)
        {
            this.player = player;
            this.radius = radius;
            this.dmg = dmg;
            this.penetration = penetration;
            effect = eff;
            duration = (int) (effDuration*1000);
        }

        public override void Tick(RealmTime time)
        {
            if (t/600 == p)
            {
                Owner.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Trap,
                    Color = new ARGB(0xff9000ff),
                    TargetId = Id,
                    PosA = new Position {X = radius/2}
                }, null);
                p++;
                if (p == LIFETIME*2)
                {
                    Explode(time);
                    return;
                }
            }
            t += time.ElaspedMsDelta;

            bool monsterNearby = false;
            this.AOE(radius/2, false, enemy => monsterNearby = true);
            if (monsterNearby)
                Explode(time);

            base.Tick(time);
        }

        private void Explode(RealmTime time)
        {
            Owner.BroadcastPacket(new ShowEffectPacket
            {
                EffectType = EffectType.AreaBlast,
                Color = new ARGB(0xff9000ff),
                TargetId = Id,
                PosA = new Position {X = radius}
            }, null);
            this.AOE(radius, false, enemy =>
            {
                (enemy as Enemy).Damage(player, time, dmg, penetration, false, null, false, new ConditionEffect
                {
                    Effect = effect,
                    DurationMS = duration
                });
            });
            Owner.LeaveWorld(this);
        }
    }
}