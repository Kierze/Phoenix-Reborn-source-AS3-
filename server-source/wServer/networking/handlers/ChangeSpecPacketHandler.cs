using wServer.networking.cliPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class ChangeSpecPacketHandler : PacketHandlerBase<ChangeSpecPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.ChangeSpec; }
        }

        protected override void HandlePacket(Client client, ChangeSpecPacket packet)
        {
            client.Manager.Logic.AddPendingAction(t => Handle(client.Player, t, packet));
        }

        private void Handle(Player player, RealmTime time, ChangeSpecPacket packet)
        {
            if (player != null && player.Owner != null && player.Level >= 10 && (player.Specialization == null || player.Specialization == ""))
            {
                player.Specialization = packet.SpecName;
                if (!player.UpdateAbilities()) player.Specialization = null;
            }
        }
    }
}