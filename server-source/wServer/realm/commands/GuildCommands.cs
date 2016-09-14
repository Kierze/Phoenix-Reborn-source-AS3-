using System;
using System.Linq;
using wServer.networking.svrPackets;
using wServer.realm.entities;

namespace wServer.realm.commands
{
    internal class GuildChatCommand : Command
    {
        public GuildChatCommand() : base("guild", desc: "send a message to your guild", usage: "<message>")
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (player.Guild != "")
                try
                {
                    var saytext = string.Join(" ", args);
                    if ((from w in player.Manager.Worlds let world = w.Value where w.Key != 0 from i in world.Players.Where(i => i.Value.Guild == player.Guild) select world).Any())
                    {
                        if (saytext.Equals(" ") || saytext == "")
                        {
                            player.SendHelp("Usage: /guild <text>");
                            return false;
                        }
                        player.Manager.Chat.SayGuild(player, saytext.ToSafeText());
                        return true;
                    }
                }
                catch(Exception e)
                {
                    player.SendError(e.ToString());
                    player.SendInfo("Cannot guild chat!");
                    return false;
                }
            else
                player.SendInfo("You need to be in a guild to use guild chat!");
            return false;
        }
    }

    internal class GChatCommand : Command
    {
        public GChatCommand() : base("g", desc: "send a message to your guild", usage: "<message>")
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (player.Guild != "")
                try
                {
                    string saytext = string.Join(" ", args);
                    if ((from w in player.Manager.Worlds let world = w.Value where w.Key != 0 from i in world.Players.Where(i => i.Value.Guild == player.Guild) select world).Any())
                    {
                        if (saytext.Equals(" ") || saytext == "")
                        {
                            player.SendHelp("Usage: /g <text>");
                            return false;
                        }
                        player.Manager.Chat.SayGuild(player, saytext.ToSafeText());
                        return true;
                    }
                }
                catch (Exception e)
                {
                    player.SendError(e.ToString());
                    player.SendInfo("Cannot guild chat!");
                    return false;
                }
            else
                player.SendInfo("You need to be in a guild to use guild chat!");
            return false;
        }
    }

    internal class GuildInviteCommand : Command
    {
        public GuildInviteCommand() : base("invite", desc: "invite a player to your guild", usage: "<player name>")
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            if (player.GuildRank < 20) return false;
            foreach (var e in from i in player.Manager.Worlds where i.Key != 0 from e in i.Value.Players select e)
                if (String.Equals(e.Value.Client.Account.Name, args, StringComparison.CurrentCultureIgnoreCase))
                    if (e.Value.Client.Account.Guild.Name == "")
                    {
                        player.SendInfo(e.Value.Client.Account.Name + " has been invited to your guild!");
                        e.Value.Client.SendPacket(new InvitedToGuildPacket
                        {
                            Name = player.Client.Account.Name,
                            Guild = player.Client.Account.Guild.Name
                        });
                        return true;
                    }
                    else
                    {
                        player.SendError(e.Value.Client.Account.Name + " is already in a guild!");
                        return false;
                    }
                else
                    player.SendInfo("Members and initiates cannot invite!");
            return false;
        }
    }
}