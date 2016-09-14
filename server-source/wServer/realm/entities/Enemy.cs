using System;
using System.Collections.Generic;
using wServer.logic;
using wServer.networking.svrPackets;
using wServer.realm.terrain;

namespace wServer.realm.entities
{
    public class Enemy : Character
    {
        private DamageCounter counter;
        private readonly bool zeroHealth;
        private float bleeding;
        public bool burning;
        private Position? pos;
        public Dictionary<Player, int> raged = new Dictionary<Player, int>();
        public Enemy(RealmManager manager, ushort objType)
            : base(manager, objType, new wRandom())
        {
            zeroHealth = ObjectDesc.MaxHP == 0;
            MaxHP = ObjectDesc.MaxHP;
            Defense = ObjectDesc.Defense;
            Resilience = ObjectDesc.Resilience;
            counter = new DamageCounter(this);
        }

        public int Resilience { get; set; }
        public int Defense { get; set; }
        public int MaxHP { get; set; }

        public DamageCounter DamageCounter
        {
            get { return counter; }
        }

        public void SetDamageCounter(DamageCounter counter, Enemy target)
        {
            target.counter = counter;
        }

        public WmapTerrain Terrain { get; set; }

        public int AltTextureIndex { get; set; }

        public Position SpawnPoint
        {
            get { return pos ?? new Position {X = X, Y = Y}; }
        }

        protected override void ExportStats(IDictionary<StatsType, object> stats)
        {
            stats[StatsType.AltTextureIndex] = AltTextureIndex;

            stats[StatsType.Defense] = Defense;
            stats[StatsType.HP] = HP;
            stats[StatsType.MaximumHP] = MaxHP;

            base.ExportStats(stats);
        }

        public override void Init(World owner)
        {
            base.Init(owner);
            if (ObjectDesc.StasisImmune)
                ApplyConditionEffect(new ConditionEffect
                {
                    Effect = ConditionEffectIndex.StasisImmune,
                    DurationMS = -1
                });
        }

        public void Death(RealmTime time)
        {
            counter.Death(time);
            if (CurrentState != null)
                CurrentState.OnDeath(new BehaviorEventArgs(this, time));
            Owner.LeaveWorld(this);

        }

        public int Damage(Player from, RealmTime time, int dmg, int pen, bool noDef, Projectile proj, bool deathmark = false, params ConditionEffect[] effs)
        {
            if (zeroHealth) return 0;
            if (HasConditionEffect(ConditionEffects.Invincible))
                return 0;
            if (!HasConditionEffect(ConditionEffects.Paused) &&
                !HasConditionEffect(ConditionEffects.Stasis))
            {
                int def = Defense;
                int res = Resilience;
                if (noDef)
                {
                    def = 0;
                    Resilience = 0;
                }
                if (from.Specialization == "Blood" && from.AbilityActiveDurations[2] != 0)
                {
                    float totalhealth = from.Stats[0];
                    float dmgPercentage = from.HP / totalhealth;
                    dmg = dmg + (int)(dmg * dmgPercentage);
                }
                if (from.Specialization == "Marksmanship" && from.AbilityActiveDurations[2] != 0)
                {
                    from.bowBlessing = from.bowBlessing + 5;
                    float blessing = from.bowBlessing;
                    float dmgmodifier = blessing / 100;
                    dmg = (int)(dmg * dmgmodifier);
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.FireBall && burning)
                {
                    dmg = dmg * 3;
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.PoisonDagger)
                {
                    from.poisons.Add(new Poison(this, proj.abil));
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.ToxicBolt)
                {
                    if (Owner != null)
                    {
                        Owner.BroadcastPacket(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffddff00),
                            PosA = new Position { X = proj.abil.Radius }
                        }, null);
                        Owner.AOE(new Position { X = this.X, Y = this.Y }, proj.abil.Radius, false,
                            enemy =>
                            {
                                from.poisons.Add(new Poison(enemy as Enemy, proj.abil));
                            });

                    }
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.FireBlast)
                {
                    from.burns.Add(new Burn(this, proj.abil));
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.FlameVolley)
                {
                    from.burns.Add(new Burn(this, proj.abil));
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.BlastVolley)
                {

                    Owner.BroadcastPacket(new ShowEffectPacket
                    {
                        EffectType = EffectType.AreaBlast,
                        TargetId = Id,
                        Color = new ARGB(0xffff5500),
                        PosA = new Position { X = proj.abil.Radius }
                    }, null);
                    Owner.AOE(new Position { X = this.X, Y = this.Y }, proj.abil.Radius, false,
                            enemy =>
                            {
                                (enemy as Enemy).Damage(from, time, proj.abil.Damage, pen, false, null);
                                if (burning)
                                {
                                    from.burns.Add(new Burn(enemy as Enemy, proj.abil));
                                }
                            });
                    
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.SkillShot)
                {
                    float elapsed = time.TotalElapsedMs - proj.BeginTime;
                    float dmgmodifier = elapsed / 1500;
                    dmg = (int)(dmg + (dmg * dmgmodifier * 5));
                }
                if (proj != null && proj.abil != null && proj.abil.Ability == ActivateAbilities.DeathArrow)
                {
                    proj.deathhitcount++;
                    dmg = dmg * proj.deathhitcount;
                }
                int effDmg = Math.Min((int)StatsManager.GetEnemyDamage(this, dmg, pen, def, res), HP);
                if (HasConditionEffect(ConditionEffects.Invulnerable)) effDmg = 0;
                HP -= effDmg;

                if (from.DeathMarked != null)
                {
                    if (deathmark == false)
                    {
                        foreach (var i in from.DeathMarked.Keys)
                        {
                            if (i == this || i.Owner == null) continue;
                            i.Damage(from, time, dmg / 10, pen, false, null, true);
                        }
                    }
                }
                ApplyConditionEffect(effs);
                if (effDmg != 0)
                {
                    Owner.BroadcastPacket(new DamagePacket
                    {
                        TargetId = Id,
                        Effects = 0,
                        Damage = (ushort)effDmg,
                        Killed = HP <= 0,
                        BulletId = 0,
                        ObjectId = from != null ? from.Id : -1
                    }, null);
                    
                }

                if (from != null) counter.HitBy(from, time, proj, effDmg);

                if (HP <= 0 && Owner != null)
                {
                    Death(time);
                }

                UpdateCount++;
                return effDmg;
            }
            return 0;
        }
        

        public override bool HitByProjectile(Projectile projectile, RealmTime time)
        {

            if (zeroHealth) return false;
            if (HasConditionEffect(ConditionEffects.Invincible))
                return false;
            if (projectile.ProjectileOwner is Player &&
                !HasConditionEffect(ConditionEffects.Paused) &&
                !HasConditionEffect(ConditionEffects.Stasis))
            {
                ApplyConditionEffect(projectile.Descriptor.Effects);
                counter.HitBy(projectile.ProjectileOwner as Player, time, projectile, projectile.Damage);

                if (HP < 0 && Owner != null)
                {
                    Death(time);
                }
                UpdateCount++;
                return true;
            }
            return false;
        }

        public int TrueDamage(Player from, RealmTime time, int dmg)
        {
            int effDmg = dmg;
            if (effDmg > HP)
                effDmg = HP;
            HP -= dmg;
            Owner.BroadcastPacket(new DamagePacket
            {
                TargetId = Id,
                Effects = 0,
                Damage = (ushort)dmg,
                Killed = HP <= 0,
                BulletId = 0,
                ObjectId = from.Id
            }, null);

            counter.HitBy(from, time, null, dmg);

            if (HP <= 0 && Owner != null)
            {
                Death(time);
            }

            UpdateCount++;
            return effDmg;
        }

        public override void Tick(RealmTime time)
        {
            List<Player> keys = new List<Player>(raged.Keys);
            foreach (var i in keys)
            {
                raged[i] = raged[i] - time.ElaspedMsDelta;
                if (raged[i] <= 0)
                {
                    raged.Remove(i);
                }
            }
            if (pos == null)
                pos = new Position {X = X, Y = Y};

            

            if (!zeroHealth && HasConditionEffect(ConditionEffects.Bleeding))
            {
                if (bleeding > 1)
                {
                    HP -= (int) bleeding;
                    bleeding -= (int) bleeding;
                    UpdateCount++;
                }
                bleeding += 28*(time.ElaspedMsDelta/1000f);
            }
            
            base.Tick(time);
        }
    }
}