namespace wServer.realm.worlds
{
    public class Shop : World
    {
        public Shop()
        {
            Id = SHOP_ID;
            Identifier = "Shop";
            Name = "Shop";
            Background = 0;
            Difficulty = 0;
            SetMusic("world/Vault");
        }

        protected override void Init()
        {
            base.FromWorldMap(typeof (RealmManager).Assembly.GetManifestResourceStream("wServer.realm.worlds.friendly.shop.wmap"));
        }
    }
}