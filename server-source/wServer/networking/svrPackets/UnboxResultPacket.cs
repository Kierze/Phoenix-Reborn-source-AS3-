using db;
using System;
namespace wServer.networking.svrPackets
{
    public class UnboxResultPacket : ServerPacket
    {
        public ushort[] Items { get; set; }
        public ItemData[] Datas { get; set; }

        public override PacketID ID
        {
            get { return PacketID.UnboxResult; }
        }

        public override Packet CreateInstance()
        {
            return new UnboxResultPacket();
        }

        protected override void Read(NReader rdr)
        {
            Items = new ushort[rdr.ReadInt16()];
            for (int i = 0; i < Items.Length; i++)
                Items[i] = (ushort)rdr.ReadInt32();


            Datas = new ItemData[rdr.ReadInt16()];
            for (int i = 0; i < Datas.Length; i++)
                Datas[i] = ItemData.CreateData(rdr.ReadUTF());
        }

        protected override void Write(NWriter wtr)
        {
            wtr.Write((short)Items.Length);
            for (int i = 0; i < Items.Length; i++)
                wtr.Write((int)Items[i]);

            wtr.Write((short)Datas.Length);
            for (int i = 0; i < Datas.Length; i++)
            {
                if (Datas[i] != null)
                    wtr.WriteUTF(Datas[i].GetJson());
                else
                    wtr.WriteUTF("{}");
            }
        }
    }
}