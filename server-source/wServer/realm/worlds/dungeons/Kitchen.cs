namespace wServer.realm.worlds
{
    public class Kitchen : World
    {
        public Kitchen()
        {
            Identifier = "TutorialKitchen";
            Name = "Kitchen";
            Background = 0;
            Difficulty = 1;
            SetMusic("dungeon/Undead Lair");
        }

        protected override void Init()
        {
            base.FromWorldMap(
                typeof (RealmManager).Assembly.GetManifestResourceStream("wServer.realm.worlds.dungeons.kitchen.wmap"));
        }
    }
}