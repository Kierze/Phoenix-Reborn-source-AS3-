using System;
using db;
using wServer.networking.cliPackets;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.worlds;

namespace wServer.networking.handlers
{
    internal class HelloPacketHandler : PacketHandlerBase<HelloPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.Hello; }
        }

        protected override void HandlePacket(Client client, HelloPacket packet)
        {
            client.Manager.Data.AddDatabaseOperation(db =>
            {
                Account acc = db.Verify(packet.GUID, packet.Password);
                if (packet.BuildVersion != client.Version)
                {
                    SendFailure(client.Version, 4);
                    return;
                }
                if (acc == null)
                {
                    SendFailure("Invalid account.");
                    client.Disconnect();
                }
                else
                {
                    if (acc.isGuest)
                    {
                        SendFailure("Guests have been disabled, Please register in order to play.", 7);
                        return;
                    }
                    if (packet.Copyright != client.Copyright)
                    {
                        SendFailure("Invalid Game Client.");
                        client.Disconnect();
                    }
                    if (!acc.VerifiedEmail)
                    {
                        SendFailure("Account is not verified.");
                        client.Disconnect();
                    }
                    if (client.Manager.IsUserOnline(client, acc))
                    {
                        SendFailure("Account in use. (" + client.Manager.TimeOut + " seconds until timeout)");
                        client.Disconnect();
                    }
                    client.Account = acc;
                    if (!client.Manager.TryConnect(client))
                    {
                        client.Account = null;
                        SendFailure("Failed to Connect.");
                        client.Disconnect();
                    }
                    else
                    {
                        World world = client.Manager.GetWorld(packet.GameId);
                        if (world == null)
                        {
                            SendFailure("Invalid world.");
                            client.Disconnect();
                            return;
                        }
                            
                        if (world.Id == -6)
                        {
                            if (client.Account.Admin)
                                (world as Test).LoadJson(packet.MapInfo);
                            else
                                SendFailure("Account is not Admin!");
                        }
                        else if (world.IsLimbo)
                            world = world.GetInstance(client);

                        uint seed = (uint) ((long) Environment.TickCount*packet.GUID.GetHashCode())%uint.MaxValue;
                        client.Random = new wRandom(seed);
                        client.targetWorld = world.Id;
                        client.SendPacket(new MapInfoPacket
                        {
                            Width = world.Map.Width,
                            Height = world.Map.Height,
                            Name = world.Name,
                            ConMessage = world.ConMessage,
                            Seed = seed,
                            Background = world.Background,
                            Difficulty = world.Difficulty,
                            AllowTeleport = world.AllowTeleport,
                            ShowDisplays = world.ShowDisplays,
                            Music = world.GetMusic(client.Random),
                            ClientXML = client.Manager.GameData.AdditionXml,
                            ExtraXML = world.ExtraXML
                        });
                        client.Stage = ProtocalStage.Handshaked;
                    }
                }
            });
        }
    }
}