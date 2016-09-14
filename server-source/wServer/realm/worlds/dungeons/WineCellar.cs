using wServer.networking;

namespace wServer.realm.worlds
{
    public class WineCellar : World
    {
        public WineCellar()
        {
            Identifier = "WineCellar";
            Name = "Wine Cellar";
            Background = 0;
            SetMusic("dungeon/Wine Cellar");
            AllowTeleport = false;
        }

        protected override void Init()
        {
            base.FromWorldMap(typeof (RealmManager).Assembly.GetManifestResourceStream("wServer.realm.worlds.dungeons.wineCellar.wmap"));
        }
    }
}