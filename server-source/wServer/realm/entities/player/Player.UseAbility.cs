using System;
using Mono.Game;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wServer.networking;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.realm.entities
{
    partial class Player
    {
        private double ToggleMPCost = 0;
        //WarpCrystal warpCrystal;

        private void CheckCache()
        {
            int AP = Stats[8] + Boost[8];
            bool recached = false;
            for (int abilitySlot = 0; abilitySlot < 3; abilitySlot++)
            {
                if (!recached && (CacheAbilities[abilitySlot] == null || CacheAbilities[abilitySlot].AbilityType != Ability[abilitySlot].AbilityType || CacheAP != AP))
                {
                    RecacheAbilities(AP);
                    UpdateCount++;
                    recached = true;
                }
                else if (recached) return;
            }
        }

        private void HandleCooldowns(RealmTime t)
        {
            bool cdChanged = false;
            for (int i = 0; i < 3; i++)
            {
                int prevCooldown = AbilityCooldown[i];
                if (ignoringcooldowns)
                    AbilityCooldown[i] = 0;
                if (AbilityCooldown[i] > 0)
                    AbilityCooldown[i] = AbilityCooldown[i] - t.ElaspedMsDelta;
                if (AbilityCooldown[i] < 0)
                    AbilityCooldown[i] = 0;

                if (AbilityCooldown[i] != prevCooldown)
                    cdChanged = true;
            }
            if (cdChanged)
                UpdateCount++;
        }

        private void HandleActives(RealmTime t)
        {
            bool adChanged = false;
            for (int count = 0; count < 3; count++)
            {
                int prevActiveDuration = AbilityActiveDurations[count];
                if (AbilityActiveDurations[count] > 0)
                {
                    CheckCache();
                    if (CacheAbilities[count].TickingAbilities != null) TickAbility(CacheAbilities[count], count, t);
                    AbilityActiveDurations[count] = AbilityActiveDurations[count] - t.ElaspedMsDelta;
                    if (AbilityActiveDurations[count] == 0) AbilityActiveDurations[count] = -1;
                }

                if (AbilityActiveDurations[count] < 0)
                {
                    AbilityActiveDurations[count] = 0;
                    EndTickAbility(CacheAbilities[count], count, t);
                    AbilityCooldown[count] = CacheAbilities[count].Cooldown;

                }

                if (AbilityActiveDurations[count] != prevActiveDuration)
                    adChanged = true;
            }
            if (adChanged)
                UpdateCount++;
        }

        private void HandleToggles(RealmTime t)
        {
            double percent = t.ElaspedMsDelta / 1000f; //the percentage of a second that passed.
            for (int count = 0; count < 3; count++)
            {
                if (AbilityToggle[count])
                {
                    CheckCache();
                    ToggleMPCost += CacheAbilities[count].MpCostPerSec * percent;
                    if (ToggleMPCost > MP)
                    {
                        AbilityToggle[count] = false;
                        EndTickAbility(CacheAbilities[count], count, t);
                        ToggleChanged = true;
                        AbilityCooldown[count] = CacheAbilities[count].Cooldown;
                        return;
                    }
                    MP -= (int)ToggleMPCost;
                    ToggleMPCost -= (int)ToggleMPCost; //smoothened MP reduction to avoid having to use integers all the time
                    TickAbility(Ability[count], count, t);
                }
            }

        }

        private Ability CalculateSlotAbility(int abilityPower, Ability abil)
        {
            Ability ret = abil;
            ProjectileDesc[] projs = null;
            if (abil.Formulas != null)
            {
                foreach (Formula f in abil.Formulas)
                {
                    switch (f.Attribute)
                    {
                        case "MpCost":
                            ret.MpCost = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "Cooldown":
                            ret.Cooldown = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "MpCostPerSec":
                            ret.MpCostPerSec = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "ActiveDuration":
                            ret.ActiveDuration = (int)CalculateFormula(abilityPower, f);
                            break;
                        default:
                            break;
                    }
                }
            }
            if (abil.Projectiles != null)
            {
                projs = new ProjectileDesc[abil.Projectiles.Length];
                for (int i = 0; i < abil.Projectiles.Length; i++)
                {
                    projs[i] = CalculateProjectileFormulas(abilityPower, abil.Projectiles[i]);
                }
            }
            ret.Projectiles = projs;
            ret.Formulas = null;
            return ret;
        }

        private ProjectileDesc CalculateProjectileFormulas(int abilityPower, ProjectileDesc old)
        {
            ProjectileDesc ret = old;
            if (old.Formulas != null)
            {
                foreach (Formula f in old.Formulas)
                {
                    switch (f.Attribute.ToLower()) //this sorts out the formulas by attribute allowing it to change each property individually
                    {
                        case "speed":
                            ret.Speed = (float)CalculateFormula(abilityPower, f);
                            break;
                        case "mindamage":
                            ret.MinDamage = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "maxdamage":
                            ret.MaxDamage = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "lifetimems":
                            ret.LifetimeMS = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "amplitude":
                            ret.Amplitude = (float)CalculateFormula(abilityPower, f);
                            break;
                        case "frequency":
                            ret.Frequency = (float)CalculateFormula(abilityPower, f);
                            break;
                        case "penetration":
                            ret.Penetration = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "poisondamage":
                            ret.PoisonDamage = (int)CalculateFormula(abilityPower, f);
                            break;
                        case "durationms":
                            ret.DurationMS = (int)CalculateFormula(abilityPower, f);
                            break;
                        default:
                            break;
                    }
                }
                ret.Formulas = null;
            }
            return ret;
        }

        private ActivateAbility CalculateAbility(int abilityPower, ActivateAbility abil)
        {
            ActivateAbility ret = abil;
            if (abil.Formulas != null)
            {
                foreach (Formula f in abil.Formulas)
                {
                    AbilityProperties prop;
                    if (Enum.TryParse(f.Attribute, true, out prop))
                    {
                        switch (prop)
                        {
                            case AbilityProperties.Amount:
                                ret.Amount = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Range:
                                ret.Range = (float)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.DurationMS:
                                ret.DurationMS = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.EffectDuration:
                                ret.EffectDuration = (float)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MaximumDistance:
                                ret.MaximumDistance = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Radius:
                                ret.Radius = (float)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.TotalDamage:
                                ret.TotalDamage = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.AngleOffset:
                                ret.AngleOffset = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MaxTargets:
                                ret.MaxTargets = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MoveDistance:
                                ret.MoveDistance = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Damage:
                                ret.Damage = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Penetration:
                                ret.Penetration = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.FireRate:
                                ret.FireRate = (int)CalculateFormula(abilityPower, f);
                                break;
                            default:
                                break;
                        }
                    }
                }
                ret.Formulas = null;
            }
            return ret;
        }

        private AbilityPerTick CalculatePerTickAbility(int abilityPower, AbilityPerTick abil)
        {
            AbilityPerTick ret = abil;
            if (abil.Formulas != null)
            {
                foreach (Formula f in abil.Formulas)
                {
                    AbilityProperties prop;
                    if (Enum.TryParse(f.Attribute, true, out prop))
                    {
                        switch (prop)
                        {
                            case AbilityProperties.Amount:
                                ret.Amount = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Range:
                                ret.Range = (float)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MaximumDistance:
                                ret.MaximumDistance = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Radius:
                                ret.Radius = (float)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.TotalDamage:
                                ret.TotalDamage = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.AngleOffset:
                                ret.AngleOffset = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.DurationMS:
                                ret.DurationMS = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MaxTargets:
                                ret.MaxTargets = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.MoveDistance:
                                ret.MoveDistance = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Damage:
                                ret.Damage = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.Penetration:
                                ret.Penetration = (int)CalculateFormula(abilityPower, f);
                                break;
                            case AbilityProperties.FireRate:
                                ret.FireRate = (int)CalculateFormula(abilityPower, f);
                                break;
                            default:
                                break;
                        }
                    }
                }
                ret.Formulas = null;
            }
            return ret;
        }

        private double CalculateFormula(int abilityPower, Formula f)
        {
            double ret;
            int min = f.Minimum;
            int max = f.Maximum;
            RoundingTypes rType = f.Rounding;
            switch (f.Type)
            {
                case ScaleTypes.Flat: //Returns only the base value, no math done.
                    ret = f.Base;
                    break;
                case ScaleTypes.Simple: //Simple linear equation.
                    //In the similar model of y = mx + b
                    //Output = GainPerAP * abilityPower + Base
                    //This output is rounded, then checked within the min, max range.
                    ret = CheckLimits(min, max, RoundFormula((f.Base + (f.GainPerAP * abilityPower)), rType));
                    break;
                case ScaleTypes.ExpoGain: //Exponential equation, rising in potential output with each level of AP.
                    //In the similar model of y = x^e + b
                    //Output = abilityPower^Exponent + Base
                    //This output is rounded, then checked within the min, max range.
                    ret = CheckLimits(min, max, RoundFormula((f.Base + Math.Pow(abilityPower, f.Exponent)), rType));
                    break;
                case ScaleTypes.Increment: //Exponential equation, lowering in potential output with each level of AP.
                    //This is not directly an exponential decay equation. Instead, with each level of AP, the equation reruns with a slightly lower exponent.
                    //This creates an output where each consecutive output has less gain than the former.
                    //This output is rounded, then checked within the min, max range.
                    double add = 0;
                    for (int q = 0; q < abilityPower; q++)
                    {
                        double a = f.DecayExponent + (q * f.DecayExponentMultiplier);
                        add += Math.Pow(f.ExponentBase, a);
                    }
                    ret = CheckLimits(min, max, RoundFormula((f.Base + add), rType));
                    break;
                case ScaleTypes.LogGain: //Exponential equation similar to "expogain", however AP acts as the exponent.
                    //ScaleFactor simply exists to scale AP into a more convenient value for an exponent.
                    double b = abilityPower * f.ScaleFactor;
                    ret = CheckLimits(min, max, RoundFormula((f.Base + Math.Pow(f.ExponentBase, b)), rType));
                    break;
                case ScaleTypes.ExpoGainComposite: //Same as "expogain", except added with the "simple" equation.
                    ret = CheckLimits(min, max, RoundFormula((f.Base + (f.GainPerAP * abilityPower) + Math.Pow(abilityPower, f.Exponent)), rType));
                    break;
                case ScaleTypes.IncrementComposite: //Same as "expodecay", except added with the "simple equation.
                    double addd = 0;
                    for (int q = 0; q < abilityPower; q++)
                    {
                        double c = f.DecayExponent + (q * f.DecayExponentMultiplier);
                        addd += Math.Pow(f.ExponentBase, c);
                    }
                    ret = CheckLimits(min, max, RoundFormula((f.Base + (f.GainPerAP * abilityPower) + addd), rType));
                    break;
                default:
                    ret = f.Base;
                    break;
            }
            return ret;
        }
        private double RoundFormula(double n, RoundingTypes roundingType)
        {
            //Used in the formula system, this rounds the input value using the specified rounding method and returns it.
            double ret;
            switch (roundingType)
            {
                case RoundingTypes.True:
                    ret = Math.Round(n);
                    break;
                case RoundingTypes.Ceiling:
                    ret = Math.Ceiling(n);
                    break;
                case RoundingTypes.Floor:
                    ret = Math.Floor(n);
                    break;
                default:
                    ret = n;
                    break;
            }
            return ret;
        }
        private double CheckLimits(int min, int max, double n)
        {
            //Used in the formula system, this verifies that the input value is within the range of the min, max values.
            //Values lower than min will be set to min. Values higher than max will be set to max.
            double ret = n;
            if (n < min) ret = min;
            if (n > max) ret = max;
            return ret;
        }

        

        
        private void ActivateAbilityShoot(RealmTime time, Ability ability, Position target, int prj, ActivateAbility abil = null)
        {
            double arcGap = ability.ArcGap * Math.PI / 180;
            double startAngle = Math.Atan2(target.Y - Y, target.X - X) - (ability.NumProjectiles - 1) / 2 * arcGap;
            ProjectileDesc prjDesc = ability.Projectiles[prj]; //Assume only one

            var batch = new Packet[ability.NumProjectiles];
            for (int i = 0; i < ability.NumProjectiles; i++)
            {
                Projectile proj = CreateProjectile(prjDesc, ObjectDesc.ObjectType,
                    (int)statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                    time.TotalElapsedMs, new Position { X = X, Y = Y }, (float)(startAngle + arcGap * i), abil);

                Owner.EnterWorld(proj);
                fameCounter.Shoot(proj);
                batch[i] = new ShootPacket
                {
                    BulletId = proj.ProjectileId,
                    OwnerId = Id,
                    ContainerType = ability.AbilityType,
                    Position = new Position { X = X, Y = Y },
                    Angle = proj.Angle,
                    Damage = (short)proj.Damage,
                    FromAbility = true,
                    hasFormula = prjDesc.hasFormulas
                };
            }
            BroadcastSync(batch, p => this.Dist(p) < 25);
        }

        private void ActivateAbilityArrowShoot(RealmTime time, Ability ability, Position target, int prj, ActivateAbility abil)
        {
            double arcGap = ability.ArcGap * Math.PI / 180;
            double startAngle = Math.Atan2(target.Y - Y, target.X - X) - (ability.NumProjectiles - 1) / 2 * arcGap;

            var batch = new Packet[ability.NumProjectiles];
            for (int i = 0; i < ability.NumProjectiles; i++)
            {
                ProjectileDesc prjDesc = ability.Projectiles[i];
                Projectile proj = CreateProjectile(prjDesc, ObjectDesc.ObjectType,
                    (int)statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                    time.TotalElapsedMs, new Position { X = X, Y = Y }, (float)(startAngle + arcGap * i), abil);


                Owner.EnterWorld(proj);
                fameCounter.Shoot(proj);
                batch[i] = new ShootPacket
                {
                    BulletId = proj.ProjectileId,
                    OwnerId = Id,
                    ContainerType = ability.AbilityType,
                    Position = new Position { X = X, Y = Y },
                    Angle = proj.Angle,
                    Damage = (short)proj.Damage,
                    FromAbility = true,
                    hasFormula = prjDesc.hasFormulas
                };
            }
            BroadcastSync(batch, p => this.Dist(p) < 25);

        }

        private void ActivateAbilityDisablingStrike(RealmTime time, Ability ability, Position target, int dmg, int prj)
        {
            double arcGap = ability.ArcGap * Math.PI / 180;
            double startAngle = Math.Atan2(target.Y - Y, target.X - X) - (ability.NumProjectiles - 1) / 2 * arcGap;
            ProjectileDesc prjDesc = ability.Projectiles[prj]; //Assume only one
           
            var batch = new Packet[ability.NumProjectiles];
            for (int i = 0; i < ability.NumProjectiles; i++)
            {
                Projectile proj = CreateProjectile(prjDesc, ObjectDesc.ObjectType,
                    (int)statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                    time.TotalElapsedMs, new Position { X = X, Y = Y }, (float)(startAngle + arcGap * i));
                Owner.EnterWorld(proj);
                fameCounter.Shoot(proj);

                batch[i] = new ShootPacket
                {
                    BulletId = proj.ProjectileId,
                    OwnerId = Id,
                    ContainerType = ability.AbilityType,
                    Position = new Position { X = X, Y = Y },
                    Angle = proj.Angle,
                    Damage = (short)dmg,
                    FromAbility = true,
                    hasFormula = prjDesc.hasFormulas
                };
            }
            BroadcastSync(batch, p => this.Dist(p) < 25);
        }

        private Ability CacheAbility(Ability abil, int AP)
        {
            Ability CacheAbil = CalculateSlotAbility(AP, abil);

            if (CacheAbil.ActivateAbilities != null)
            {
                ActivateAbility[] ActivateAbils = new ActivateAbility[CacheAbil.ActivateAbilities.Length];
                for (int count = 0; count < ActivateAbils.Length; count++)
                {
                    ActivateAbils[count] = CalculateAbility(AP, CacheAbil.ActivateAbilities[count]);
                }
                CacheAbil.ActivateAbilities = ActivateAbils;
            }

            if (CacheAbil.TickingAbilities != null)
            {
                AbilityPerTick[] TickAbils = new AbilityPerTick[CacheAbil.TickingAbilities.Length];
                for (int count = 0; count < TickAbils.Length; count++)
                {
                    TickAbils[count] = CalculatePerTickAbility(AP, CacheAbil.TickingAbilities[count]);
                }
                CacheAbil.TickingAbilities = TickAbils;
            }

            return CacheAbil;
        }

        private void RecacheAbilities(int AP)
        {
            for (int count = 0; count < 3; count++)
            {
                if (Ability[count] != null) CacheAbilities[count] = CacheAbility(Ability[count], AP);
            }
            CacheAP = AP;
        }

        public bool ToggleChanged = false;
        
        public void UseAbility(RealmTime time, int abilitySlot, Position target, int AP)
        {
            
            if (Ability[abilitySlot] == null) return;

            CheckCache();

            var ability = CacheAbilities[abilitySlot];

            if (ability.Toggle) //MP and Cooldown and Ticking handling for Toggle abilities
            {
                if (AbilityToggle[abilitySlot]) //Turn off the Toggle
                {
                    AbilityToggle[abilitySlot] = false;
                    EndTickAbility(ability, abilitySlot, time);
                    AbilityCooldown[abilitySlot] = ability.Cooldown;
                    ToggleChanged = true;
                    return;
                }
                else //Turn on the Toggle
                {
                    if (HasConditionEffect(ConditionEffects.Quiet) || MP < ability.MpCost || AbilityCooldown[abilitySlot] != 0 ) return;
                    MP -= ability.MpCost;
                    AbilityToggle[abilitySlot] = true;
                    ToggleChanged = true;
                }
            }

            if (ability.ActiveDuration > 0) //MP and Cooldown and Ticking handling for ActiveDuration abilities
            {
                if (AbilityActiveDurations[abilitySlot] == 0)
                {
                    if (HasConditionEffect(ConditionEffects.Quiet) || MP < ability.MpCost || AbilityCooldown[abilitySlot] != 0) return;
                    MP -= ability.MpCost;
                    AbilityActiveDurations[abilitySlot] = ability.ActiveDuration;
                }
                else return;
            }

            if (ability.ActiveDuration == 0 && !ability.Toggle) //MP and Cooldown handling for normal abilities
            {
                if (HasConditionEffect(ConditionEffects.Quiet) || MP < ability.MpCost || AbilityCooldown[abilitySlot] != 0) return;
                MP -= ability.MpCost;
                AbilityCooldown[abilitySlot] = ability.Cooldown;
            }
                
            foreach (ActivateAbility abil in ability.ActivateAbilities)
            {
                AbilityAmount = abil.Amount;
                switch (abil.Ability)
                {

                    case ActivateAbilities.BulletNova:
                        {
                            ProjectileDesc prjDesc = ability.Projectiles[0]; //Assume only one
                            int shots = 20;
                            if (abil.Amount > 0) shots = abil.Amount;
                            var batch = new Packet[shots + 1];
                            for (int i = 0; i < shots; i++)
                            {
                                Projectile proj = CreateProjectile(prjDesc, ability.AbilityType,
                                    (int)statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                                    time.TotalElapsedMs, target, (float)(i * (Math.PI * 2) / shots));
                                Owner.EnterWorld(proj);
                                fameCounter.Shoot(proj);
                                batch[i] = new ShootPacket
                                {
                                    BulletId = proj.ProjectileId,
                                    OwnerId = Id,
                                    ContainerType = ability.AbilityType,
                                    Position = target,
                                    Angle = proj.Angle,
                                    Damage = (short)proj.Damage,
                                    FromAbility = true,
                                    hasFormula = prjDesc.hasFormulas
                                };
                            }
                            batch[shots] = new ShowEffectPacket
                            {
                                EffectType = EffectType.Trail,
                                PosA = target,
                                TargetId = Id,
                                Color = new ARGB(0xFFFF00AA)
                            };
                            BroadcastSync(batch, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.FireBlast:
                        {
                            ProjectileDesc prjDesc = ability.Projectiles[0]; //Assume only one
                            int shots = 20;
                            if (abil.Amount > 0) shots = abil.Amount;
                            var batch = new Packet[shots + 1];
                            for (int i = 0; i < shots; i++)
                            {
                                Projectile proj = CreateProjectile(prjDesc, ability.AbilityType,
                                    (int)statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                                    time.TotalElapsedMs, target, (float)(i * (Math.PI * 2) / shots), abil);
                                Owner.EnterWorld(proj);
                                fameCounter.Shoot(proj);
                                batch[i] = new ShootPacket
                                {
                                    BulletId = proj.ProjectileId,
                                    OwnerId = Id,
                                    ContainerType = ability.AbilityType,
                                    Position = target,
                                    Angle = proj.Angle,
                                    Damage = (short)proj.Damage,
                                    FromAbility = true,
                                    hasFormula = prjDesc.hasFormulas
                                };
                            }
                            batch[shots] = new ShowEffectPacket
                            {
                                EffectType = EffectType.Trail,
                                PosA = target,
                                TargetId = Id,
                                Color = new ARGB(0xFFFF00AA)
                            };
                            BroadcastSync(batch, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.Shoot:
                        {
                            ActivateAbilityShoot(time, ability, target, 0);
                        }
                        break;
                    case ActivateAbilities.FireBall:
                        {
                            ActivateAbilityShoot(time, ability, target, 0, abil);
                        }
                        break;
                    case ActivateAbilities.Burn:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Diffuse,
                                TargetId = Id,
                                Color = new ARGB(0xffff5500),
                                PosA = target,
                                PosB = new Position { X = target.X + (float)abil.Radius, Y = target.Y }
                            }, p => this.Dist(p) < 25);
                            Owner.AOE(target, (float)abil.Radius, false,
                                enemy =>
                                {
                                    burns.Add(new Burn(enemy as Enemy, abil));
                                    (enemy as Enemy).Damage(this, time, abil.Damage, abil.Penetration, false, null);
                                });
                        }
                        break;

                    case ActivateAbilities.ChaosAnomaly:
                        {
                            var pkts = new List<Packet>();
                            double a = X - target.X;
                            double b = Y - target.Y;
                            double distance = Math.Sqrt(a * a + b * b);
                            var spd = distance / (abil.DurationMS / 1000f);
                            var dist = spd * (time.ElaspedMsDelta / 1000f);
                            var chaosAnomaly = new ChaosAnomaly(this, abil.DurationMS, target, (float)spd, (float)dist, 4f, (float)abil.Damage, abil.Penetration);
                            chaosAnomaly.Move(X, Y);
                            Owner.EnterWorld(chaosAnomaly);

                            chaosAnomaly.UpdateCount++;
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius / 2 }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.MoveCamera:
                        {
                            if (!FixedCamera)
                            {
                                CameraX = target.X;
                                CameraY = target.Y;
                                FixedCamera = true;
                                BroadcastSync(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Trail,
                                    PosA = target,
                                    TargetId = Id,
                                    Color = new ARGB(0xFFFFFF00)
                                });
                            }
                            else
                            {
                                CameraX = CameraY = 0;
                                FixedCamera = false;
                            }
                            CameraUpdate = true;
                        }
                        break;
                    case ActivateAbilities.Lightning:
                        {
                            Enemy start = null;
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double diff = Math.PI / 3;
                            Owner.AOE(target, 6, false, enemy =>
                            {
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff)
                                {
                                    start = enemy as Enemy;
                                    diff = Math.Abs(angle - x);
                                }
                            });
                            if (start == null) break;

                            Enemy current = start;
                            var targets = new Enemy[abil.MaxTargets];
                            for (int i = 0; i < targets.Length; i++)
                            {
                                targets[i] = current;
                                var next = current.GetNearestEntity(8, false,
                                    enemy =>
                                        enemy is Enemy &&
                                        Array.IndexOf(targets, enemy) == -1 &&
                                        this.Dist(enemy) <= 6) as Enemy;

                                if (next == null) break;
                                current = next;
                            }

                            var pkts = new List<Packet>();
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Lightning,
                                    TargetId = prev.Id,
                                    Color = new ARGB(0xffC2F0FF),
                                    PosA = new Position
                                    {
                                        X = targets[i].X,
                                        Y = targets[i].Y
                                    },
                                    PosB = new Position { X = 350 }
                                });
                            }
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                targets[i].Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                if (abil.ConditionEffect != null)
                                    targets[i].ApplyConditionEffect(new ConditionEffect
                                    {
                                        Effect = abil.ConditionEffect.Value,
                                        DurationMS = (int)(abil.EffectDuration * 1000)
                                    });
                            }

                        }
                        break;
                    case ActivateAbilities.ChainLightning:
                        {
                            Entity start = null;
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double diff = Math.PI / 3;
                            Owner.AOE(target, 6, false, true, enemy =>
                            {
                                if (enemy is ItemEntity && ((enemy.ObjectDesc.ObjectType != 0x2007 && enemy.ObjectDesc.ObjectType != 0x2008) || enemy.playerOwner != this)) return;
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff)
                                {
                                    start = enemy as Entity;
                                    diff = Math.Abs(angle - x);
                                }
                            });
                            if (start == null) break;

                            Entity current = start;
                            var targets = new Entity[abil.MaxTargets];
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (current.ObjectDesc.ObjectType == 0x2007 && current.playerOwner == this)
                                {
                                    Array.Resize(ref targets, i + 1 + abil.MaxTargets);
                                }
                                targets[i] = current;
                                var next = current.GetNearestEntity(8, false,
                                    enemy =>
                                        (enemy != null && (enemy is Enemy || enemy is ItemEntity)) &&
                                        Array.IndexOf(targets, enemy) == -1 &&
                                        this.Dist(enemy) <= 6) as Entity;

                                if (next == null) break;
                                current = next;
                            }

                            var pkts = new List<Packet>();
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Lightning,
                                    TargetId = prev.Id,
                                    Color = new ARGB(0xffC2F0FF),
                                    PosA = new Position
                                    {
                                        X = targets[i].X,
                                        Y = targets[i].Y
                                    },
                                    PosB = new Position { X = 350 }
                                });
                                if (targets[i].ObjectDesc.ObjectType == 0x2008)
                                {
                                    BurstOrb orb = targets[i] as BurstOrb;
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = orb.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position { X = orb.radius }
                                    });
                                }
                            }
                            //BroadcastSync(pkts, p => this.Dist(p) < 25);
                            int damage = abil.TotalDamage;
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                if (!(targets[i] is ItemEntity))
                                {
                                    (targets[i] as Enemy).Damage(this, time, damage, abil.Penetration, false, null);
                                    if (abil.ConditionEffect != null)
                                        targets[i].ApplyConditionEffect(new ConditionEffect
                                        {
                                            Effect = abil.ConditionEffect.Value,
                                            DurationMS = (int)(abil.EffectDuration * 1000)
                                        });
                                }
                                else if (targets[i].ObjectDesc.ObjectType == 0x2008)
                                {
                                    BurstOrb orb = targets[i] as BurstOrb;
                                    this.AOE(orb.radius, false, enemy =>
                                    {
                                        (enemy as Enemy).Damage(this, time, orb.damage, abil.Penetration, false, null);
                                    });
                                }
                                damage = (int)Math.Round(damage + (damage * 0.2));

                            }
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.LightningOrb:
                        {
                            double a = X - target.X;
                            double b = Y - target.Y;
                            double distance = Math.Sqrt(a * a + b * b);
                            var spd = distance / (1);
                            var LightningOrb = new LightningOrb(this, abil.DurationMS, (float)spd, target);
                            LightningOrb.Move(X, Y);
                            Owner.EnterWorld(LightningOrb);
                            LightningOrb.UpdateCount++;
                        }
                        break;
                    case ActivateAbilities.BurstOrb:
                        {
                            double a = X - target.X;
                            double b = Y - target.Y;
                            double distance = Math.Sqrt(a * a + b * b);
                            var spd = distance / (1);
                            var BurstOrb = new BurstOrb(this, abil.DurationMS, (float)spd, target, abil.Damage, abil.Radius);
                            BurstOrb.Move(X, Y);
                            Owner.EnterWorld(BurstOrb);
                            BurstOrb.UpdateCount++;
                        }
                        break;
                    case ActivateAbilities.StormSurge:
                        {
                            Enemy start = null;
                            Enemy start2 = null;
                            Enemy start3 = null;
                            int startcount = 0;
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double diff = Math.PI / 3;
                            double diff2 = Math.PI / 3;
                            double diff3 = Math.PI / 3;
                            Owner.AOE(target, 6, false, enemy =>
                            {
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff)
                                {
                                    start = enemy as Enemy;
                                    diff = Math.Abs(angle - x);
                                }
                            });
                            Owner.AOE(target, 6, false, enemy =>
                            {
                                if (enemy == start) return;
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff2)
                                {
                                    start2 = enemy as Enemy;
                                    diff2 = Math.Abs(angle - x);
                                }
                            });
                            Owner.AOE(target, 6, false, enemy =>
                            {
                                if (enemy == start || enemy == start2) return;
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff3)
                                {
                                    start3 = enemy as Enemy;
                                    diff3 = Math.Abs(angle - x);
                                }
                            });
                            if (start == null) break;

                            Enemy current = start;
                            Enemy current2 = start2;
                            Enemy current3 = start3;
                            var targets = new Enemy[abil.MaxTargets];
                            var targets2 = new Enemy[abil.MaxTargets];
                            var targets3 = new Enemy[abil.MaxTargets];
                            for (int i = 0; i < targets.Length; i++)
                            {
                                targets[i] = current;
                                var next = current.GetNearestEntity(8, false,
                                    enemy =>
                                        enemy is Enemy &&
                                        Array.IndexOf(targets, enemy) == -1 &&
                                        this.Dist(enemy) <= 6) as Enemy;

                                if (next == null) break;
                                current = next;
                            }
                            if (start2 != null)
                            {
                                for (int i = 0; i < targets2.Length; i++)
                                {
                                    targets2[i] = current2;
                                    var next = current2.GetNearestEntity(8, false,
                                        enemy =>
                                            enemy is Enemy &&
                                            Array.IndexOf(targets2, enemy) == -1 &&
                                            this.Dist(enemy) <= 6) as Enemy;

                                    if (next == null) break;
                                    current2 = next;
                                }
                            }
                            if (start3 != null)
                            {
                                for (int i = 0; i < targets3.Length; i++)
                                {
                                    targets3[i] = current3;
                                    var next = current3.GetNearestEntity(8, false,
                                        enemy =>
                                            enemy is Enemy &&
                                            Array.IndexOf(targets3, enemy) == -1 &&
                                            this.Dist(enemy) <= 6) as Enemy;

                                    if (next == null) break;
                                    current3 = next;
                                }
                            }
                            var pkts = new List<Packet>();
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];

                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Lightning,
                                    TargetId = prev.Id,
                                    Color = new ARGB(0xffC2F0FF),
                                    PosA = new Position
                                    {
                                        X = targets[i].X,
                                        Y = targets[i].Y
                                    },
                                    PosB = new Position { X = 350 }
                                });
                            }
                            if (start2 != null)
                            {
                                for (int i = 0; i < targets2.Length; i++)
                                {
                                    if (targets2[i] == null) break;
                                    Entity prev = i == 0 ? (Entity)this : targets2[i - 1];

                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Lightning,
                                        TargetId = prev.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position
                                        {
                                            X = targets2[i].X,
                                            Y = targets2[i].Y
                                        },
                                        PosB = new Position { X = 350 }
                                    });
                                }
                            }
                            if (start3 != null)
                            {
                                for (int i = 0; i < targets3.Length; i++)
                                {
                                    if (targets3[i] == null) break;
                                    Entity prev = i == 0 ? (Entity)this : targets3[i - 1];

                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Lightning,
                                        TargetId = prev.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position
                                        {
                                            X = targets3[i].X,
                                            Y = targets3[i].Y
                                        },
                                        PosB = new Position { X = 350 }
                                    });
                                }
                            }
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                targets[i].Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                if (abil.ConditionEffect != null)
                                    targets[i].ApplyConditionEffect(new ConditionEffect
                                    {
                                        Effect = abil.ConditionEffect.Value,
                                        DurationMS = (int)(abil.EffectDuration * 1000)
                                    });
                            }
                            if (start2 != null)
                            {
                                for (int i = 0; i < targets2.Length; i++)
                                {
                                    if (targets2[i] == null) break;
                                    Entity prev = i == 0 ? (Entity)this : targets2[i - 1];
                                    targets2[i].Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                    if (abil.ConditionEffect != null)
                                        targets2[i].ApplyConditionEffect(new ConditionEffect
                                        {
                                            Effect = abil.ConditionEffect.Value,
                                            DurationMS = (int)(abil.EffectDuration * 1000)
                                        });
                                }
                            }
                            if (start3 != null)
                            {
                                for (int i = 0; i < targets3.Length; i++)
                                {
                                    if (targets3[i] == null) break;
                                    Entity prev = i == 0 ? (Entity)this : targets3[i - 1];
                                    targets3[i].Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                    if (abil.ConditionEffect != null)
                                        targets3[i].ApplyConditionEffect(new ConditionEffect
                                        {
                                            Effect = abil.ConditionEffect.Value,
                                            DurationMS = (int)(abil.EffectDuration * 1000)
                                        });
                                }
                            }

                        }
                        break;
                    case ActivateAbilities.StormCloud:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Trail,
                                TargetId = Id,
                                PosA = target,
                                Color = new ARGB(0xffC2F0FF)
                            }, p => this.Dist(p) < 25);
                            var StormCloud = new StormCloud(this, abil.DurationMS, abil.Damage, abil.FireRate, abil.Radius, abil.Penetration);
                            StormCloud.Move(target.X, target.Y);
                            Owner.EnterWorld(StormCloud);
                            StormCloud.UpdateCount++;
                        }
                        break;
                    case ActivateAbilities.CloudBurst:
                        {
                            var pkts = new List<Packet>();
                            var enemies = new List<Enemy>();
                            Entity start = null;
                            int hitcount = 0;
                            Owner.AOE(target, 6, false, true, targetcloud =>
                            {
                                if (targetcloud == null || targetcloud.ObjectDesc.ObjectType != 0x2009 || start != null || targetcloud.playerOwner != this) return;
                                {
                                    hitcount++;
                                    start = targetcloud;
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Lightning,
                                        TargetId = this.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position
                                        {
                                            X = start.X,
                                            Y = start.Y
                                        },
                                        PosB = new Position { X = 350 }
                                    });
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = start.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position { X = abil.Radius }
                                    });
                                    Owner.LeaveWorld(targetcloud);
                                }


                            });
                            if (start != null)
                            {
                                Owner.AOE(new Position { X = start.X, Y = start.Y }, abil.Radius, false, enemy =>
                                {
                                    enemies.Add(enemy as Enemy);
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Lightning,
                                        TargetId = start.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position
                                        {
                                            X = enemy.X,
                                            Y = enemy.Y
                                        },
                                        PosB = new Position { X = 350 }
                                    });
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                                foreach (var i in enemies)
                                {
                                    i.Damage(this, time, abil.Damage, abil.Penetration, false, null);
                                    i.ApplyConditionEffect(
                                        new ConditionEffect
                                        {
                                            Effect = ConditionEffectIndex.Slowed,
                                            DurationMS = abil.DurationMS
                                        }
                                    );
                                }


                            }
                            else
                            {
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Trail,
                                    TargetId = Id,
                                    PosA = target,
                                    Color = new ARGB(0xffC2F0FF)
                                });
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Diffuse,
                                    TargetId = Id,
                                    Color = new ARGB(0xffC2F0FF),
                                    PosA = target,
                                    PosB = new Position { X = target.X + (float)abil.Radius, Y = target.Y }
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                                Owner.AOE(target, (float)abil.Radius, false,
                                    enemy => enemy.ApplyConditionEffect(
                                        new ConditionEffect
                                        {
                                            Effect = ConditionEffectIndex.Slowed,
                                            DurationMS = abil.DurationMS
                                        }
                                    ));

                            }
                        }
                        break;
                    case ActivateAbilities.ChaosBurst:
                        {
                            var pkts = new List<Packet>();
                            var enemies = new List<Entity>();
                            Entity start = null;
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double diff = Math.PI / 3;
                            Owner.AOE(target, 6, false, true, enemy =>
                            {
                                if ((enemy is ItemEntity) && (!(enemy.ObjectType == 0x2010) || enemy.playerOwner != this)) return;
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff)
                                {
                                    start = enemy as Entity;
                                    diff = Math.Abs(angle - x);
                                }
                            });
                            if (start == null) break;
                            enemies.Add(start as Entity);
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.Lightning,
                                TargetId = this.Id,
                                Color = new ARGB(0xffC2F0FF),
                                PosA = new Position
                                {
                                    X = start.X,
                                    Y = start.Y
                                },
                                PosB = new Position { X = 350 }
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = start.Id,
                                Color = new ARGB(0xffC2F0FF),
                                PosA = new Position { X = abil.Radius }
                            });

                            Owner.AOE(new Position { X = start.X, Y = start.Y }, abil.Radius, false, true, enemy =>
                            {
                                if (enemy is Enemy || (enemy.ObjectType == 0x2010 && enemy.playerOwner == this))
                                {
                                    if (enemy == start) return;
                                    enemies.Add(enemy as Entity);
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Lightning,
                                        TargetId = start.Id,
                                        Color = new ARGB(0xffC2F0FF),
                                        PosA = new Position
                                        {
                                            X = enemy.X,
                                            Y = enemy.Y
                                        },
                                        PosB = new Position { X = 350 }
                                    });
                                }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            foreach (var i in enemies)
                            {
                                if (i is Enemy)
                                {
                                    (i as Enemy).Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                }
                                else
                                {
                                    if ((i as ChaosOrb).charges < 15)
                                    {
                                        (i as ChaosOrb).charges++;
                                        (i as ChaosOrb).Size += 10;
                                    }
                                }
                            }
                        }
                        break;
                    case ActivateAbilities.ChaosBolt:
                        {
                            Entity start = null;
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double diff = Math.PI / 3;
                            Owner.AOE(target, 6, false, true, enemy =>
                            {
                                if (enemy is ItemEntity && (enemy.ObjectDesc.ObjectType != 0x2010 || enemy.playerOwner != this)) return;
                                double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                                if (Math.Abs(angle - x) < diff)
                                {
                                    start = enemy as Entity;
                                    diff = Math.Abs(angle - x);
                                }
                            });
                            if (start == null) break;

                            Entity current = start;
                            var targets = new Entity[abil.MaxTargets];
                            for (int i = 0; i < targets.Length; i++)
                            {
                                targets[i] = current;
                                var next = current.GetNearestEntity(8, false,
                                    enemy =>
                                        (enemy is Enemy || (enemy.ObjectType == 0x2010 && enemy.playerOwner == this)) &&
                                        Array.IndexOf(targets, enemy) == -1 &&
                                        this.Dist(enemy) <= 6) as Entity;

                                if (next == null) break;
                                current = next;
                            }

                            var pkts = new List<Packet>();
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Lightning,
                                    TargetId = prev.Id,
                                    Color = new ARGB(0xffC2F0FF),
                                    PosA = new Position
                                    {
                                        X = targets[i].X,
                                        Y = targets[i].Y
                                    },
                                    PosB = new Position { X = 350 }
                                });
                            }
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            for (int i = 0; i < targets.Length; i++)
                            {
                                if (targets[i] == null) break;
                                Entity prev = i == 0 ? (Entity)this : targets[i - 1];
                                if (targets[i] is Enemy)
                                {
                                    (targets[i] as Enemy).Damage(this, time, abil.TotalDamage, abil.Penetration, false, null);
                                    targets[i].ApplyConditionEffect(new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Paralyzed,
                                        DurationMS = abil.DurationMS
                                    });
                                }
                                else if (targets[i].ObjectDesc.ObjectType == 0x2010)
                                {
                                    if ((targets[i] as ChaosOrb).charges < 15)
                                    {
                                        (targets[i] as ChaosOrb).charges++;
                                        (targets[i] as ChaosOrb).Size += 10;
                                    }
                                }
                            }

                        }
                        break;
                    case ActivateAbilities.ChaosOrb:
                        {
                            double a = X - target.X;
                            double b = Y - target.Y;
                            double distance = Math.Sqrt(a * a + b * b);
                            var spd = distance / (1);
                            var ChaosOrb = new ChaosOrb(this, abil.DurationMS, (float)spd, target, abil.Damage, abil.Radius);
                            ChaosOrb.Move(X, Y);
                            Owner.EnterWorld(ChaosOrb);
                            ChaosOrb.UpdateCount++;
                        }
                        break;
                    case ActivateAbilities.StasisBlast:
                        {
                            var pkts = new List<Packet>();

                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.Concentrate,
                                TargetId = Id,
                                PosA = target,
                                PosB = new Position { X = target.X + 3, Y = target.Y },
                                Color = new ARGB(0xffffffff)
                            });
                            Owner.AOE(target, 3, false, enemy =>
                            {
                                if (enemy.HasConditionEffect(ConditionEffects.StasisImmune))
                                {
                                    pkts.Add(new NotificationPacket
                                    {
                                        ObjectId = enemy.Id,
                                        Color = new ARGB(0xff00ff00),
                                        Text = "Immune"
                                    });
                                }
                                if (enemy.ObjectDesc.StasisImmune)
                                {
                                    pkts.Add(new NotificationPacket
                                    {
                                        ObjectId = enemy.Id,
                                        Color = new ARGB(0xff00ff00),
                                        Text = "Immune"
                                    });
                                }
                                else if (!enemy.HasConditionEffect(ConditionEffects.Stasis))
                                {
                                    enemy.ApplyConditionEffect(
                                        new ConditionEffect
                                        {
                                            Effect = ConditionEffectIndex.Stasis,
                                            DurationMS = abil.DurationMS
                                        },
                                        new ConditionEffect
                                        {
                                            Effect = ConditionEffectIndex.Paused,
                                            DurationMS = abil.DurationMS
                                        },
                                        new ConditionEffect
                                        {
                                            Effect = ConditionEffectIndex.Confused,
                                            DurationMS = abil.DurationMS
                                        }
                                        );
                                }
                                Owner.Timers.Add(new WorldTimer(abil.DurationMS, (world, t) => enemy.ApplyConditionEffect(new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.StasisImmune,
                                    DurationMS = 3000
                                })));
                                pkts.Add(new NotificationPacket
                                {
                                    ObjectId = enemy.Id,
                                    Color = new ARGB(0xffff0000),
                                    Text = "Stasis"
                                });
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;

                    case ActivateAbilities.HealNova:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Radius, true,
                                player => { ActivateHealHp(player as Player, abil.Amount, pkts); });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.Smite:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Radius, true, player =>
                           {
                               ActivateHealHp(player as Player, abil.Amount, pkts);
                           });
                            this.AOE(abil.Radius, false, enemy =>
                            {
                                (enemy as Enemy).Damage(this, time, abil.Damage, abil.Penetration, false, null);
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.Judgement:
                        {
                            var pkts = new List<Packet>();
                            List<Enemy> enemies = new List<Enemy>();
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            this.AOE(abil.Radius, false, enemy =>
                            {
                                (enemy as Enemy).Damage(this, time, abil.Damage, abil.Penetration, false, null);
                                burns.Add(new Burn(enemy as Enemy, abil));
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.HealingWave:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Radius, true, player =>
                            {
                                double dist = MathsUtils.Dist(this.X, this.Y, player.X, player.Y);
                                double healbonus = (1 - Math.Ceiling(dist / abil.Radius)) * abil.Amount;
                                double totalheal = abil.Amount + healbonus;
                                ActivateHealHp(player as Player, (int)totalheal, pkts);
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.SufferersPrayer:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Radius, true, player =>
                            {
                                double totalhealth = Stats[0];
                                double healbonus = (1 - (HP / totalhealth)) * abil.Amount;
                                double totalheal = abil.Amount + healbonus;
                                ActivateHealHp(player as Player, (int)totalheal, pkts);
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.HiddenBlade:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Range, false, enemy =>
                            {
                                (enemy as Enemy).Damage(this, time, abil.Damage, 0, true, null);
                                poisons.Add(new Poison(enemy as Enemy, abil));
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Range }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.DisablingStrike:
                        {
                            int dmg = abil.Damage;
                            if (this.HasConditionEffect(ConditionEffects.Invisible))
                            {
                                dmg *= 2;
                                ActivateAbilityDisablingStrike(time, ability, target, dmg, 1);
                            }
                            else
                                ActivateAbilityDisablingStrike(time, ability, target, dmg, 0);
                        }
                        break;
                    case ActivateAbilities.WarpCrystal:
                        {
                            var warpCrystal = new WarpCrystal(this);

                            if (this.warpUses == 1)
                            {
                                warpUses = 2;
                                break;
                            }
                            if (this.warpUses == 0)
                            {
                                warpUses = 1;
                                warpCrystal.Move(X, Y);
                                Owner.EnterWorld(warpCrystal);
                                warpCrystal.UpdateCount++;
                                break;
                            }
                        }
                        break;
                    case ActivateAbilities.KnockoutStrike:
                        {
                            AbilityToggle[0] = false;
                            EndTickAbility(CacheAbilities[0], 0, time);
                            ToggleChanged = true;


                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = 0
                                }
                            );
                            var pkts = new List<Packet>();
                            var enem = this.GetNearestEntity(abil.Range, false,
                                    enemy =>
                                        enemy is Enemy);
                            if (enem == null) break;
                            (enem as Enemy).Damage(this, time, abil.Damage, 0, true, null);
                            (enem as Enemy).ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Paralyzed,
                                        DurationMS = abil.DurationMS
                                    }
                                );
                            (enem as Enemy).ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Stunned,
                                    DurationMS = abil.DurationMS
                                }
                            );
                        }
                        break;
                    case ActivateAbilities.Pickpocket:
                        {
                            Random r = new Random();
                            var rand1 = r.Next(1, 100);
                            var rand2 = r.Next(1, 100);
                            ushort item = 0x0;
                            this.AOE(abil.Radius, false, enemy =>
                            {
                                if (rand1 >= 1 && rand1 <= 20)
                                {
                                    if (rand2 >= 1 && rand2 <= 50)
                                        item = 0xa22;
                                    else if (rand2 >= 51 && rand2 <= 100)
                                        item = 0xa23;
                                    if (item == 0xa22 || item == 0xa23)
                                    {
                                        for (var i = 4; i < this.Inventory.Length; i++)
                                            if (this.Inventory[i] == null)
                                            {
                                                this.Inventory[i] = this.Manager.GameData.Items[item];

                                                break;
                                            }
                                    }
                                }
                                else
                                    SendInfo("You failed to pickpocket an enemy.");
                            });
                        }
                        break;
                    case ActivateAbilities.WideGuard:
                        {
                            var pkts = new List<Packet>();
                            ActivateAbilityShoot(time, ability, target, 0);
                            this.AOE(abil.Radius, true, player =>
                            {
                                player.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Armored,
                                        DurationMS = abil.DurationMS
                                    }
                                );
                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.Enrage:
                        {
                            var pkts = new List<Packet>();
                            this.AOE(abil.Radius, false, enemy =>
                            {
                                enemy.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.ArmorBroken,
                                        DurationMS = abil.DurationMS
                                    }
                                );
                                (enemy as Enemy).raged.Add(this, abil.DurationMS);

                            });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.PoisonToss:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Throw,
                                Color = new ARGB(0xffddff00),
                                TargetId = Id,
                                PosA = target
                            }, p => this.Dist(p) < 25);
                            var x = new Placeholder(Manager, 1500);
                            x.Move(target.X, target.Y);
                            Owner.EnterWorld(x);
                            Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                            {
                                if (Owner != null)
                                {
                                    Owner.BroadcastPacket(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = x.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    }, null);
                                    Owner.AOE(target, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });

                                }
                            }));
                        }
                        break;
                    case ActivateAbilities.PoisonBurst:
                        {
                            if (Owner != null)
                            {
                                Owner.BroadcastPacket(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Diffuse,
                                    TargetId = Id,
                                    PosA = target,
                                    PosB = new Position { X = target.X + abil.Radius, Y = target.Y },
                                    Color = new ARGB(0xffddff00)
                                }, null);
                                Owner.AOE(target, abil.Radius, false,
                                    enemy =>
                                    {
                                        this.poisons.Add(new Poison(enemy as Enemy, abil));
                                    });
                            }
                            
                        }
                        break;
                    case ActivateAbilities.NightVeil:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Diffuse,
                                TargetId = Id,
                                Color = new ARGB(0x2300a3),
                                PosA = target,
                                PosB = new Position { X = target.X + (float)abil.Radius, Y = target.Y }
                            }, p => this.Dist(p) < 25);
                            Owner.AOE(target, abil.Radius, false, enemy =>
                            {
                                (enemy as Enemy).ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Blind,
                                        DurationMS = abil.DurationMS
                                    });
                            });
                        }
                        break;
                    
                    case ActivateAbilities.DeadlyToss:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Throw,
                                Color = new ARGB(0xffddff00),
                                TargetId = Id,
                                PosA = target
                            }, p => this.Dist(p) < 25);
                            var x = new Placeholder(Manager, 1500);
                            x.Move(target.X, target.Y);
                            Owner.EnterWorld(x);
                            Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                            {
                                if (Owner != null)
                                {
                                    Owner.BroadcastPacket(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = x.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    }, null);
                                    var enemies = new List<Enemy>();
                                    Owner.AOE(target, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });

                                }
                            }));
                        }
                        break;
                    case ActivateAbilities.PoisonDagger:
                        {
                            Random r = new Random();
                            var rand1 = r.Next(1, 100);
                            if (rand1 >= 1 && rand1 <= 20)
                                ActivateAbilityShoot(time, ability, target, 0, abil);
                            else if (rand1 >= 21 && rand1 <= 35)
                                ActivateAbilityShoot(time, ability, target, 1, abil);
                            else if (rand1 >= 36 && rand1 <= 45)
                                ActivateAbilityShoot(time, ability, target, 2, abil);
                            else
                                ActivateAbilityShoot(time, ability, target, 3, abil);
                        }
                        break;
                    case ActivateAbilities.FinishingStrike:
                        {
                            Owner.BroadcastPacket(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffddff00),
                                PosA = new Position { X = abil.Radius }
                            }, null);
                            Entity enemy = EntityUtils.GetNearestEntityPlayer(this, new Position { X = this.X, Y = this.Y }, abil.Radius);
                            if ((enemy as Enemy).HP < ((enemy as Enemy).MaxHP * 0.1))
                            {
                                enemy.ApplyConditionEffect(new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Bleeding,
                                    DurationMS = abil.DurationMS
                                });
                                (enemy as Enemy).Damage(this, time, abil.Damage * 2, 0, false, null);
                            }
                            else
                            {
                                enemy.ApplyConditionEffect(new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Bleeding,
                                    DurationMS = abil.DurationMS
                                });
                                (enemy as Enemy).Damage(this, time, abil.Damage, 0, false, null);
                            }
                        }
                        break;
                    case ActivateAbilities.SplitBomb:
                        {
                            Random r = new Random();
                            var bomb1x = r.Next(-5, 5);
                            var bomb2x = r.Next(-5, 5);
                            var bomb3x = r.Next(-5, 5);
                            var bomb1y = r.Next(-5, 5);
                            var bomb2y = r.Next(-5, 5);
                            var bomb3y = r.Next(-5, 5);
                            var bomb1pos = new Position { X = target.X + bomb1x, Y = target.Y + bomb1y };
                            var bomb2pos = new Position { X = target.X + bomb2x, Y = target.Y + bomb2y };
                            var bomb3pos = new Position { X = target.X + bomb3x, Y = target.Y + bomb3y };
                            var bombplac1 = new Placeholder(Manager, 3000);
                            var bombplac2 = new Placeholder(Manager, 3000);
                            var bombplac3 = new Placeholder(Manager, 3000);
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Throw,
                                Color = new ARGB(0xffddff00),
                                TargetId = Id,
                                PosA = target
                            }, p => this.Dist(p) < 25);
                            var x = new Placeholder(Manager, 3000);
                            x.Move(target.X, target.Y);
                            Owner.EnterWorld(x);
                            Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                            {
                                if (Owner != null)
                                {
                                    Owner.BroadcastPacket(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = x.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    }, null);
                                    var enemies = new List<Enemy>();
                                    Owner.AOE(target, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });
                                }
                            }));

                        
                
                            Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                            {
                                if (Owner != null)
                                {
                                    var pkts1 = new List<Packet>();
                                    pkts1.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Throw,
                                        Color = new ARGB(0xffddff00),
                                        TargetId = x.Id,
                                        PosA = bomb1pos
                                    });
                                    bombplac1.Move(bomb1pos.X, bomb1pos.Y);
                                    Owner.EnterWorld(bombplac1);

                                    pkts1.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Throw,
                                        Color = new ARGB(0xffddff00),
                                        TargetId = x.Id,
                                        PosA = bomb2pos
                                    });
                                    bombplac2.Move(bomb2pos.X, bomb2pos.Y);
                                    Owner.EnterWorld(bombplac2);
                                    pkts1.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Throw,
                                        Color = new ARGB(0xffddff00),
                                        TargetId = x.Id,
                                        PosA = bomb3pos
                                    });
                                    bombplac3.Move(bomb3pos.X, bomb3pos.Y);
                                    Owner.EnterWorld(bombplac3);
                                    BroadcastSync(pkts1, p => this.Dist(p) < 25);
                                }
                            }));
                            Owner.Timers.Add(new WorldTimer(3000, (world, t) =>
                            {
                                if (Owner != null)
                                {
                                    var pkts2 = new List<Packet>();
                                    pkts2.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = bombplac1.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    });
                                    pkts2.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = bombplac2.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    });
                                    pkts2.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.AreaBlast,
                                        TargetId = bombplac3.Id,
                                        Color = new ARGB(0xffddff00),
                                        PosA = new Position { X = abil.Radius }
                                    });
                                    BroadcastSync(pkts2, p => this.Dist(p) < 25);
                                    Owner.AOE(bomb1pos, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });
                                    Owner.AOE(bomb2pos, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });
                                    Owner.AOE(bomb3pos, abil.Radius, false,
                                        enemy =>
                                        {
                                            this.poisons.Add(new Poison(enemy as Enemy, abil));
                                        });
                                }

                            }));
                        }
                        break;
                    case ActivateAbilities.StoneGuards:
                        {
                            double angle = Math.Atan2(target.Y - Y, target.X - X);
                            double angle2 = angle - 0.5;
                            double angle3 = angle + 0.5;
                            Vector2 direction = new Vector2(target.X - X, target.Y - Y);
                            Vector2 direction2 = new Vector2((float)Math.Cos(angle2), (float)Math.Sin(angle2));
                            Vector2 direction3 = new Vector2((float)Math.Cos(angle3), (float)Math.Sin(angle3));
                            direction.Normalize();
                            direction2.Normalize();
                            direction3.Normalize();
                            var Guard1 = new StoneGuard(this);
                            var Guard2 = new StoneGuard(this);
                            var Guard3 = new StoneGuard(this);
                            Guard1.Move(X + direction.X, Y + direction.Y);
                            Guard2.Move(X + direction2.X, Y + direction2.Y);
                            Guard3.Move(X + direction3.X, Y + direction3.Y);
                            Guard1.HP = abil.Amount;
                            Guard2.HP = abil.Amount;
                            Guard3.HP = abil.Amount;
                            Owner.EnterWorld(Guard1);
                            Owner.EnterWorld(Guard2);
                            Owner.EnterWorld(Guard3);
                        }
                        break;
                    case ActivateAbilities.ShieldCrush:
                        {
                            var pkts = new List<Packet>();
                            ActivateAbilityShoot(time, ability, target, 0);
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.GiantsSlash:
                        {
                            Vector2 direction = new Vector2(target.X - X, target.Y - Y);
                            direction.Normalize();
                            var pos = new Position { X = X + direction.X, Y = Y + direction.Y };
                            Owner.AOE(pos, abil.Radius, false, enemy =>
                            {
                                (enemy as Enemy).Damage(this, time, (int)abil.Damage, abil.Penetration, false, null);
                                enemy.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Bleeding,
                                        DurationMS = abil.DurationMS
                                    }
                                );

                            });
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Diffuse,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = pos,
                                PosB = new Position { X = X + direction.X + (float)abil.Radius, Y = Y + direction.Y }
                            }, p => this.Dist(p) < 25);

                        }
                        break;
                    case ActivateAbilities.Slay:
                        {
                            Entity enemy = EntityUtils.GetNearestEntityPlayer(this, new Position { X = this.X, Y = this.Y}, abil.Radius);
                            float enemyhp = (enemy as Enemy).HP;
                            float enemymaxhp = (enemy as Enemy).MaxHP;
                            float multiplier = 1 - enemyhp / enemymaxhp;

                            float dmg = abil.Damage + abil.Damage * multiplier;
                            (enemy as Enemy).Damage(this, time, (int)dmg, abil.Penetration, false, null);
                            var pkts = new List<Packet>();
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = abil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);

                        }
                        break;
                    case ActivateAbilities.ShieldLunge:
                        {
                            var pkts = new List<Packet>();
                            ActivateAbilityShoot(time, ability, target, 0);
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                        }
                        break;
                    case ActivateAbilities.DragonSkin:
                        {
                            if (AbilityToggle[1] == true)
                            {
                                StopActiveAbility(1);
                            }
                            this.ApplyConditionEffect(
                                 new ConditionEffect
                                 {
                                     Effect = ConditionEffectIndex.Invulnerable,
                                     DurationMS = abil.DurationMS
                                 });
                        }
                        break;
                    case ActivateAbilities.Blizzard:
                        {
                            var Blizzard = new BlizzardBase(this, abil.Amount, abil.DurationMS, target, abil.Damage, abil.Radius);
                            Blizzard.Move(target.X, target.Y);
                            Owner.EnterWorld(Blizzard);
                            Blizzard.UpdateCount++;
                        }
                        break;
                    case ActivateAbilities.AcidBomb:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Throw,
                                Color = new ARGB(0xffddff00),
                                TargetId = Id,
                                PosA = target
                            }, p => this.Dist(p) < 25);
                            Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                            {
                                var acidBomb = new AcidBomb(this, abil);
                                acidBomb.Move(target.X, target.Y);
                                Owner.EnterWorld(acidBomb);
                            }));
                        }
                        break;
                    case ActivateAbilities.ToxicBolt:
                        ActivateAbilityArrowShoot(time, ability, target, 0, abil);
                        break;
                    case ActivateAbilities.FocusedShot:
                        ActivateAbilityShoot(time, ability, target, 0);
                        break;
                    case ActivateAbilities.Bombard:
                        ActivateAbilityShoot(time, ability, target, 0);
                        break;
                    case ActivateAbilities.FlameVolley:
                        ActivateAbilityShoot(time, ability, target, 0, abil);
                        break;
                    case ActivateAbilities.BlastVolley:
                        ActivateAbilityShoot(time, ability, target, 0, abil);
                        break;
                    case ActivateAbilities.Snipe:
                        ActivateAbilityShoot(time, ability, target, 0);
                        break;
                    case ActivateAbilities.SkillShot:
                        ActivateAbilityShoot(time, ability, target, 0, abil);
                        break;
                    case ActivateAbilities.DeathArrow:
                        ActivateAbilityShoot(time, ability, target, 0, abil);
                        break;
                    case ActivateAbilities.DisablingArrow:
                        ActivateAbilityShoot(time, ability, target, 0);
                        break;
                    case ActivateAbilities.DeathMark:
                        {
                            BroadcastSync(new ShowEffectPacket
                            {
                                EffectType = EffectType.Diffuse,
                                TargetId = Id,
                                Color = new ARGB(0x2300a3),
                                PosA = target,
                                PosB = new Position { X = target.X + (float)abil.Radius, Y = target.Y }
                            }, p => this.Dist(p) < 25);
                            Owner.AOE(target, abil.Radius, false, enemy =>
                            {
                                if (enemy != null)
                                {
                                    DeathMarked.Add(enemy as Enemy, abil.DurationMS);
                                }
                            });
                        }
                        break;
                }

            }
            UpdateCount++;
        }

        public void StopActiveAbility(int slot)
        {
            AbilityActiveDurations[slot] = -1;
            AbilityToggle[slot] = false;
            ToggleChanged = true;
        }

        public void AddToActiveDuration(int slot, int timeMS)
        {
            if (AbilityActiveDurations[slot] > 0) AbilityActiveDurations[slot] += timeMS;
        }

        //Lingering variables

        private int? Count0;
        private int? Count1;
        private int? Count2;
        private int? glowyCount;

        //private int Instability = 0;
        //Lingering variables

        public void TickAbility(Ability abil, int slot, RealmTime time)
        {
            Position target;
            var pkts = new List<Packet>();
            foreach (AbilityPerTick tickAbil in abil.TickingAbilities)
            {
                switch (tickAbil.TickAbil)
                {
                    case AbilitiesPerTick.BowmanBlessing:
                        {
                            //nothing to put here...
                        }
                        break;
                    case AbilitiesPerTick.RapidFire:
                        {
                            if (Count0 == null) Count0 = 3;
                            Entity enemy = EntityUtils.GetNearestEntityPlayer(this, new Position { X = this.X, Y = this.Y }, 8);
                            if (Count0 < 3)
                            {
                                Count0++;
                            }
                            else if (Count0 < 6)
                            {
                                if (enemy != null)
                                    ActivateAbilityShoot(time, abil, new Position { X = enemy.X, Y = enemy.Y }, 0);
                                Count0++;
                            }
                            else
                            {
                                Count0 = 1;
                            }

                        }
                        break;
                    case AbilitiesPerTick.InstabilityBase:
                        {
                            //TODO: implement something!
                        }
                        break;
                    case AbilitiesPerTick.ShieldOfRepent:
                        {
                            if (HP < (Stats[0] / 2))
                            {
                                this.AOE(tickAbil.Radius, false,
                                    enemy => { (enemy as Enemy).Damage(this, time, tickAbil.Damage, tickAbil.Penetration, false, null); });
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.AreaBlast,
                                    TargetId = Id,
                                    Color = new ARGB(0xffffffff),
                                    PosA = new Position { X = tickAbil.Radius }
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                                pkts = null;
                                Count1 = null;
                                StopActiveAbility(slot);
                            }
                            else
                            {
                                if (Count1 == null) Count1 = 4;
                                else Count1++;

                                if (Count1 % 4 == 0)
                                {
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Potion,
                                        TargetId = Id,
                                        Color = new ARGB(0xffffffff)
                                    });
                                    BroadcastSync(pkts, p => this.Dist(p) < 25);
                                    pkts = null;
                                }
                            }
                        }
                        break;
                    case AbilitiesPerTick.ShieldofFaith:
                        {
                            if (HP < (Stats[0] / 3))
                            {
                                ActivateHealHp(this, tickAbil.Amount, pkts);
                                ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Armored,
                                        DurationMS =  tickAbil.DurationMS
                                    });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                                pkts = null;
                                Count1 = null;
                                StopActiveAbility(slot);
                            }
                            else
                            {
                                if (Count1 == null) Count1 = 4;
                                else Count1++;
                                if (Count1 % 4 == 0)
                                {
                                    pkts.Add(new ShowEffectPacket
                                    {
                                        EffectType = EffectType.Potion,
                                        TargetId = Id,
                                        Color = new ARGB(0xffffffff)
                                    });
                                    BroadcastSync(pkts, p => this.Dist(p) < 25);
                                    pkts = null;
                                }
                            }
                        }
                        break;
                    case AbilitiesPerTick.NightCloak:
                        {
                            ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = -1
                                });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = tickAbil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            pkts = null;
                        }
                        break;
                    case AbilitiesPerTick.ImmunitytoEvil:
                        {
                            if (!HasConditionEffect(ConditionEffects.Invulnerable))
                            {
                                ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Invulnerable,
                                        DurationMS = abil.ActiveDuration
                                    });
                            }
                            ActivateHealHp(this, (int)(DamageCount * 0.1), pkts);
                            DamageCount = 0;
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            pkts = null;
                        }
                        break;
                    case AbilitiesPerTick.SpilledBlood:
                        {
                            //Nothing to put here...
                        }
                        break;
                    case AbilitiesPerTick.FollowersFaith:
                        {
                            //Nothing to put here...
                        }
                        break;
                    case AbilitiesPerTick.GlowyToggle:
                        {
                            if (glowyCount == null) glowyCount = 2;
                            else glowyCount++;

                            if (glowyCount % 2 == 0)
                            {
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.Potion,
                                    TargetId = Id,
                                    Color = new ARGB(0xff00ff00)
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                                pkts = null;
                            }
                        }
                        break;
                    case AbilitiesPerTick.DefensiveStance:
                        {
                            if (!HasConditionEffect(ConditionEffects.Armored))
                            {
                                this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Armored,
                                    DurationMS = -1
                                });
                            }
                        }
                        break;

                    case AbilitiesPerTick.ShadowCloak:
                        {
                            if (!HasConditionEffect(ConditionEffects.Invisible))
                            {
                                this.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Invisible,
                                        DurationMS = -1
                                    });
                            
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.AreaBlast,
                                    TargetId = Id,
                                    Color = new ARGB(0xffffffff),
                                    PosA = new Position { X = 3 }
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                            }

                        }
                        break;
                    case AbilitiesPerTick.BanditCloak:
                        {
                            if (!HasConditionEffect(ConditionEffects.Invisible))
                            {
                                this.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Invisible,
                                        DurationMS = -1
                                    });
                            
                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.AreaBlast,
                                    TargetId = Id,
                                    Color = new ARGB(0xffffffff),
                                    PosA = new Position { X = 3 }
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                            }

                        }
                        break;
                    case AbilitiesPerTick.SpeedCloak:
                        {
                            if (!HasConditionEffect(ConditionEffects.Invisible))
                            {
                                this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = -1
                                }
                                );
                                this.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Speedy,
                                        DurationMS = -1
                                    }
                                );

                                pkts.Add(new ShowEffectPacket
                                {
                                    EffectType = EffectType.AreaBlast,
                                    TargetId = Id,
                                    Color = new ARGB(0xffffffff),
                                    PosA = new Position { X = 3 }
                                });
                                BroadcastSync(pkts, p => this.Dist(p) < 25);
                            }
                        
                        }
                        break;
                }
            }
        }

        public void EndTickAbility(Ability abil, int slot, RealmTime time)
        {
            var pkts = new List<Packet>();
            foreach (AbilityPerTick tickAbil in abil.TickingAbilities)
            {
                switch (tickAbil.TickAbil)
                {
                    case AbilitiesPerTick.GlowyToggle:
                        {
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = 4 }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            pkts = null;
                        }
                        break;
                    case AbilitiesPerTick.NightCloak:
                        {

                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = 0

                                }

                            );
                        }
                        break;
                    case AbilitiesPerTick.DefensiveStance:
                        {
                            this.ApplyConditionEffect(
                                 new ConditionEffect
                                 {
                                     Effect = ConditionEffectIndex.Armored,
                                     DurationMS = 0
                                 });
                        }
                        break;
                    case AbilitiesPerTick.ShadowCloak:
                        {

                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = 0
                                });

                        }
                        break;
                    case AbilitiesPerTick.BanditCloak:
                        {

                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = 0
                                });
                            this.AOE(tickAbil.Radius, false,
                                    enemy => { (enemy as Enemy).Damage(this, time, tickAbil.Damage, tickAbil.Penetration, false, null); });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.AreaBlast,
                                TargetId = Id,
                                Color = new ARGB(0xffffffff),
                                PosA = new Position { X = tickAbil.Radius }
                            });
                            BroadcastSync(pkts, p => this.Dist(p) < 25);
                            pkts = null;

                        }
                        break;
                    case AbilitiesPerTick.SpeedCloak:
                        {
                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Invisible,
                                    DurationMS = 0
                                }
                            );
                            this.ApplyConditionEffect(
                                new ConditionEffect
                                {
                                    Effect = ConditionEffectIndex.Speedy,
                                    DurationMS = 0
                                }
                            );
                        }
                        break;
                    case AbilitiesPerTick.RapidFire:
                        {
                            Count0 = null;
                        }
                        break;
                    case AbilitiesPerTick.BowmanBlessing:
                        {
                            bowBlessing = 100;
                        }
                        break;
                }
            }
        }

    }
}
