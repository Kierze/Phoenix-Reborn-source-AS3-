using wServer.logic.behaviors;
using wServer.logic.transitions;
using wServer.logic.loot;


namespace wServer.logic
{
    partial class BehaviorDb
    {
        private _ ForbiddenJungle = () => Behav()
            .Init("Great Coil Snake",
                new State(
                    new Prioritize(
                        new StayCloseToSpawn(0.8, 5),
                        new Wander(0.4)
                    ),
                    new State("Waiting",
                        new PlayerWithinTransition(15, "Attacking")
                    ),
                    new State("Attacking",
                        new Shoot(10, projectileIndex: 0, coolDown: 700, coolDownOffset: 600),
                        new Shoot(10, 10, 36, 1, coolDown: 2000),
                        new TossObject("Great Snake Egg", 4, 0, 5000, coolDownOffset: 0),
                        new TossObject("Great Snake Egg", 4, 90, 5000, 600),
                        new TossObject("Great Snake Egg", 4, 180, 5000, 1200),
                        new TossObject("Great Snake Egg", 4, 270, 5000, 1800),
                        new NoPlayerWithinTransition(30, "Waiting")
                    )
                )
            )
            .Init("Jungle Fire",
                new State(
                     new State("Shoot",
                         new Shoot(6, count:1, projectileIndex:1,coolDown:140),
                         new TimedTransition(1200,"ShootDelay")
                     ),
                     new State("ShootDelay",
                         new TimedTransition(800, "Shoot")
                    )
                )
            )
           .Init("Totem Spirit",
                new State(
                     new State("Shoot",
                         new Wander(0.3),
                         new Shoot(6, count: 1, coolDown: 660),
                         new Shoot(6, count: 2, coolDown: 1780)
                     )
                )
            )
           .Init("Jungle Totem",
                new State(
                     new State("Shoot",
                         new Shoot(6, count: 9,shootAngle:20, coolDown: 2900),
                         new Spawn("Totem Spirit",maxChildren:5),
                         new PlayerWithinTransition(6,"Spawn")
                     ),
                     new State("Spawn",
                         new Shoot(6, count: 9, shootAngle: 20, coolDown: 2900),
                         new Spawn("Totem Spirit",maxChildren:100,initialSpawn:0.001,coolDown:12000)
                     )
                )
            )
            .Init("Mask Shaman",
                new State(
                    new State("Waiting",
                        new Orbit(0.1,target:"Jungle Fire", radius:2),
                        new EntityNotExistsTransition("Jungle Fire",6, "Attacking")
                    ),
                    new State("Attacking",
                        new Charge(0.3, range:1,coolDown: 400),
                        new Shoot(10,count:9,shootAngle:40, projectileIndex: 0, coolDown: 700, coolDownOffset:600)
                    )
                )
            )
            .Init("Mask Warrior",
                new State(
                    new State("Waiting",
                        new Orbit(0.1,target:"Jungle Fire", radius:2),
                        new PlayerWithinTransition(6,"Shoot")
                    ),
                    new State("Shoot",
                        new Charge(0.3, range:1,coolDown: 400),
                        new Shoot(3, count:8,shootAngle:45, coolDown:500)
                    )
                )
            )
            .Init("Mask Hunter",
                new State(
                    new State("Waiting",
                        new Orbit(0.1, target: "Jungle Fire", radius: 2),
                        new PlayerWithinTransition(5, "Shoot")
                    ),
                    new State("Shoot",
                        new Charge(0.3, range: 1, coolDown: 400),
                        new Shoot(6, count: 1, coolDown: 300),
                        new TimedTransition(600, "ShootDelay")
                    ),
                    new State("ShootDelay",
                        new Charge(0.3, range: 1, coolDown: 400),
                        new TimedTransition(500, "Shoot")
                    )
                )
            )
            .Init("Basilisk Baby",
                new State(
                    new State("Si",
                        new Charge(1.6, range: 1),
                        new PlayerWithinTransition(2,"Find")
                    ),
                    new State("Find",
                        new Orbit(0.4,2),
                        new Shoot(6, count: 1, coolDown: 300),
                        new TimedTransition(600, "ShootDelay"),
                        new NoPlayerWithinTransition(3,"Si")
                    ),
                    new State("ShootDelay",
                        new Orbit(0.4, 2),
                        new TimedTransition(340, "Find")
                    )
                )
            )
            .Init("Basilisk",
                new State(
                    new State("Si",
                        new Spawn("Basilisk Baby", maxChildren: 2, coolDown: 22000),
                        new Charge(1.6, range: 1),
                        new PlayerWithinTransition(2, "Find")
                    ),
                    new State("Find",
                        new Orbit(0.4, 2),
                        new Shoot(1, count: 1, projectileIndex: 0, coolDown: 300),
                        new Shoot(4, count: 2,shootAngle:5,projectileIndex:1, coolDown: 300),
                        new Shoot(5, count: 3, shootAngle: 5, projectileIndex: 2, coolDown: 300),
                        new Shoot(5, count: 4, shootAngle: 5, projectileIndex: 3, coolDown: 300),
                        new TimedTransition(600, "ShootDelay"),
                        new NoPlayerWithinTransition(3, "Si")
                    ),
                    new State("ShootDelay",
                        new Orbit(0.4, 2),
                        new TimedTransition(340, "Find")
                    )
                )
            )
            .Init("Great Snake Egg",
                new State(
                    new TransformOnDeath("Great Temple Snake", 1, 2),
                    new State("Wait",
                        new TimedTransition(2500, "Explode"),
                        new PlayerWithinTransition(2, "Explode")
                    ),
                    new State("Explode",
                        new Suicide()
                    )
                )
            )
            .Init("Boss Totem",
                new State(
                    new State("Check1",
                        new EntityNotExistsTransition("Mixcoatl the Masked God",800,"Check")
                    ),
                    new State("Check",
                        new EntityNotExistsTransition("Mixcoatl Part 1",800,"Shoot")
                    ),
                    new State("Shoot",
                        new Shoot(6, count:8, fixedAngle:45, coolDown:400),
                        new EntityNotExistsTransition("Mixcoatl the Masked God",800,"off")
                    ),
                    new State("off",
                        new Flash(0xffff6666, 1, 1)
                    )
                )
            )
            .Init("Mixcoatl Part 1",
                new State(
                    new Prioritize(
                        new StayCloseToSpawn(0.1, 1),
                        new Wander(0.1)
                    ),
                    new State("Wait",
                        new HpLessTransition(0.9999, "Phase1")
                    ),
                    new State("Phase1",
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Shoot(7, count:1, projectileIndex:2, coolDown:200),
                        new TimedTransition(4000,"Phase2")
                    ),
                    new State("Phase2",
                        new SetAltTexture(3),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 40, coolDown: 200),
                        new HpLessTransition(0.50, "Transform"),
                        new TimedTransition(200,"1")
                    ),
                    new State("1",
                        new StayCloseToSpawn(1),
                        new SetAltTexture(4),
                        new Shoot(7, count:3, projectileIndex:1,shootAngle:20, fixedAngle:80,coolDown:200),
                        new HpLessTransition(0.50, "Transform"),
                        new TimedTransition(200, "2")
                    ),
                    new State("2",
                        new SetAltTexture(5),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 120, coolDown: 200),
                        new HpLessTransition(0.50, "Transform"),
                        new TimedTransition(200, "3")
                    ),
                    new State("3",
                        new SetAltTexture(6),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 160, coolDown: 200),
                        new HpLessTransition(0.50, "Transform"),
                        new TimedTransition(200, "4")
                    ),
                    new State("4",
                        new SetAltTexture(3),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 200, coolDown: 200),
                        new HpLessTransition(0.50, "Transform"),
                        new TimedTransition(200, "5")
                    ),
                    new State("5",
                        new SetAltTexture(4),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 240, coolDown: 200),
                        new HpLessTransition(0.40, "Transform"),
                        new TimedTransition(200, "6")
                    ),
                    new State("6",
                        new SetAltTexture(5),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 280, coolDown: 200),
                        new HpLessTransition(0.40, "Transform"),
                        new TimedTransition(200, "7")
                    ),
                    new State("7",
                        new SetAltTexture(6),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 320, coolDown: 200),
                        new HpLessTransition(0.40, "Transform"),
                        new TimedTransition(200, "8")
                    ),
                    new State("8",
                        new SetAltTexture(3),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 360, coolDown: 200),
                        new HpLessTransition(0.40,"Transform"),
                        new TimedTransition(200, "9")
                    ),
                    new State("9",
                        new StayCloseToSpawn(1),
                        new SetAltTexture(4),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 0, coolDown: 200),
                        new TimedTransition(200,"Phase2"),
                        new HpLessTransition(0.50,"Transform")
                    ),
                    new State("Transform",
                        new Transform("Mixcoatl the Masked God")
                    )
                )
            )
            .Init("Mixcoatl the Masked God",
                new State(
                    new State("Phase3",                         
                        new SetAltTexture(1),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Shoot(5, count:8, fixedAngle:45, coolDown:400),
                        new TimedTransition(3000,"11")
                    ),
                    new State("11",
                        new Follow(1, range: 3),
                        new SetAltTexture(4),
                        new Shoot(5, count: 8, fixedAngle: 45, coolDown: 800),
                        new Shoot(7, count:3, projectileIndex:1,shootAngle:20, fixedAngle:80,coolDown:200),
                        new TimedTransition(200, "22")
                    ),
                    new State("22",
                        new Follow(1, range: 3),
                        new SetAltTexture(5),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 120, coolDown: 200),
                        new TimedTransition(200, "33")
                    ),
                    new State("33",
                        new Follow(1,range:3),
                        new SetAltTexture(6),
                        new Shoot(5, count: 8, fixedAngle: 45, coolDown: 800),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 160, coolDown: 200),
                        new TimedTransition(200, "44")
                    ),
                    new State("44",
                        new Follow(1, range: 3),
                        new SetAltTexture(3),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 200, coolDown: 200),
                        new TimedTransition(200, "55")
                    ),
                    new State("55",
                        new Follow(1, range: 3),
                        new SetAltTexture(4),
                        new Shoot(5, count: 8, fixedAngle: 45, coolDown: 800),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 240, coolDown: 200),
                        new TimedTransition(200, "66")
                    ),
                    new State("66",
                        new Follow(1, range: 3),
                        new SetAltTexture(5),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 280, coolDown: 200),
                        new TimedTransition(200, "77")
                    ),
                    new State("77",
                        new Follow(1, range: 3),
                        new SetAltTexture(6),
                        new Shoot(5, count: 8, fixedAngle: 45, coolDown: 1800),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 320, coolDown: 200),
                        new TimedTransition(200, "88")
                    ),
                    new State("88",
                        new Follow(1, range: 3),
                        new SetAltTexture(3),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 360, coolDown: 200),
                        new TimedTransition(200, "99")
                    ),
                    new State("99",
                        new Follow(1, range: 3),
                        new SetAltTexture(4),
                        new Shoot(5, count: 8, fixedAngle: 45, coolDown: 1800),
                        new Shoot(7, count: 3, projectileIndex: 1, shootAngle: 20, fixedAngle: 0, coolDown: 200),
                        new TimedTransition(200, "11")
                    )
                ),
                new ItemLoot("Cracked Crystal Skull", 0.1),
                new ItemLoot("Robe of the Tlatoani", 0.1),
                new ItemLoot("Staff of the Crystal Serpent", 0.1),
                new ItemLoot("Crystal Bone Ring", 0.1),
                new ItemLoot("Pollen Powder", 1),
                new Threshold(0.015,
                    new TierLoot(5, ItemType.Potion, 0.03)
                )
            )
            .Init("Great Temple Snake",
                new State(
                    new Prioritize(
                        new Follow(0.6),
                        new Wander(0.4)
                    ),
                    new Shoot(10, 2, 7, 0, coolDown: 1000, coolDownOffset: 0),
                    new Shoot(10, 6, 60, 1, coolDown: 2000, coolDownOffset: 600)
                )
            );
    }
}