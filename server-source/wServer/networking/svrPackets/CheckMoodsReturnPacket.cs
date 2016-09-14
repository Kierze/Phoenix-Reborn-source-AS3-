using db;

namespace wServer.networking.svrPackets
{
    public class CheckMoodsReturnPacket : ServerPacket
    {
        public bool[] unlockedMoods { get; set; }

        public override PacketID ID
        {
            get { return PacketID.CheckMoodsReturn; }
        }

        public override Packet CreateInstance()
        {
            return new CheckMoodsReturnPacket();
        }

        protected override void Read(NReader rdr)
        {
            unlockedMoods = new bool[Database.MoodNumber];
            for (var m = 0; m < unlockedMoods.Length; m++)
                unlockedMoods[m] = rdr.ReadBoolean();
        }

        protected override void Write(NWriter wtr)
        {
            wtr.Write((short)unlockedMoods.Length);
            foreach (var m in unlockedMoods)
                wtr.Write(m);
        }
    }
}