using db;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wServer.realm.entities
{
    partial class Player
    {
        public Tuple<Item, ItemData> GetUnboxResult(Item crateItem, Random rand)
        {
            if (rand == null)
                rand = new Random();
            double choice = rand.NextDouble();
            double totalChance = 0;
            foreach (Tuple<double, List<CrateLoot>> i in crateItem.CrateLoot)
            {
                totalChance += i.Item1;
                if (choice < totalChance)
                {
                    var crateLoot = i.Item2.RandomElement(rand);
                    return GetCrateLoot(crateLoot, rand);
                }
            }
            Item item = Manager.GameData.Items[Manager.GameData.IdToObjectType["Gold Medal"]];
            ItemData itemData = new ItemData();
            itemData.NameColor = 0x3B875D;
            itemData.NamePrefix = "Bugfinder's";
            return Tuple.Create(item, itemData);
        }

        public Tuple<Item, ItemData> GetCrateLoot(CrateLoot crateLoot, Random rand)
        {
            if (rand == null)
                rand = new Random();
            Item item = null;
            ItemData itemData = null;
            switch (crateLoot.Type)
            {
                case CrateLootTypes.Item:
                    {
                        itemData = new ItemData();
                        if (crateLoot.Strange)
                        {
                            itemData.NameColor = 0xFF5A28;
                            itemData.NamePrefix = "Strange";
                            itemData.Kills = 0;
                            itemData.Strange = true;
                        }
                        if (crateLoot.NameColor != 0xFFFFFF)
                            itemData.NameColor = crateLoot.NameColor;
                        item = Manager.GameData.Items[Manager.GameData.IdToObjectType[crateLoot.Name]];
                    }
                    break;
                case CrateLootTypes.Skin:
                    {
                        if (crateLoot.Unusual)
                        {
                            itemData = new ItemData();
                            List<string> effects = new List<string>();
                            if (crateLoot.Series != 0)
                                effects = UnusualEffects.Series[crateLoot.Series];
                            else
                            {
                                foreach (var i in UnusualEffects.Series)
                                    if (i.Key != 0)
                                        effects.AddRange(i.Value);
                            }
                            itemData.NamePrefix = "Unusual";
                            itemData.NameColor = 0x8000FF;
                            itemData.Effect = effects.RandomElement(rand);
                            itemData.FullEffect = UnusualEffects.Save(itemData.Effect);
                        }
                        List<Item> candidates = Manager.GameData.Items
                            .Where(_item =>
                            {
                                foreach (var activEff in _item.Value.ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnlockSkin)
                                        return true;
                                return false;
                            })
                            .Where(_item =>
                            {
                                if (crateLoot.Premium && !_item.Value.Premium)
                                    return false;
                                if (!crateLoot.Premium && _item.Value.Premium)
                                    return false;
                                return true;
                            })
                            .Where(_item => !_item.Value.AdminOnly)
                            .Select(_item => _item.Value)
                            .ToList();
                        item = candidates.RandomElement(rand);
                    }
                    break;
                case CrateLootTypes.StrangePart:
                    {
                        item = Manager.GameData.Items[Manager.GameData.IdToObjectType["Strange Part"]];
                        itemData = new ItemData();
                        if (crateLoot.Name != null)
                            itemData.NamePrefix = crateLoot.Name;
                        else
                        {
                            string randPart = ItemData.StrangePartTypes.RandomElement(rand);
                            itemData.NamePrefix = randPart;
                        }
                    }
                    break;
                case CrateLootTypes.TieredStrangifier:
                    {
                        item = Manager.GameData.Items[Manager.GameData.IdToObjectType["Strangifier"]];
                        itemData = new ItemData();
                        int[] types = new int[] { 1, 2, 3, 8, 17, 24 };
                        List<Item> candidates = Manager.GameData.Items
                            .Where(_item => Array.IndexOf(types, _item.Value.SlotType) != -1)
                            .Where(_item => _item.Value.Tier == rand.Next(crateLoot.MinTier, crateLoot.MaxTier + 1))
                            .Select(_item => _item.Value)
                            .ToList();
                        itemData.NamePrefix = candidates.RandomElement(rand).ObjectId;
                        itemData.NameColor = 0xFF5A28;
                    }
                    break;
            }
            return Tuple.Create(item, itemData);
        }
    }
}