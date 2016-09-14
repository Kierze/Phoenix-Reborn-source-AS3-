#region

using System;
using System.Collections.Generic;

#endregion

namespace wServer.realm.setpieces
{
    internal class Hermit : ISetPiece
    {
        private static readonly string DarkGrass = "Dark Grass";
        private static readonly string Water = "Shallow Water";
        private static readonly string Pillar = "Grey Pillar";
        private static readonly string BrokenPillar = "Broken Grey Pillar";
        private static readonly string WaterDeep = "Dark Water";
        private static readonly string Flower = "Jungle Ground Flowers";
        private static readonly string Sand = "Dark Sand";


        private readonly Random rand = new Random();

        public int Size
        {
            get { return 30; }
        }

        public void RenderSetPiece(World world, IntPoint pos)
        {
            var DarkGrassradiu = 14;
            var sandRadius = 12;
            var waterRadius = 9;
            var deepWaterRadius = 4f;

            var border = new List<IntPoint>();

            const int bas = 17;
            var o = new int[Size, Size];
            var t = new int[Size, Size];


            for (var x = 0; x < Size; x++) //Flooring
                for (var y = 0; y < Size; y++)
                {
                    var dx = x - (Size / 2.0);
                    var dy = y - (Size / 2.0);
                    var r = Math.Sqrt(dx * dx + dy * dy) + rand.NextDouble() * 4 - 2;
                    if (r <= DarkGrassradiu)
                        t[x, y] = 1;
                }

            for (var y = 0; y < Size; y++) //Outer
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - (Size / 2.0);
                    var dy = y - (Size / 2.0);
                    var r = Math.Sqrt(dx * dx + dy * dy);
                    if (r <= sandRadius)
                        t[x, y] = 2;
                }
            for (var y = 0; y < Size; y++) //Water
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - (Size / 2.0);
                    var dy = y - (Size / 2.0);
                    var r = Math.Sqrt(dx * dx + dy * dy);
                    if (r <= waterRadius)
                    {
                        t[x, y] = 3;
                    }
                }


            for (var y = 0; y < Size; y++) //Deep Water
                for (var x = 0; x < Size; x++)
                {
                    var dx = x - (Size / 2.0);
                    var dy = y - (Size / 2.0);
                    var r = Math.Sqrt(dx * dx + dy * dy);
                    if (r <= deepWaterRadius)
                    {
                        t[x, y] = 4;
                    }
                }
            for (var x = 0; x < Size; x++) //Plants
                for (var y = 0; y < Size; y++)
                {
                    if (((x > 5 && x < bas) || (x < Size - 5 && x > Size - bas) ||
                         (y > 5 && y < bas) || (y < Size - 5 && y > Size - bas)) &&
                        o[x, y] == 0 && t[x, y] == 1)
                    {
                        var r = rand.NextDouble();
                        if (r > 0.6) //0.4
                            o[x, y] = 4;
                        else if (r > 0.35) //0.25
                            o[x, y] = 5;
                        else if (r > 0.33) //0.02
                            o[x, y] = 6;
                    }
                }

            XmlData dat = world.Manager.GameData;
            for (var x = 0; x < Size; x++)
                for (var y = 0; y < Size; y++)
                {
                    if (t[x, y] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[DarkGrass];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (t[x, y] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[Sand];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (t[x, y] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[Water];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (t[x, y] == 4)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[WaterDeep];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (o[x, y] == 5)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.ObjType = dat.IdToObjectType[Flower];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (t[x, y] == 6)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[BrokenPillar];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (t[x, y] == 7)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType[Pillar];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                }
            var hermit = Entity.Resolve(world.Manager, "Hermit God");

            hermit.Move(pos.X + 15.5f, pos.Y + 15.5f);
            world.EnterWorld(hermit);
        }
    }
}