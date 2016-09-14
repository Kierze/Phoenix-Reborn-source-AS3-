using db;
using MySql.Data.MySqlClient;
using wServer.networking.cliPackets;
using wServer.networking.svrPackets;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class CreatePacketHandler : PacketHandlerBase<CreatePacket>
    {
        public override PacketID ID
        {
            get { return PacketID.Create; }
        }

        protected override void HandlePacket(Client client, CreatePacket packet)
        {
            client.Manager.Data.AddDatabaseOperation(db =>
            {
                int nextCharId = 1;
                nextCharId = db.GetNextCharID(client.Account);
                MySqlCommand cmd = db.CreateQuery();
                cmd.CommandText = "SELECT maxCharSlot FROM accounts WHERE id=@accId;";
                cmd.Parameters.AddWithValue("@accId", client.Account.AccountId);
                var maxChar = (int)cmd.ExecuteScalar();

                cmd = db.CreateQuery();
                cmd.CommandText = "SELECT COUNT(id) FROM characters WHERE accId=@accId;";
                cmd.Parameters.AddWithValue("@accId", client.Account.AccountId);
                var currChar = (int)(long)cmd.ExecuteScalar();

                if (currChar >= maxChar)
                {
                    SendFailure("Not enough character slots.");
                    client.Disconnect();
                    return;
                }

                if (!client.Manager.GameData.ObjectDescs[packet.ObjectType].Player || (client.Manager.GameData.ObjectDescs[packet.ObjectType].ClassInDev && !client.Account.Admin))
                {
                    SendFailure("Failed to create character.");
                    client.Disconnect();
                    return;
                }

                client.Character = Database.CreateCharacter(client.Manager.GameData, packet.ObjectType, nextCharId);

                int[] stats =
                {
                    client.Character.MaxHitPoints,
                    client.Character.MaxMagicPoints,
                    client.Character.Attack,
                    client.Character.Defense,
                    client.Character.Speed,
                    client.Character.Dexterity,
                    client.Character.Vitality,
                    client.Character.Wisdom,
                    client.Character.Aptitude,
                    client.Character.Resilience,
                    client.Character.Penetration
                };

                bool ok = true;
                cmd = db.CreateQuery();
                cmd.CommandText =
                    @"INSERT INTO characters(accId, charId, charType, level, exp, fame, items, itemDatas, hp, mp, stats, deaths, pet, mood, maxLevel)
 VALUES(@accId, @charId, @charType, 1, 0, 0, @items, @itemDatas, 100, 100, @stats, @deaths, -1, @mood, @maxLevel);";
                cmd.Parameters.AddWithValue("@accId", client.Account.AccountId);
                cmd.Parameters.AddWithValue("@charId", nextCharId);
                cmd.Parameters.AddWithValue("@charType", packet.ObjectType);
                cmd.Parameters.AddWithValue("@items", client.Character._Equipment);
                cmd.Parameters.AddWithValue("@itemDatas", client.Character._EquipData);
                cmd.Parameters.AddWithValue("@stats", Utils.GetCommaSepString(stats));
                cmd.Parameters.AddWithValue("@mood", client.Character.Mood);
                cmd.Parameters.AddWithValue("@deaths", client.Character.Deaths);
                cmd.Parameters.AddWithValue("@maxLevel", client.Character.MaxLevel);
                int v = cmd.ExecuteNonQuery();
                ok = v > 0;

                if (ok)
                {
                    World target = client.Manager.Worlds[client.targetWorld];
                    client.SendPacket(new CreateSuccessPacket
                    {
                        CharacterID = client.Character.CharacterId,
                        ObjectID = target.EnterWorld(client.Player = new Player(client))
                    });
                    client.Stage = ProtocalStage.Ready;
                }
                else
                {
                    SendFailure("Failed to create character.");
                    client.Disconnect();
                }
            });
        }
    }
}