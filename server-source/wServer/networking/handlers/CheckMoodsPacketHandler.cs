using System.Threading.Tasks;
using wServer.networking.cliPackets;
using wServer.networking.svrPackets;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class CheckMoodsPacketHandler : PacketHandlerBase<CheckMoodsPacket>
    {
        public override PacketID ID
        {
            get { return PacketID.CheckMoods; }
        }

        protected override void HandlePacket(Client client, CheckMoodsPacket packet)
        {
            client.Manager.Data.AddDatabaseOperation(db => db.UpdateUnlockedMoods(client.Account))
                .ContinueWith(task => client.Manager.Logic.AddPendingAction(t => Handle(client.Player)), TaskContinuationOptions.NotOnFaulted);
        }

        private void Handle(Player player)
        {
            player.Client.SendPacket(new CheckMoodsReturnPacket
            {
                unlockedMoods = player.Client.Account.UnlockedMoods
            });
        }
    }
}