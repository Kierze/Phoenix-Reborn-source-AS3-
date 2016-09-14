using db;
using wServer.networking.cliPackets;
using wServer.realm;
using wServer.realm.entities;
using wServer.realm.entities.player;

namespace wServer.networking.handlers
{
    internal class UseAbilityPacketHandler : PacketHandlerBase<UseAbilityPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.UseAbility; }
        }

        protected override void HandlePacket(Client client, UseAbilityPacket packet)
        {
            client.Manager.Logic.AddPendingAction(t => Handle(client.Player, t, packet));
        }

        private void Handle(Player player, RealmTime time, UseAbilityPacket packet)
        {
            if (player.Owner == null) return;

            player.UseAbility(time, packet.Ability, packet.Position, player.Stats[8] + player.Boost[8]);
        }
    }
}