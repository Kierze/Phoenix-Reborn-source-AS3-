using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wServer.logic.behaviors;
using wServer.logic.transitions;
using wServer.logic.loot;

namespace wServer.logic
{
    partial class BehaviorDb
    {
        private _ PirateCave = () => Behav()
            .Init("Dreadstump the Pirate King", //dreadstump the badass by roxy (wip)
                new State(
                    new State("default",
                        new Wander(0.2),
                        new HpLessTransition(1.0, "intro")
                    ),
                    new State("intro",
                        new Taunt("Ye want yer treasure back? Arharhar! I'll give ye an easy beatin' before I plunder yer riches!"),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Wander(0.2),
                        new TimedTransition(5000, "begin")
                    ),
                    new State("begin",
                        new Taunt("I'm the pirate KING! No slimy sea dog's bested me!"),
                        new ConditionalEffect(ConditionEffectIndex.Armored),
                        new Prioritize(
                            new Follow(0.5, 10, 6),
                            new Orbit(0.5, 4, 10, null, 0.1, 0.1, true),
                            new Wander(0.25)
                        ),
                        new Shoot(6, coolDown: 400),                                             //blade-forward
                        new Shoot(6, 4, 90, coolDown: 1400),                                     //blade-4ring
                        new Shoot(10, projectileIndex: 1, coolDownOffset: 3000, coolDown: 1000), //gunshot
                        new Heal(1, null, 250, coolDown: 2000),
                        new TimedTransition(20000, "strafe-n-shoot")
                    ),
                    new State("strafe-n-shoot",
                        new Taunt("Hah! I'll drink my rum outta yer skull!"),
                        new Prioritize(
                            new StayBack(0.4, 4),
                            new Follow(0.5, 15, 7),
                            new Orbit(0.5, 5.5, 10, null, 0.1, 0.1, false),
                            new Wander(0.25)
                        ),
                        new Shoot(10, projectileIndex: 1, coolDownOffset: 2000, coolDown: 400),  //rapid-gunshot
                        new Grenade(2, 140, 4, coolDown: 2000),                                  //a-bomb-lol
                        new TimedTransition(30000, "blades-ahoy"),
                        new HpLessTransition(0.8, "get-serious")
                    ),
                    new State("blades-ahoy",
                        new Taunt("Arr!"),
                        new Prioritize(
                            new Follow(0.55, 15, 1.5),
                            new Wander(0.25)
                        ),
                        new Shoot(6.5, 1, 0, 0, coolDownOffset: 2000, coolDown: 400),
                        new Shoot(6.5, 2, 12.5, 0, coolDownOffset: 2200, coolDown: 600),
                        new Shoot(6.5, 3, 10, 0, coolDownOffset: 2300, coolDown: 600),
                        new Shoot(0, 6, 60, 3, coolDownOffset: 4000, coolDown: 10000),
                        new TimedTransition(30000, "strafe-n-shoot"),
                        new HpLessTransition(0.8, "get-serious")
                    ),
                    new State("get-serious",
                        new Taunt("Yer not the only ones with tricks up yer sleeve! Arharhar!"),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Wander(0.25),
                        new TimedTransition(2500, "let-it-begin")
                    ),
                    new State("let-it-begin",
                        new Taunt("Boys, get em!"),
                        new ConditionalEffect(ConditionEffectIndex.Armored),
                        new Spawn("Pirate Lieutenant", 6, 1, coolDown: 900),
                        new Spawn("Pirate Commander", 6, 1, coolDown: 900),
                        new Grenade(2, 140, 4, coolDown: 2000),
                        new Shoot(6.5, 3, 55, 0, coolDownOffset: 2000, coolDown: 400),
                        new Shoot(10, projectileIndex: 1, coolDownOffset: 2000, coolDown: 400),  //rapid-gunshot
                        new Heal(1, null, 600, coolDown: 2000),
                        new TimedTransition(20000, "the cannon cometh")
                    ),
                    new State("the cannon cometh",
                        new Taunt("Eat cannonballs!"),
                        new ConditionalEffect(ConditionEffectIndex.Armored),
                        new Shoot(12, 3, 120, 4, coolDownOffset: 2400, coolDown: 300),
                        new Shoot(12, 2, 20, 4, coolDownOffset: 2400, coolDown: 300),
                        new Reproduce("Pirate Lieutenant", 8, 6, coolDown: 1500, spawnRadius: 1),
                        new Reproduce("Pirate Commander", 8, 6, coolDown: 1500, spawnRadius: 1),
                        new TimedTransition(20000, "strafe-n-shoot-more")
                    ),
                    new State("strafe-n-shoot-more",
                        new Taunt("Ye can't beat me!", "Arharhar!"),
                        new Prioritize(
                            new Follow(0.8, 1, 0),
                            new StayBack(1.2, 1.5),
                            new StayBack(0.5, 4),
                            new Follow(0.7, 15, 6.5),
                            new Orbit(1.0, 5.5, 10, null, 0.1, 0.1, true),
                            new Wander(0.3)
                        ),
                        new Shoot(10, 2, 8, projectileIndex: 1, coolDownOffset: 1400, coolDown: 400),  //rapid-gunshot
                        new Grenade(2, 140, 4, coolDown: 1400),                                  //a-bomb-lol
                        new TimedTransition(30000, "blades-ahoy-more")
                    ),
                    new State("blades-ahoy-more",
                        new Taunt("Landlubbers can't fight me face to face!", "Think you can best me at the blade's edge?"),
                        new Prioritize(
                            new Follow(0.6, 15, 1.5),
                            new Wander(0.25)
                        ),
                        new Shoot(6.5, 1, 0, 0, coolDownOffset: 1500, coolDown: 400),
                        new Shoot(6.5, 2, 12.5, 0, coolDownOffset: 1700, coolDown: 500),
                        new Shoot(6.5, 3, 10, 0, coolDownOffset: 1800, coolDown: 600),
                        new Shoot(8, 4, 20, 3, coolDown: 4900),
                        new Shoot(8, 3, 20, 2, coolDown: 4900),
                        new TimedTransition(30000, "prepare-ult")
                    ),
                    new State("prepare-ult",
                        new Taunt("I've got a powder-coated surprise for you!"),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Wander(0.25),
                        new Heal(1, null, 250, coolDown: 2000),
                        new TimedTransition(10000, "ultimate-1")
                    ),
                    new State("ultimate-1",
                        new Taunt("Dodge THIS!"),
                        new Prioritize(
                            new Follow(0.6, 20, 7),
                            new Wander(0.6)
                        ),
                        new ConditionalEffect(ConditionEffectIndex.Armored),
                        new Shoot(15, 5, 32, projectileIndex: 1, coolDownOffset: 1500, coolDown: 400),
                        new Shoot(15, 5, 32, projectileIndex: 4, coolDownOffset: 1500, coolDown: 400),
                        new Reproduce("Pirate Lieutenant", 8, 6, coolDown: 3000, spawnRadius: 1),
                        new Reproduce("Pirate Commander", 8, 6, coolDown: 3000, spawnRadius: 1),
                        new TimedTransition(12000, "ultimate-2")
                    ),
                    new State("ultimate-2",
                        new Taunt("AAAHAHAHAA!"),
                        new ConditionalEffect(ConditionEffectIndex.StunImmune),
                        new ConditionalEffect(ConditionEffectIndex.Armored),
                        new SpiralShoot(999, 5, 36, projectileIndex: 1, angleOffset: 36, coolDown: 100),
                        new SpiralShoot(999, 5, 36, projectileIndex: 4, angleOffset: 36, coolDown: 100),
                        new Reproduce("Pirate Lieutenant", 8, 6, coolDown: 3000, spawnRadius: 1),
                        new Reproduce("Pirate Commander", 8, 6, coolDown: 3000, spawnRadius: 1),
                        new TimedTransition(12000, "out-of-lead")
                    ),
                    new State("out-of-lead",
                        new Taunt("I'm out of lead! Arrghhh! I'm going to kill you personally!"),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new Wander(0.25),
                        new TimedTransition(2500, "blades-ahoy-last")
                    ),
                    new State("blades-ahoy-last",
                        new Taunt("This will sink your last efforts at defeating me!"),
                        new Prioritize(
                            new Follow(0.7, 1.5, range: 2),
                            new Wander(0.25)
                        ),
                        new Shoot(6.5, 1, 0, 0, coolDownOffset: 1500, coolDown: 300),
                        new Shoot(6.5, 2, 12.5, 0, coolDownOffset: 1700, coolDown: 400),
                        new Shoot(6.5, 3, 10, 0, coolDownOffset: 1800, coolDown: 500),
                        new Shoot(8, 4, 24, 3, coolDown: 2000),
                        new Shoot(8, 3, 24, 2, coolDown: 2000),
                        new Shoot(8, 4, 24, 3, angleOffset: 180, coolDown: 2000),
                        new Shoot(8, 3, 24, 2, angleOffset: 180, coolDown: 2000)
                    )

                ),
				new TierLoot(2, ItemType.Weapon, 0.5),
				new TierLoot(3, ItemType.Weapon, 0.33),
				new TierLoot(2, ItemType.Armor, 0.5),
				new TierLoot(3, ItemType.Armor, 0.33)
			)
			.Init("Pirate Lieutenant",
				new State(
					new Prioritize(
						new Protect(0.5, "Dreadstump the Pirate King", protectionRange: 12),
                        new Follow(0.3, 9, 5, 800, 600),
						new Wander(0.25)
					),
					new Shoot(10, coolDownOffset: 2000, coolDown: 1200)
                    ),
				new TierLoot(2, ItemType.Weapon, 0.2),
                new TierLoot(3, ItemType.Weapon, 0.1),
				new TierLoot(1, ItemType.Armor, 0.2),
				new TierLoot(1, ItemType.Ring, 0.1),
				new Threshold(0.5,
					new ItemLoot("Pirate Rum", 0.02)
                    )
            )
            .Init("Pirate Commander",
                new State(
                    new Prioritize(
                        new Protect(0.5, "Dreadstump the Pirate King", protectionRange: 14),
                        new Follow(0.3, 10, 4, 800, 600),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDownOffset: 2000, coolDown: 1200)
                    ),
                new TierLoot(2, ItemType.Weapon, 0.2),
                new TierLoot(3, ItemType.Weapon, 0.1),
                new TierLoot(1, ItemType.Armor, 0.2),
                new TierLoot(1, ItemType.Ring, 0.1),
                new Threshold(0.5,
                    new ItemLoot("Pirate Rum", 0.02)
                    )
            )
            .Init("Pirate Captain",
                new State(
                    new Prioritize(
                        new Protect(0.5, "Dreadstump the Pirate King", protectionRange: 14),
                        new Follow(0.3, 10, 4, 800, 600),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDownOffset: 2000, coolDown: 1200)
                    ),
                new TierLoot(2, ItemType.Weapon, 0.2),
                new TierLoot(3, ItemType.Weapon, 0.1),
                new TierLoot(1, ItemType.Armor, 0.2),
                new TierLoot(1, ItemType.Ring, 0.1),
                new Threshold(0.5,
                    new ItemLoot("Pirate Rum", 0.02)
                    )
            )
            .Init("Pirate Admiral",
                new State(
                    new Prioritize(
                        new Protect(0.5, "Dreadstump the Pirate King", protectionRange: 14),
                        new Follow(0.3, 10, 4, 800, 600),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDownOffset: 2000, coolDown: 1200)
                    ),
                new TierLoot(2, ItemType.Weapon, 0.2),
                new TierLoot(3, ItemType.Weapon, 0.1),
                new TierLoot(1, ItemType.Armor, 0.2),
                new TierLoot(1, ItemType.Ring, 0.1),
                new Threshold(0.5,
                    new ItemLoot("Pirate Rum", 0.02)
                    )
            )
            .Init("Cave Pirate Brawler",
                new State(
                    new Prioritize(
						new Follow(0.55, acquireRange: 8, range: 1),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDown: 800)
                    ),
				new ItemLoot("Health Potion", 0.05)
            )
            .Init("Cave Pirate Sailor",
                new State(
                    new Prioritize(
                        new Follow(0.55, acquireRange: 7, range: 1),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDown: 800)
                    ),
                new ItemLoot("Health Potion", 0.05)
            )
            .Init("Cave Pirate Veteran",
                new State(
                    new Prioritize(
                        new Follow(0.55, acquireRange: 8, range: 1),
                        new Wander(0.25)
                    ),
                    new Shoot(10, coolDown: 700)
                    ),
                new ItemLoot("Health Potion", 0.05)
            )
			.Init("Cave Pirate Cabin Boy",
				new State(
                    new StayBack(0.35, 3.5),
					new Wander(0.25)
                    ),
				new TierLoot(1, ItemType.Weapon, 0.1)
            )
            .Init("Cave Pirate Hunchback",
                new State(
                    new StayBack(0.35, 3.5),
                    new Wander(0.25)
                    ),
                new TierLoot(1, ItemType.Ability, 0.1)
            )
            .Init("Cave Pirate Macaw",
                new State(
                    new StayBack(0.35, 3.5),
                    new Wander(0.25)
                    ),
                new TierLoot(1, ItemType.Ability, 0.1)
            )
            .Init("Cave Pirate Moll",
                new State(
                    new StayBack(0.35, 3.5),
                    new Wander(0.25)
                    ),
                new TierLoot(1, ItemType.Ability, 0.1)
            )
            .Init("Cave Pirate Monkey",
                new State(
                    new StayBack(0.35, 3.5),
                    new Wander(0.25)
                    ),
                new TierLoot(1, ItemType.Ability, 0.1)
            )
            .Init("Cave Pirate Parrot",
                new State(
                    new StayBack(0.35, 3.5),
                    new Wander(0.25)
                    ),
                new TierLoot(1, ItemType.Ability, 0.1)
            )
            ;
    }
}
