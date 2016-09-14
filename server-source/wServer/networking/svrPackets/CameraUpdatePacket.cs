namespace wServer.networking.svrPackets
{
    public class CameraUpdatePacket : ServerPacket
    {
        public int CameraOffsetX { get; set; }
        public int CameraOffsetY { get; set; }
        public Position CameraPosition { get; set; }
        public float CameraRot { get; set; }
        public bool FixedCamera { get; set; }
        public bool FixedCameraRot { get; set; }

        public override PacketID ID
        {
            get { return PacketID.CameraUpdate; }
        }

        public override Packet CreateInstance()
        {
            return new CameraUpdatePacket();
        }

        protected override void Read(NReader rdr)
        {
            CameraOffsetX = rdr.ReadInt32();
            CameraOffsetY = rdr.ReadInt32();
            CameraPosition = Position.Read(rdr);
            CameraRot = rdr.ReadSingle();
            FixedCamera = rdr.ReadBoolean();
            FixedCameraRot = rdr.ReadBoolean();
        }

        protected override void Write(NWriter wtr)
        {
            wtr.Write(CameraOffsetX);
            wtr.Write(CameraOffsetY);
            CameraPosition.Write(wtr);
            wtr.Write(CameraRot);
            wtr.Write(FixedCamera);
            wtr.Write(FixedCameraRot);
        }
    }
}