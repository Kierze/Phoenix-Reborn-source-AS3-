using wServer.networking.cliPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class ChangeMoodPacketHandler : PacketHandlerBase<ChangeMoodPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.ChangeMood; }
        }

        protected override void HandlePacket(Client client, ChangeMoodPacket packet)
        {
            client.Manager.Logic.AddPendingAction(t => Handle(client.Player, t, packet));
        }

        private void Handle(Player player, RealmTime time, ChangeMoodPacket packet)
        {
            if (player.Owner == null) return;
            player.Mood = packet.MoodName;
        }
    }
}