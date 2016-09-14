package GameAssets.EmbedDatas
{
    public class DataEmbeds
    {
        public static const TilesDatas:Array = [new Ground()];

        public static const ObjectDatas:Array = [ new Environment(), new Projectile(), new PlayerSkin(), new PirateCave(), new TutorialKitchen(), new SpiderDen(), new ForbiddenJungle(), new SnakePit(), new SpriteWorld(), new UndeadLair(), new AbyssOfDemons(), new MadLab(), new ManorOfTheImmortals(), new DavyJonesLocker(), new OceanTrench(), new TombOfTheAncients(), new WoodlandLabyrinth(), new OryxCastle(), new OryxChamber(), new WineCellar(), new AprilFoolsEvent(), new Beachzone(), new SeraphsTower(), new Treasure(), new Tutorial(), new Cloth(), new Crate(), new DrakeEgg(), new DungeonUntiered(), new Dye(), new Essence(), new FunctionConsumable(), new garbage(), new PortalKey(), new LimitedEvent(), new RealmItem(), new RecoveryConsumable(), new SkinItem(), new StatConsumable(), new TieredEquip(), new FunctionalObject(), new garbageEntity(), new itemEntity(), new TownNPCData(), new Regions(), new PlayerClass(), new PlayerPet(), new RealmBoss(), new RealmSuperBoss(), new RealmBeach(), new RealmLowland(), new RealmMidland(), new RealmHighland(), new RealmMountain()];

        public static const RegionDatas:Array = [new TileRegions()];

        public static const TutorialUIData:XML = XML(new TutorialUI());

        public static const PlayerAbilityDatas:XML = XML(new PlayerAbility());

        public static const PlayerCharMoodDatas:XML = XML (new PlayerCharMood());

        public static const TalkSpriteDatas:XML = XML(new TalkSpritesData());
    }
}

