namespace wServer.networking.cliPackets
{
    public class UseAbilityPacket : ClientPacket
    {
        public int Time { get; set; }
        public int Ability { get; set; }
        public Position Position { get; set; }

        public override PacketID ID
        {
            get { return PacketID.UseAbility; }
        }

        public override Packet CreateInstance()
        {
            return new UseAbilityPacket();
        }

        protected override void Read(NReader rdr)
        {
            Time = rdr.ReadInt32();
            Ability = rdr.ReadInt32();
            Position = Position.Read(rdr);
        }

        protected override void Write(NWriter wtr)
        {
            wtr.Write(Time);
            wtr.Write(Ability);
            Position.Write(wtr);
        }
    }
}