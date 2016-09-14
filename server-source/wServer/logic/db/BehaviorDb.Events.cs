using System.Threading;
using wServer.logic.behaviors;
using wServer.logic.loot;
using wServer.logic.transitions;

namespace wServer.logic
{
    partial class BehaviorDb
    {
        private _ Events = () => Behav()
            #region Custom Events

            .Init("Custom Boss",
                new State(
                    new State("idle",
                        new HpLessTransition(0.9999, "active")
                        ),
                    new State("active",
                        new Taunt("{PLAYER}, You will regret that you've awoken me!"),
                        new Shoot(50, 1, coolDown: 500),
                        new Shoot(50, 1, coolDown: 750),
                        new Shoot(50, 1, coolDown: 1000),
                        new Shoot(50, 1, coolDown: 1250),
                        new Shoot(50, 1, coolDown: 1500)
                        )
                    )
            )

            .Init("Super Cube God",
                new State(
                    new State("idle",
                        new HpLessTransition(0.999999, "begin")
                    ),
                    new State("begin",
                        new Taunt("..."),
                        new HpLessTransition(0.99, "really begin")
                    ),
                    new State("really begin",
                        new Taunt("Do not test me! Begone."),
                        new TossObject("Super Cube Defender", range: 6, angle: 0, coolDown: 35000),
                        new TossObject("Super Cube Defender", range: 6, angle: 90, coolDown: 35000),
                        new TossObject("Super Cube Defender", range: 6, angle: 180, coolDown: 35000),
                        new TossObject("Super Cube Defender", range: 6, angle: 270, coolDown: 35000),
                        new HpLessTransition(0.95, "still warming up")
                    ),
                    new State("still warming up",
                        new Taunt("Foolish cubes do not know their own god. You will be punished!"),
                        new TossObject("Super Cube Defender", range: 2, angle: 90, coolDown: 25000),
                        new SpiralShoot(radius: 15, count: 4, shootAngle: 90, projectileIndex: 3, angleOffset: 8, defaultAngle: 0.0, coolDownOffset: 0, coolDown: 200)
                    )
                )
            )

            .Init("Super Cube Defender",
                new State(
                    new State("chasing chasing chasing oooaAAH",
                        new Prioritize(
                            new Follow(2.5, 30, 0.5, 10000, coolDown: 500),
                            new Wander(0.3)
                        ),
                        //new RandomPlayersWithinTransition(1.0, "Ring", "Shotgun", "Spread")
                        new ChooseRandom(
                            new ChangeState("Ring"),
                            new ChangeState("Shotgun"),
                            new ChangeState("Spread")
                        )
                    ),

                    new State("Ring",
                        new SpiralShoot(15, 4, 90, 1, 10, 0.0, 0, coolDown: 500),
                        new Shoot(10, 1, projectileIndex: 2, coolDown: 800),
                        new TimedTransition(6000, "chasing chasing chasing oooaAAH")
                    ),

                    new State("Shotgun",
                        new Shoot(15, 5, 11, 3, coolDown: 300),
                        new TimedTransition(3000, "chasing chasing chasing oooaAAH")
                    ),

                    new State("Spread",
                        new Shoot(15, 7, 22, 0, coolDown:1500),
                        new Shoot(15, 5, 72, 2, coolDown:1500),
                        new TimedTransition(4500, "chasing chasing chasing oooaAAH")
                    )
                )
            )
            #endregion

            #region Cube God

            .Init("Cube God",
                new State(
                    new Shoot(25, 9, 10, 0, null, 0, null, 1, 0, 750),
                    new Shoot(25, 4, 10, 1, null, 0, null, 1),
                    new Wander(0.1),
                    new Spawn("Cube Overseer", 4, coolDown: 5000),
                    new Spawn("Cube Defender", 20, coolDown: 1000),
                    new Spawn("Cube Blaster", 4, coolDown: 5000),
                    new Reproduce("Cube Overseer", 10, 4, 5000),
                    new Reproduce("Cube Defender", 10, 20, 1000),
                    new Reproduce("Cube Blaster", 10, 20, 1000)
                    ),
                new TierLoot(3, ItemType.Ring, 0.2),
                new TierLoot(7, ItemType.Armor, 0.2),
                new TierLoot(8, ItemType.Weapon, 0.2),
                new TierLoot(4, ItemType.Ability, 0.1),
                new TierLoot(8, ItemType.Armor, 0.1),
                new TierLoot(4, ItemType.Ring, 0.05),
                new TierLoot(9, ItemType.Armor, 0.03),
                new TierLoot(5, ItemType.Ability, 0.03),
                new TierLoot(9, ItemType.Weapon, 0.03),
                new TierLoot(10, ItemType.Armor, 0.02),
                new TierLoot(10, ItemType.Weapon, 0.02),
                new TierLoot(11, ItemType.Armor, 0.01),
                new TierLoot(11, ItemType.Weapon, 0.01),
                new TierLoot(5, ItemType.Ring, 0.01),
                new Threshold(0.03,
                    new ItemLoot("Unknown Essence", 0.01),
                    new ItemLoot("Potion of Dexterity", 0.5),
                    new ItemLoot("Potion of Attack", 0.5)
                )
            )
            .Init("Cube Overseer",
                new State(
                    new Shoot(10, 4, 10, 0, predictive: 1, coolDown: 1000),
                    new Shoot(10, 1, projectileIndex: 1, predictive: 1, coolDown: 2000),
                    new Orbit(1, 5, target: "Cube God", radiusVariance: 0.5)
                    //new Wander(.5)
                    )
            )
            .Init("Cube Defender",
                new State(
                    new Shoot(10, 1, 10, 0, coolDown: 1000),
                    new Orbit(1, 7.5, target: "Cube God", radiusVariance: 0.5)
                    //new Follow(1, 7, 7)
                    )
            )
            .Init("Cube Blaster",
                new State(
                    new Shoot(10, 1, projectileIndex: 1, coolDown: 1000),
                    new Shoot(10, 2, 10, 0, coolDown: 1000),
                    new Orbit(1, 7.5, target: "Cube God", radiusVariance: 0.5)
                    //new Follow(1, 7, 7)
                    )
            )
            #endregion

            #region Skull Shrine

            .Init("Skull Shrine",
                new State(
                    new Shoot(25, 11, 15, predictive: 1, coolDown: 1250),
                    //new Spawn("Red Flaming Skull", 8, coolDown: 5000),
                    //new Spawn("Blue Flaming Skull", 10, coolDown: 1000),
                    new Reproduce("Red Flaming Skull", 6, 12, 5000, 3),
                    new Reproduce("Blue Flaming Skull", 15, 16, 1000)
                    ),
                new TierLoot(3, ItemType.Ring, 0.2),
                new TierLoot(7, ItemType.Armor, 0.2),
                new TierLoot(8, ItemType.Weapon, 0.2),
                new TierLoot(4, ItemType.Ability, 0.1),
                new TierLoot(8, ItemType.Armor, 0.1),
                new TierLoot(4, ItemType.Ring, 0.05),
                new TierLoot(9, ItemType.Armor, 0.03),
                new TierLoot(5, ItemType.Ability, 0.03),
                new TierLoot(9, ItemType.Weapon, 0.03),
                new TierLoot(10, ItemType.Armor, 0.02),
                new TierLoot(10, ItemType.Weapon, 0.02),
                new TierLoot(11, ItemType.Armor, 0.01),
                new TierLoot(11, ItemType.Weapon, 0.01),
                new TierLoot(5, ItemType.Ring, 0.01),
                new Threshold(0.03,
                    new ItemLoot("Unknown Essence", 0.01),
                    new ItemLoot("Potion of Dexterity", 0.5),
                    new ItemLoot("Potion of Attack", 0.5)
                )
            )
            .Init("Red Flaming Skull",
                new State(
                    new Prioritize(
                        new Orbit(0.5, 3, target: "Skull Shrine", speedVariance: 0.2, radiusVariance: 3),
                        new Wander(.2)
                        ),
                    new Shoot(15, 2, 5, 0, predictive: 1, coolDown: 750)
                    )
            )
            .Init("Blue Flaming Skull",
                new State(
                    new Prioritize(
                        new Orbit(1, 8, target: "Skull Shrine", speedVariance: 0.4, radiusVariance: 6),
                        new Wander(.6)
                        ),
                    new Shoot(15, 2, 5, 0, predictive: 1, coolDown: 750)
                    )
            )
            #endregion

            #region Hermit God

            .Init("Hermit God",
                new State(
                    new CopyDamageRecord("Hermit God Tentacle Spawner"),
                    new State("invis",
                        new SetAltTexture(3),
                        new ConditionalEffect(ConditionEffectIndex.Invincible),
                        new InvisiToss("Hermit Minion", 9, 0, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 45, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 90, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 135, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 180, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 225, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 270, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 315, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 15, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 30, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 90, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 120, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 150, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 180, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 210, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 240, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 50, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 100, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 150, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 200, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 250, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit Minion", 9, 300, 90000001, coolDownOffset: 0),

                        new InvisiToss("Hermit God Tentacle", 5, 45, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 90, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 135, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 180, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 225, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 270, 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle", 5, 315, 90000001, coolDownOffset: 0),

                        new InvisiToss("Hermit God Tentacle Spawner", 6, 40, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 80, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 120, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 160, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 200, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 240, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 280, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 320, coolDown: 90000001, coolDownOffset: 0),
                        new InvisiToss("Hermit God Tentacle Spawner", 6, 360, coolDown: 90000001, coolDownOffset: 0),

                        new InvisiToss("Hermit God Drop", 6, 90, coolDown: 90000001, coolDownOffset: 0),

                        //new Spawn("Hermit God Tentacle", 8, 8, coolDown:9000001),
                        new TimedTransition(1000, "check")
                        ),
                    new State("check",
                        new ConditionalEffect(ConditionEffectIndex.Invincible),
                        new EntityNotExistsTransition("Hermit God Tentacle", 20, "active")
                        ),
                    new State("active",
                        new SetAltTexture(2),
                        new TimedTransition(500, "active2")
                        ),
                    new State("active2",
                        new SetAltTexture(0),
                        new Shoot(25, 3, 10, 0, coolDown: 200),
                        new Wander(.2),
                        new TossObject("Whirlpool", 6, 0, 90000001, 100),
                        new TossObject("Whirlpool", 6, 45, 90000001, 100),
                        new TossObject("Whirlpool", 6, 90, 90000001, 100),
                        new TossObject("Whirlpool", 6, 135, 90000001, 100),
                        new TossObject("Whirlpool", 6, 180, 90000001, 100),
                        new TossObject("Whirlpool", 6, 225, 90000001, 100),
                        new TossObject("Whirlpool", 6, 270, 90000001, 100),
                        new TossObject("Whirlpool", 6, 315, 90000001, 100),
                        new TimedTransition(20000, "rage")
                        ),
                    new State("rage",
                        new SetAltTexture(4),
                        new Order(20, "Whirlpool", "despawn"),
                        new Flash(0xfFF0000, .8, 9000001),
                        new Shoot(25, 8, projectileIndex: 1, coolDown: 2000),
                        new Shoot(25, 20, projectileIndex: 2, coolDown: 3000, coolDownOffset: 5000),
                        new TimedTransition(17000, "invis")
                        )
                    )
            )
            .Init("Whirlpool",
                new State(
                    new State("active",
                        new Shoot(25, 8, projectileIndex: 0, coolDown: 1000),
                        new Orbit(.5, 6, target: "Hermit God", radiusVariance: 0)
                        ),
                    new State("despawn",
                        new Suicide()
                        )
                    )
            )
            .Init("Hermit God Tentacle",
                new State(
                    new Prioritize(
                        new Orbit(.5, 5, target: "Hermit God", radiusVariance: 0.5),
                        new Follow(0.85, range: 1, duration: 2000, coolDown: 0)
                        ),
                    new Shoot(4, 8, projectileIndex: 0, coolDown: 1000)
                    )
            )
            .Init("Hermit Minion",
                new State(
                    new Prioritize(
                        new Wander(.5),
                        new Follow(0.85, 3, 1, 2000, 0)
                        ),
                    new Shoot(5, 1, 1, 1, coolDown: 2300),
                    new Shoot(5, 3, 1, 0, coolDown: 1000)
                    )
            )
            .Init("Hermit God Tentacle Spawner",
                new State(
                    new State(
                        new ConditionalEffect(ConditionEffectIndex.Invincible, perm: true),
                        new EntityNotExistsTransition("Hermit God", 10, "despawn")
                        ),
                    new State("despawn",
                        new Suicide()
                        )
                    ),
                new Threshold(0.03,
                    new ItemLoot("Potion of Dexterity", 0.08),
                    new ItemLoot("Helm of the Juggernaut", 0.003),
                    new ItemLoot("Unknown Essence", 0.005),
                    new ItemLoot("Potion of Vitality", 0.08)
                )
            )

            .Init("Hermit God Drop",
                new State(
                    new SpawnOnDeath("Ocean Trench Portal", 1),
                    new State(
                        new ConditionalEffect(ConditionEffectIndex.Invincible, perm: true),
                        new EntityNotExistsTransition("Hermit God", 10, "despawn")
                        ),
                    new State("despawn",
                        new Suicide()
                        )
                    )
            )
            #endregion

            #region Pentaract

            .Init("Pentaract",
                new State(
                    new Taunt("Wowowkn now i am a beeear because you have haaaair and in the lake i am a rake who eats a cake with a steak bake bake bake bake bake WWEEEE And one day I will become a too and one day I will become one too and one day I WILL BELIEVE IN MYSELF TO MAKE A BIG NEW BRAND NEW DOCTOR HOSPITAL WITH A BIG-ASS GREEN BILLBoARD STATING THAT I AM THE BEST AND NOBODY CAN BEAT ME?")
                    )
            )
            .Init("Pentaract Tower",
                new State(
                    new Grenade(2, 50, 30, 2.5, coolDown: 2000)
                    )
            )
            .Init("Pentaract Eye",
                new State(
                    new Shoot(2, coolDown: 333)
                    )
            )
            #endregion

            #region Grand Sphinx

            .Init("Grand Sphinx",
                new State(
                    new Prioritize(
                        new Wander(0.1)
                        )
                    )
            )
            #endregion

            #region Ghost Ship

            .Init("Ghost Ship",
                new State(
                    new State("idle",
                        new HpLessTransition(0.9999, "active")
                        ),
                    new State("active",
                        new Prioritize(
                            new Wander(0.1)
                            )
                        )
                    )
            )
            #endregion

            #region Lord of the Lost Lands

            .Init("Lord of the Lost Lands",
                new State(
                    new State("idle",
                        new HpLessTransition(0.9999, "active")
                        ),
                    new State("active",
                        new Prioritize(
                            new Wander(0.1)
                            )
                        )
                    )
            );

        #endregion
    }
}