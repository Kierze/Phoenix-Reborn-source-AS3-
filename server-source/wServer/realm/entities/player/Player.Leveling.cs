using db;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    public partial class Player
    {
        private static readonly Dictionary<string, Tuple<int, int, int>> QuestDat =
            new Dictionary<string, Tuple<int, int, int>> //Priority, Min, Max
            {
                /* Basic Quests */
                {"Scorpion Queen",              Tuple.Create(1, 1, 6)},
                {"Bandit Leader",               Tuple.Create(1, 1, 6)},
                {"Hobbit Mage",                 Tuple.Create(3, 3, 8)},
                {"Undead Hobbit Mage",          Tuple.Create(3, 3, 8)},
                {"Giant Crab",                  Tuple.Create(3, 3, 8)},
                {"Desert Werewolf",             Tuple.Create(3, 3, 8)},
                {"Sandsman King",               Tuple.Create(4, 4, 9)},
                {"Goblin Mage",                 Tuple.Create(4, 4, 9)},
                {"Elf Wizard",                  Tuple.Create(4, 4, 9)},
                {"Dwarf King",                  Tuple.Create(5, 5, 10)},
                {"Swarm",                       Tuple.Create(6, 6, 11)},
                {"Shambling Sludge",            Tuple.Create(6, 6, 11)},
                {"Great Lizard",                Tuple.Create(7, 7, 12)},
                {"Wasp Queen",                  Tuple.Create(8, 7, References.LevelCap)},
                {"Horned Drake",                Tuple.Create(8, 7, References.LevelCap)},
                {"Deathmage",                   Tuple.Create(5, 6, 11)},
                {"Great Coil Snake",            Tuple.Create(6, 6, 12)},

                /* Events */
                {"Lich",                        Tuple.Create(8, 6, References.LevelCap)},
                {"Actual Lich",                 Tuple.Create(8, 7, References.LevelCap)},
                {"Ent Ancient",                 Tuple.Create(9, 7, References.LevelCap)},
                {"Actual Ent Ancient",          Tuple.Create(9, 7, References.LevelCap)},
                {"Oasis Giant",                 Tuple.Create(10, 8, References.LevelCap)},
                {"Phoenix Lord",                Tuple.Create(10, 9, References.LevelCap)},
                {"Ghost King",                  Tuple.Create(11, 10, References.LevelCap)},
                {"Actual Ghost King",           Tuple.Create(11, 10, References.LevelCap)},
                {"Cyclops God",                 Tuple.Create(12, 10, References.LevelCap)},
                {"Red Demon",                   Tuple.Create(14, 15, References.LevelCap)},
                {"Skull Shrine",                Tuple.Create(13, 15, References.LevelCap)},
                {"Pentaract",                   Tuple.Create(13, 15, References.LevelCap)},
                {"Cube God",                    Tuple.Create(13, 15, References.LevelCap)},
                {"Grand Sphinx",                Tuple.Create(13, 15, References.LevelCap)},
                {"Lord of the Lost Lands",      Tuple.Create(13, 15, References.LevelCap)},
                {"Hermit God",                  Tuple.Create(13, 15, References.LevelCap)},
                {"Ghost Ship",                  Tuple.Create(13, 15, References.LevelCap)},

                /* Dungeons */
                {"Evil Chicken God",            Tuple.Create(15, 1, References.LevelCap)},
                {"Bonegrind the Butcher",       Tuple.Create(15, 1, References.LevelCap)},
                {"Dreadstump the Pirate King",  Tuple.Create(15, 1, References.LevelCap)},
                {"Arachna the Spider Queen",    Tuple.Create(15, 1, References.LevelCap)},
                {"Stheno the Snake Queen",      Tuple.Create(15, 1, References.LevelCap)},
                {"Mixcoatl the Masked God",     Tuple.Create(15, 1, References.LevelCap)},
                {"Limon the Sprite God",        Tuple.Create(15, 1, References.LevelCap)},
                {"Septavius the Ghost God",     Tuple.Create(15, 1, References.LevelCap)},
                {"Davy Jones",                  Tuple.Create(15, 1, References.LevelCap)},
                {"Lord Ruthven",                Tuple.Create(15, 1, References.LevelCap)},
                {"Archdemon Malphas",           Tuple.Create(15, 1, References.LevelCap)},
                {"Thessal the Mermaid Goddess", Tuple.Create(15, 1, References.LevelCap)},
                {"Dr. Terrible",                Tuple.Create(15, 1, References.LevelCap)},
                {"Horrific Creation",           Tuple.Create(15, 1, References.LevelCap)},
                {"Masked Party God",            Tuple.Create(15, 1, References.LevelCap)},
                {"Stone Guardian Left",         Tuple.Create(15, 1, References.LevelCap)},
                {"Stone Guardian Right",        Tuple.Create(15, 1, References.LevelCap)},
                {"Oryx the Mad God 1",          Tuple.Create(15, 1, References.LevelCap)},
                {"Oryx the Mad God 2",          Tuple.Create(15, 1, References.LevelCap)},
                {"Tower Golem Boss",            Tuple.Create(15, 1, References.LevelCap)},
                {"Super Tower Warrior",         Tuple.Create(15, 1, References.LevelCap)}

            };

        private Entity questEntity;

        public Entity Quest
        {
            get { return questEntity; }
        }

        public static readonly int[] ExpToLevel =
        {
            0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000,
            10000, 11000, 12000, 13000, 14000, 15000, 17000, 19000, 21000, 23000,
            25000, 27000, 29000, 31000, 33000, 35000, 37000, 39000, 41000, 43000,
            45000, 48000, 51000, 54000, 57000, 60000, 63000, 66000, 69000, 72000,
            75000, 78000, 81000, 84000, 87000, 90000, 94000, 98000, 102000, 106000,
            110000, 114000, 118000, 122000, 126000, 130000, 134000, 138000, 142000,
            146000, 150000, 155000, 160000, 165000, 170000, 175000, 180000, 185000,
            190000, 195000, 200000, 205000, 210000, 215000, 220000, 225000, 231000,
            237000, 243000, 249000, 255000, 261000, 267000, 273000, 279000, 285000,
            291000, 297000, 303000, 309000, 315000
            //use little EXPAlgorithm program to print 
        };

        public static int GetExpGoal(int level)
        {
            return ExpToLevel[level];
        }

        public static int GetLevelExp(int level)
        {
            var exp = 0;
            for (int i = 0; i < level; i++)
            {
                exp += ExpToLevel[i];
            }
            return exp;
        }

        public static int GetLevelFromExp(int exp)
        {
            int expCount = exp;
            int output;
            for (output = 0; output < References.LevelCap; output++)
            {
                if (expCount < ExpToLevel[output])
                    break;

                expCount -= ExpToLevel[output];
            }
            return output;
        }

        private static int GetFameGoal(int fame)
        {
            if (fame >= 4000) return 0;
            if (fame >= 2000) return 4000;
            if (fame >= 800) return 2000;
            if (fame >= 400) return 800;
            if (fame >= 150) return 400;
            if (fame >= 20) return 150;
            return 100;
        }

        public int GetStars()
        {
            int ret = 0;
            foreach (ClassStats i in client.Account.Stats.ClassStates)
            {
                if (i.BestFame >= 4000) ret += 6;
                else if (i.BestFame >= 2000) ret += 5;
                else if (i.BestFame >= 800) ret += 4;
                else if (i.BestFame >= 400) ret += 3;
                else if (i.BestFame >= 150) ret += 2;
                else if (i.BestFame >= 20) ret += 1;
            }
            return ret;
        }

        private Entity FindQuest()
        {
            Entity ret = null;
            double bestScore = 0;
            foreach (Enemy i in Owner.Quests.Values
                .OrderBy(quest => MathsUtils.DistSqr(quest.X, quest.Y, X, Y)))
            {
                if (i.ObjectDesc == null || !i.ObjectDesc.Quest) continue;

                Tuple<int, int, int> x;
                if (!QuestDat.TryGetValue(i.ObjectDesc.ObjectId, out x)) continue;

                if ((Level >= x.Item2 && Level <= x.Item3))
                {
                    double score = (References.LevelCap/*I think this is why quests doesn't show after certain level*/ - Math.Abs((i.ObjectDesc.Level ?? 0) - Level)) * x.Item1 - //priority * level diff
                                   this.Dist(i) / 100; //minus 1 for every 100 tile distance
                    if (score > bestScore)
                    {
                        bestScore = score;
                        ret = i;
                    }
                }
            }
            return ret;
        }

        private void HandleQuest(RealmTime time)
        {
            if (time.TickCount % 500 == 0 || questEntity == null || questEntity.Owner == null)
            {
                Entity newQuest = FindQuest();
                if (newQuest != null && newQuest != questEntity)
                {
                    Owner.Timers.Add(new WorldTimer(100, (w, t) => client.SendPacket(new QuestObjIdPacket
                    {
                        ObjectID = newQuest.Id
                    })));
                    questEntity = newQuest;
                }
            }
        }

        private void CalculateFame()
        {
            int newFame = 0;
            if (Experience < 200 * 20000) newFame = Experience / 20000;
            else newFame = 200 + (Experience - 200 * 20000) / 20000;
            if (newFame != Fame)
            {
                Fame = newFame;
                int newGoal;
                ClassStats state = client.Account.Stats.ClassStates.SingleOrDefault(_ => _.ObjectType == ObjectType);
                if (state != null && state.BestFame > Fame)
                    newGoal = GetFameGoal(state.BestFame);
                else
                    newGoal = GetFameGoal(Fame);
                if (newGoal > FameGoal)
                {
                    BroadcastSync(new NotificationPacket
                    {
                        ObjectId = Id,
                        Color = new ARGB(0xFF00FF00),
                        Text = "Class Quest Complete!"
                    }, p => this.Dist(p) < 25);
                    Stars = GetStars();
                }
                FameGoal = newGoal;
                UpdateCount++;
            }
        }

        public bool CheckLevelUp()
        {
            if (Experience - GetLevelExp(Level) >= ExperienceGoal && Level < References.LevelCap)
            {
                Level++;
                if (Level == References.LevelCap && XpBoost > 0)
                    XpBoost = 0;
                ExperienceGoal = GetExpGoal(Level);
                if (Level > MaxLevel)
                {
                    uint seed = client.Random.CurrentSeed;
                    foreach (XElement i in Manager.GameData.ObjectTypeToElement[ObjectType].Elements("LevelIncrease"))
                    {
                        
                           var rand = new Random();
                        int min = int.Parse(i.Attribute("min").Value);
                        int max = int.Parse(i.Attribute("max").Value) + 1;
                        int limit =
                            int.Parse(
                                Manager.GameData.ObjectTypeToElement[ObjectType].Element(i.Value).Attribute("max").Value);
                        int idx = StatsManager.StatsNameToIndex(i.Value);
                        //Stats[idx] += rand.Next(min, max);
                        Stats[idx] += (int)StatsManager.ObfRandom.Next(seed, (uint)min, (uint)max);
                        if (Stats[idx] > limit) Stats[idx] = limit;
                    }
                }
                HP = Stats[0] + Boost[0];
                MP = Stats[1] + Boost[1];
                if (client.Character.Level > client.Character.MaxLevel)
                {
                    client.Character.MaxLevel = Level;
                    MaxLevel = Level;
                }
                UpdateAbilities();
                UpdateCount++;

                if (Level == 10 || Level == 20 || Level == 40 || Level == 90)
                    foreach (Player i in Owner.Players.Values)
                        i.SendInfo(string.Format("{0} achieved level {1}", Name, Level));

                questEntity = null;
                
                return true;
                
            }
            CalculateFame();
            return false;
        }

        public bool EnemyKilled(Enemy enemy, int exp, bool killer)
        {
            try
            {
                if (enemy == questEntity)
                    BroadcastSync(new NotificationPacket
                    {
                        ObjectId = Id,
                        Color = new ARGB(0xFF00FF00),
                        Text = "Quest Complete!"
                    }, p => this.Dist(p) < 25);
                if (killer)
                {
                    if (Inventory[0] != null && Inventory.Data[0] != null && Inventory.Data[0].Strange)
                    {
                        ItemData data = Inventory.Data[0];
                        data.Kills++;
                        foreach (var i in data.StrangeParts)
                            switch (i.Key)
                            {
                                case "God Kills":
                                    if (enemy.ObjectDesc.God)
                                        data.StrangeParts[i.Key]++;
                                    break;
                                case "Quest Kills":
                                    if (enemy == questEntity)
                                        data.StrangeParts[i.Key]++;
                                    break;
                                case "Oryx Kills":
                                    if (enemy.ObjectDesc.Oryx)
                                        data.StrangeParts[i.Key]++;
                                    break;
                                case "Kills While Cloaked":
                                    if (HasConditionEffect(ConditionEffects.Invisible))
                                        data.StrangeParts[i.Key]++;
                                    break;
                                case "Kills Near Death":
                                    if (HP < Stats[0] * 0.2)
                                        data.StrangeParts[i.Key]++;
                                    break;
                            }
                        switch (Inventory.Data[0].Kills)
                        {
                            case 0: Inventory.Data[0].NamePrefix = "Strange"; break;
                            case 10: Inventory.Data[0].NamePrefix = "Unremarkable"; break;
                            case 25: Inventory.Data[0].NamePrefix = "Scarcely Lethal"; break;
                            case 45: Inventory.Data[0].NamePrefix = "Mildly Menacing"; break;
                            case 70: Inventory.Data[0].NamePrefix = "Somewhat Threatening"; break;
                            case 100: Inventory.Data[0].NamePrefix = "Uncharitable"; break;
                            case 135: Inventory.Data[0].NamePrefix = "Notably Dangerous"; break;
                            case 175: Inventory.Data[0].NamePrefix = "Sufficiently Lethal"; break;
                            case 225: Inventory.Data[0].NamePrefix = "Truly Feared"; break;
                            case 275: Inventory.Data[0].NamePrefix = "Spectacularly Lethal"; break;
                            case 350: Inventory.Data[0].NamePrefix = "Gore-Spattered"; break;
                            case 500: Inventory.Data[0].NamePrefix = "Wicked Nasty"; break;
                            case 750: Inventory.Data[0].NamePrefix = "Positively Inhumane"; break;
                            case 999: Inventory.Data[0].NamePrefix = "Totally Ordinary"; break;
                            case 1000: Inventory.Data[0].NamePrefix = "Face-Melting"; break;
                            case 1500: Inventory.Data[0].NamePrefix = "Rage-Inducing"; break;
                            case 2500: Inventory.Data[0].NamePrefix = "Realm-Clearing"; break;
                            case 5000: Inventory.Data[0].NamePrefix = "Epic"; break;
                            case 7500: Inventory.Data[0].NamePrefix = "Legendary"; break;
                            case 7616: Inventory.Data[0].NamePrefix = "Australian"; break;
                            case 8500: Inventory.Data[0].NamePrefix = "Soul-Tearing"; break;
                            case 10000: Inventory.Data[0].NamePrefix = "Oryx's Own"; break;
                            case 20000: Inventory.Data[0].NamePrefix = "Purified"; break;
                            case 50000: Inventory.Data[0].NamePrefix = "Phoenix God's Own"; break;
                            case 100000: Inventory.Data[0].NamePrefix = "Reborn"; break;
                        }
                        UpdateCount++;
                    }
                }
                if (exp > 0)
                {
                    Experience += (XpBoost != 0) ? (exp * (int)XpBoost) : exp;
                    UpdateCount++;
                    foreach (Entity i in Owner.PlayersCollision.HitTest(X, Y, 15))
                    {
                        if (i != this)
                        {
                            (i as Player).Experience += exp;
                            (i as Player).UpdateCount++;
                            (i as Player).CheckLevelUp();
                        }
                    }
                }
                fameCounter.Killed(enemy, killer);
                return CheckLevelUp();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }
        }
    }
}