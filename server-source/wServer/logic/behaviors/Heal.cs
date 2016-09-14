using System.Linq;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.logic.behaviors
{
    internal class Heal : Behavior
    {
        //State storage: cooldown timer

        private readonly string group;
        private readonly double range;
        private readonly int? amount;
        private Cooldown coolDown;
        private int cool;

        public Heal(double range, string group, int? amount = null, Cooldown coolDown = new Cooldown())
        {
            this.range = (float) range;
            this.group = group;
            this.amount = amount;
            this.coolDown = coolDown.Normalize();
        }

        protected override void OnStateEntry(Entity host, RealmTime time, ref object state)
        {
            state = 0;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            cool = (int)state;

            if (cool <= 0)
            {
                if (host.HasConditionEffect(ConditionEffects.Stunned)) return;

                if (group == null)
                {
                    Enemy e = (host as Enemy);
                    int newHp = e.HP;

                    if (amount != null)
                    {
                        newHp += (int)amount;
                        if (newHp > e.ObjectDesc.MaxHP) newHp = e.ObjectDesc.MaxHP;
                    }
                    else
                    {
                        newHp = e.ObjectDesc.MaxHP;
                    }

                    if (newHp != e.HP)
                    {
                        int n = newHp - e.HP;
                        e.HP = newHp;
                        e.UpdateCount++;
                        e.Owner.BroadcastPacket(new ShowEffectPacket
                        {
                            EffectType = EffectType.Potion,
                            TargetId = e.Id,
                            Color = new ARGB(0xffffffff)
                        }, null);
                        e.Owner.BroadcastPacket(new NotificationPacket
                        {
                            ObjectId = e.Id,
                            Text = "+" + n,
                            Color = new ARGB(0xff00ff00)
                        }, null);
                    }
                    cool = coolDown.Next(Random);
                }
                else
                {
                    foreach (Enemy entity in host.GetNearestEntitiesByGroup(range, group).OfType<Enemy>())
                    {
                        int newHp = entity.ObjectDesc.MaxHP;
                        if (newHp != entity.HP)
                        {
                            int n = newHp - entity.HP;
                            entity.HP = newHp;
                            entity.UpdateCount++;
                            entity.Owner.BroadcastPacket(new ShowEffectPacket
                            {
                                EffectType = EffectType.Potion,
                                TargetId = entity.Id,
                                Color = new ARGB(0xffffffff)
                            }, null);
                            entity.Owner.BroadcastPacket(new ShowEffectPacket
                            {
                                EffectType = EffectType.Trail,
                                TargetId = host.Id,
                                PosA = new Position { X = entity.X, Y = entity.Y },
                                Color = new ARGB(0xffffffff)
                            }, null);
                            entity.Owner.BroadcastPacket(new NotificationPacket
                            {
                                ObjectId = entity.Id,
                                Text = "+" + n,
                                Color = new ARGB(0xff00ff00)
                            }, null);
                        }
                    }
                    cool = coolDown.Next(Random);
                }
            }
            else
                cool -= time.ElaspedMsDelta;

            state = cool;
        }
    }
}