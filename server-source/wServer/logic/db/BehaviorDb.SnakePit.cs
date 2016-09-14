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
        _ SnakePit = () => Behav()
            .Init("Stheno the Snake Queen",
                  new State(
                      new State("phase1",
                          new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                          new Spawn("Stheno Pet", maxChildren: 5),
                          new TimedTransition(2000, "ShootQuick")
                      ),
                      new State("ShootQuick",
                          new ConditionalEffect(ConditionEffectIndex.Invulnerable),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 50, coolDown: 900),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 40, coolDown: 900),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 310, coolDown: 900),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 320, coolDown: 900),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 135, coolDown: 900),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 225, coolDown: 900),
                          new TimedTransition(8000, "Phase1")
                      ),
                      new State("Phase1",
                          new Spawn("Stheno Swarm", maxChildren: 4),
                          new Wander(0.1),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 90, coolDown: 700),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 0, coolDown: 700),
                          new Shoot(10, projectileIndex: 0, count: 1, angleOffset: 270, coolDown: 700),
                          new TimedTransition(12000, "WhiteBulletGrenade")
                      ),
                      new State("WhiteBulletGrenade",
                          new Shoot(10,count:6, shootAngle:60,projectileIndex:1, coolDown: 400),
                          new Grenade(radius:3,damage:90,penetration:60,range:10,coolDown:1400),
                          new TimedTransition(8000, "ShootQuick")
                        )
                    ),
                    new ItemLoot("Potion of Speed", 1),
                    new Threshold(0.015,
                        new TierLoot(2, ItemType.Potion, 0.03)
                    )
                )
            .Init("Stheno Pet",
                new State(
                    new State("CirclenShoot",
                        new Orbit(2,radius:8,target:"Stheno the Snake Queen"),
                        new Shoot(10, count: 1, projectileIndex: 0, coolDown: 3500)
                    )
                ),
                new ItemLoot("Potion of Speed", 0.0001),
                new Threshold(0.015,
                    new TierLoot(2, ItemType.Potion, 0.03)
                )
            )
            .Init("Stheno Swarm",
                new State(
                    new State("ImAnnoying",
                        new Decay(12000),
                        new Wander(0.2),
                        new Shoot(10, projectileIndex: 0, count: 1, coolDown:1400)
                    )
                )
            );
    }
}