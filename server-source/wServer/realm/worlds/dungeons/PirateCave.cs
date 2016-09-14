using wServer.networking;

namespace wServer.realm.worlds
{
    public class PirateCave : World
    {
        public PirateCave()
        {
            Identifier = "PirateCave";
            Name = "Pirate Cave";
            Background = 0;
            Difficulty = 1;
            SetMusic("dungeon/Abyss of Demons");
            SetDisposeTime(10 * 1000);
        }

        protected override void Init()
        {
            LoadMap(GeneratorCache.NextPirateCave(Seed));
        }
    }
}