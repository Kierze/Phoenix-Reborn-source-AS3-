namespace wServer.networking.cliPackets
{
    public class CheckMoodsPacket : ClientPacket
    {
        public override PacketID ID
        {
            get { return PacketID.CheckMoods; }
        }

        public override Packet CreateInstance()
        {
            return new CheckMoodsPacket();
        }

        protected override void Read(NReader rdr)
        {
        }

        protected override void Write(NWriter wtr)
        {
        }
    }
}