namespace wServer.networking.cliPackets
{
    public class ChangeMoodPacket : ClientPacket
    {
        public string MoodName { get; set; }

        public override PacketID ID
        {
            get { return PacketID.ChangeMood; }
        }

        public override Packet CreateInstance()
        {
            return new ChangeMoodPacket();
        }

        protected override void Read(NReader rdr)
        {
            MoodName = rdr.ReadUTF();
        }

        protected override void Write(NWriter wtr)
        {
            wtr.WriteUTF(MoodName);
        }
    }
}