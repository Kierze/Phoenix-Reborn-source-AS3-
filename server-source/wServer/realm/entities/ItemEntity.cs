using System;
using System.Collections.Generic;
using System.Xml.Linq;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    public class ItemEntity : Character
    {
        //Stats
        public ItemEntity(RealmManager manager, ushort objType)
            : base(manager, objType, new wRandom())
        {
            zeroHealth = ObjectDesc.MaxHP == 0;
        }

        public bool Dying { get; private set; }
        public int HP { get; set; }
        private readonly bool zeroHealth;
        public bool hittable = false;
        public bool targeted = false;

        public static int? GetHP(XElement elem)
        {
            XElement n = elem.Element("MaxHitPoints");
            if (n != null)
                return Utils.FromString(n.Value);
            return null;
        }
        public override void Init(World owner)
        {
            base.Init(owner);
        }
        protected override void ExportStats(IDictionary<StatsType, object> stats)
        {
            if (!Dying)
                stats[StatsType.HP] = int.MaxValue;
            else
                stats[StatsType.HP] = HP;
            base.ExportStats(stats);
        }
        public bool IsVisibleToEnemy()
        {
            return true;
        }
        public void Damage(int dmg, int pen, Entity chr)
        {
            if (!hittable) return;
            if (zeroHealth) return;
            if (HasConditionEffect(ConditionEffects.Paused) ||
                    HasConditionEffect(ConditionEffects.Stasis) ||
                    HasConditionEffect(ConditionEffects.Invincible))
                return;
            int def = ObjectDesc.Defense;
            int res = ObjectDesc.Resilience;
            
            int effDmg = Math.Min((int)StatsManager.GetEnemyDamage(this, dmg, pen, def, res), HP);
            if (!HasConditionEffect(ConditionEffects.Invulnerable))
                HP -= dmg;
            Owner.BroadcastPacket(new DamagePacket
            {
                TargetId = Id,
                Effects = 0,
                Damage = (ushort)dmg,
                Killed = HP < 0,
                BulletId = 0,
                ObjectId = chr.Id
            }, null);


            if (HP < 0 && Owner != null)
            {
                Owner.LeaveWorld(this);
            }
            UpdateCount++;
        }
        public override bool HitByProjectile(Projectile projectile, RealmTime time)
        {
            if (!hittable) return false;
            if (zeroHealth) return false;
            if (HasConditionEffect(ConditionEffects.Invincible))
                return false;
            if (projectile.ProjectileOwner is Enemy &&
                !HasConditionEffect(ConditionEffects.Paused) &&
                !HasConditionEffect(ConditionEffects.Stasis))
            {
                int def = ObjectDesc.Defense;
                int res = ObjectDesc.Resilience;
                if (projectile.Descriptor.ArmorPiercing)
                {
                    def = 0;
                    res = 0;
                }
                var dmg = projectile.Damage;
                dmg = Math.Min((int)StatsManager.GetEnemyDamage(this, dmg, projectile.Penetration, def, res), HP);
                if (!HasConditionEffect(ConditionEffects.Invulnerable))
                    HP -= dmg;
                ApplyConditionEffect(projectile.Descriptor.Effects);
                Owner.BroadcastPacket(new DamagePacket
                {
                    TargetId = Id,
                    Effects = projectile.ConditionEffects,
                    Damage = (ushort)dmg,
                    Killed = HP < 0,
                    BulletId = projectile.ProjectileId,
                    ObjectId = projectile.ProjectileOwner.Self.Id
                }, null);
                

                if (HP < 0 && Owner != null)
                {
                    Owner.LeaveWorld(this);
                }
                UpdateCount++;
                return true;
            }
            return false;
        }
        //protected bool CheckHP()
        //{
        //    if (HP <= 0)
        //    {
        //        Owner.LeaveWorld(this);
        //        return false;
        //    }
        //    return true;
        //}

        //public override void Tick(RealmTime time)
        //{
        //    if (Dying)
        //    {
        //        HP -= time.ElaspedMsDelta;
        //        UpdateCount++;
        //        CheckHP();
        //    }

        //    base.Tick(time);
        //}
    }
}