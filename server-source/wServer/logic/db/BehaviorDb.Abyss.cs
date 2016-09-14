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
        _ ArchdemonMalphas = () => Behav()
            .Init("Archdemon Malphas",
                    new State(
                        new State("Idle",
                            //new StayCloseToSpawn(0.1, range: 6),
                            new HpLessTransition(0.99, "Shooting+Potectors")
                        ),
                       

                         new State("Shooting+Potectors",

                            new TossObject("Malphas Missile", range: 0, angle: 0, coolDown: 2500),
                            new TossObject("Malphas Protector", range: 0, angle: 0, coolDown: 2500),
                            new Shoot(11, projectileIndex: 0, coolDown: 3000),
                            new Prioritize(
                                new Wander(0.5) // should be tested and changed to match prod
                            ),
                            new TimedTransition(15000, "sizechange1")
                        ),

                #region sizechange 1-6  (90-40) - get small
                        new State("sizechange1",
                           
                            new ChangeSize(11, 90),
                            
                            new Prioritize(
                               
                                new Wander(0.3)
                            ),
                           
                            new TimedTransition(200, "sizechange2")
                        ),

                         new State("sizechange2",

                            new ChangeSize(11, 80),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange3")
                        ),

                        new State("sizechange3",

                            new ChangeSize(11, 70),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange4")
                        ),

                         new State("sizechange4",

                            new ChangeSize(11, 60),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange5")
                        ),

                         new State("sizechange5",

                            new ChangeSize(11, 50),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange6")
                        ),

                         new State("sizechange6",

                            new ChangeSize(11, 40),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange6")
                        ),

                         #endregion // makes him smaller // makes him smaller
                


                        new State("smallform",
                            new Shoot(12, projectileIndex: 1, count: 6, shootAngle: 60, predictive: 0.5, coolDown: 1000), //Shoot small silver shields every second
                            new Shoot(10, projectileIndex: 0, predictive: 1),   //Shoot white Armor Piercing bullet every second
                            new Prioritize(
                                new Wander(0.8) // should be tested and changed to match prod
                            ),
                            new TimedTransition(10000, "sizechange7")
                        ),

                #region sizechange 7-13  (60-170) - grow
                  new State("sizechange7",

                            new ChangeSize(11, 60),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange8")
                        ),

                         new State("sizechange8",

                            new ChangeSize(11, 80),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange9")
                        ),

                        new State("sizechange9",

                            new ChangeSize(11, 100),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange10")
                        ),

                         new State("sizechange10",

                            new ChangeSize(11, 120),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange11")
                        ),

                         new State("sizechange11",

                            new ChangeSize(11, 140),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange12")
                        ),

                         new State("sizechange12",

                            new ChangeSize(11, 160),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange13")
                        ),


                         new State("sizechange13",

                            new ChangeSize(11, 170),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange13")
                        ),

        #endregion 
                       


                        new State("largeform",
                            new Shoot(12, projectileIndex: 1, count: 3, shootAngle: 120, predictive: 0.5, coolDown: 1000), //Shoot 3 small silver shields every second
                            new Shoot(10, projectileIndex: 0, predictive: 2),   //Shoot white Armor Piercing bullet every second
                            new Wander(0.1),
                            new TimedTransition(10000, "sizechange14")
                        ),

                #region sizechange 14-20  (160-100) - back to normal size
                     
                        new State("sizechange14",
                            new ChangeSize(11, 160),
                            new Prioritize(
                                new Wander(0.3)
                            ),
                            new TimedTransition(200, "sizechange15")
                        ),
                        new State("sizechange15",
                            new ChangeSize(11, 150),
                            new Prioritize(
                                new Wander(0.3)
                            ),
                            new TimedTransition(200, "sizechange16")
                        ),
                        new State("sizechange16",

                            new ChangeSize(11, 140),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange17")
                        ),

                         new State("sizechange17",

                            new ChangeSize(11, 130),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange18")
                        ),

                         new State("sizechange18",

                            new ChangeSize(11, 120),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange19")
                        ),

                         new State("sizechange19",

                            new ChangeSize(11, 110),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "sizechange20")
                        ),


                         new State("sizechange20",

                            new ChangeSize(11, 100),

                            new Prioritize(

                                new Wander(0.3)
                            ),

                            new TimedTransition(200, "spawnflamers")
                        ),

        #endregion 
                        new State("spawnflamers",
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),
                            new TossObject("Malphas Flamer", range: 3, angle: 0, coolDown: 100000),

                            new TimedTransition(5000, "Flashing+Vulnerable")
                        ),
                        new State("Flashing+Vulnerable",
                            new Flash(0x000000, 0.6, 5000),
                            new TimedTransition(5000, "Shooting+Potectors")
                        )
                       
                    ),
                    new ItemLoot("Potion of Defense", 0.5),
                    new ItemLoot("Potion of Vitality", 0.5),
                    new ItemLoot("Wine Cellar Incantation", 0.05),
                    new ItemLoot("Demon Blade", 0.005),
                    new TierLoot(8, ItemType.Armor, 0.3)
                )










                  .Init("Malphas Missile",
                    new State(
                        new State("chase",
                            new Prioritize(
                
                            new Charge(0.5)   // there was no chase instance so I used a charge instance because it seems like the next best thing...
                            ),
                            new TimedTransition(2000, "Explode")
                        ),
                       new State("Explode",
                            new Flash(0x01FAEBD7, 0.6, 500),
                            new Shoot(0, count: 6, shootAngle: 60, fixedAngle: 0),
                            new Suicide()
                        )
                        ))





                        .Init("Demon of the Abyss",
                    new State(
                        new State("chase",
                            new Prioritize(
                            new Shoot(12, projectileIndex: 0, count: 3, shootAngle: 60, predictive: 0.5, coolDown: 100),
                            new Charge(0.5)   // there was no chase instance so I used a charge instance because it seems like the next best thing...
                            )
                            
                        )
                      
                        ))

                          .Init("Malphas Protector",
                    new State(
                        new State("circle",
                            new Prioritize(
                            new Shoot(12, projectileIndex: 0, count: 3, shootAngle: 60, predictive: 0.5, coolDown: 100),
                           new Orbit(1, 10, target: "Archdemon Malphas", radiusVariance: 0)
                            )

                        )

                        ))








                ;





         



                


    }
}
