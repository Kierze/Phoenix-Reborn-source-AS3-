using System;
using System.Collections.Generic;
using System.Linq;
using wServer.networking.svrPackets;
using wServer.realm.terrain;

namespace wServer.realm.entities
{
    public partial class Player
    {
        public const int RADIUS = 15;
        public const int APPOX_AREA_OF_SIGHT = (int) (Math.PI*RADIUS*RADIUS + 1);

        private readonly HashSet<Entity> clientEntities = new HashSet<Entity>();
        private readonly HashSet<IntPoint> clientStatic = new HashSet<IntPoint>(new IntPointComparer());
        private readonly Dictionary<Entity, int> lastUpdate = new Dictionary<Entity, int>();

        private List<byte[,]> Invisible = new List<Byte[,]>();
        private int mapHeight;
        private int mapWidth;
        private int tickId;

        private IEnumerable<Entity> GetNewEntities()
        {
            foreach (var i in Owner.Players)
            {
                if (clientEntities.Add(i.Value))
                    yield return i.Value;
            }
            foreach (Entity i in Owner.PlayersCollision.HitTest(X, Y, RADIUS))
            {
                if (i is Decoy)
                {
                    if (clientEntities.Add(i))
                        yield return i;
                }
            }
            foreach (Entity i in Owner.EnemiesCollision.HitTest(X, Y, RADIUS))
            {
                if (i is Container)
                {
                    int[] owners = (i as Container).BagOwners;
                    if (owners.Length > 0 && Array.IndexOf(owners, AccountId) == -1) continue;
                }
                if (MathsUtils.DistSqr(i.X, i.Y, X, Y) <= RADIUS*RADIUS)
                {
                    if (clientEntities.Add(i))
                        yield return i;
                }
            }
            if (questEntity != null && clientEntities.Add(questEntity))
                yield return questEntity;
        }

        private IEnumerable<int> GetRemovedEntities()
        {
            foreach (Entity i in clientEntities.Where(i => i is Player))
            {
                if ((i as Player).isNotVisible && i != this)
                {
                    yield return i.Id;
                }
            }
            foreach (Entity i in clientEntities)
            {
                if (i is Player && i.Owner != null) continue;
                if (MathsUtils.DistSqr(i.X, i.Y, X, Y) > RADIUS*RADIUS &&
                    !(i is StaticObject && (i as StaticObject).Static) &&
                    i != questEntity)
                    yield return i.Id;
                else if (i.Owner == null)
                    yield return i.Id;
                if (i is Player)
                    if ((i as Player).isNotVisible && i != this)
                        yield return i.Id;
            }
        }

        private IEnumerable<ObjectDef> GetNewStatics(int _x, int _y)
        {
            var ret = new List<ObjectDef>();
            foreach (IntPoint i in Sight.GetSightCircle(RADIUS))
            {
                int x = i.X + _x;
                int y = i.Y + _y;
                if (x < 0 || x >= mapWidth ||
                    y < 0 || y >= mapHeight) continue;
                WmapTile tile = Owner.Map[x, y];
                if (tile.ObjId != 0 && tile.ObjType != 0 && clientStatic.Add(new IntPoint(x, y)))
                {
                    ObjectDef def = tile.ToDef(x, y);
                    string cls = Manager.GameData.ObjectDescs[tile.ObjType].Class;
                    if (cls == "ConnectedWall" || cls == "CaveWall")
                    {
                        bool hasCon = false;
                        foreach (var s in def.Stats.Stats)
                            if (s.Key == StatsType.ObjectConnection && s.Value != null)
                                hasCon = true;
                        if (!hasCon)
                        {
                            var stats = def.Stats.Stats.ToList();
                            stats.Add(new KeyValuePair<StatsType, object>(StatsType.ObjectConnection, (int)ConnectionComputer.Compute((xx, yy) => Owner.Map[x + xx, y + yy].ObjType == tile.ObjType).Bits));
                            def.Stats.Stats = stats.ToArray();
                        }
                    }
                    ret.Add(def);
                }
            }
            return ret;
        }

        private IEnumerable<IntPoint> GetRemovedStatics(int _x, int _y)
        {
            foreach (IntPoint i in clientStatic)
            {
                int dx = i.X - _x;
                int dy = i.Y - _y;
                WmapTile tile = Owner.Map[i.X, i.Y];
                if (dx*dx + dy*dy > RADIUS*RADIUS ||
                    tile.ObjType == 0)
                {
                    int objId = Owner.Map[i.X, i.Y].ObjId;
                    if (objId != 0)
                        yield return i;
                }
            }
        }

        public void SendUpdate(RealmTime time, int Radius = 15, int aos = (int)(Math.PI * RADIUS * RADIUS + 1))
        {
            mapWidth = Owner.Map.Width;
            mapHeight = Owner.Map.Height;
            Wmap map = Owner.Map;
            aos = (int)(Math.PI * Radius * Radius + 1);

            int _y;
            int _x;
            if(FixedCamera)
            {
                _x = (int) CameraX;
                _y = (int) CameraY;
            }
            else
            {
                _x = (int) X;
                _y = (int) Y;
            }

            var sendEntities = new HashSet<Entity>(GetNewEntities());

            var list = new List<UpdatePacket.TileData>(APPOX_AREA_OF_SIGHT);
            int sent = 0;
            foreach (IntPoint i in Sight.GetSightCircle(Radius))
            {
                int x = i.X + _x;
                int y = i.Y + _y;

                WmapTile tile;

                if (x < 0 || x >= mapWidth ||
                    y < 0 || y >= mapHeight ||
                    map[x, y].TileId == 0xff ||
                    tiles[x, y] >= (tile = map[x, y]).UpdateCount) continue;

                list.Add(new UpdatePacket.TileData
                {
                    X = (short) x,
                    Y = (short) y,
                    Tile = (Tile) tile.TileId
                });
                tiles[x, y] = tile.UpdateCount;
                sent++;
            }
            fameCounter.TileSent(sent);

            int[] dropEntities = GetRemovedEntities().Distinct().ToArray();
            clientEntities.RemoveWhere(_ => Array.IndexOf(dropEntities, _.Id) != -1);

            foreach (Entity i in sendEntities)
                lastUpdate[i] = i.UpdateCount;

            ObjectDef[] newStatics = GetNewStatics(_x, _y).ToArray();
            IntPoint[] removeStatics = GetRemovedStatics(_x, _y).ToArray();
            var removedIds = new List<int>();
            foreach (IntPoint i in removeStatics)
            {
                removedIds.Add(Owner.Map[i.X, i.Y].ObjId);
                clientStatic.Remove(i);
            }

            if (sendEntities.Count > 0 || list.Count > 0 || dropEntities.Length > 0 ||
                newStatics.Length > 0 || removedIds.Count > 0)
            {
                var packet = new UpdatePacket();
                packet.Tiles = list.ToArray();
                packet.NewObjects = sendEntities.Select(_ => _.ToDefinition()).Concat(newStatics).ToArray();
                packet.RemovedObjectIds = dropEntities.Concat(removedIds).ToArray();
                client.SendPacket(packet);
            }
            SendNewTick(time);
        }

        public void SendNewTick(RealmTime time)
        {
            var sendEntities = new List<Entity>();
            foreach (Entity i in clientEntities)
            {
                if (i.UpdateCount > lastUpdate[i])
                {
                    sendEntities.Add(i);
                    lastUpdate[i] = i.UpdateCount;
                }
            }
            if (questEntity != null &&
                (!lastUpdate.ContainsKey(questEntity) || questEntity.UpdateCount > lastUpdate[questEntity]))
            {
                sendEntities.Add(questEntity);
                lastUpdate[questEntity] = questEntity.UpdateCount;
            }
            var p = new NewTickPacket();
            tickId++;
            p.TickId = tickId;
            p.TickTime = time.ElaspedMsDelta;
            p.UpdateStatuses = sendEntities.Select(_ => _.ExportStats()).ToArray();
            client.SendPacket(p);
        }
    }
}