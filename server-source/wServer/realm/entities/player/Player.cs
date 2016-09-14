using db;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Linq;
using wServer.logic;
using wServer.networking;
using wServer.networking.svrPackets;
using wServer.realm.terrain;

namespace wServer.realm.entities
{
    internal interface IPlayer
    {
        void Damage(int dmg, int penetration, Entity chr);

        bool IsVisibleToEnemy();
    }

    public partial class Player : Character, IContainer, IPlayer
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(Player));

        private readonly Client client;
        private FameCounter fameCounter;
        private float vitalityCounter;
        public bool isNotVisible = false;
        private float wisdomCounter;
        private bool resurrecting;
        public bool ignoringcooldowns = false;
        public StatsManager statsMgr;
        private byte[,] tiles;
        public bool usingShuriken = false;
        private int pingSerial;
        public bool Dead;
        public int bowBlessing = 100;
        private RealmTime t;
        public List<Poison> poisons = new List<Poison>();
        public List<Poison> removepoisons = new List<Poison>();
        public List<Burn> burns = new List<Burn>();
        public List<Burn> removeburns = new List<Burn>();
        public Dictionary<Enemy, int> DeathMarked = new Dictionary<Enemy, int>();

        public Player(Client client)
            : base(client.Manager, (ushort)client.Character.ObjectType, client.Random)
        {
            this.client = client;
            statsMgr = new StatsManager(this, client.Random.CurrentSeed);
            Name = client.Account.Name;
            AccountId = client.Account.AccountId;

            Name = client.Account.Name;
            Level = client.Character.Level;
            Experience = client.Character.Exp;
            ExperienceGoal = GetExpGoal(client.Character.Level);
            Stars = GetStars();
            Texture1 = client.Character.Tex1;
            Texture2 = client.Character.Tex2;
            Effect = client.Character.Effect;
            XmlEffect = "";
            Skin = client.Character.Skin;
            PermaSkin = client.Character.PermaSkin != 0;
            XpBoost = client.Character.XpBoost;
            Credits = client.Account.Credits;
            Silver = client.Account.Silver;
            UnlockedMoods = client.Account.UnlockedMoods;
            NameChosen = client.Account.NameChosen;
            CurrentFame = client.Account.Stats.Fame;
            Fame = client.Character.CurrentFame;
            ClassStats state = client.Account.Stats.ClassStates.SingleOrDefault(_ => _.ObjectType == ObjectType);
            FameGoal = GetFameGoal(state?.BestFame ?? 0);
            CameraOffsetX = CameraOffsetY = 0;
            CameraX = CameraY = 0;
            CameraRot = 0;
            FixedCamera = FixedCameraRot = false;
            CameraUpdate = false;
            warpUses = 0;

            Locked = client.Account.Locked ?? new List<int>();
            Ignored = client.Account.Ignored ?? new List<int>();

            Glowing = -1;
            Manager.Data.AddDatabaseOperation(db => //We dont need to await here
            {
                if (db.IsUserInLegends(AccountId))
                    Glowing = 0xFF0000;
                if (client.Account.Admin)
                    Glowing = 0xFF00FF;
            });
            Guild = client.Account.Guild.Name;
            GuildRank = client.Account.Guild.Rank;
            HP = client.Character.HitPoints;
            MP = client.Character.MagicPoints;
            Floors = client.Character.Floors;
            ConditionEffects = 0;
            OxygenBar = 100;

            Party = Party.GetParty(this);
            if (Party != null)
                if (Party.Leader.AccountId == AccountId)
                    Party.Leader = this;
                else
                    Party.Members.Add(this);

            if (HP <= 0)
                HP = client.Character.MaxHitPoints;

            Inventory = new Inventory(this,
                client.Character.Equipment
                    .Select(_ => _ == 0xffff ? null : client.Manager.GameData.Items[_])
                    .ToArray(),
                client.Character.EquipData);
            Inventory.InventoryChanged += (sender, e) => CalculateBoost();
            SlotTypes =
                Utils.FromCommaSepString32(
                    client.Manager.GameData.ObjectTypeToElement[ObjectType].Element("SlotTypes").Value);
            Stats = new[]
            {
                client.Character.MaxHitPoints,
                client.Character.MaxMagicPoints,
                client.Character.Attack,
                client.Character.Defense,
                client.Character.Speed,
                client.Character.Vitality,
                client.Character.Wisdom,
                client.Character.Dexterity,
                client.Character.Aptitude,
                client.Character.Resilience,
                client.Character.Penetration
            };
            CalculateBoost();
            Pet = null;

            for (int i = 0; i < SlotTypes.Length; i++)
                if (SlotTypes[i] == 0) SlotTypes[i] = 10;

            Ability = new Ability[3] { null, null, null };
            CacheAbilities = Ability;
            CacheAP = 0;
            AbilityCooldown = new int[3] { 3, 3, 3 };
            AbilityActiveDurations = new int[3] { 0, 0, 0 };
            AbilityToggle = new bool[3] { false, false, false };
            AbilityToggleVar = 0;
            Specialization = client.Character.Specialization;

            UpdateAbilities();

            Mood = client.Character.Mood;

            MaxLevel = client.Character.MaxLevel;

            AddRecipes();

            // "default_" is default and all the rest are normal.
            // red, orange, yellow, green, blue.
            if (/*criteria*/ false)
                ChatBubbleColour = "purple";
            else
                ChatBubbleColour = "default_";
        }

        public Client Client
        {
            get { return client; }
        }

        //Stats
        public int AccountId { get; private set; }

        public Entity Pet { get; set; }

        public int Experience { get; set; }
        public int ExperienceGoal { get; set; }
        public int Level { get; set; }

        public List<int> Locked { get; set; }
        public List<int> Ignored { get; set; }

        public int CurrentFame { get; set; }
        public int Fame { get; set; }
        public int FameGoal { get; set; }
        public int Stars { get; set; }

        public string Guild { get; set; }
        public int GuildRank { get; set; }
        public bool Invited { get; set; }

        public int Credits { get; set; }
        public int Silver { get; set; }
        public bool[] UnlockedMoods { get; set; }
        public bool NameChosen { get; set; }
        public int OxygenBar { get; set; }
        public int Texture1 { get; set; }
        public int Texture2 { get; set; }
        public int Skin { get; set; }
        public bool PermaSkin { get; set; }

        public int Glowing { get; set; }
        public int MP { get; set; }

        public int[] Stats { get; private set; }
        public int[] Boost { get; private set; }
        public ActivateBoost[] ActivateBoost { get; private set; }

        public int? XpBoost { get; set; }

        public bool CanNexus { get; set; }
        public int Floors { get; set; }
        public Party Party { get; set; }

        public string Effect { get; set; }
        public string XmlEffect { get; set; }

        public Ability[] Ability { get; set; }
        public Ability[] CacheAbilities { get; set; }
        public int CacheAP { get; set; }
        public int[] AbilityCooldown { get; set; }
        public int[] AbilityActiveDurations { get; set; }
        public int AbilityAmount { get; set; }
        public bool[] AbilityToggle { get; set; }
        public int AbilityToggleVar { get; set; }
        public string Specialization { get; set; }
        public string Mood { get; set; }
        public int MaxLevel { get; set; }
        public int warpUses { get; set; }

        public int CameraOffsetX { get; set; }
        public int CameraOffsetY { get; set; }
        public float CameraX { get; set; }
        public float CameraY { get; set; }
        public float CameraRot { get; set; }
        public bool FixedCamera { get; set; }
        public bool FixedCameraRot { get; set; }
        public bool CameraUpdate { get; set; }

        public string ChatBubbleColour { get; set; }

        public FameCounter FameCounter
        {
            get { return fameCounter; }
        }

        public int[] SlotTypes { get; private set; }
        public Inventory Inventory { get; private set; }

        public int DamageCount = 0; //for bishop and other damage counting specs

        public void Damage(int dmg, int pen, Entity chr)
        {
            try
            {
                if (AbilityActiveDurations[2] != 0 && Specialization == "Light")
                {
                    DamageCount += dmg;
                }
                if (Specialization == "Blood" && AbilityActiveDurations[1] != 0)
                {
                    dmg = dmg / 2;
                    if (chr != null) (chr as Enemy).Damage(this, t, dmg, pen, false, null);
                }
                if (Specialization == "Blood" && AbilityActiveDurations[2] != 0)
                {
                    double totalhealth = Stats[0];
                    double dmgPercentage = HP / totalhealth;
                    dmg = (int)(dmg * dmgPercentage);
                }
                if (HasConditionEffect(ConditionEffects.Paused) ||
                    HasConditionEffect(ConditionEffects.Stasis) ||
                    HasConditionEffect(ConditionEffects.Invincible))
                    return;

                dmg = (int)statsMgr.GetPlayerDamage(dmg, pen, false);

                if (!HasConditionEffect(ConditionEffects.Invulnerable))
                    HP -= dmg;

                UpdateCount++;
                if (Owner != null && chr != null)
                {
                    Owner.BroadcastPacket(new DamagePacket
                    {
                        TargetId = Id,
                        Effects = 0,
                        Damage = (ushort)dmg,
                        Killed = HP <= 0,
                        BulletId = 0,
                        ObjectId = chr.Id
                    }, null);
                }
                else if (Owner != null)
                {
                    Owner.BroadcastPacket(new DamagePacket
                    {
                        TargetId = Id,
                        Effects = 0,
                        Damage = (ushort)dmg,
                        Killed = HP <= 0,
                        BulletId = 0,
                        ObjectId = -1
                    }, null);
                }
                SaveToCharacter();

                string killerName = chr is Player
                    ? chr.Name
                    : chr != null ? (chr.ObjectDesc.DisplayId ?? chr.ObjectDesc.ObjectId) : "Unknown";

                if (HP <= 0 && !Dead)
                {
                    Dead = true;
                    Death(killerName);
                }
            }
            catch (Exception e)
            {
                log.Error("Error while processing playerDamage: ", e);
            }
        }

        protected override void ExportStats(IDictionary<StatsType, object> stats)
        {
            base.ExportStats(stats);
            stats[StatsType.AccountId] = AccountId;

            stats[StatsType.Experience] = Experience - GetLevelExp(Level);
            stats[StatsType.ExperienceGoal] = ExperienceGoal;
            stats[StatsType.Level] = Level;

            stats[StatsType.CurrentFame] = CurrentFame;
            stats[StatsType.Fame] = Fame;
            stats[StatsType.FameGoal] = FameGoal;
            stats[StatsType.Stars] = Stars;

            stats[StatsType.Guild] = Guild;
            stats[StatsType.GuildRank] = GuildRank;

            stats[StatsType.Credits] = Credits;
            stats[StatsType.Silver] = Silver;
            stats[StatsType.NameChosen] = NameChosen ? 1 : 0;
            stats[StatsType.Texture1] = Texture1;
            stats[StatsType.Texture2] = Texture2;
            stats[StatsType.Skin] = Skin;

            stats[StatsType.Glowing] = Glowing;
            stats[StatsType.HP] = HP;
            stats[StatsType.MP] = MP;

            stats[StatsType.InvData0] = (Inventory.Data[0] != null ? Inventory.Data[0].GetJson() : "{}");
            stats[StatsType.InvData1] = (Inventory.Data[1] != null ? Inventory.Data[1].GetJson() : "{}");
            stats[StatsType.InvData2] = (Inventory.Data[2] != null ? Inventory.Data[2].GetJson() : "{}");
            stats[StatsType.InvData3] = (Inventory.Data[3] != null ? Inventory.Data[3].GetJson() : "{}");
            stats[StatsType.InvData4] = (Inventory.Data[4] != null ? Inventory.Data[4].GetJson() : "{}");
            stats[StatsType.InvData5] = (Inventory.Data[5] != null ? Inventory.Data[5].GetJson() : "{}");
            stats[StatsType.InvData6] = (Inventory.Data[6] != null ? Inventory.Data[6].GetJson() : "{}");
            stats[StatsType.InvData7] = (Inventory.Data[7] != null ? Inventory.Data[7].GetJson() : "{}");
            stats[StatsType.InvData8] = (Inventory.Data[8] != null ? Inventory.Data[8].GetJson() : "{}");
            stats[StatsType.InvData9] = (Inventory.Data[9] != null ? Inventory.Data[9].GetJson() : "{}");
            stats[StatsType.InvData10] = (Inventory.Data[10] != null ? Inventory.Data[10].GetJson() : "{}");
            stats[StatsType.InvData11] = (Inventory.Data[11] != null ? Inventory.Data[11].GetJson() : "{}");

            stats[StatsType.Inventory0] = (Inventory[0] != null ? Inventory[0].ObjectType : -1);
            stats[StatsType.Inventory1] = (Inventory[1] != null ? Inventory[1].ObjectType : -1);
            stats[StatsType.Inventory2] = (Inventory[2] != null ? Inventory[2].ObjectType : -1);
            stats[StatsType.Inventory3] = (Inventory[3] != null ? Inventory[3].ObjectType : -1);
            stats[StatsType.Inventory4] = (Inventory[4] != null ? Inventory[4].ObjectType : -1);
            stats[StatsType.Inventory5] = (Inventory[5] != null ? Inventory[5].ObjectType : -1);
            stats[StatsType.Inventory6] = (Inventory[6] != null ? Inventory[6].ObjectType : -1);
            stats[StatsType.Inventory7] = (Inventory[7] != null ? Inventory[7].ObjectType : -1);
            stats[StatsType.Inventory8] = (Inventory[8] != null ? Inventory[8].ObjectType : -1);
            stats[StatsType.Inventory9] = (Inventory[9] != null ? Inventory[9].ObjectType : -1);
            stats[StatsType.Inventory10] = (Inventory[10] != null ? Inventory[10].ObjectType : -1);
            stats[StatsType.Inventory11] = (Inventory[11] != null ? Inventory[11].ObjectType : -1);

            if (Boost == null) CalculateBoost();

            stats[StatsType.MaximumHP] = Stats[0] + Boost[0];
            stats[StatsType.MaximumMP] = Stats[1] + Boost[1];
            stats[StatsType.Attack] = Stats[2] + Boost[2];
            stats[StatsType.Defense] = Stats[3] + Boost[3];
            stats[StatsType.Speed] = Stats[4] + Boost[4];
            stats[StatsType.Vitality] = Stats[5] + Boost[5];
            stats[StatsType.Wisdom] = Stats[6] + Boost[6];
            stats[StatsType.Dexterity] = Stats[7] + Boost[7];
            stats[StatsType.Aptitude] = Stats[8] + Boost[8];
            stats[StatsType.Resilience] = Stats[9] + Boost[9];
            stats[StatsType.Penetration] = Stats[10] + Boost[10];

            if (Owner != null && Owner.Name == "Ocean Trench")
                stats[StatsType.OxygenBar] = OxygenBar;

            stats[StatsType.HPBoost] = Boost[0];
            stats[StatsType.MPBoost] = Boost[1];
            stats[StatsType.AttackBonus] = Boost[2];
            stats[StatsType.DefenseBonus] = Boost[3];
            stats[StatsType.SpeedBonus] = Boost[4];
            stats[StatsType.VitalityBonus] = Boost[5];
            stats[StatsType.WisdomBonus] = Boost[6];
            stats[StatsType.DexterityBonus] = Boost[7];
            stats[StatsType.AptitudeBonus] = Boost[8];
            stats[StatsType.ResilienceBonus] = Boost[9];
            stats[StatsType.PenetrationBonus] = Boost[10];

            stats[StatsType.XpBoost] = XpBoost;

            stats[StatsType.CanNexus] = CanNexus ? 1 : 0;
            stats[StatsType.Party] = Party != null ? Party.ID : -1;
            stats[StatsType.PartyLeader] = Party != null ? (Party.Leader == this ? 1 : 0) : 0;

            stats[StatsType.Effect] = XmlEffect == "" ? UnusualEffects.GetXML(Effect) : XmlEffect;

            stats[StatsType.Ability1] = (Ability[0] != null ? Ability[0].AbilityType : -1);
            stats[StatsType.Ability2] = (Ability[1] != null ? Ability[1].AbilityType : -1);
            stats[StatsType.Ability3] = (Ability[2] != null ? Ability[2].AbilityType : -1);
            stats[StatsType.AbilityCD1] = AbilityCooldown[0];
            stats[StatsType.AbilityCD2] = AbilityCooldown[1];
            stats[StatsType.AbilityCD3] = AbilityCooldown[2];
            stats[StatsType.AbilityAD1] = AbilityActiveDurations[0];
            stats[StatsType.AbilityAD2] = AbilityActiveDurations[1];
            stats[StatsType.AbilityAD3] = AbilityActiveDurations[2];
            stats[StatsType.AbilityToggle] = AbilityToggleVar;
            stats[StatsType.Specialization] = Specialization;
            stats[StatsType.Mood] = Mood;
            stats[StatsType.ChatBubbleColour] = (ChatBubbleColour != null ? ChatBubbleColour : "default");
        }

        public void SaveToCharacter()
        {
            Char chr = client.Character;
            chr.Exp = Experience;
            chr.Level = Level;
            chr.Tex1 = Texture1;
            chr.Tex2 = Texture2;
            chr.Effect = Effect;
            chr.Skin = Skin;
            chr.PermaSkin = PermaSkin ? 1 : 0;
            chr.Pet = (Pet != null ? Pet.ObjectType : -1);
            chr.CurrentFame = Fame;
            chr.HitPoints = HP;
            chr.MagicPoints = MP;
            chr.Equipment = Inventory.Select(_ => _ == null ? (ushort)0xffff : _.ObjectType).ToArray();
            chr.EquipData = Inventory.Data;
            chr.MaxHitPoints = Stats[0];
            chr.MaxMagicPoints = Stats[1];
            chr.Attack = Stats[2];
            chr.Defense = Stats[3];
            chr.Speed = Stats[4];
            chr.Vitality = Stats[5];
            chr.Wisdom = Stats[6];
            chr.Dexterity = Stats[7];
            chr.Aptitude = Stats[8];
            chr.Resilience = Stats[9];
            chr.Penetration = Stats[10];
            chr.XpBoost = XpBoost;
            chr.Floors = Floors;
            chr.Specialization = Specialization;
            chr.Mood = Mood;
            chr.MaxLevel = MaxLevel;
        }

        public void CalculateBoost()
        {
            if (Boost == null)
                Boost = new int[(10 + 1)];

            if (ActivateBoost == null)
            {
                ActivateBoost = new ActivateBoost[(10 + 1)];
                for (int i = 0; i < (10 + 1); i++)
                    ActivateBoost[i] = new ActivateBoost();
            }

            for (int i = 0; i < Boost.Length; i++)
                Boost[i] = 0;

            for (int i = 0; i < 4; i++)
            {
                if (Inventory[i] == null) continue;
                foreach (var b in Inventory[i].StatsBoost)
                {
                    switch ((StatsType)b.Key)
                    {
                        case StatsType.MaximumHP: Boost[0] += b.Value; break;
                        case StatsType.MaximumMP: Boost[1] += b.Value; break;
                        case StatsType.Attack: Boost[2] += b.Value; break;
                        case StatsType.Defense: Boost[3] += b.Value; break;
                        case StatsType.Speed: Boost[4] += b.Value; break;
                        case StatsType.Vitality: Boost[5] += b.Value; break;
                        case StatsType.Wisdom: Boost[6] += b.Value; break;
                        case StatsType.Dexterity: Boost[7] += b.Value; break;
                        case StatsType.Aptitude: Boost[8] += b.Value; break;
                        case StatsType.Resilience: Boost[9] += b.Value; break;
                        case StatsType.Penetration: Boost[10] += b.Value; break;
                    }
                }
            }

            for (int i = 0; i < (10 + 1); i++) // apply activate boosts
                Boost[i] += ActivateBoost[i].GetBoost();
        }

        public override void Init(World owner)
        {
            Dead = false;
            Owner = owner;
            var rand = new Random();
            int x, y;
            do
            {
                x = rand.Next(0, owner.Map.Width);
                y = rand.Next(0, owner.Map.Height);
            } while (owner.Map[x, y].Region != TileRegion.Spawn);
            Move(0.5f, 0.5f);
            tiles = new byte[owner.Map.Width, owner.Map.Height];
            SetInvinciblePeriod();
            base.Init(owner);
            fameCounter = new FameCounter(this);
            if (client.Character.Pet >= 0)
                GivePet((ushort)client.Character.Pet);

            Manager.Data.AddDatabaseOperation(db =>
            {
                Locked = db.GetLockeds(AccountId);
                Ignored = db.GetIgnoreds(AccountId);
            }).ContinueWith(task =>
            {
                SendAccountList(Locked, Client.LOCKED_LIST_ID);
                SendAccountList(Ignored, Client.IGNORED_LIST_ID);
            }, TaskContinuationOptions.NotOnFaulted);

            CanNexus = Owner.AllowNexus;
            UpdateCount++;

            /*WorldTimer pingTimer = null;
            owner.Timers.Add(pingTimer = new WorldTimer(PING_PERIOD, (w, t) =>
            {
                if (Client.Stage == ProtocalStage.Ready)
                {
                    Client.SendPacket(new PingPacket {Serial = pingSerial++});
                    pingTimer.Reset();
                    Manager.Logic.AddPendingAction(_ => w.Timers.Add(pingTimer), PendingPriority.Creation);
                }
            }));*/
        }

        public override void Tick(RealmTime time)
        {
            try
            {
                if (client.Stage == ProtocalStage.Disconnected)
                {
                    Owner.LeaveWorld(this);
                    return;
                }
            }
            catch
            {
            }
            if (!KeepAlive(time)) return;

            if (Boost == null) CalculateBoost();

            t = time;
            CheckTradeTimeout(time);
            TradeTick(time);
            HandleRegen(time);
            HandleQuest(time);
            HandleGround(time);
            HandleEffects(time);
            HandlePoison(time);
            HandleBurn(time);
            HandleDeathMark(time);
            HandleCooldowns(time);
            HandleActives(time); //ability stuff for these three
            HandleToggles(time);

            RegulateParty();
            fameCounter.Tick(time);

            if (CameraUpdate)
            {
                CameraUpdate = false;
                client.SendPacket(new CameraUpdatePacket
                {
                    CameraOffsetX = this.CameraOffsetX,
                    CameraOffsetY = this.CameraOffsetY,
                    CameraPosition = new Position { X = CameraX, Y = CameraY },
                    CameraRot = this.CameraRot,
                    FixedCamera = this.FixedCamera,
                    FixedCameraRot = this.FixedCameraRot
                });
            }

            if (usingShuriken)
            {
                if (MP > 0)
                    MP -= 2;
                else
                {
                    usingShuriken = false;
                    ApplyConditionEffect(new ConditionEffect
                    {
                        Effect = ConditionEffectIndex.Speedy,
                        DurationMS = 0
                    });
                }
            }

            if (ToggleChanged)
            {
                AbilityToggleVar = 0;
                int count;
                for (count = 0; count < 3; count++)
                {
                    AbilityToggleVar += (AbilityToggle[count] ? 1 : 0) << count;
                }
                ToggleChanged = false;
            }
            try
            {
                SendUpdate(time);
            }
            catch (Exception e)
            {
                log.Error(e);
            }

            if (HP <= -1 && !Dead)
            {
                Dead = true;
                Death("Unknown");
                return;
            }

            base.Tick(time);
        }

        private void HandleRegen(RealmTime time)
        {
            if (HP == Stats[0] + Boost[0] || !CanHPRegen())
                vitalityCounter = 0;
            else
            {
                vitalityCounter += statsMgr.GetHPRegen() * time.ElaspedMsDelta / 1000f;
                var regen = (int)vitalityCounter;
                if (regen > 0)
                {
                    HP = Math.Min(Stats[0] + Boost[0], HP + regen);
                    vitalityCounter -= regen;
                    UpdateCount++;
                }
            }

            if (MP == Stats[1] + Boost[1] || !CanMPRegen())
                wisdomCounter = 0;
            else
            {
                wisdomCounter += statsMgr.GetMPRegen() * time.ElaspedMsDelta / 1000f;
                var regen = (int)wisdomCounter;
                if (regen > 0)
                {
                    MP = Math.Min(Stats[1] + Boost[1], MP + regen);
                    wisdomCounter -= regen;
                    UpdateCount++;
                }
            }
        }

        private void HandlePoison(RealmTime time)
        {
            foreach (Poison poison in poisons)
            {
                if (poison.enemy == null || poison.enemy.Owner == null)
                {
                    removepoisons.Add(poison);
                    continue;
                }
                Owner.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Dead,
                    TargetId = poison.enemy.Id,
                    Color = new ARGB(0xffddff00)
                }, null);

                if (poison.count % 10 == 0)
                {
                    int thisDmg;
                    if (poison.remainingDmg < poison.perDmg) thisDmg = poison.remainingDmg;
                    else thisDmg = poison.perDmg;
                    poison.enemy.Damage(this, time, thisDmg, 0, true, null);
                    poison.remainingDmg -= thisDmg;
                    if (poison.remainingDmg <= 0)
                        removepoisons.Add(poison);
                }
                poison.count++;
            }
            foreach (Poison poison in removepoisons)
            {
                poisons.Remove(poison);
            }
            removepoisons.Clear();
        }

        private void HandleBurn(RealmTime time)
        {
            foreach (Burn burn in burns)
            {
                if (burn.enemy == null || burn.enemy.Owner == null)
                {
                    removeburns.Add(burn);
                    continue;
                }
                Owner.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Dead,
                    TargetId = burn.enemy.Id,
                    Color = new ARGB(0xffff5500)
                }, null);

                if (burn.count % 10 == 0)
                {
                    burn.enemy.burning = true;
                    int thisDmg;
                    if (burn.remainingDmg < burn.perDmg) thisDmg = burn.remainingDmg;
                    else thisDmg = burn.perDmg;
                    burn.enemy.Damage(this, time, thisDmg, 0, true, null);
                    burn.remainingDmg -= thisDmg;
                    if (burn.remainingDmg <= 0)
                        removeburns.Add(burn);
                }
                burn.count++;
            }
            foreach (Burn burn in removeburns)
            {
                if (burn.enemy != null)
                {
                    burn.enemy.burning = false;
                }
                burns.Remove(burn);
            }
            removeburns.Clear();
        }

        private void HandleDeathMark(RealmTime time)
        {
            List<Enemy> keys = new List<Enemy>(DeathMarked.Keys);
            foreach (var i in keys)
            {
                DeathMarked[i] = DeathMarked[i] - time.ElaspedMsDelta;
                if (i == null || DeathMarked[i] <= 0)
                {
                    DeathMarked.Remove(i);
                }
            }
        }

        public void Teleport(RealmTime time, int objId)
        {
            if (!TPCooledDown())
            {
                SendError("Too soon to teleport again!");
                return;
            }
            SetTPDisabledPeriod();
            if (Pet != null)
                Pet.Move(X, Y);
            Entity obj = Owner.GetEntity(objId);
            if (obj == null) return;
            Move(obj.X, obj.Y);
            fameCounter.Teleport();
            SetInvinciblePeriod();
            UpdateCount++;
            Owner.BroadcastPacket(new GotoPacket
            {
                ObjectId = Id,
                Position = new Position
                {
                    X = X,
                    Y = Y
                }
            }, null);
            if (!isNotVisible)
                Owner.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Teleport,
                    TargetId = Id,
                    PosA = new Position
                    {
                        X = X,
                        Y = Y
                    },
                    Color = new ARGB(0xFFFFFFFF)
                }, null);
        }

        public override bool HitByProjectile(Projectile projectile, RealmTime time)
        {
            if (projectile.ProjectileOwner is Player ||
                HasConditionEffect(ConditionEffects.Paused) ||
                HasConditionEffect(ConditionEffects.Stasis) ||
                HasConditionEffect(ConditionEffects.Invincible))
                return false;

            return base.HitByProjectile(projectile, time);
        }

        public void Hit(Projectile proj)
        {
            var dmg = (int)statsMgr.GetPlayerDamage(proj.Damage, proj.Penetration, proj.Descriptor.ArmorPiercing);
            if (!HasConditionEffect(ConditionEffects.Invulnerable))
                HP -= dmg;
            ApplyConditionEffect(proj.Descriptor.Effects);
            UpdateCount++;
            Owner.BroadcastPacket(new DamagePacket
            {
                TargetId = Id,
                Effects = HasConditionEffect(ConditionEffects.Invincible) ? 0 : proj.ConditionEffects,
                Damage = (ushort)dmg,
                Killed = HP <= 0,
                BulletId = proj.ProjectileId,
                ObjectId = proj.ProjectileOwner.Self.Id
            }, null);

            string killerName = proj.ProjectileOwner is Player
                ? proj.ProjectileOwner.Self.Name
                : (proj.ProjectileOwner.Self.ObjectDesc.DisplayId ?? proj.ProjectileOwner.Self.ObjectDesc.ObjectId);

            if (HP <= 0)
            {
                HP = client.Character.MaxHitPoints;
                Death(killerName);
            }
        }

        private bool CheckResurrection()
        {
            for (int i = 0; i < 4; i++)
            {
                Item item = Inventory[i];
                if (item == null || !item.Resurrects) continue;

                HP = Stats[0] + Stats[0];
                MP = Stats[1] + Stats[1];
                Inventory[i] = null;
                foreach (Player player in Owner.Players.Values)
                    player.SendInfo(string.Format("{0}'s {1} breaks and {0} disappears", Name, item.ObjectId));

                client.Reconnect(new ReconnectPacket
                {
                    Host = "",
                    Port = 2050,
                    GameId = World.NEXUS_ID,
                    Name = "Nexus",
                    Key = Empty<byte>.Array,
                });
                EntryInvincibleTime += 1000;

                resurrecting = true;
                return true;
            }
            return false;
        }

        public List<string> GetMaxed()
        {
            List<string> maxed = new List<string>();
            foreach (XElement i in Manager.GameData.ObjectTypeToElement[ObjectType].Elements("LevelIncrease"))
            {
                int limit =
                    int.Parse(Manager.GameData.ObjectTypeToElement[ObjectType].Element(i.Value).Attribute("max").Value);
                int idx = StatsManager.StatsNameToIndex(i.Value);
                if (Stats[idx] >= limit)
                    maxed.Add(i.Value);
            }
            return maxed;
        }

        private void GenerateGravestone()
        {
            int maxed = GetMaxed().Count;
            ushort objType;
            int? time;
            switch (maxed)
            {
                case 8:
                    objType = 0x0735;
                    time = null;
                    break;

                case 7:
                    objType = 0x0734;
                    time = null;
                    break;

                case 6:
                    objType = 0x072b;
                    time = null;
                    break;

                case 5:
                    objType = 0x072a;
                    time = null;
                    break;

                case 4:
                    objType = 0x0729;
                    time = null;
                    break;

                case 3:
                    objType = 0x0728;
                    time = null;
                    break;

                case 2:
                    objType = 0x0727;
                    time = null;
                    break;

                case 1:
                    objType = 0x0726;
                    time = null;
                    break;

                default:
                    if (Level <= 1)
                    {
                        objType = 0x0723;
                        time = 30 * 1000;
                    }
                    else if (Level < 20)
                    {
                        objType = 0x0724;
                        time = 60 * 1000;
                    }
                    else
                    {
                        objType = 0x0725;
                        time = 5 * 60 * 1000;
                    }
                    break;
            }
            var obj = new StaticObject(Manager, objType, time, true, time != null, false);
            obj.Move(X, Y);
            obj.Name = Name;
            Owner.EnterWorld(obj);
        }

        public void GivePet(ushort petId)
        {
            if (Pet != null)
                Owner.LeaveWorld(Pet);
            Pet = Resolve(Manager, petId);
            Pet.playerOwner = this;
            Pet.Move(X, Y);
            Pet.isPet = true;
            Owner.EnterWorld(Pet);
        }

        public bool CompareName(string name)
        {
            string rn = name.ToLower();
            if (rn.Split(' ')[0].StartsWith("[") || Name.Split(' ').Length == 1)
                if (Name.ToLower().StartsWith(rn)) return true;
                else return false;
            if (Name.Split(' ')[1].ToLower().StartsWith(rn)) return true;
            return false;
        }

        public string GetNameColor()
        {
            if (client.Account.Rank >= 2)
            {
                return "0xE678CC";
            }
            return "0xFF0000";
        }

        public bool UpdateAbilities()
        {
            int abilsUnlocked = 0;
            int LR = 5;
            for (int c = 0; c < 3; c++)
            {
                LR *= 2;
                if (Level >= LR) abilsUnlocked++;
                else break; //(10, 0) (20, 1) (40, 2)
            }

            XElement xml = Manager.GameData.ObjectTypeToElement[(ushort)client.Character.ObjectType];
            if (abilsUnlocked > 0 && Specialization != "" && xml.Elements("Specialization").Where(_ => (_.Attribute("id").Value == Specialization)).Count() == 1)
            {
                string[] abilities = xml.Elements("Specialization").Where(_ => (_.Attribute("id").Value == Specialization)).ToArray()[0].Value.Split(',');
                for (int i = 0; i < abilsUnlocked; i++)
                    Ability[i] = (abilities.Length - 1 >= i) ? Manager.GameData.Abilities[Manager.GameData.IdToAbilityType[abilities[i].Trim()]] : null;
                RecacheAbilities(Stats[8] + Boost[8]);
                UpdateCount++;
                return true;
            }
            else
            {
                Ability[0] = Manager.GameData.Abilities[Manager.GameData.IdToAbilityType[Manager.GameData.ObjectTypeToElement[(ushort)client.Character.ObjectType].Element("DefaultAbility").Value]];
                Ability[1] = null;
                Ability[2] = null;
                RecacheAbilities(Stats[8] + Boost[8]);
                UpdateCount++;
                return false;
            }
        }

        public void Death(string killer, ObjectDesc desc = null)
        {
            if (client.Stage == ProtocalStage.Disconnected || resurrecting)
                return;
            switch (Owner.Name)
            {
                case "Editor":
                    return;

                case "Nexus":
                    HP = Stats[0] + Stats[0];
                    MP = Stats[1] + Stats[1];
                    client.Disconnect();
                    return;
            }
            if (client.Stage == ProtocalStage.Disconnected || resurrecting)
                return;
            if (CheckResurrection())
                return;
            //if (client.Character.Dead)
            //{
            //    client.Disconnect();
            //    return;
            //}

            GenerateGravestone();
            if (desc != null)
                killer = desc.DisplayId;
            switch (killer)
            {
                case "":
                case "Unknown":
                    break;

                default:
                    Owner.BroadcastPacket(new TextPacket
                    {
                        BubbleTime = 0,
                        Stars = -1,
                        Name = "",
                        Text = ""
                    }, null);
                    break;
            }
            if (killer != "" && killer != "Unknown" && killer != "???")
            {
                Owner.BroadcastPacket(new TextPacket
                {
                    BubbleTime = 0,
                    Stars = -1,
                    Name = "",
                    Text = string.Format("{0} died at level {1}, killed by {2}", Name, Level, killer)
                }, null);
            }

            try
            {
                Manager.Data.AddDatabaseOperation(db =>
                {
                    client.Player.Experience -= (int)(Math.Round(client.Player.Experience * 0.2));
                    client.Character.Deaths++;

                    client.Player.CalculateFame();
                    db.SaveCharacter(client.Account, client.Character);

                    for (var i = 0; i < Level; i++)
                    {
                        if (GetLevelExp(client.Player.Level) > client.Player.Experience)
                        {
                            client.Character.Level--;
                            client.Player.Level--;
                        }
                    }
                    HP = Stats[0] + Stats[0];
                    MP = Stats[1] + Stats[1];
                    client.Player.CalculateFame();
                    client.Player.UpdateCount++;
                    SaveToCharacter();
                }).ContinueWith(task =>
                client.Reconnect(new ReconnectPacket
                {
                    Host = "",
                    Port = 2050,
                    GameId = World.NEXUS_ID,
                    Name = "Nexus",
                    Key = Empty<byte>.Array,
                }));
            }
            catch (Exception e)
            {
                log.Error(e);
            }
        }
    }
}