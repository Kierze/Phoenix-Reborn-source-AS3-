#region

using System.Linq;
using db;
using log4net;
using System;
using System.Collections.Generic;

#endregion

namespace wServer.realm.entities
{
    internal class MerchantLists
    {
        public static int[] AccessoryClothList;
        public static int[] AccessoryDyeList;
        public static int[] ClothingClothList;
        public static int[] ClothingDyeList;

        public static int[] PetGeneratorList;
        public static int[] MaterialList;
        public static int[] KeyList;

        public static int[] WeaponList;
        public static int[] AbilityList;
        public static int[] ArmorList;
        public static int[] RingList;

        public static int[] BoosterList = { 0xc5d, 0xc5e };

        public static int[] NoDiscountList;

        public static Dictionary<int, Tuple<int, CurrencyType>> prices = new Dictionary<int, Tuple<int, CurrencyType>>
        {
            {0x230c, new Tuple<int, CurrencyType>(1250, CurrencyType.Gold)},
            {0xc5d, new Tuple<int, CurrencyType>(500, CurrencyType.Gold)},
            {0xc5e, new Tuple<int, CurrencyType>(700, CurrencyType.Gold)}
        };

        // Untiered
        public static int[] Store10List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store11List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store12List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store13List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store14List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store15List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store16List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store17List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store18List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store19List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };
        public static int[] Store20List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };

        // Keys
        public static int[] Store1List =
        {
            /*0xcdd, 0xcda, 0xccf, 0xcce, */0xc2f, 0xc2e, 0xc23, 0xc19, 0xc11, 0x71f, 0x710,
            0x70b, 0x70a, 0x705, 0x701/*, 0x2290*/
        };

        // Pet Eggs
        public static int[] Store2List =
        {
            0xcbf, 0xcbe, 0xcbb, 0xcba, 0xcb7, 0xcb6, 0xcb2, 0xcb3, 0xcae, 0xcaf, 0xcab,
            0xcaa, 0xca7, 0xca6, 0xca3, 0xca2, 0xc9f, 0xc9e, 0xc9b, 0xc9a, 0xc97, 0xc96, 0xc93, 0xc92, 0xc8f, 0xc8e,
            0xc8b, 0xc8a, 0xc87, 0xc86
        };

        // Pet Food
        public static int[] Store3List = { 0xccc, 0xccb, 0xcca, 0xcc9, 0xcc8, 0xcc7, 0xcc6, 0xcc5, 0xcc4 };

        // T5-T6 (Abilities)
        public static int[] Store4List =
        {
            0xb25, 0xa5b, 0xb22, 0xa0c, 0xb24, 0xa30, 0xb26, 0xa55, 0xb27, 0xae1, 0xb28,
            0xa65, 0xb29, 0xa6b, 0xb2a, 0xaa8, 0xb2b, 0xaaf, 0xb2c, 0xab6, 0xb2d, 0xa46, 0xb23, 0xb20, 0xb33, 0xb32,
            0xc59, 0xc58
        };

        // T9-T13 (Armors)
        public static int[] Store5List =
        {
            0xb05, 0xa96, 0xa95, 0xa94, 0xa60, 0xafc, 0xa93, 0xa92, 0xa91, 0xa13, 0xaf9,
            0xa90, 0xa8f, 0xa8e, 0xad3
        };

        // T8-T12 (Magic Weapons)
        public static int[] Store6List =
        {
            0xaf6, 0xa87, 0xa86, 0xa85, 0xa07, 0xb02, 0xa8d, 0xa8c, 0xa8b, 0xa1e, 0xb08,
            0xaa2, 0xaa1, 0xaa0, 0xa9f
        };

        // T8-T12 (Bladed Weapons)
        public static int[] Store7List =
        {
            0xb0b, 0xa47, 0xa84, 0xa83, 0xa82, 0xaff, 0xa8a, 0xa89, 0xa88, 0xa19, 0xc50,
            0xc4f, 0xc4e, 0xc4d, 0xc4c
        };

        // Rings
        public static int[] Store8List =
        {
            0xabf, 0xac0, 0xac1, 0xac2, 0xac3, 0xac4, 0xac5, 0xac6, 0xac7, 0xac8, 0xac9,
            0xaca, 0xacb, 0xacc, 0xacd, 0xace
        };

        // Untiered
        public static int[] Store9List = { /*0xb41, 0xbab, 0xbad, 0xbac*/ };

        private static readonly ILog log = LogManager.GetLogger(typeof(MerchantLists));

        public static void InitMerchantLists(XmlData data)
        {
            log.Info("Loading merchant lists...");
            
            /* Price Lists */
            var accessoryDyeList = new List<int>();
            var clothingDyeList = new List<int>();
            var accessoryClothList = new List<int>();
            var clothingClothList = new List<int>();

            var petGeneratorList = new List<int>();
            var materialList = new List<int>();
            var keyList = new List<int>();

            var weaponList = new List<int>();
            var abilityList = new List<int>();
            var armorList = new List<int>();
            var ringList = new List<int>();

            var noDiscountList = new List<int>();

            foreach (KeyValuePair<ushort, Item> item in data.Items)
            {
                if (item.Value.Texture1 != 0 && item.Value.ObjectId.Contains("Clothing") &&
                    item.Value.Class == "Dye")
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(150, CurrencyType.Gold));
                    clothingDyeList.Add(item.Value.ObjectType);
                }

                if (item.Value.Texture2 != 0 && item.Value.ObjectId.Contains("Accessory") &&
                    item.Value.Class == "Dye")
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(150, CurrencyType.Gold));
                    accessoryDyeList.Add(item.Value.ObjectType);
                }

                if (item.Value.Texture1 != 0 && item.Value.ObjectId.Contains("Cloth") &&
                    item.Value.ObjectId.Contains("Large"))
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                    clothingClothList.Add(item.Value.ObjectType);
                }

                if (item.Value.Texture2 != 0 && item.Value.ObjectId.Contains("Cloth") &&
                    item.Value.ObjectId.Contains("Small"))
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                    accessoryClothList.Add(item.Value.ObjectType);
                }

                if (item.Value.ObjectId.EndsWith("Generator"))
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Fame));
                    petGeneratorList.Add(item.Value.ObjectType);
                }

                if (item.Value.Material && item.Value.Price > 0)
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(item.Value.Price, CurrencyType.Silver));
                    materialList.Add(item.Value.ObjectType);

                    noDiscountList.Add(item.Value.ObjectType);
                }

                if (item.Value.ObjectId.EndsWith("Key") && item.Value.Class == "Equipment" &&
                    item.Value.Consumable && item.Value.Soulbound && !item.Value.AdminOnly)
                {
                    prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(item.Value.Price != 0 ? item.Value.Price : 1500, CurrencyType.Gold));
                    keyList.Add(item.Value.ObjectType);

                    noDiscountList.Add(item.Value.ObjectType);
                }

                if (item.Value.Class == "Equipment" &&
                    (item.Value.SlotType == 1 || item.Value.SlotType == 2 || item.Value.SlotType == 3 || item.Value.SlotType == 8 ||
                    item.Value.SlotType == 17 || item.Value.SlotType == 24) && !item.Value.AdminOnly)
                {
                    switch (item.Value.Tier)
                    {
                        case 8:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                            weaponList.Add(item.Value.ObjectType);
                            break;
                        case 9:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(750, CurrencyType.Gold));
                            weaponList.Add(item.Value.ObjectType);
                            break;
                    }
                }

                if (item.Value.Class == "Equipment" &&
                    (item.Value.SlotType == 4 || item.Value.SlotType == 5 || item.Value.SlotType == 11 || item.Value.SlotType == 12 ||
                    item.Value.SlotType == 13 || item.Value.SlotType == 15 || item.Value.SlotType == 16 || item.Value.SlotType == 18 ||
                    item.Value.SlotType == 19 || item.Value.SlotType == 20 || item.Value.SlotType == 21 || item.Value.SlotType == 22 ||
                    item.Value.SlotType == 23 || item.Value.SlotType == 25) && !item.Value.AdminOnly)
                {
                    switch (item.Value.Tier)
                    {
                        case 4:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                            abilityList.Add(item.Value.ObjectType);
                            break;
                    }
                }

                if (item.Value.Class == "Equipment" &&
                    (item.Value.SlotType == 6 || item.Value.SlotType == 7 || item.Value.SlotType == 14) && !item.Value.AdminOnly)
                {
                    switch (item.Value.Tier)
                    {
                        case 9:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                            armorList.Add(item.Value.ObjectType);
                            break;
                        case 10:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(750, CurrencyType.Gold));
                            armorList.Add(item.Value.ObjectType);
                            break;
                    }
                }

                if (item.Value.Class == "Equipment" && item.Value.ObjectId.Contains("Ring") && (item.Value.SlotType == 9) && !item.Value.AdminOnly)
                {
                    switch (item.Value.Tier)
                    {
                        case 4:
                            prices.Add(item.Value.ObjectType, new Tuple<int, CurrencyType>(500, CurrencyType.Gold));
                            ringList.Add(item.Value.ObjectType);
                            break;
                    }
                }
            }

            ClothingDyeList = clothingDyeList.ToArray();
            ClothingClothList = clothingClothList.ToArray();
            AccessoryClothList = accessoryClothList.ToArray();
            AccessoryDyeList = accessoryDyeList.ToArray();

            PetGeneratorList = petGeneratorList.ToArray();
            MaterialList = materialList.ToArray();
            KeyList = keyList.ToArray();

            WeaponList = weaponList.ToArray();
            AbilityList = abilityList.ToArray();
            ArmorList = armorList.ToArray();
            RingList = ringList.ToArray();

            noDiscountList.Add(0xc5e);
            noDiscountList.Add(0xc5d);

            NoDiscountList = noDiscountList.ToArray();

            log.Info("Merchat lists added.");
        }
    }
}