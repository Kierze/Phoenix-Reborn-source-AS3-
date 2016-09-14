using System;
using System.Collections.Generic;
using wServer.realm;
using wServer.realm.entities;
using wServer.realm.worlds;

namespace wServer.logic
{
    public class DamageCounter
    {
        private readonly Enemy enemy;
        private readonly WeakDictionary<Player, int> hitters = new WeakDictionary<Player, int>();

        public DamageCounter(Enemy enemy)
        {
            this.enemy = enemy;
        }

        public Enemy Host
        {
            get { return enemy; }
        }

        public Projectile LastProjectile { get; private set; }
        public Player LastHitter { get; private set; }

        public DamageCounter Corpse { get; set; }
        public DamageCounter Parent { get; set; }

        public int Total;

        public void HitBy(Player player, RealmTime time, Projectile projectile, int dmg)
        {
            int totalDmg;
            if (!hitters.TryGetValue(player, out totalDmg))
                totalDmg = 0;
            totalDmg += dmg;
            hitters[player] = totalDmg;
            Total = totalDmg;

            LastProjectile = projectile;
            LastHitter = player;

            player.FameCounter.Hit(projectile, enemy);
        }

        public Tuple<Player, int>[] GetPlayerData()
        {
            if (Parent != null)
                return Parent.GetPlayerData();
            var dat = new List<Tuple<Player, int>>();
            foreach (var i in hitters)
            {
                if (i.Key.Owner == null) continue;
                dat.Add(new Tuple<Player, int>(i.Key, i.Value));
            }
            return dat.ToArray();
        }

        public void Death(RealmTime time)
        {
            if (Corpse != null)
            {
                Corpse.Parent = this;
                return;
            }

            var eligiblePlayers = new List<Tuple<Player, int>>();
            int totalDamage = 0;
            Enemy enemy = (Parent ?? this).enemy;
            foreach (var i in (Parent ?? this).hitters)
            {
                if (i.Key.Owner == null) continue;
                totalDamage += i.Value;
                Total = totalDamage;
                eligiblePlayers.Add(new Tuple<Player, int>(i.Key, i.Value));
            }
            //float totalExp = (enemy.ObjectDesc.MaxHP/10f)*(enemy.ObjectDesc.ExpMultiplier ?? 1);
            //float lowerLimit = totalExp*0.1f;
            int lvUps = 0;
            foreach (var i in eligiblePlayers)
            {
                //float playerXp = totalExp*i.Item2/totalDamage;

                //float upperLimit = i.Item1.ExperienceGoal*0.1f;
                //if (i.Item1.Quest == enemy)
                //    upperLimit = i.Item1.ExperienceGoal*0.5f;

                //if (playerXp < lowerLimit) playerXp = lowerLimit;
                //if (playerXp > upperLimit) playerXp = upperLimit;

                float playerXp = ((i.Item1.Level*5) + (enemy.ObjectDesc.MaxHP/10f)) / 2;

                if (enemy.ObjectDesc.Terrain != null)
                {
                    switch (enemy.ObjectDesc.Terrain)
                    {
                        case "ShoreSand":
                        case "ShorePlains":
                            playerXp += 25;
                            break;
                        case "LowSand":
                        case "LowPlains":
                        case "LowForest":
                            playerXp += 45;
                            break;
                        case "MidSand":
                        case "MidPlains":
                        case "MidForest":
                            playerXp += 135;
                            break;
                        case "HighSand":
                        case "HighPlains":
                        case "HighForest":
                            playerXp += 270;
                            break;
                        case "Mountains":
                            playerXp += 635;
                            break;
                    }
                }

                if (playerXp > (i.Item1.ExperienceGoal*0.15f) && i.Item1.Quest != enemy)
                    playerXp = i.Item1.ExperienceGoal*0.15f;


                bool killer = (Parent ?? this).LastHitter == i.Item1;
                if (i.Item1.EnemyKilled(enemy, (int)playerXp, killer))
                    lvUps++;
            }
            if ((Parent ?? this).LastHitter != null)
            {
                (Parent ?? this).LastHitter.FameCounter.LevelUpAssist(lvUps);
            }
            if (enemy.Owner is GameWorld)
                (enemy.Owner as GameWorld).EnemyKilled(enemy, (Parent ?? this).LastHitter);

            
        }
    }
}