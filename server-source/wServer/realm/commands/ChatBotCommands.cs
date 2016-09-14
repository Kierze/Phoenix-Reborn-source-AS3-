using System;
using System.Text;
using wServer.realm.entities;
using wServer;
using System.Xml.Linq;
using System.Linq;

namespace wServer.realm.commands
{

    internal class ChatBotHelpCommand : ChatBotCommand
    {
        public ChatBotHelpCommand() : base("help", desc: "shows your available commands for HatBot", usage: "<page number>") { }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            ChatBotCommand[] cmds = player.Manager.ChatBotCommands.ChatBotCommands.Values
                .Where(x => x.HasPermission(player))
                .ToArray();

            int curPage = (args != "") ? Convert.ToInt32(args) : 1;
            double maxPage = Math.Floor((double)cmds.Length / 10);

            if (curPage > maxPage + 1)
                curPage = (int)maxPage + 1;
            if (curPage < 1)
                curPage = 1;

            var sb = new StringBuilder(string.Format("{2}'s Available Commands <Page {0}/{1}>: \n", curPage, maxPage + 1, player.Name));

            int y = (curPage - 1) * 10;
            int z = y + 10;

            int commands = cmds.Length;
            if (z > commands)
            {
                z = commands;
            }

            for (int i = y; i < z; i++)
            {
                sb.Append(string.Format("[!{0}{1}]{2}", cmds[i].CommandName, (cmds[i].CommandUsage != "" ? " " + cmds[i].CommandUsage : null), (cmds[i].CommandDesc != "" ? ": " + cmds[i].CommandDesc : null)) + "\n");
            }
            player.SendChatBot(sb.ToString());
            return true;
        }
    }

    internal class FAQCommand : ChatBotCommand
    {
        public FAQCommand() : base("faq", desc: "opens HatBot's FAQ database from specific keywords", usage: "<keyword>", permLevel: 1)
        {

        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            bool worldBroadcast = true;
            string output = string.Format("Sorry, {0}. I don't have data for that keyword! :c", player.Name);

            switch (args.ToLower())
            {
                case "hatbot":
                case "hatbo":
                case "chatbo":
                case "chatbot":
                    output = "Hi! I'm HatBot, the friendly and safe chat bot for Phoenix Realms!";
                    break;

                #region <Game Definitions>
                case "town":
                case "nexus":
                    output = "The Town is the safe place where adventurers can rest, recuperate, and plan ahead!";
                    break;
                case "oryx":
                    output = "Oryx the Mad God is a powerful being who presides over a large section of the Realm. He's really strong, so don't fight him until you're ready!";
                    break;
                case "dungeon":
                    output = "Dungeons are unique, separate areas in the Realm where you may find tougher enemies and untold secrets!";
                    break;
                case "npc":
                case "npcs":
                case "npc's":
                    output = "You can interact with NPCs in the Town or in special areas. They usually have something to say as well as a service they provide!";
                    break;

                #endregion
                #region <Player Class FAQ's>
                case "wizard":
                case "wixard":
                case "wizar":
                case "wiz":
                case "wizzy":
                    output = "The Wizard is a damage-dealer player class who deals damage at long range using powerful spells! Wizards can specialize into: Fire, Frost, Doom.";
                    break;
                case "rogue":
                case "rogu":
                case "rouge":
                    output = "The Rogue is a tactical player class who can deal damage under the safety of invisibility! Rogues can specialize into: Stealth, Banditry, Tracking.";
                    break;
                case "archer":
                case "arche":
                case "arch":
                    output = "The Archer is a damage-dealer player class who deals damage with a long-range bow! Archers can specialize into: Sharpshooting, (assassin archer?), Wartime.";
                    break;
                case "priest":
                case "pries":
                case "healer":
                    output = "The Priest is a support player class who can heal others with light magic! Priests can specialize into: Healing, Light, Martyrdom.";
                    break;
                case "warrior":
                case "warrio":
                case "war":
                case "warr":
                    output = "The Warrior is a fighter player class who deals heavy damage at close range! Warriors can specialize into: (?), (?), (?).";
                    break;
                case "knight":
                case "knigh":
                case "night":
                    output = "The Knight is a fighter player class who can sustain against many attacks with defense! Knights can specialize into: (?), (?), (?).";
                    break;
                case "paladin":
                case "paladi":
                case "pala":
                case "pally":
                    output = "The Paladin is a support player class who can empower allies and fight at close range! Paladins can specialize into: (?), (?), (?).";
                    break;
                case "assassin":
                case "assassi":
                case "asassin":
                case "assasin":
                case "asasin":
                case "ssin":
                case "ass":
                    output = "The Assassin is a tactical player class who deals damage using poison and other stealthy attacks! Assassins can specialize into: (?), (?), (?).";
                    break;
                case "necromancer":
                case "necromance":
                case "necroman":
                case "necro":
                case "lagromancer":
                case "lagromance":
                case "lagroman":
                    output = "The Necromancer is a damage-dealer player class who uses dark forces to combat enemies! Necromancers can specialize into: (?), (?), (?).";
                    break;
                case "huntress":
                case "hunt":
                case "huntres":
                case "hunter":
                case "female archer":
                    output = "The Huntress is a tactical player class who uses traps and the environment to the best advantage! Huntresses can specialize into: (?), (?), (?).";
                    break;
                case "sorcerer":
                case "sorc":
                case "sorcere":
                case "electricman":
                    output = "The Sorcerer is a damage-dealer player class who deals damage using the forces of lightning! Sorcerers can specialize into: (?), (?), (?).";
                    break;
                case "mystic":
                case "mysti":
                case "myst":
                case "mystyc":
                case "mistic":
                case "misty":
                    output = "The Mystic is a support player class who can bind enemies and deter enemies! Mystics can specialize into: (?), (?), (?).";
                    break;
                case "trickster":
                case "trickste":
                case "trix":
                case "trick":
                case "henez":
                    output = "The Trickster is a tactical player class who uses deception to open weaknesses in enemies! Tricksters can specialize into: (?), (?), (?).";
                    break;
                case "ninja":
                case "ninj":
                case "katana guy":
                case "shuriken":
                    output = "The Ninja is a damage-dealer player class who deals damage with high agility and unique weapons! Ninjas can specialize into: (?), (?), (?).";
                    break;
                #endregion
                #region <Others>
                case "new":
                case "newb":
                case "newbie":
                case "noob":
                    output = "Don't worry! By playing more and learning about the game, you'll be able to progress faster and further!";
                    break;

                case "finalboss":
                case "final boss":
                    output = string.Format("Don't be silly, {0}. :3", player.Name);
                    break;
                case "me":
                case "myself":
                case "i":
                    output = string.Format("You are {0}. Hi, {0}!", player.Name);
                    break;
                #endregion

                default:
                    worldBroadcast = false;
                    output = string.Format("Sorry, {0}. I don't have data for that keyword! :c", player.Name);
                    break;
            }
            if (worldBroadcast) player.Manager.Chat.ChatBot(player.Owner, output);
            else player.SendChatBot(output);

            return true;
        }
    }

    internal class RollCommand : ChatBotCommand
    {
        public RollCommand() : base("roll", desc: "rolls a random number using cryptographic RNG", usage: "", permLevel: 1)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            Random rand = new Random();
            int diceNumber = 100;
            int output = -1;
            double percent = 0;
            
            try { diceNumber = Convert.ToInt32(args); }
            catch { diceNumber = 100; }

            if (diceNumber > 0) output = CryptoRandom.Next(0, diceNumber);
            else if (diceNumber < 0)
            {
                output = CryptoRandom.Next(diceNumber, 0);
                player.Manager.Chat.ChatBot(player.Owner, "I'm not sure if a negative-sided die makes sense, but I'll give it a try.");
            }
            else // if diceNumber IS zero
            {
                player.Manager.Chat.ChatBot(player.Owner, string.Format("Silly {0}! There's no such thing as a die without sides!", player.Client.Account.Name));
                return true;
            }

            double prePercent = (int)((output / (double)diceNumber) * 10000);

            for (int e = 1337; (prePercent % 10 == 0) && (prePercent <= 100); e++) //added to remove trailing zeros in the percentage
            {
                prePercent = prePercent / 10;
            }

            percent = prePercent / 100;
            player.Manager.Chat.ChatBot(player.Owner, string.Format("{0} rolled {1} out of {2}. ({3}%)", player.Name, output.ToString(), diceNumber, percent.ToString()));
            return true;
        }
    }

    internal class ListShuffleCommand : ChatBotCommand
    {
        public ListShuffleCommand() : base("shuffle", desc: "randomizes a set list with cryptographic rng", usage: "", permLevel: 1)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            StringBuilder output = new StringBuilder("");
            string[] list = args.Split(' ');
            if (list.Length < 2)
            {
                player.Manager.Chat.ChatBot(player.Owner, string.Format("I need more than one item to shuffle, {0}! Separate each item with a space.", player.Name));
                return false;
            }

            Tools.ArrayShuffleRNG(list);
            Array.Reverse(list);
            foreach (var item in list)
            {
                output.Insert(0, item + " ");
            }

            player.Manager.Chat.ChatBot(player.Owner, string.Format("{0}'s list shuffled to: {1}", player.Name, output.ToString()));
            output.Remove(0, output.Length);
            return true;
        }
    }

    internal class MotivationCommand : ChatBotCommand
    {
        public MotivationCommand() : base("motivation", desc: "brings wise words from the learned", usage: "", permLevel: 1)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            string quote = "";
            string author = "";
            const int quotes = 7;
            int choice = CryptoRandom.Next(1, quotes);

            switch (choice)
            {
                case 1:
                    quote = "Failure will never overtake me if my determination to succeed is strong enough.";
                    author = "Og Mandino";
                    break;
                case 2:
                    quote = "What you do today can improve all your tomorrows.";
                    author = "Ralph Marston";
                    break;
                case 3:
                    quote = "Knowing is not enough; we must apply. Willing is not enough; we must do.";
                    author = "Johann Wolfgang von Goethe";
                    break;
                case 4:
                    quote = "In order to succeed, we must first believe that we can.";
                    author = "Nikos Kazantzakis";
                    break;
                case 5:
                    quote = "JUST DO IT";
                    author = "Shia LaBeouf";
                    break;
                case 6:
                    quote = "When I'm sad and have errors, I'll bake myself a cake. And a pie. And maybe I'll feel better. Oh wait, I can't eat pie or cake.";
                    author = "HatBot";
                    break;
                case 7:
                    quote = "With each scrub you take out some more of the grit.";
                    author = "Anonymous Dishwasher";
                    break;
                default:
                    quote = "When I'm sad and have errors, I'll bake myself a cake. And a pie. And maybe I'll feel better. Oh wait, I can't eat pie or cake.";
                    author = "HatBot";
                    break;
            }
            player.Manager.Chat.ChatBot(player.Owner, string.Format("\"{0}\" -{1}", quote, author));
            return true;
        }
    }

    internal class StatsCommand : ChatBotCommand
    {
        public StatsCommand() : base("stats", desc: "displays your character's stats and their offsets from average", usage: "", permLevel: 1)
        {
        }
        
        protected override bool Process(Player player, RealmTime time, string args)
        {
            uint statNo = 11; //there are 11 stats
            StringBuilder output = new StringBuilder("", 200);
            string[] stats = new string[statNo];
            XElement elem = player.Manager.GameData.ObjectTypeToElement[(ushort)player.Client.Character.ObjectType];
            
            foreach (XElement i in elem.Elements("LevelIncrease"))
            {
                XElement stat = elem.Element(i.Value);
                int idx = StatsManager.StatsNameToIndex(i.Value);
                string posinegative = "";

                int min = int.Parse(i.Attribute("min").Value);
                int max = int.Parse(i.Attribute("max").Value);
                double difference = player.Stats[idx] - Math.Round(int.Parse(stat.Value) + (player.Level * ((double)(min + max) / 2)), 1);
                posinegative = (difference >= 0) ? "+" : "-";
                double strDiff = Math.Abs(difference);
                stats[idx] = string.Format("{0} ({1}{2}) {3}", player.Stats[idx], posinegative, strDiff, i.Value);
            }
            Array.Reverse(stats);
            //I decided to concatenate the entire string in reverse. So we're working backwards.

            for (int e = 0; e < statNo; e++)
            {
                if (e == 0)
                {
                    output.Insert(0, "."); //Ending period or "full stop" for last statement.
                    output.Insert(0, stats[e]); 
                    output.Insert(0, "and "); //english is powerful so i decided to grammar it.
                }
                else
                {
                    output.Insert(0, ", "); //list concatenation and fancy words
                    output.Insert(0, stats[e]); //EX: 34 (+1) Vitality
                }
            }
            output.Insert(0, string.Format("Hi {0}! Your level {1} {2} has: ", player.Client.Account.Name, player.Level, elem.Attribute("id").Value));
            //Displays level and class id at the start of the string. also greets you. what do you want now? serve you coffee? goddammit
            player.SendChatBot(output.ToString());
            return true;
        }
    }

    internal class DeathLossCommand : ChatBotCommand
    {
        public DeathLossCommand() : base("deathloss", desc: "calculates experience and level losses on death", permLevel: 1)
        {
        }

        protected override bool Process(Player player, RealmTime time, string args)
        {
            player.UpdateCount++;
            int expLost = (int)(player.Experience * 0.2);
            int deathLevel = Player.GetLevelFromExp(player.Experience - expLost);

            player.SendChatBot(string.Format("Hi, {0}! Currently, your level is {1} and you have {2} experience.", player.Name, player.Level, player.Experience));
            player.SendChatBot(string.Format("On \"death\", you'll lose {0} experience, bringing you to {1} experience.", expLost, player.Experience - expLost));
            if (deathLevel < player.Level) player.SendChatBot("You'll lose " + (player.Level - deathLevel) + " levels, bringing you to level " + deathLevel);
            else if (deathLevel == player.Level) player.SendChatBot("Despite this, you won't lose any levels.");
            else
            {
                player.SendChatBot("Something went wrong with my calculations. You shouldn't be gaining levels on death...");
                return false;
            }
            return true;
        }
    }
}