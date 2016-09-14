using db;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.logic.loot
{
    public interface ILootDef
    {
        void Populate(RealmManager manager, Enemy enemy, Tuple<Player, int> playerDat,
            Random rand, IList<LootDef> lootDefs);
    }

    public class ItemLoot : ILootDef
    {
        private readonly string item;
        private readonly double probability;

        public ItemLoot(string item, double probability)
        {
            this.item = item;
            this.probability = probability;
        }

        public void Populate(RealmManager manager, Enemy enemy, Tuple<Player, int> playerDat,
            Random rand, IList<LootDef> lootDefs)
        {
            try
            {
                XmlData dat = manager.GameData;
                lootDefs.Add(new LootDef(dat.Items[dat.IdToObjectType[item]], probability));
            }
            catch
            {
                string text = enemy.ObjectDesc.ObjectId + " seems to have a loot error. Please send a staff member a screenshot of this error.";
                foreach (wServer.networking.Client i in manager.Clients.Values)
                    i.SendPacket(new TextPacket
                    {
                        BubbleTime = 0,
                        Stars = -1,
                        Name = "Loot Error",
                        Text = text.ToSafeText()
                    });
                
            }
        }
    }

    public enum ItemType
    {
        Weapon,
        Ability,
        Armor,
        Ring,
        Potion
    }

    public class TierLoot : ILootDef
    {
        public static readonly int[] WeaponT = {1, 2, 3, 8, 17, 24};
        public static readonly int[] AbilityT = {4, 5, 11, 12, 13, 15, 16, 18, 19, 20, 21, 22, 23, 25};
        public static readonly int[] ArmorT = {6, 7, 14};
        public static readonly int[] RingT = {9};
        public static readonly int[] PotionT = {10};
        private readonly double probability;
        private double prob;
        private int count;
        private readonly byte tier;
        private readonly int[] types;

        public TierLoot(byte tier, ItemType type, double probability)
        {
            this.tier = tier;
            switch (type)
            {
                case ItemType.Weapon:
                    types = WeaponT;
                    break;
                case ItemType.Ability:
                    types = AbilityT;
                    break;
                case ItemType.Armor:
                    types = ArmorT;
                    break;
                case ItemType.Ring:
                    types = RingT;
                    break;
                case ItemType.Potion:
                    types = PotionT;
                    break;
                default:
                    throw new NotSupportedException(type.ToString());
            }
            this.probability = probability;
          
        }

        public void Populate(RealmManager manager, Enemy enemy, Tuple<Player, int> playerDat,
            Random rand, IList<LootDef> lootDefs)
        {
            
            Item[] candidates = manager.GameData.Items
                .Where(item => Array.IndexOf(types, item.Value.SlotType) != -1)
                .Where(item => item.Value.Tier == tier)
                .Select(item => item.Value)
                .ToArray();
            count = candidates.Length;
            foreach (Item i in candidates)
            {
                if (playerDat != null && playerDat.Item1.SlotTypes.Contains(i.SlotType) && i.SlotType != 0)
                {
                    count++;
                }
            }
            foreach (Item i in candidates)
            {
                prob = probability;
                if (playerDat != null && playerDat.Item1.SlotTypes.Contains(i.SlotType) && i.SlotType != 0)
                {
                    lootDefs.Add(new LootDef(i, prob / count));
                }
                lootDefs.Add(new LootDef(i, prob / count));
            }
        }
    }

    public class Threshold : ILootDef
    {
        private readonly ILootDef[] children;
        private readonly double threshold;

        public Threshold(double threshold, params ILootDef[] children)
        {
            this.threshold = threshold;
            this.children = children;
        }

        public void Populate(RealmManager manager, Enemy enemy, Tuple<Player, int> playerDat,
            Random rand, IList<LootDef> lootDefs)
        {
            if (playerDat != null && playerDat.Item2/(double) enemy.ObjectDesc.MaxHP >= threshold)
            {
                foreach (ILootDef i in children)
                    i.Populate(manager, enemy, null, rand, lootDefs);
            }
        }
    }

    public class SilverLoot : ILootDef
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(SilverLoot));

        private readonly int maxSilver;
        private readonly int minSilver;

        public SilverLoot(int minSilver, int maxSilver)
        {
            this.maxSilver = maxSilver;
            this.minSilver = minSilver;
        }

        public void Populate(RealmManager manager, Enemy enemy, Tuple<Player, int> playerDat,
            Random rand, IList<LootDef> lootDefs)
        {
            if (playerDat == null)
                return;
            for (int i = 0; i < 3; i++ )
                playerDat.Item1.Owner.BroadcastPacket(new ShowEffectPacket()
                {
                    EffectType = EffectType.Flow,
                    Color = new ARGB(0xFF9999FF),
                    TargetId = playerDat.Item1.Id,
                    PosA = new Position() { X = enemy.X, Y = enemy.Y }
                }, null);
            manager.Data.AddDatabaseOperation(db =>
            {
                playerDat.Item1.Silver =
                    playerDat.Item1.Client.Account.Silver =
                        db.UpdateSilver(playerDat.Item1.Client.Account,
                            rand.Next(minSilver, maxSilver + 1));
                playerDat.Item1.UpdateCount++;
            });
        }
    }
}