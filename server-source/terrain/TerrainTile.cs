using System;

namespace terrain
{
    internal enum TerrainType
    {
        None,
        Mountains,
        HighSand,
        HighPlains,
        HighForest,
        MidSand,
        MidPlains,
        MidForest,
        LowSand,
        LowPlains,
        LowForest,
        ShoreSand,
        ShorePlains,
    }

    internal enum TileRegion : byte
    {
        None,
        Spawn,
        Realm_Portals,
        Store_1,
        Store_2,
        Store_3,
        Store_4,
        Store_5,
        Store_6,
        Store_7,
        Store_8,
        Store_9,
        Store_10,
        Store_11,
        Store_12,
        Store_13,
        Store_14,
        Store_15,
        Store_16,
        Store_17,
        Store_18,
        Store_19,
        Store_20,
        Store_21,
        Store_22,
        Store_23,
        Store_24,
        Vault,
        Loot,
        Defender,
        Hallway,
        Enemy,
        Hallway_1,
        Hallway_2,
        Hallway_3,
        Gifting_Chest,
        Item_Spawn_Point,
        Setpiece1,
        Setpiece2,
        Setpiece3
    }

    internal struct TerrainTile : IEquatable<TerrainTile>
    {
        public string Biome;
        public float Elevation;
        public float Moisture;
        public string Name;
        public int PolygonId;
        public TileRegion Region;
        public TerrainType Terrain;
        public ushort TileId;
        public string TileObj;

        public bool Equals(TerrainTile other)
        {
            return
                TileId == other.TileId &&
                TileObj == other.TileObj &&
                Name == other.Name &&
                Terrain == other.Terrain &&
                Region == other.Region;
        }
    }
}