using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using wServer.realm;
using wServer.logic.behaviors;
using wServer.logic.loot;
using wServer.logic.transitions;

namespace wServer.logic
{
    partial class BehaviorDb
    {
        
        _ ForestLarva = () => Behav()
            .Init("Forest Larva",
                new State(
                    new State("Activate",
                        new Prioritize(
                            new Follow(1, range: 1, duration: 1200, coolDown: 1000),
                            new Wander(0.4)
                        ),
                        new Shoot(10, count: 10, shootAngle: 36.5, fixedAngle: 0, projectileIndex: 0, coolDown: 1000),
                        new HpLessTransition(0.05, "Transition")
                    ),
                    new State("Transition",
                        new Flash(0xff0000, 1, 100),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Die")
                    ),
                    new State("Die",
                        new Spawn("Monstrous Megamoth", maxChildren: 1, initialSpawn: 1, coolDown: 9999999),
                        new Suicide()
                    )
                )
            )

            .Init("Monstrous Megamoth Sentinel",
                new State(
                    new Prioritize(
                        new Protect(0.4, "Monstrous Megamoth", protectionRange: 1),
                        new Wander(0.4)
                    ),
                    new Shoot(10, count: 1, shootAngle: 72.5, projectileIndex: 0, coolDown: 1000)
                )
            )

            .Init("Monstrous Megamoth",
                new State(
                    new State("Act",
                        new Prioritize(
                            new Follow(1, range: 7),
                            new Wander(0.4)
                        ),
                        new Spawn("Monstrous Megamoth Sentinel", maxChildren: 5, initialSpawn: 5, coolDown: 2500),
                        new Shoot(10, count: 3, shootAngle: 7, predictive: 1, projectileIndex: 0, coolDown: 250),
                        new HpLessTransition(0.05, "Transition")
                    ),
                    new State("Transition",
                        new Flash(0xff0000, 1, 100),
                        new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                        new TimedTransition(5000, "Death")
                    ),
                    new State("Death",
                        new Spawn("Murderous Megamoth", maxChildren: 1, initialSpawn: 1, coolDown: 500000000),
                        new Suicide()
                    )
                )
            )

            .Init("Murderous Megamoth",
                new State(
                    new Prioritize(
                        new Follow(1, range: 7),
                        new Wander(0.4)
                    ),
                    new Spawn("Mini Larva", maxChildren: 5, initialSpawn: 5, coolDown: 2500),
                    new Shoot(10, count: 3, shootAngle: 7, predictive: 1, projectileIndex: 0, coolDown: 250),
                    new Shoot(10, count: 10, shootAngle: 36.5, fixedAngle: 0, projectileIndex: 1, coolDown: 2500)
                )
            )

            .Init("Mini Larva",
                new State(
                    new Prioritize(
                        new Protect(0.4, "Murderous Megamoth", protectionRange: 1),
                        new Wander(0.4)
                    ),
                    new Shoot(10, count: 5, shootAngle: 72.5, fixedAngle: 0, projectileIndex: 0, coolDown: 1000)
                )
            );
            
    }
}