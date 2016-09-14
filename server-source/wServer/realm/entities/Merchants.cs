#region

using System.Linq;
using db;
using log4net;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Xml.Linq;
using wServer.networking.svrPackets;
using wServer.realm.entities.player;
using wServer.realm.terrain;

#endregion

namespace wServer.realm.entities
{
    public class Merchants : SellableObject
    {
        private const int BUY_NO_GOLD = 3;
        private const int BUY_NO_FAME = 6;
        private const int BUY_NO_SILVER = 9;
        private const int merchantSize = 100;
        private static readonly new ILog log = LogManager.GetLogger(typeof(Merchants));

        private readonly Dictionary<int, Tuple<int, CurrencyType>> prices = MerchantLists.prices;
        private int objType;

        private bool closing;
        private bool newMerchant;
        private int tickcount;

        public static Random Random { get; private set; }

        public Merchants(RealmManager manager, ushort objType, World owner = null)
            : base(manager, objType)
        {
            MType = -1;
            this.objType = objType;
            Size = merchantSize;
            if (owner != null)
                Owner = owner;

            if (Random == null) Random = new Random();
            if (AddedTypes == null) AddedTypes = new List<KeyValuePair<string, int>>();
            if (owner != null) ResolveMType();
        }

        private static List<KeyValuePair<string, int>> AddedTypes { get; set; }

        public bool Custom { get; set; }

        public int MType { get; set; }
        public int MRemaining { get; set; }
        public int MTime { get; set; }
        public int Discount { get; set; }

        protected override void ExportStats(IDictionary<StatsType, object> stats)
        {
            stats[StatsType.MerchantMerchandiseType] = MType;
            stats[StatsType.MerchantRemainingCount] = MRemaining;
            stats[StatsType.MerchantRemainingMinute] = newMerchant ? Int32.MaxValue : MTime;
            stats[StatsType.MerchantDiscount] = Discount;
            stats[StatsType.SellablePrice] = Price;
            stats[StatsType.SellableRankRequirement] = RankReq;
            stats[StatsType.SellablePriceCurrency] = Currency;

            base.ExportStats(stats);
        }

        public override void Init(World owner)
        {
            base.Init(owner);
            ResolveMType();
            UpdateCount++;
            if (MType == -1) Owner.LeaveWorld(this);
        }

        protected bool TryDeduct(Player player)
        {
            Account acc = player.Client.Account;
            if (player.Stars < RankReq) return false;

            if (Currency == CurrencyType.Fame)
                if (acc.Stats.Fame < Price) return false;

            if (Currency == CurrencyType.Gold)
                if (acc.Credits < Price) return false;

            if (Currency == CurrencyType.Silver)
                if (acc.Silver < Price) return false;
            return true;
        }

        public override void Buy(Player player)
        {
            if (ObjectType == 0x01ca) //Merchant
            {
                if (TryDeduct(player))
                {
                    for (int i = 0; i < player.Inventory.Length; i++)
                    {
                        try
                        {
                            XElement ist;
                            Manager.GameData.ObjectTypeToElement.TryGetValue((ushort)MType, out ist);
                            if (player.Inventory[i] == null &&
                                (player.SlotTypes[i] == 10 ||
                                 player.SlotTypes[i] == Convert.ToInt16(ist.Element("SlotType").Value)))
                            // Exploit fix - No more mnovas as weapons!
                            {
                                player.Inventory[i] = Manager.GameData.Items[(ushort)MType];

                                Manager.Data.AddDatabaseOperation(db =>
                                {
                                    switch (Currency)
                                    {
                                        case CurrencyType.Gold:
                                            player.Credits = player.Client.Account.Credits = db.UpdateCredit(player.Client.Account, -Price);
                                            break;
                                        case CurrencyType.Fame:
                                            player.CurrentFame = player.Client.Account.Stats.Fame = db.UpdateFame(player.Client.Account, -Price);
                                            break;
                                        case CurrencyType.GuildFame:
                                            throw new ArgumentException("No guild fame pl0x");
                                        case CurrencyType.Silver:
                                            player.Silver = player.Client.Account.Silver = db.UpdateSilver(player.Client.Account, -Price);
                                            break;
                                        default:
                                            throw new ArgumentOutOfRangeException();
                                    }

                                    player.Client.SendPacket(new BuyResultPacket
                                    {
                                        Result = 0, Message = "Purchase Successful"
                                    });
                                }).ContinueWith(task =>
                                {
                                    MRemaining--;
                                    player.UpdateCount++;
                                    player.SaveToCharacter();
                                    UpdateCount++;
                                }, TaskContinuationOptions.NotOnFaulted);
                                return;
                            }
                        }
                        catch (Exception e)
                        {
                            log.Error(e);
                        }
                    }
                    player.Client.SendPacket(new BuyResultPacket
                    {
                        Result = 0, Message = "You cannot purchase when your inventory is full"
                    });
                }
                else
                {
                    if (player.Stars < RankReq)
                    {
                        player.Client.SendPacket(new BuyResultPacket
                        {
                            Result = 0, Message = "Not Enough Stars"
                        });
                        return;
                    }
                    switch (Currency)
                    {
                        case CurrencyType.Gold:
                            player.Client.SendPacket(new BuyResultPacket
                            {
                                Result = BUY_NO_GOLD, Message = "Not Enough Gold"
                            });
                            break;
                        case CurrencyType.Fame:
                            player.Client.SendPacket(new BuyResultPacket
                            {
                                Result = BUY_NO_FAME, Message = "Not Enough Fame"
                            });
                            break;
                        case CurrencyType.Silver:
                            player.Client.SendPacket(new BuyResultPacket
                            {
                                Result = BUY_NO_SILVER, Message = "Not Enough Silver"
                            });
                            break;
                    }
                }
            }
        }

        public override void Tick(RealmTime time)
        {
            try
            {
                if (Size == 0 && MType != -1)
                {
                    Size = merchantSize;
                    UpdateCount++;
                }

                if (!closing)
                {
                    tickcount++;
                    if (Manager != null)
                    {
                        if (tickcount%(Manager.TPS*60) == 0) //once per minute after spawning
                        {
                            MTime--;
                            UpdateCount++;
                        }
                    }
                }

                if (MRemaining == 0 && MType != -1)
                {
                    if (AddedTypes.Contains(new KeyValuePair<string, int>(Owner.Name, MType)))
                        AddedTypes.Remove(new KeyValuePair<string, int>(Owner.Name, MType));
                    Recreate(this);
                    UpdateCount++;
                }

                if (MTime == -1 && Owner != null)
                {
                    if (AddedTypes.Contains(new KeyValuePair<string, int>(Owner.Name, MType)))
                        AddedTypes.Remove(new KeyValuePair<string, int>(Owner.Name, MType));
                    Recreate(this);
                    UpdateCount++;
                }

                if (MTime == 1 && !closing)
                {
                    closing = true;
                    if (Owner != null)
                        Owner.Timers.Add(new WorldTimer(30*1000, (w1, t1) =>
                        {
                            MTime--;
                            UpdateCount++;
                            w1.Timers.Add(new WorldTimer(30*1000, (w2, t2) =>
                            {
                                MTime--;
                                UpdateCount++;
                            }));
                        }));
                }

                if (!MerchantLists.NoDiscountList.Contains(MType))
                {
                    int s = MRemaining;

                    if (s <= 2)
                        Discount = 50;
                    else if (s <= 5)
                        Discount = 25;
                    else if (s <= 10)
                        Discount = 15;
                    else if (s <= 15)
                        Discount = 10;
                    else Discount = 0;

                    Tuple<int, CurrencyType> price;
                    if (prices.TryGetValue(MType, out price))
                    {
                        Price = (int) (price.Item1 - (price.Item1*((double) Discount/100))) < 1 ? price.Item1 : (int) (price.Item1 - (price.Item1*((double) Discount/100)));
                    }
                }

                if (MType == -1 && Owner != null) Owner.LeaveWorld(this);

                base.Tick(time);
            }
            catch (Exception ex)
            {
                log.Error(ex);
            }
        }

        public void Recreate(Merchants x)
        {
            try
            {
                Merchants mrc = new Merchants(Manager, x.ObjectType, x.Owner);
                mrc.Move(x.X, x.Y);
                World w = Owner;
                Owner.LeaveWorld(this);
                w.Timers.Add(new WorldTimer(Random.Next(30, 60)*1000, (world, time) => w.EnterWorld(mrc)));
            }
            catch (Exception e)
            {
                log.Error(e);
            }
        }

        public void ResolveMType()
        {
            MType = -1;
            int[] list = new int[0];
            if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_1)
                list = MerchantLists.KeyList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_2)
                list = MerchantLists.WeaponList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_3)
                list = MerchantLists.AbilityList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_4)
                list = MerchantLists.ArmorList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_5)
                list = MerchantLists.RingList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_6)
                list = MerchantLists.BoosterList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_7)
                list = MerchantLists.MaterialList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_12)
                list = MerchantLists.AccessoryDyeList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_13)
                list = MerchantLists.ClothingClothList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_14)
                list = MerchantLists.AccessoryClothList;
            else if (Owner.Map[(int) X, (int) Y].Region == TileRegion.Store_15)
                list = MerchantLists.ClothingDyeList;

            if (AddedTypes == null) AddedTypes = new List<KeyValuePair<string, int>>();
            //list.Shuffle();
            for (int i = 0; i < list.Length; i++)
            {
                if (!AddedTypes.Contains(new KeyValuePair<string, int>(Owner.Name, list[i])))
                {
                    AddedTypes.Add(new KeyValuePair<string, int>(Owner.Name, list[i]));
                    MType = list[i];
                    MTime = Random.Next(6, 15);
                    MRemaining = Random.Next(10, 20);
                    newMerchant = true;
                    Owner.Timers.Add(new WorldTimer(30000, (w, t) =>
                    {
                        newMerchant = false;
                        UpdateCount++;
                    }));

                    Tuple<int, CurrencyType> price;
                    if (prices.TryGetValue(MType, out price))
                    {
                        Price = price.Item1;
                        Currency = price.Item2;
                    }

                    break;
                }
            }
            UpdateCount++;
        }
    }
}