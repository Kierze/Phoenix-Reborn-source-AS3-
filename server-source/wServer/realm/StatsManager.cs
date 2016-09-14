using System;
using wServer.realm.entities;

namespace wServer.realm
{
    public class StatsManager
    {
        private readonly Player player;

        public StatsManager(Player player, uint seed)
        {
            this.player = player;
            Random = new ObfRandom(seed);
        }

        public ObfRandom Random { get; }

        //from wiki

        private int GetStats(int id)
        {
            return player.Stats[id] + player.Boost[id];
        }

        public int GetPenetration()
        {
            return GetStats(10);
        }

        public float GetAttackDamage(int min, int max, int percent = 0)
        {
            /*int att = GetStats(2);

            min += min * (percent / 1000);
            max += max * (percent / 1000);

            //float ret = player.Random.Next(min, max)*(0.5f + att/50f); //this means that 25 att is the 100% marker of weapon damage. ok.
            float ret = player.Random.Next(min, max) * (1f + (att / 1500));

            if (player.HasConditionEffect(ConditionEffects.Damaging))
                ret *= 1.5f;

            if (player.HasConditionEffect(ConditionEffects.Weak))
                ret *= 0.6667f;
            
            return ret;*/

            return Random.obf6((uint)min, (uint)max) * DamageModifier();
        }

        private float DamageModifier()
        {
            if (player.HasConditionEffect(ConditionEffects.Weak))
                return 0.6667f;
            var ret = (1f + GetStats(2) / 750F * (2 - 0.5f));

            if (player.HasConditionEffect(ConditionEffects.Damaging))
                ret *= 1.5f;
            return ret;
        }

        public static float GetResilienceReduction(int res)
        {
            //returns the percentage of damage to be reduced!
            int Resilience = Math.Min(5000, res); 
            if (Resilience < 1) return 0;
            if (Resilience > 5020) return 1;
            return (float)((100 - Math.Pow(((5000 - Resilience) / 125), 1.246)) / 100); //inverse of exponential function
        }

        public static float GetEnemyDamage(Entity host, int dmg, int pen, int def, int res) //Enemy Calculations
        {
            if (host.HasConditionEffect(ConditionEffects.Invulnerable) || host.HasConditionEffect(ConditionEffects.Invincible))
                return 0;

            if (host.HasConditionEffect(ConditionEffects.Armored))
                def *= 2;
            if (host.HasConditionEffect(ConditionEffects.ArmorBroken))
                def = 0;

            int effDef = Math.Max(0, (def - pen));
            int effRes = Math.Max(0, (res - pen));

            float damage = Math.Max(1, dmg - (dmg * GetResilienceReduction(effRes)));
            
            return Math.Max(damage * 0.15f, damage - effDef);
        }

        public float GetPlayerDamage(int dmg, int pen, bool noDef) //Player Calculations
        {
            if (player.HasConditionEffect(ConditionEffects.Invulnerable) || player.HasConditionEffect(ConditionEffects.Invincible))
                return 0;

            int def = GetStats(3);
            int res = GetStats(9);

            if (player.HasConditionEffect(ConditionEffects.Armored))
            {
                def *= 2;
                res = (res * 3) / 2; //150%
            }
            if (player.HasConditionEffect(ConditionEffects.ArmorBroken))
            {
                def = 0;
                res = (res * 2) / 3; //66% or 100% of 150%
            }
            if (noDef)
            {
                def = 0;
                res = 0;
            }

            int effDef = Math.Max(0, (def - pen));
            int effRes = Math.Max(0, (res - pen));

            float damage = Math.Max(1, dmg - (dmg * GetResilienceReduction(effRes)));

            return Math.Max(damage * 0.15f, damage - effDef);
        }

        public static float GetSpeed(Entity entity, float stat)
        {
            //float ret = 4 + 5.6f*(stat/75f); //5.12 = 15 speed  9.6 = 75 speed (187.5% increase from 15 spd to 75)
            //float ret = 4 + 5.6f * (stat / 1000f);
            float ret = 7 + 5.6f * (stat / 75f); //4.336 = 15 speed; 4.56 = 25 speed; 7.696 = 165 spd; 225 spd = 9.04

            if (entity.HasConditionEffect(ConditionEffects.Slowed) && entity.HasConditionEffect(ConditionEffects.Speedy))
                return ret;
            else if (entity.HasConditionEffect(ConditionEffects.Speedy))
                ret *= 1.5f;
            else if (entity.HasConditionEffect(ConditionEffects.Slowed))
                ret *= 0.5f;
            else if (entity.HasConditionEffect(ConditionEffects.Paralyzed))
                ret = 0f;
            return ret;
        }

        public float GetSpeed()
        {
            return GetSpeed(player, GetStats(4));
        }

        public float GetHPRegen()
        {
            int vit = GetStats(5);
            if (player.HasConditionEffect(ConditionEffects.Sick))
                vit = 0;
            //return 3 + vit / 23f; //per second i guess?
            return 3 + 0.12f * vit;
        }

        public float GetMPRegen()
        {
            int wis = GetStats(6);
            if (player.HasConditionEffect(ConditionEffects.Quiet))
                return 0;
            //return 2 + wis / 38f;
            return 1.65f + 0.06f * wis;
        }

        public float GetDex() //this isn't used lol
        {
            int dex = GetStats(7);
            //float ret = 1.5f + 6.5f * (dex / 1400f);
            if (player.HasConditionEffect(ConditionEffects.Dazed))
                dex = 0;

            float ret = 1.5f + 6.5f * (dex / 1400f);

            if (player.HasConditionEffect(ConditionEffects.Berserk))
                ret *= 1.5f;
            //if (player.HasConditionEffect(ConditionEffects.Dazed))
            //    ret *= 0.6667f;
            if (player.HasConditionEffect(ConditionEffects.Stunned))
                ret = 0;
            return ret;
        }

        public static int StatsNameToIndex(string name)
        {
            switch (name)
            {
                case "MaxHitPoints":
                    return 0;
                case "MaxMagicPoints":
                    return 1;
                case "Attack":
                    return 2;
                case "Defense":
                    return 3;
                case "Speed":
                    return 4;
                case "Vitality":
                    return 5;
                case "Wisdom":
                    return 6;
                case "Dexterity":
                    return 7;
                case "Aptitude":
                    return 8;
                case "Resilience":
                    return 9;
                case "Penetration":
                    return 10;
            }
            return -1;
        }

        public static string StatsIndexToName(int index)
        {
            switch (index)
            {
                case 0:
                    return "MaxHitPoints";
                case 1:
                    return "MaxMagicPoints";
                case 2:
                    return "Attack";
                case 3:
                    return "Defense";
                case 4:
                    return "Speed";
                case 5:
                    return "Vitality";
                case 6:
                    return "Wisdom";
                case 7:
                    return "Dexterity";
                case 8:
                    return "Aptitude";
                case 9:
                    return "Resilience";
                case 10:
                    return "Penetration";
            }
            return null;
        }

        public static string StatsIndexToPotName(int index)
        {
            switch (index)
            {
                case 0:
                    return "Life";
                case 1:
                    return "Mana";
                case 2:
                    return "Attack";
                case 3:
                    return "Defense";
                case 4:
                    return "Speed";
                case 5:
                    return "Vitality";
                case 6:
                    return "Wisdom";
                case 7:
                    return "Dexterity";
            }
            return null;
        }

        public class ObfRandom
        {
            public ObfRandom(uint seed = 1)
            {
                Seed = seed;
            }

            public uint Seed { get; private set; }

            public static uint obf1()
            {
                return (uint)Math.Round(new Random().NextDouble() * (uint.MaxValue - 1) + 1);
            }

            public uint obf2()
            {
                return obf3();
            }

            public float obf4()
            {
                return obf3() / 2147483647;
            }

            public float obf5(float param1 = 0.0f, float param2 = 1.0f)
            {
                float _loc3_ = obf3() / 2147483647;
                float _loc4_ = obf3() / 2147483647;
                float _loc5_ = (float)Math.Sqrt(-2 * (float)Math.Log(_loc3_)) * (float)Math.Cos(2 * _loc4_ * Math.PI);
                return param1 + _loc5_ * param2;
            }

            public uint obf6(uint param1, uint param2)
            {
                if (param1 == param2)
                {
                    return param1;
                }
                return param1 + obf3() % (param2 - param1);
            }

            public float obf7(float param1, float param2)
            {
                return param1 + (param2 - param1) * obf4();
            }

            private uint obf3()
            {
                uint _loc1_ = 0;
                uint _loc2_ = 0;
                _loc2_ = 16807 * (this.Seed & 65535);
                _loc1_ = 16807 * (this.Seed >> 16);
                _loc2_ = _loc2_ + ((_loc1_ & 32767) << 16);
                _loc2_ = _loc2_ + (_loc1_ >> 15);
                if (_loc2_ > 2147483647)
                {
                    _loc2_ = _loc2_ - 2147483647;
                }
                return Seed = _loc2_;
            }

            public static uint RegenSeed(uint Seed) //obf3 static version
            {
                uint _loc1_ = 0;
                uint _loc2_ = 0;
                _loc2_ = 16807 * (Seed & 65535);
                _loc1_ = 16807 * (Seed >> 16);
                _loc2_ = _loc2_ + ((_loc1_ & 32767) << 16);
                _loc2_ = _loc2_ + (_loc1_ >> 15);
                if (_loc2_ > 2147483647)
                {
                    _loc2_ = _loc2_ - 2147483647;
                }
                return Seed = _loc2_;
            }

            public static uint Next(uint Seed, uint min, uint max) //obf6 static version
            {
                if (min == max)
                {
                    return min;
                }
                return min + RegenSeed(Seed) % (max - min);
            }
        }
    }
}