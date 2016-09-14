using db;
using log4net;
using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Xml.Linq;
using wServer;
using wServer.networking;
using wServer.networking.svrPackets;
using wServer.realm.entities;
using wServer.realm.setpieces;

namespace wServer.realm.commands
{
    //rank 0 = unable to chat or something
    //rank 1 = player
    //rank 2 = unused (perhaps trusted?)
    //rank 3 = moderator
    //rank 4 = admin
    internal class SpawnCommand : Command
    {
        public SpawnCommand() : base("spawn", desc: "spawns the selected amount of the specified object", usage: "[amount] <object name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var index = args.IndexOf(' ');
            int num;
            var name = args;

            if (args.IndexOf(' ') > 0 && int.TryParse(args.Substring(0, args.IndexOf(' ')), out num)) //multi
                name = args.Substring(index + 1);
            else
                num = 1;

            ushort objType;
            if (!player.Manager.GameData.IdToObjectType.TryGetValue(name, out objType) ||
                !player.Manager.GameData.ObjectDescs.ContainsKey(objType))
            {
                player.SendError("Unknown entity!");
                return false;
            }

            for (var i = 0; i < num; i++)
            {
                var entity = Entity.Resolve(player.Manager, objType);
                entity.Move(player.X, player.Y);
                player.Owner.EnterWorld(entity);
            }
            if (num > 1)
                if (!args.ToLower().EndsWith("s"))
                    player.SendInfo("Sucessfully spawned " + num + " : " +
                                    CultureInfo.CurrentCulture.TextInfo.ToTitleCase(
                                        args.Substring(index + 1).ToLower() + "s"));
                else
                    player.SendInfo("Sucessfully spawned " + num + " : " +
                                    CultureInfo.CurrentCulture.TextInfo.ToTitleCase(
                                        args.Substring(index + 1).ToLower() + "'"));
            else
                player.SendInfo("Sucessfully spawned " + num + " : " +
                                CultureInfo.CurrentCulture.TextInfo.ToTitleCase(args.ToLower()));
            var dir = @"logs";
            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }
            using (var writer = new StreamWriter(@"logs\SpawnLog.log", true))
            {
                writer.WriteLine(player.Name + " spawned " + num + " " + name + " at " + DateTime.Now + " in " + player.Owner.Name);
            }
            return true;
        }
    }

    internal class ToggleEffCommand : Command
    {
        public ToggleEffCommand() : base("eff", desc: "toggles the specified effect on your character", usage: "<effect name>", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            ConditionEffectIndex effect;
            if (!Enum.TryParse(args, true, out effect))
            {
                player.SendError("Invalid effect!");
                return false;
            }
            if ((player.ConditionEffects & (ConditionEffects)(1 << (int)effect)) != 0)
            {
                //remove
                player.ApplyConditionEffect(new ConditionEffect
                {
                    Effect = effect,
                    DurationMS = 0
                });
                player.SendInfo("Sucessfully removed effect : " + args);
            }
            else
            {
                //add
                player.ApplyConditionEffect(new ConditionEffect
                {
                    Effect = effect,
                    DurationMS = -1
                });
                player.SendInfo("Sucessfully added effect : " + args);
            }
            return true;
        }
    }

    internal class GiveCommand : Command
    {
        public GiveCommand() : base("give", desc: "adds the specified item to your inventory", usage: "<item name> [item data]", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var item = args;

            var dataJson = "";
            if (args.IndexOf("{", StringComparison.Ordinal) >= 0 && args.EndsWith("}"))
            {
                item = args.Remove(args.IndexOf("{", StringComparison.Ordinal)).TrimEnd();
                dataJson = args.Substring(args.IndexOf("{", StringComparison.Ordinal));
            }
            ushort objType;
            if (!player.Manager.GameData.IdToObjectType.TryGetValue(item, out objType))
            {
                player.SendError("Unknown item type!");
                return false;
            }
            for (var i = 0; i < player.Inventory.Length; i++)
                if (player.Inventory[i] == null)
                {
                    player.Inventory[i] = player.Manager.GameData.Items[objType];
                    player.Inventory.Data[i] = null; //cleaning it out before working with it

                    if (dataJson != "")
                        player.Inventory.Data[i] = ItemData.CreateData(dataJson); //serializes the itemData

                    if (player.Inventory.Data[i] != null)
                    {
                        player.Inventory.Data[i].GivenItem = true; //if already serialized, just add a tag change
                        player.Inventory.Data[i].Soulbound = true;
                    }
                    else
                        player.Inventory.Data[i] = new ItemData { GivenItem = true, Soulbound = true }; 
                    //otherwise, create the object and add the property

                    player.UpdateCount++;

                    var dir = @"logs";
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }
                    using (var writer = new StreamWriter(@"logs\GiveLog.log", true))
                    {
                        writer.WriteLine(player.Name + " gave themselves a " + item + " at " + DateTime.Now);
                    }
                    player.UpdateCount++;
                    return true;
                }
            player.SendError("Not enough space in inventory!");
            return false;
        }
    }

    internal class LevelCommand : Command
    {
        public LevelCommand() : base("level", desc: "levels you up X amount of times", usage: "<X>", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int oldLevel = player.Level;
            var level = Convert.ToInt32(args);
            if (level <= 0)
            {
                player.SendError("Invalid Level");
                return false;
            }
            var currLevel = player.Level;

            for (var i = 0; i < level; i++)
            {
                if (currLevel <= 89)
                {
                    player.Level++;
                    currLevel++;
                    player.Experience += Player.ExpToLevel[currLevel];
                    player.Manager.GameData.ObjectTypeToElement[player.ObjectType].Elements("LevelIncrease");
                    foreach (XElement e in player.Manager.GameData.ObjectTypeToElement[player.ObjectType].Elements("LevelIncrease"))
                    {
                        var rand = new Random();
                        int min = int.Parse(e.Attribute("min").Value);
                        int max = int.Parse(e.Attribute("max").Value) + 1;
                        int limit =
                            int.Parse(
                                player.Manager.GameData.ObjectTypeToElement[player.ObjectType].Element(e.Value).Attribute("max").Value);
                        int idx = StatsManager.StatsNameToIndex(e.Value);
                        player.Stats[idx] += rand.Next(min, max);
                        if (player.Stats[idx] > limit) player.Stats[idx] = limit;
                    }
                    player.UpdateCount++;
                }
                else
                    player.Level = 90;
                player.UpdateCount++;
            }
            player.HP = player.Stats[0] + player.Boost[0];
            player.MP = player.Stats[1] + player.Boost[1];
            if (player.Level != oldLevel) player.UpdateAbilities();
            player.UpdateCount++;
            return true;
        }
    }

    internal class TpPosCommand : Command
    {
        public TpPosCommand() : base("tpPos", desc: "teleports you to the X and Y location specified", usage: "<x> <y>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            string[] coordinates = args.Split(' ');
            if (coordinates.Length != 2)
            {
                player.SendError("Invalid coordinates!");
                return false;
            }

            int x, y;
            if (!int.TryParse(coordinates[0], out x) ||
                !int.TryParse(coordinates[1], out y))
            {
                player.SendError("Invalid coordinates!");
                return false;
            }

            player.Move(x + 0.5f, y + 0.5f);
            player.SetInvinciblePeriod();
            player.UpdateCount++;
            player.Owner.BroadcastPacket(new GotoPacket
            {
                ObjectId = player.Id,
                Position = new Position
                {
                    X = player.X,
                    Y = player.Y
                }
            }, null);
            return true;
        }
    }

    internal class RemoveWorldCommand : Command
    {
        public RemoveWorldCommand() : base("removeworld", desc: "forces removal of the current world", usage: "", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            bool success = false;
            if (player != null && player.Owner != null)
            {
                foreach (Player p in player.Owner.Players.Values)
                {
                    if (p != null && p.Client != null)
                    {
                        p.Client.Disconnect();
                        p.Client.Save();
                    }
                }
                success = player.Manager.RemoveWorld(player.Owner);
            }
            return success;
        }
    }

    internal class SetpieceCommand : Command
    {
        public SetpieceCommand() : base("setpiece", desc: "generates a structure of selected type", usage: "<structure type>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var piece = (ISetPiece)Activator.CreateInstance(Type.GetType(
                "wServer.realm.setpieces." + args, true, true));
            piece.RenderSetPiece(player.Owner, new IntPoint((int)player.X + 1, (int)player.Y + 1));
            return true;
        }
    }

    internal class DebugCommand : Command
    {
        public DebugCommand() : base("debug", desc: "test command that usually don't stay the same", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            switch (args)
            {
                case "locater":
                    player.Owner.EnterWorld(new Locater(player));
                    return true;
                case "notif":
                    player.Client.SendPacket(new GlobalNotificationPacket
                    {
                        Text = "{\"type\": \"notif\", \"title\": \"Notif Box\", \"text\": \"Notification box that works as it should...\"}"
                    });
                    return true;

                default:
                    player.Client.SendPacket(new GlobalNotificationPacket
                    {
                        Text = "{\"type\": \"notif\", \"title\": \"Notif Box\", \"text\": \"Notification box that works as it should...\"}"
                    });
                    return true;
            }
        }

        private class Locater : Enemy
        {
            private readonly Player _player;

            public Locater(Player player)
                : base(player.Manager, 0x0d5d)
            {
                _player = player;
                Move(player.X, player.Y);
                ApplyConditionEffect(new ConditionEffect
                {
                    Effect = ConditionEffectIndex.Invincible,
                    DurationMS = -1
                });
            }

            public override void Tick(RealmTime time)
            {
                Move(_player.X, _player.Y);
                UpdateCount++;
                base.Tick(time);
            }
        }
    }

    internal class AllOnlineCommand : Command
    {
        public AllOnlineCommand() : base("online", desc: "displays the name, location and IP of all online users", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var sb = new StringBuilder("Users online: \r\n");
            foreach (Client i in player.Manager.Clients.Values)
            {
                if (i.Stage == ProtocalStage.Disconnected || i.Player == null || i.Player.Owner == null) continue;
                sb.AppendFormat("{0}#{1}@{2}\r\n",
                    i.Account.Name,
                    i.Player.Owner.Name,
                    i.Socket.RemoteEndPoint);
            }

            player.SendInfo(sb.ToString());
            return true;
        }
    }

    internal class DespawnAllCommand : Command
    {
        public DespawnAllCommand() : base("despawnAll", desc: "removes all of targeted enemies from current world", usage: "<enemy name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int count = 0;
            foreach (var i in player.Owner.Enemies)
            {
                ObjectDesc desc = i.Value.ObjectDesc;
                if (desc != null &&
                    desc.ObjectId != null &&
                    desc.ObjectId.ContainsIgnoreCase(args))
                {
                    player.Owner.LeaveWorld(i.Value);
                    count++;
                }
            }
            player.SendInfo(string.Format("{0} of type {1} despawned!", count, args));
            return true;
        }
    }

    internal class KillAllCommand : Command
    {
        public KillAllCommand() : base("killAll", desc: "kills all targeted enemies and grants the experience", usage: "<enemy name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int count = 0;
            foreach (var i in player.Owner.Enemies)
            {
                ObjectDesc desc = i.Value.ObjectDesc;
                if (desc != null &&
                    desc.ObjectId != null &&
                    desc.ObjectId.ContainsIgnoreCase(args))
                {
                    i.Value.TrueDamage(player, time, i.Value.HP + 1);
                    count++;
                }
            }
            player.SendInfo(string.Format("{0} of type {1} killed!", count, args));
            return true;
        }
    }

    internal class KickCommand : Command
    {
        public KickCommand() : base("kick", desc: "disconnects the targeted player", usage: "<player name>", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (Client i in player.Manager.Clients.Values)
            {
                if (i.Account.Name.EqualsIgnoreCase(args))
                {
                    i.Disconnect();
                    i.Save();
                    player.SendInfo("Player disconnected!");
                    return true;
                }
            }
            player.SendError(string.Format("Player '{0}' could not be found!", args));
            return false;
        }
    }

    internal class GetQuestCommand : Command
    {
        public GetQuestCommand() : base("getQuest", desc: "shows the X and Y location of your next quest", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (player.Quest == null)
            {
                player.SendError("Player does not have a quest!");
                return false;
            }
            player.SendInfo("Quest location: (" + player.Quest.X + ", " + player.Quest.Y + ")");
            return true;
        }
    }

    internal class OryxSayCommand : Command
    {
        public OryxSayCommand() : base("oryxSay", desc: "displays a message using Oryx the Mad Gods name", usage: "<message>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.Manager.Chat.Oryx(player.Owner, args);
            return true;
        }
    }

    internal class AnnounceCommand : Command
    {
        public AnnounceCommand() : base("announce", desc: "displays a message to all online players", usage: "<message>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.Manager.Chat.Announce(args);
            return true;
        }
    }

    internal class SummonCommand : Command
    {
        public SummonCommand() : base("summon", desc: "summons the targeted player to your location", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (var i in player.Owner.Players)
            {
                if (i.Value.Name.EqualsIgnoreCase(args))
                {
                    i.Value.Teleport(time, player.Id);
                    player.SendInfo("Player summoned!");
                    return true;
                }
            }
            player.SendError(string.Format("Player '{0}' could not be found!", args));
            return false;
        }
    }

    internal class KillPlayerCommand : Command
    {
        public KillPlayerCommand() : base("killPlayer", desc: "kills the targeted player", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (Client i in player.Manager.Clients.Values)
            {
                if (i.Account.Name.EqualsIgnoreCase(args))
                {
                    i.Player.HP = 0;
                    i.Player.Death("Moderator");
                    player.SendInfo("Player killed!");
                    return true;
                }
            }
            player.SendError(string.Format("Player '{0}' could not be found!", args));
            return false;
        }
    }

    internal class VanishCommand : Command
    {
        public VanishCommand() : base("vanish", desc: "hides from all players", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (!player.isNotVisible)
            {
                player.isNotVisible = true;
                player.Owner.PlayersCollision.Remove(player);
                if (player.Pet != null)
                    player.Owner.LeaveWorld(player.Pet);
                player.SendInfo("You're now hidden from all players!");
                return true;
            }
            player.isNotVisible = false;

            player.SendInfo("You're now visible to all players!");
            return true;
        }
    }

    internal class SayCommand : Command
    {
        public SayCommand() : base("say", desc: "displays a notification over your characters head", usage: "<message>", permLevel: 1)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (Client i in player.Manager.Clients.Values)
                i.SendPacket(new NotificationPacket
                {
                    Color = new ARGB(0xff00ff00),
                    ObjectId = player.Id,
                    Text = args
                });
            return true;
        }
    }

    internal class SaveCommand : Command
    {
        public SaveCommand() : base("save", desc: "saves all active players in the server", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (Client i in player.Manager.Clients.Values)
                i.Save();

            player.SendInfo("Saved all Clients!");
            return true;
        }
    }

    internal class DevChatCommand : Command
    {
        public DevChatCommand() : base("d", desc: "writes a message in the developer chat", usage: "<message>", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            foreach (Client client in player.Manager.Clients.Values)
                if (client.Account.Rank > 3)
                    client.Player.SendText("@[DEV] - " + player.Name + "", args);
            return true;
        }
    }
    
    internal class StatCommand : Command
    {
        public StatCommand() : base("stats", desc: "sets the selected amount to the specified stat", usage: "<stat name> <amount>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int index = args.IndexOf(' ');
            int num;
            string stat = args;
            bool hasUpdated = false;

            if (args.IndexOf(' ') > 0 && int.TryParse(args.Substring(index), out num))
                stat = args.Substring(0, args.IndexOf(' '));
            else
            {
                num = 1;
                player.SendHelp("hp, mp, att, def, spd, vit, wis, dex, ap, res");
            }
            switch (stat)
            {
                case "hp":
                case "health":
                    player.Stats[0] = num;
                    hasUpdated = true;
                    player.UpdateCount++;
                    break;

                case "mp":
                case "mana":
                    player.Stats[1] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "att":
                case "attack":
                    player.Stats[2] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "def":
                case "defense":
                    player.Stats[3] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "spd":
                case "speed":
                    player.Stats[4] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "vit":
                case "vitality":
                    player.Stats[5] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "wis":
                case "wisdom":
                    player.Stats[6] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "dex":
                case "dexterity":
                    player.Stats[7] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "ap":
                case "apt":
                case "aptitude":
                    player.Stats[8] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "res":
                case "resilience":
                    player.Stats[9] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                case "all":
                    player.Stats[2] = num;
                    player.Stats[3] = num;
                    player.Stats[4] = num;
                    player.Stats[5] = num;
                    player.Stats[6] = num;
                    player.Stats[7] = num;
                    player.Stats[8] = num;
                    player.Stats[9] = num;
                    player.UpdateCount++;
                    hasUpdated = true;
                    break;

                default:
                    player.SendHelp("Usage: /stats <stat name> <amount>");
                    break;
            }
            if (hasUpdated) { player.SendInfo($"Successfully updated '{stat}'"); return true; }
            return false;
        }
    }

    internal class UpdateCommand : Command
    {
        public UpdateCommand() : base("update", desc: "updates all players information in the current world", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.Manager.Data.AddDatabaseOperation(db =>
            {
                foreach (var i in player.Owner.Players)
                {
                    Account x = db.GetAccount(i.Value.AccountId);
                    Player usr = i.Value;

                    usr.Name = x.Name;
                    usr.Client.Account.Rank = x.Rank;

                    usr.UpdateCount++;
                }
                player.SendInfo("Users Updated.");
            });
            return true;
        }
    }
    
    internal class BanCommand : Command
    {
        public BanCommand() : base("ban", desc: "bans the specified player from the server", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var name = args;

            if (name == "") return false;
            player.Manager.Data.AddDatabaseOperation(db =>
            {
                var cmd = db.CreateQuery();

                cmd.CommandText = "UPDATE accounts SET banned=1 WHERE name=@name LIMIT 1";
                cmd.Parameters.AddWithValue("@name", name);

                if (cmd.ExecuteNonQuery() <= 0) return;
                player.SendInfo("User was successfully banned");
                foreach (var i in player.Manager.Clients.Values.Where(i => i.Account.Name.EqualsIgnoreCase(name)))
                {
                    i.Disconnect();
                }
            });
            return true;
        }
    }

    internal class UnbanCommand : Command
    {
        public UnbanCommand()
            : base("unban", desc: "unbans the specified player from the server", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var name = args;

            if (name == "") return false;
            player.Manager.Data.AddDatabaseOperation(db =>
            {
                var cmd = db.CreateQuery();

                cmd.CommandText = "UPDATE accounts SET banned=0 WHERE name=@name LIMIT 1";
                cmd.Parameters.AddWithValue("@name", name);

                if (cmd.ExecuteNonQuery() <= 0) return;
                player.SendInfo("User was successfully unbanned");
                foreach (var i in player.Manager.Clients.Values.Where(i => i.Account.Name.EqualsIgnoreCase(name)))
                {
                    i.Disconnect();
                }
            });
            return true;
        }
    }

    internal class MuteCommand : Command
    {
        public MuteCommand() : base("mute", desc: "mutes the specified player", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var name = args;

            if (name == "") return false;
            player.Manager.Data.AddDatabaseOperation(db =>
            {
                var cmd = db.CreateQuery();

                cmd.CommandText = "UPDATE accounts SET muted=1 WHERE name=@name LIMIT 1";
                cmd.Parameters.AddWithValue("@name", name);

                if (cmd.ExecuteNonQuery() <= 0) return;
                player.SendInfo("User was successfully muted");
                foreach (var i in player.Owner.Players)
                {
                    var x = db.GetAccount(i.Value.AccountId);
                    var usr = i.Value;

                    usr.Client.Account.Muted = x.Muted;

                    usr.UpdateCount++;
                }
            });
            return true;
        }
    }

    internal class UnmuteCommand : Command
    {
        public UnmuteCommand() : base("unmute", desc: "unmutes the specified player", usage: "<player name>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var name = args;

            if (name == "") return false;
            player.Manager.Data.AddDatabaseOperation(db =>
            {
                var cmd = db.CreateQuery();

                cmd.CommandText = "UPDATE accounts SET muted=0 WHERE name=@name LIMIT 1";
                cmd.Parameters.AddWithValue("@name", name);

                if (cmd.ExecuteNonQuery() <= 0) return;
                player.SendInfo("User was successfully unmuted");
                foreach (var i in player.Owner.Players)
                {
                    var x = db.GetAccount(i.Value.AccountId);
                    var usr = i.Value;

                    usr.Client.Account.Muted = x.Muted;

                    usr.UpdateCount++;
                }
            });
            return true;
        }
    }

    internal class AdminBuffCommand : Command
    {
        public AdminBuffCommand() : base("adminBuff", desc: "updates the item in the specified slot with admin properties", usage: "<slot id>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var index = Convert.ToInt32(args);
            var data = new ItemData
            {
                NamePrefix = "Admin",
                NameColor = 0xFF1297,
                DmgPercentage = 1250,
                FireRate = 2.75,
                Soulbound = true,
                Range = 6,
            };
            if (player.Inventory.Data[index] == null)
                player.Inventory.Data[index] = data;
            else
            {
                player.Inventory.Data[index].NamePrefix = data.NamePrefix;
                player.Inventory.Data[index].NameColor = data.NameColor;
                player.Inventory.Data[index].DmgPercentage = data.DmgPercentage;
                player.Inventory.Data[index].FireRate = data.FireRate;
                player.Inventory.Data[index].Soulbound = data.Soulbound;
                player.Inventory.Data[index].Range = data.Range;
            }
            player.UpdateCount++;
            return true;
        }
    }

    internal class StrangifyCommand : Command
    {
        public StrangifyCommand() : base("strangify", desc: "updates the item in the specified slot with strange properties", usage: "<slot id>", permLevel: 3)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            var index = Convert.ToInt32(args);
            player.SendInfo("Stranged");
            var data = new ItemData
            {
                NamePrefix = "Strange",
                NameColor = 0xFF5A28,
                Strange = true
            };
            if (player.Inventory.Data[index] == null)
                player.Inventory.Data[index] = data;
            else
            {
                player.Inventory.Data[index].NamePrefix = data.NamePrefix;
                player.Inventory.Data[index].NameColor = data.NameColor;
                player.Inventory.Data[index].Strange = data.Strange;
            }
            player.UpdateCount++;
            return true;
        }
    }

    internal class SkinEffectCommand : Command
    {
        public SkinEffectCommand() : base("skinEff", desc: "applies an xml effect to your character", usage: "<xml effect>", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.XmlEffect = args;
            player.UpdateCount++;
            return true;
        }
    }

    internal class CommandCommand : Command
    {
        public CommandCommand() : base("cmd", desc: "executes a command", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.Client.SendPacket(new GetTextInputPacket
            {
                Action = "sendCommand",
                Name = "Type the command"
            });
            return true;
        }
    }

    internal class SetAbilityCommand : Command
    {
        public SetAbilityCommand()
            : base("ability", desc: "set an ability", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            string[] newArgs = args.Split(' ');
            if (newArgs.Length < 2)
                return false;
            var abilitySlot = Convert.ToInt32(newArgs[0]) - 1;
            var abilityName = string.Join(" ", newArgs, 1, newArgs.Length - 1);
            player.AbilityCooldown[abilitySlot] = 0;
            player.Ability[abilitySlot] = player.Manager.GameData.Abilities[player.Manager.GameData.IdToAbilityType[abilityName]];
            player.UpdateCount++;
            return true;
        }
    }

    internal class CameraOffsetCommand : Command
    {
        public CameraOffsetCommand() : base("cam", desc: "offsets your camera", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            string[] numbers = args.Split(' ');
            if (!String.IsNullOrWhiteSpace(args))
            {
                player.CameraOffsetX = Convert.ToInt32(numbers[0]);
                player.CameraOffsetY = Convert.ToInt32(numbers[1]);
                player.CameraUpdate = true;
                player.SendInfo("Camera offset: " + player.CameraOffsetX + ", " + player.CameraOffsetY);
                return true;
            }
            else
            {
                player.SendHelp("Usage: /cam <Offset X> <Offset Y>");
                return false;
            }
        }
    }

    internal class CameraRotateCommand : Command
    {
        public CameraRotateCommand() : base("camrot", desc: "rotates your camera", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (!player.FixedCameraRot)
            {
                player.CameraRot = Convert.ToInt32(args);
                player.FixedCameraRot = true;
                player.CameraUpdate = true;
                player.SendInfo("Camera rotation: " + player.CameraRot + " degrees");
            }
            else
            {
                player.FixedCameraRot = false;
                player.CameraUpdate = true;
                player.SendInfo("Camera rotation set back to normal");
            }
            return true;
        }
    }

    internal class IgnoreCooldowns : Command
    {
        public IgnoreCooldowns() : base("nocooldown", desc: "disables cooldowns", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (player.ignoringcooldowns == true)
            {
                player.ignoringcooldowns = false;
                player.SendInfo("Ignoring cooldowns is off");
            }
            else
            {
                player.ignoringcooldowns = true;
                player.SendInfo("Ignoring cooldowns is on");
            }
            return true;
        }
    }

    internal class FameCommand : Command
    {
        public FameCommand() : base("fame", desc: "Sets your fame to the desired amount", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int amount;
            if (!string.IsNullOrEmpty(args))
            {
                if (int.TryParse(args, out amount))
                {
                    player.Manager.Data.AddDatabaseOperation(db =>
                    {
                        player.CurrentFame = player.Client.Account.Stats.Fame = db.UpdateFame(player.Client.Account, amount);
                        player.UpdateCount++;
                    });
                    return true;
                }
                else
                {
                    player.SendInfo("Must be a valid number");
                }
            }
            else
            {
                player.SendHelp("Usage: /fame <amount>");
                return false;
            }
            return false;
        }
    }

    internal class GoldCommand : Command
    {
        public GoldCommand() : base("gold", desc: "Sets or gives you a set amount of gold", permLevel: 4)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            int amount;
            if (!string.IsNullOrEmpty(args))
            {
                if (int.TryParse(args, out amount))
                {
                    player.Manager.Data.AddDatabaseOperation(db =>
                    {
                        player.Credits = player.Client.Account.Credits = db.UpdateCredit(player.Client.Account, amount);
                    });
                    player.UpdateCount++;
                }
                else
                {
                    player.SendInfo("Must be a valid number");
                }
            }
            else
            {
                player.SendHelp("Usage: /gold <amount>");
                return false;
            }
            return false;
        }
    }
}