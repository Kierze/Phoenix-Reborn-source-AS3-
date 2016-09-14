namespace wServer.networking.cliPackets
{
    public class ChangeSpecPacket : ClientPacket
    {
        public string SpecName { get; set; }

        public override PacketID ID
        {
            get { return PacketID.ChangeSpec; }
        }

        public override Packet CreateInstance()
        {
            return new ChangeSpecPacket();
        }

        protected override void Read(NReader rdr)
        {
            SpecName = rdr.ReadUTF();
        }

        protected override void Write(NWriter wtr)
        {
            wtr.WriteUTF(SpecName);
        }
    }
}