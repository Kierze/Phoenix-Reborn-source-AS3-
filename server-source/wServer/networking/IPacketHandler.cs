using log4net;
using System;
using System.Collections.Generic;
using wServer.networking.cliPackets;
using wServer.networking.svrPackets;
using wServer.realm;
using FailurePacket = wServer.networking.svrPackets.FailurePacket;

namespace wServer.networking
{
    internal interface IPacketHandler
    {
        PacketID ID { get; }
        void Handle(Client client, ClientPacket packet);
    }

    internal abstract class PacketHandlerBase<T> : IPacketHandler where T : ClientPacket
    {
        protected ILog log;
        private Client client;

        public abstract PacketID ID { get; }

        public void Handle(Client client, ClientPacket packet)
        {
            this.client = client;
            HandlePacket(client, (T) packet);
        }

        protected abstract void HandlePacket(Client client, T packet);

        protected void SendFailure(string text, int type = 0)
        {
            client.SendPacket(new FailurePacket {Message = text, ErrorId = type});
        }

        protected void SendNotification(string text, int type = 0)
        {
            client.SendPacket(new GlobalNotificationPacket {Text = text, Type = type});
        }
    }

    internal class PacketHandlers
    {
        public static Dictionary<PacketID, IPacketHandler> Handlers = new Dictionary<PacketID, IPacketHandler>();

        static PacketHandlers()
        {
            foreach (Type i in typeof (Packet).Assembly.GetTypes())
                if (typeof (IPacketHandler).IsAssignableFrom(i) &&
                    !i.IsAbstract && !i.IsInterface)
                {
                    var pkt = (IPacketHandler) Activator.CreateInstance(i);
                    Handlers.Add(pkt.ID, pkt);
                }
        }
    }
}