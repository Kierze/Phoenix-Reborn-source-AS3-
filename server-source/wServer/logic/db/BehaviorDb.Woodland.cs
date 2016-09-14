//using wServer.logic.behaviors;
//using wServer.logic.loot;
//using wServer.logic.transitions;

//namespace wServer.logic
//{
//    partial class BehaviorDb
//    {
//        private _ Woodland = () => Behav()
//            .Init("Woodland Weakness Turret",
//                new State(
//                    new ConditionalEffect(ConditionEffectIndex.Invulnerable),
//                    new Shoot(25, projectileIndex: 0, count: 8, shootAngle: 10, coolDown: 1000, coolDownOffset: 1000)
//                )
//            )
//            .Init("Woodland Silence Turret",
//                new State(
//                    new ConditionalEffect(ConditionEffectIndex.Invulnerable),
//                    new Shoot(25, projectileIndex: 0, count: 8, shootAngle: 10, coolDown: 1000, coolDownOffset: 1000)
//                )
//            )
//            .Init("Woodland Paralyze Turret",
//                new State(
//                    new ConditionalEffect(ConditionEffectIndex.Invulnerable),
//                    new Shoot(25, projectileIndex: 0, count: 8, shootAngle: 10, coolDown: 1000, coolDownOffset: 1000)
//                )
//            )
//            .Init("Grizzled Armored Squirrel",
//                new State(
//                    new Shoot(25, projectileIndex: 0, count: 2, shootAngle: 30, coolDown: 700, coolDownOffset: 1000)
//                )
//            )
//            .Init("Mecha Squirrel",
//                new State(
//                    new Shoot(25, projectileIndex: 0, count: 3, shootAngle: 35, coolDown: 900, coolDownOffset: 1000)
//                )
//            )
//            .Init("Forest Goblin Nechromancer",
//                new State(
//                    new Shoot(55, projectileIndex: 0, count: 2, shootAngle: 10, coolDown: 900, coolDownOffset: 1000)
//                )
//            )
//            .Init("Forest Goblin Bruiser",
//                new State(
//                    new Shoot(25, projectileIndex: 0, count: 2, shootAngle: 20, coolDown: 900, coolDownOffset: 1000)
//                )
//            );
//    }
//}