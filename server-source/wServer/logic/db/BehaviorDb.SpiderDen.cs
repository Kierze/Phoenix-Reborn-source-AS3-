using wServer.logic.behaviors;
using wServer.logic.loot;
using wServer.logic.transitions;

namespace wServer.logic
{
    partial class BehaviorDb
    {
        _ SpiderDenP2 = () => Behav()
            .Init("Arachna the Spider Queen",
                new State(
                    new State("Idle",
                        new PlayerWithinTransition(dist: 25, targetState: "Webs")),
                    new State("Webs",
                        new ConditionalEffect(common.ConditionEffectIndex.Invulnerable),
                        //new Wander(speed: 0.4), // Not yet?
                        #region
                        new TossObject(child: "Arachna Web Spoke 1", range: 10, angle: 0, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 2", range: 10, angle: 60, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 3", range: 10, angle: 120, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 4", range: 10, angle: 180, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 5", range: 10, angle: 240, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 6", range: 10, angle: 300, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 7", range: 6, angle: 0, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 8", range: 6, angle: 120, coolDown: 2000),
                        new TossObject(child: "Arachna Web Spoke 9", range: 6, angle: 240, coolDown: 2000),
                        #endregion
                        new TimedTransition(time: 1500, targetState: "Attack")),
                    new State("Attack",
                        new Wander(speed: 0.35),
                        new StayCloseToSpawn(speed: 0.35, range: 9), // Not sure if this works
                        new Shoot(radius: 16, count: 10, shootAngle: 36, projectileIndex: 0, coolDown: 3000),
                        new Shoot(radius: 16, projectileIndex: 0, coolDown: 1000),
                        new Shoot(radius: 16, projectileIndex: 1, coolDown: 2000))),
                    new Threshold(0.5,
                        new ItemLoot("Healing Ichor", 0.2),
                        new ItemLoot("Golden Dagger", 0.2),
                        new ItemLoot("Spider's Eye Ring", 0.2),
                        new ItemLoot("Poison Fang Dagger", 0.2)))
            .Init("Brown Den Spider",
                new State(
                    new State("Attack",
                        new Wander(speed: 0.8),
                        new Charge(speed: 0.8, range: 3),
                        new Shoot(radius: 15, count: 3, shootAngle: 5, coolDown: 500, predictive: 0.5))),
                    new Threshold(1.0, 
                        new ItemLoot("Healing Ichor", 0.2)))
            .Init("Black Den Spider",
                new State(
                    new State("Attack",
                        new Wander(speed: 0.8),
                        new Charge(speed: 2, range: 9, coolDown: 2000),
                        new Shoot(radius: 15, predictive: 0.5, coolDown: 500))),
                    new Threshold(1.0, 
                        new ItemLoot("Healing Ichor", 0.2)))
            .Init("Green Den Spider Hatchling",
                new State(
                    new State("Attack",
                        new Wander(speed: 0.1), // Wander Speed: Default?
                        //new Charge(speed: 0.8, range: 8), // Do they really Charge/Chase?
                        new Shoot(radius: 20, predictive: 0.5, coolDown: 1000))))
            .Init("Black Spotted Den Spider",
                new State(
                    new State("Attack",
                        new Wander(speed: 0.8),
                        new Charge(speed: 4, range: 9, coolDown: 2000),
                        new Shoot(radius: 15, predictive: 0.5, coolDown: 500))),
                    new Threshold(1.0, 
                        new ItemLoot("Healing Ichor", 0.2)))
            .Init("Red Spotted Den Spider",
                new State(
                    new State("Attack",
                        new Wander(speed: 0.1),
                        new Charge(speed: 0.1, range: 8),
                        new Shoot(radius: 15, predictive: 0.5, coolDown: 500))),
                    new Threshold(1.0,
                        new ItemLoot("Healing Ichor", 0.2)))
            .Init("Spider Egg Sac",
                new State(
                    new State("Idle",
                        new PlayerWithinTransition(dist: 1.5, targetState: "Explode"),
                    new State("Explode",
                        new Spawn(children: "Green Den Spider Hatchling", maxChildren: 7, initialSpawn: 1, coolDown: 90000),
                        new Decay(time: 100)))))
            #region
            .Init("Arachna Web Spoke 1",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 120, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 180, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 240, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 2",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 180, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 240, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 300, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 3",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 0, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 240, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 300, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 4",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 0, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 60, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 300, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 5",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 0, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 60, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 120, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 6",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 60, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 120, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 180, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 7",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 120, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 180, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 240, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 8",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 360, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 240, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 300, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))))
            .Init("Arachna Web Spoke 9",
                new State(
                    new State("Idle",
                        new ConditionalEffect(effect: common.ConditionEffectIndex.Invulnerable, perm: true),
                        new Shoot(radius: 50, fixedAngle: 0, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 60, coolDown: 150),
                        new Shoot(radius: 50, fixedAngle: 120, coolDown: 150),
                        new EntityNotExistsTransition(target: "Arachna the Spider Queen", dist: 50, targetState: "Suicide")),
                    new State("Suicide",
                        new Decay(time: 1500))));
            #endregion
    }
}
