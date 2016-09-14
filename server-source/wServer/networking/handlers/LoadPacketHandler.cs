using db;
using wServer.networking.cliPackets;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class LoadPacketHandler : PacketHandlerBase<LoadPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.Load; }
        }

        protected override void HandlePacket(Client client, LoadPacket packet)
        {
            client.Manager.Data.AddDatabaseOperation(db =>
            {
                client.Character = db.LoadCharacter(client.Account, packet.CharacterId);
                if (client.Character != null)
                {
                    
                    
                        World target = client.Manager.Worlds[client.targetWorld];
                        client.SendPacket(new CreateSuccessPacket
                        {
                            CharacterID = client.Character.CharacterId,
                            ObjectID = target.EnterWorld(client.Player = new Player(client))
                        });
                        client.Stage = ProtocalStage.Ready;
                    
                }
                else
                {
                    SendFailure("Failed to load character.");
                    client.Disconnect();
                }
            });
        }
    }
}