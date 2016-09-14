using db;
using System;
using System.Collections.Generic;
using System.Linq;
using wServer.networking;
using wServer.networking.svrPackets;

namespace wServer.realm.entities
{
    partial class Player
    {
        private static readonly ConditionEffect[] NegativeEffs =
        {
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Slowed,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Paralyzed,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Weak,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Stunned,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Confused,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Blind,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Quiet,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.ArmorBroken,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Bleeding,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Dazed,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Sick,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Drunk,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Hallucinating,
                DurationMS = 0
            },
            new ConditionEffect
            {
                Effect = ConditionEffectIndex.Hexed,
                DurationMS = 0
            }
        };

        public void UseItem(RealmTime time, int objId, int slot, Position pos)
        {
            var container = Owner.GetEntity(objId) as IContainer;
            Item item = container.Inventory[slot];
            ItemData itemData = container.Inventory.Data[slot];
            bool use = Activate(time, item, itemData, slot, pos);
            if ((item.Consumable && (itemData != null ? !itemData.MultiUse : true)) && use)
            {
                if (item.XpBoost != null)
                    XpBoost = item.XpBoost;
                if (item.SuccessorId != null)
                    container.Inventory[slot] =
                        Manager.GameData.Items[Manager.GameData.IdToObjectType[item.SuccessorId]];
                else
                {
                    container.Inventory[slot] = null;
                    container.Inventory.Data[slot] = null;
                }
                (container as Entity).UpdateCount++;
                UpdateCount++;
            }
            if (container.SlotTypes[slot] != -1 && use)
                fameCounter.UseAbility();
        }

        public void EntityHealHp(Player player, Entity healer, int amount, List<Packet> pkts)
        {
            int maxHp = player.Stats[0] + player.Boost[0];
            int newHp = Math.Min(maxHp, player.HP + amount);

            if (newHp != player.HP)
            {
                pkts.Add(new ShowEffectPacket
                {
                    EffectType = EffectType.Potion,
                    TargetId = player.Id,
                    Color = new ARGB(0xffffffff)
                });
                if (newHp - player.HP > 0)
                {
                    pkts.Add(new NotificationPacket
                    {
                        Color = new ARGB(0xff00ff00),
                        ObjectId = player.Id,
                        Text = "+ " + (newHp - player.HP)
                    });
                }
                else
                {
                    pkts.Add(new NotificationPacket
                    {
                        Color = new ARGB(0xffff0000),
                        ObjectId = player.Id,
                        Text = "" + (newHp - player.HP)
                    });
                }
                player.HP = newHp;
                player.UpdateCount++;
            }
        }

        private static void ActivateHealHp(Player player, int amount, List<Packet> pkts)
        {
            int maxHp = player.Stats[0] + player.Boost[0];
            int newHp = Math.Min(maxHp, player.HP + amount);

            if (newHp != player.HP)
            {
                pkts.Add(new ShowEffectPacket
                {
                    EffectType = EffectType.Potion,
                    TargetId = player.Id,
                    Color = new ARGB(0xffffffff)
                });
                pkts.Add(new NotificationPacket
                {
                    Color = new ARGB(0xff00ff00),
                    ObjectId = player.Id,
                    Text = "+ " + (newHp - player.HP)
                });
                player.HP = newHp;
                player.UpdateCount++;
            }
        }

        private static void ActivateHealMp(Player player, int amount, List<Packet> pkts)
        {
            int maxMp = player.Stats[1] + player.Boost[1];
            int newMp = Math.Min(maxMp, player.MP + amount);

            if (newMp != player.MP)
            {
                pkts.Add(new ShowEffectPacket
                {
                    EffectType = EffectType.Potion,
                    TargetId = player.Id,
                    Color = new ARGB(0xffffffff)
                });
                pkts.Add(new NotificationPacket
                {
                    Color = new ARGB(0xff6084e0),
                    ObjectId = player.Id,
                    Text = "+" + (newMp - player.MP)
                });
                player.MP = newMp;
                player.UpdateCount++;
            }
        }

        private void ActivateShoot(RealmTime time, Item item, Position target)
        {
            double arcGap = item.ArcGap*Math.PI/180;
            double startAngle = Math.Atan2(target.Y - Y, target.X - X) - (item.NumProjectiles - 1)/2*arcGap;
            ProjectileDesc prjDesc = item.Projectiles[0]; //Assume only one

            for (int i = 0; i < item.NumProjectiles; i++)
            {
                Projectile proj = CreateProjectile(prjDesc, item.ObjectType,
                    (int) statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                    time.TotalElapsedMs, new Position {X = X, Y = Y}, (float) (startAngle + arcGap*i));
                Owner.EnterWorld(proj);
                fameCounter.Shoot(proj);
            }
        }

        private void PoisonEnemy(Enemy enemy, ActivateEffect eff)
        {
            var remainingDmg = (int) StatsManager.GetEnemyDamage(enemy, eff.TotalDamage, enemy.ObjectDesc.Defense, enemy.ObjectDesc.Resilience, 0);
            int perDmg = remainingDmg*1000/eff.DurationMS;
            WorldTimer tmr = null;
            int x = 0;
            tmr = new WorldTimer(100, (w, t) =>
            {
                if (enemy.Owner == null) return;
                w.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Dead,
                    TargetId = enemy.Id,
                    Color = new ARGB(0xffddff00)
                }, null);

                if (x%10 == 0)
                {
                    int thisDmg;
                    if (remainingDmg < perDmg) thisDmg = remainingDmg;
                    else thisDmg = perDmg;

                    enemy.Damage(this, t, thisDmg, 0, true, null);
                    remainingDmg -= thisDmg;
                    if (remainingDmg <= 0) return;
                }
                x++;

                tmr.Reset();

                Manager.Logic.AddPendingAction(_ => w.Timers.Add(tmr), PendingPriority.Creation);
            });
            Owner.Timers.Add(tmr);
        }

        private void PoisonPlayer(Player enemy, ActivateEffect eff)
        {
            var remainingDmg =
                (int) StatsManager.GetEnemyDamage(enemy, Math.Max(1, eff.TotalDamage/5), 0, enemy.ObjectDesc.Defense, enemy.ObjectDesc.Resilience);
            int perDmg = remainingDmg*1000/eff.DurationMS;
            WorldTimer tmr = null;
            int x = 0;
            tmr = new WorldTimer(100, (w, t) =>
            {
                if (enemy.Owner == null) return;
                w.BroadcastPacket(new ShowEffectPacket
                {
                    EffectType = EffectType.Dead, //more like slight particle burst.
                    TargetId = enemy.Id,
                    Color = new ARGB(0xffddff00)
                }, null);

                if (x % 10 == 0)
                {
                    int thisDmg;
                    if (remainingDmg < perDmg) thisDmg = remainingDmg;
                    else thisDmg = perDmg;

                    enemy.Damage(thisDmg, 0, enemy);
                    remainingDmg -= thisDmg;
                    if (remainingDmg <= 0) return;
                }
                x++;

                tmr.Reset();

                Manager.Logic.AddPendingAction(_ => w.Timers.Add(tmr), PendingPriority.Creation);
            });
            Owner.Timers.Add(tmr);
        }

        private bool Activate(RealmTime time, Item item, ItemData data, int itemSlot, Position target)
        {
            if (MP < item.MpCost)
                return false;
            MP -= item.MpCost;
            bool success = true;
            foreach (ActivateEffect eff in item.ActivateEffects)
            {
                switch (eff.Effect)
                {
                    case ActivateEffects.BulletNova:
                    {
                        ProjectileDesc prjDesc = item.Projectiles[0]; //Assume only one
                        var batch = new Packet[21];
                        for (int i = 0; i < 20; i++)
                        {
                            Projectile proj = CreateProjectile(prjDesc, item.ObjectType,
                                (int) statsMgr.GetAttackDamage(prjDesc.MinDamage, prjDesc.MaxDamage), prjDesc.Penetration,
                                time.TotalElapsedMs, target, (float) (i*(Math.PI*2)/20));
                            Owner.EnterWorld(proj);
                            fameCounter.Shoot(proj);
                            batch[i] = new ShootPacket
                            {
                                BulletId = proj.ProjectileId,
                                OwnerId = Id,
                                ContainerType = item.ObjectType,
                                Position = target,
                                Angle = proj.Angle,
                                Damage = (short) proj.Damage,
                                FromAbility = false,
                                hasFormula = prjDesc.hasFormulas
                            };
                        }
                        batch[20] = new ShowEffectPacket
                        {
                            EffectType = EffectType.Trail,
                            PosA = target,
                            TargetId = Id,
                            Color = new ARGB(0xFFFF00AA)
                        };
                        BroadcastSync(batch, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Shoot:
                    {
                        ActivateShoot(time, item, target);
                    }
                        break;
                    case ActivateEffects.StatBoostSelf:
                    {
                        var idx = -1;
                        switch ((StatsType) eff.Stats)
                        {
                            case StatsType.MaximumHP: idx = 0; break;
                            case StatsType.MaximumMP: idx = 1; break;
                            case StatsType.Attack: idx = 2; break;
                            case StatsType.Defense: idx = 3; break;
                            case StatsType.Speed: idx = 4; break;
                            case StatsType.Vitality: idx = 5; break;
                            case StatsType.Wisdom: idx = 6; break;
                            case StatsType.Dexterity: idx = 7; break;
                            case StatsType.Aptitude: idx = 8; break;
                            case StatsType.Resilience: idx = 9; break;
                            case StatsType.Penetration: idx = 10; break;
                        }
                        var s = eff.Amount;
                        ActivateBoost[idx].Push(s);
                        CalculateBoost();
                        (this as Player).UpdateCount++;
                        Owner.Timers.Add(new WorldTimer(eff.DurationMS, (world, t) =>
                        {
                            ActivateBoost[idx].Pop(s);
                            CalculateBoost();
                            (this as Player).UpdateCount++;
                        }));
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.Potion,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff)
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.StatBoostAura:
                    {
                        int idx = -1;
                        switch ((StatsType) eff.Stats)
                        {
                            case StatsType.MaximumHP: idx = 0; break;
                            case StatsType.MaximumMP: idx = 1; break;
                            case StatsType.Attack: idx = 2; break;
                            case StatsType.Defense: idx = 3; break;
                            case StatsType.Speed: idx = 4; break;
                            case StatsType.Vitality: idx = 5; break;
                            case StatsType.Wisdom: idx = 6; break;
                            case StatsType.Dexterity: idx = 7; break;
                            case StatsType.Aptitude: idx = 8; break;
                            case StatsType.Resilience: idx = 9; break;
                            case StatsType.Penetration: idx = 10; break;
                            }
                        int s = eff.Amount;
                        this.AOE(eff.Range, true, player =>
                        {
                            ActivateBoost[idx].Push(s);
                            CalculateBoost();
                            player.UpdateCount++;
                            Owner.Timers.Add(new WorldTimer(eff.DurationMS, (world, t) =>
                            {
                                ActivateBoost[idx].Pop(s);
                                CalculateBoost();
                                player.UpdateCount++;
                            }));
                        });
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = eff.Range}
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.ConditionEffectSelf:
                    {
                        ApplyConditionEffect(new ConditionEffect
                        {
                            Effect = eff.ConditionEffect.Value,
                            DurationMS = eff.DurationMS
                        });
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = 1}
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.ConditionEffectAura:
                    {
                        this.AOE(eff.Range, true, player =>
                        {
                            player.ApplyConditionEffect(new ConditionEffect
                            {
                                Effect = eff.ConditionEffect.Value,
                                DurationMS = eff.DurationMS
                            });
                        });
                        uint color = 0xffffffff;
                        if (eff.ConditionEffect.Value == ConditionEffectIndex.Damaging)
                            color = 0xffff0000;
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(color),
                            PosA = new Position {X = eff.Range}
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Heal:
                    {
                        var pkts = new List<Packet>();
                        ActivateHealHp(this, eff.Amount, pkts);
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.HealNova:
                    {
                        var pkts = new List<Packet>();
                        this.AOE(eff.Range, true,
                            player => { ActivateHealHp(player as Player, eff.Amount, pkts); });
                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = eff.Range}
                        });
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Magic:
                    {
                        var pkts = new List<Packet>();
                        ActivateHealMp(this, eff.Amount, pkts);
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.MagicNova:
                    {
                        var pkts = new List<Packet>();
                        this.AOE(eff.Range, true,
                            player => { ActivateHealMp(player as Player, eff.Amount, pkts); });
                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = eff.Range}
                        });
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Teleport:
                    {
                        if (!Owner.AllowAbilityTeleport)
                        {
                            SendError("Teleporting is disabled.");
                            break;
                        }
                        Move(target.X, target.Y);
                        UpdateCount++;
                        Owner.BroadcastPackets(new Packet[]
                        {
                            new GotoPacket
                            {
                                ObjectId = Id,
                                Position = new Position
                                {
                                    X = X,
                                    Y = Y
                                }
                            },
                            new ShowEffectPacket
                            {
                                EffectType = EffectType.Teleport,
                                TargetId = Id,
                                PosA = new Position
                                {
                                    X = X,
                                    Y = Y
                                },
                                Color = new ARGB(0xFFFFFFFF)
                            }
                        }, null);
                    }
                        break;
                    case ActivateEffects.VampireBlast:
                    {
                        var pkts = new List<Packet>();
                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.Trail,
                            TargetId = Id,
                            PosA = target,
                            Color = new ARGB(0xFFFF0000)
                        });
                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.Diffuse,
                            TargetId = Id,
                            PosA = target,
                            PosB = new Position {X = target.X + eff.Radius, Y = target.Y},
                            Color = new ARGB(0xFFFF0000)
                        });

                        int totalDmg = 0;
                        var enemies = new List<Entity>();
                        Owner.AOE(target, eff.Radius, false, enemy =>
                        {
                            enemies.Add(enemy);
                            totalDmg += (enemy as Enemy).Damage(this, time, eff.TotalDamage, 0, false, null);
                        });
                        var players = new List<Player>();

                        this.AOE(eff.Radius, true, player =>
                        {
                            players.Add(player as Player);
                            ActivateHealHp(player as Player, totalDmg, pkts);
                        });

                        var rand = new Random();
                        for (int i = 0; i < 5; i++)
                        {
                            Entity a = enemies[rand.Next(0, enemies.Count)];
                            Player b = players[rand.Next(0, players.Count)];
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.Flow,
                                TargetId = b.Id,
                                PosA = new Position {X = a.X, Y = a.Y},
                                Color = new ARGB(0xffffffff)
                            });
                        }

                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Trap:
                    {
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.Throw,
                            Color = new ARGB(0xff9000ff),
                            TargetId = Id,
                            PosA = target
                        }, p => this.Dist(p) < 25);
                        Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                        {
                            var trap = new Trap(
                                this,
                                eff.Radius,
                                eff.TotalDamage,
                                0,
                                eff.ConditionEffect ?? ConditionEffectIndex.Slowed,
                                eff.EffectDuration);
                            trap.Move(target.X, target.Y);
                            world.EnterWorld(trap);
                        }));
                    }
                        break;
                    case ActivateEffects.StasisBlast:
                    {
                        var pkts = new List<Packet>();

                        pkts.Add(new ShowEffectPacket
                        {
                            EffectType = EffectType.Concentrate,
                            TargetId = Id,
                            PosA = target,
                            PosB = new Position {X = target.X + 3, Y = target.Y},
                            Color = new ARGB(0xffffffff)
                        });
                        Owner.AOE(target, 3, false, enemy =>
                        {
                            if (enemy.HasConditionEffect(ConditionEffects.StasisImmune))
                            {
                                pkts.Add(new NotificationPacket
                                {
                                    ObjectId = enemy.Id,
                                    Color = new ARGB(0xff00ff00),
                                    Text = "Immune"
                                });
                            }
                            if (enemy.ObjectDesc.StasisImmune)
                            {
                                pkts.Add(new NotificationPacket
                                {
                                    ObjectId = enemy.Id,
                                    Color = new ARGB(0xff00ff00),
                                    Text = "Immune"
                                });
                            }
                            else if (!enemy.HasConditionEffect(ConditionEffects.Stasis))
                            {
                                enemy.ApplyConditionEffect(
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Stasis,
                                        DurationMS = eff.DurationMS
                                    },
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Paused,
                                        DurationMS = eff.DurationMS
                                    },
                                    new ConditionEffect
                                    {
                                        Effect = ConditionEffectIndex.Confused,
                                        DurationMS = eff.DurationMS
                                    }
                                    );
                            }
                            Owner.Timers.Add(new WorldTimer(eff.DurationMS, (world, t) => enemy.ApplyConditionEffect(new ConditionEffect
                            {
                                Effect = ConditionEffectIndex.StasisImmune,
                                DurationMS = 3000
                            })));
                            pkts.Add(new NotificationPacket
                            {
                                ObjectId = enemy.Id,
                                Color = new ARGB(0xffff0000),
                                Text = "Stasis"
                            });
                        });
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.Decoy:
                    {
                        var decoy = new Decoy(this, eff.DurationMS, statsMgr.GetSpeed());
                        decoy.Move(X, Y);
                        Owner.EnterWorld(decoy);
                    }
                        break;
                    case ActivateEffects.Lightning:
                    {
                        Enemy start = null;
                        double angle = Math.Atan2(target.Y - Y, target.X - X);
                        double diff = Math.PI/3;
                        Owner.AOE(target, 6, false, enemy =>
                        {
                            if (!(enemy is Enemy)) return;
                            double x = Math.Atan2(enemy.Y - Y, enemy.X - X);
                            if (Math.Abs(angle - x) < diff)
                            {
                                start = enemy as Enemy;
                                diff = Math.Abs(angle - x);
                            }
                        });
                        if (start == null)
                            break;

                        Enemy current = start;
                        var targets = new Enemy[eff.MaxTargets];
                        for (int i = 0; i < targets.Length; i++)
                        {
                            targets[i] = current;
                            var next = current.GetNearestEntity(8, false,
                                enemy =>
                                    enemy is Enemy &&
                                    Array.IndexOf(targets, enemy) == -1 &&
                                    this.Dist(enemy) <= 6) as Enemy;

                            if (next == null) break;
                            current = next;
                        }

                        var pkts = new List<Packet>();
                        for (int i = 0; i < targets.Length; i++)
                        {
                            if (targets[i] == null) break;
                            Entity prev = i == 0 ? (Entity) this : targets[i - 1];
                            targets[i].Damage(this, time, eff.TotalDamage, 0, false, null);
                            if (eff.ConditionEffect != null)
                                targets[i].ApplyConditionEffect(new ConditionEffect
                                {
                                    Effect = eff.ConditionEffect.Value,
                                    DurationMS = (int) (eff.EffectDuration*1000)
                                });
                            pkts.Add(new ShowEffectPacket
                            {
                                EffectType = EffectType.Lightning,
                                TargetId = prev.Id,
                                Color = new ARGB(0xffff0088),
                                PosA = new Position
                                {
                                    X = targets[i].X,
                                    Y = targets[i].Y
                                },
                                PosB = new Position {X = 350}
                            });
                        }
                        BroadcastSync(pkts, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.PoisonGrenade:
                    {
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.Throw,
                            Color = new ARGB(0xffddff00),
                            TargetId = Id,
                            PosA = target
                        }, p => this.Dist(p) < 25);
                        var x = new Placeholder(Manager, 1500);
                        x.Move(target.X, target.Y);
                        Owner.EnterWorld(x);
                        Owner.Timers.Add(new WorldTimer(1500, (world, t) =>
                        {
                            if (Owner != null)
                            {
                                Owner.BroadcastPacket(new ShowEffectPacket
                                {
                                    EffectType = EffectType.AreaBlast,
                                    TargetId = x.Id,
                                    Color = new ARGB(0xffddff00),
                                    PosA = new Position { X = eff.Radius }
                                }, null);
                                var enemies = new List<Enemy>();
                                Owner.AOE(target, eff.Radius, false,
                                    enemy => PoisonEnemy(enemy as Enemy, eff));
                            }
                        }));
                    }
                        break;
                    case ActivateEffects.RemoveNegativeConditions:
                    {
                        this.AOE(eff.Range, true, player =>
                        {
                            ApplyConditionEffect(NegativeEffs);
                        });
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = eff.Range}
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.RemoveNegativeConditionsSelf:
                    {
                        ApplyConditionEffect(NegativeEffs);
                        BroadcastSync(new ShowEffectPacket
                        {
                            EffectType = EffectType.AreaBlast,
                            TargetId = Id,
                            Color = new ARGB(0xffffffff),
                            PosA = new Position {X = 1}
                        }, p => this.Dist(p) < 25);
                    }
                        break;
                    case ActivateEffects.IncrementStat:
                    {
                        int idx = -1;
                        switch ((StatsType) eff.Stats)
                        {
                            case StatsType.MaximumHP:
                                idx = 0;
                                break;
                            case StatsType.MaximumMP:
                                idx = 1;
                                break;
                            case StatsType.Attack:
                                idx = 2;
                                break;
                            case StatsType.Defense:
                                idx = 3;
                                break;
                            case StatsType.Speed:
                                idx = 4;
                                break;
                            case StatsType.Vitality:
                                idx = 5;
                                break;
                            case StatsType.Wisdom:
                                idx = 6;
                                break;
                            case StatsType.Dexterity:
                                idx = 7;
                                break;
                            case StatsType.Aptitude:
                                idx = 8;
                                break;
                            case StatsType.Resilience:
                                idx = 9;
                                break;
                            case StatsType.Penetration:
                                idx = 10;
                                break;
                        }
                        if (eff.Amount > 0)
                            Stats[idx] += eff.Amount;
                        else
                            Stats[idx] -= eff.Amount;
                        int limit =
                            int.Parse(
                                Manager.GameData.ObjectTypeToElement[ObjectType].Element(
                                    StatsManager.StatsIndexToName(idx)).Attribute("max").Value);
                        if (Stats[idx] > limit)
                            Stats[idx] = limit;
                        UpdateCount++;
                    }
                        break;
                    case ActivateEffects.Create: //this is a portal
                    {
                        ushort objType;
                        if (!Manager.GameData.IdToObjectType.TryGetValue(eff.Id, out objType) ||
                            !Manager.GameData.Portals.ContainsKey(objType))
                            break; // object not found, ignore
                        Entity entity = Resolve(Manager, objType);
                        entity.Move(X, Y);
                        int TimeoutTime = Manager.GameData.Portals[objType].TimeoutTime;
                        string DungeonName = Manager.GameData.Portals[objType].DungeonName;

                        Owner.EnterWorld(entity);
                        World w = Manager.GetWorld(Owner.Id); //can't use Owner here, as it goes out of scope

                        Client.SendPacket(new NotificationPacket
                        {
                            Color = new ARGB(0xff00ff00),
                            Text = "Opened by " + Client.Account.Name,
                            ObjectId = Client.Player.Id,
                        });
                        w.BroadcastPacket(new TextPacket
                        {
                            BubbleTime = 0,
                            Stars = -1,
                            Name = "",
                            Text = DungeonName + " opened by " + Client.Account.Name
                        }, null);

                        w.Timers.Add(new WorldTimer(TimeoutTime*1000, (world, t) => //default portal close time * 1000
                        {
                            try
                            {
                                w.LeaveWorld(entity);
                            }
                            catch
                                //couldn't remove portal, Owner became null. Should be fixed with RealmManager implementation
                            {
                                Console.WriteLine("Couldn't despawn portal.");
                            }
                        }));
                    }
                        break;
                    case ActivateEffects.PermaPet:
                        client.Character.Pet = Manager.GameData.IdToObjectType[eff.ObjectId];
                        GivePet(Manager.GameData.IdToObjectType[eff.ObjectId]);
                        UpdateCount++;
                        break;
                    case ActivateEffects.UnlockPortal:
                        break;
                    case ActivateEffects.Dye:
                        if (item.Texture1 != 0)
                        {
                            Texture1 = item.Texture1;
                        }
                        if (item.Texture2 != 0)
                        {
                            Texture2 = item.Texture2;
                        }
                        SaveToCharacter();
                        break;
                    case ActivateEffects.UnlockSkin:
                        if (Manager.GameData.Skins.ContainsKey((ushort) eff.SkinType))
                        {
                            SkinDesc skin = Manager.GameData.Skins[(ushort) eff.SkinType];
                            if (skin.PlayerClassType == -1 || skin.PlayerClassType == ObjectType)
                            {
                                Skin = eff.SkinType;
                                PermaSkin = !item.Consumable || (data != null ? data.MultiUse : false);
                                if (data != null && data.Effect != "")
                                {
                                    Effect = (data.FullEffect == "" ? UnusualEffects.Save(data.Effect) : data.FullEffect);
                                }
                                else
                                {
                                    Effect = "";
                                }
                                SendInfo("Successfully changed skin.");
                            }
                            else
                            {
                                success = false;
                                SendError("Your class cannot use this skin.");
                            }
                        }
                        else
                        {
                            success = false;
                            SendError("Invalid skin type.");
                        }
                        break;
                    case ActivateEffects.ShurikenAbility:
                    {
                        usingShuriken = !usingShuriken;
                        if (usingShuriken)
                        {
                            ApplyConditionEffect(new ConditionEffect
                            {
                                Effect = ConditionEffectIndex.Speedy,
                                DurationMS = -1
                            });
                        }
                        else
                        {
                            ApplyConditionEffect(new ConditionEffect
                            {
                                Effect = ConditionEffectIndex.Speedy,
                                DurationMS = 0
                            });
                            if (MP >= item.MpEndCost)
                            {
                                MP -= item.MpEndCost;
                                ActivateShoot(time, item, target);
                            }
                        }
                    }
                        break;
                    case ActivateEffects.SwitchMusic:
                        {
                            Client.SendPacket(new SwitchMusicPacket
                            {
                                Music = eff.Id
                            });
                        } break;
                    case ActivateEffects.OpenCrate:
                        {
                            success = false;
                            try
                            {
                                ItemSelect((_item, _data) =>
                                {
                                    return _item.Crate;
                                }, _slot =>
                                {
                                    bool succeeded = true;
                                    int keySlot = itemSlot;
                                    if (Inventory[itemSlot].ObjectId != "Supply Crate Key" || Inventory[itemSlot].ObjectId != "Admin Supply Crate Key" || Inventory[itemSlot].ObjectId != "Admin Supply Crate Key1")
                                    {
                                        succeeded = false;
                                        for (int i = 0; i < Inventory.Length; i++)
                                        {
                                            if (Inventory[i] == null) continue;
                                            if (Inventory[i].ObjectId == "Supply Crate Key" || Inventory[i].ObjectId == "Admin Supply Crate Key" || Inventory[i].ObjectId == "Admin Supply Crate Key1")
                                            {
                                                keySlot = i;
                                                succeeded = true;
                                                break;
                                            }
                                        }
                                    }
                                    if (succeeded)
                                    {

                                        Item originalItem = Inventory[_slot];
                                        Random rand1 = new Random();

                                        ushort[] items = new ushort[50];
                                        ItemData[] itemDatas = new ItemData[50];
                                        for (int i = 0; i < 50; i++)
                                        {
                                            var result = GetUnboxResult(originalItem, rand1);
                                            items[i] = result.Item1.ObjectType;
                                            itemDatas[i] = result.Item2;
                                        }
                                        client.SendPacket(new UnboxResultPacket
                                        {
                                            Items = items,
                                            Datas = itemDatas
                                        });

                                        if (Inventory.Data[keySlot] != null && Inventory.Data[keySlot].Doses > 0)
                                        {
                                            Inventory.Data[keySlot].Doses -= 1;
                                            if (Inventory.Data[keySlot].Doses == 0)
                                            {
                                                Inventory[keySlot] = null;
                                                Inventory.Data[keySlot] = null;
                                            }
                                        }
                                        else if (Inventory[keySlot].ObjectId == "Admin Supply Crate Key")
                                        {
                                            Inventory[keySlot] = Manager.GameData.Items[Manager.GameData.IdToObjectType["Admin Supply Crate Key1"]];
                                        }
                                        else if (Inventory[keySlot].ObjectId == "Admin Supply Crate Key1")
                                        {
                                            Inventory[keySlot] = Manager.GameData.Items[Manager.GameData.IdToObjectType["Admin Supply Crate Key"]];
                                        }
                                        else
                                        {
                                            Inventory[keySlot] = null;
                                            Inventory.Data[keySlot] = null;
                                        }
                                        Inventory[_slot] = Manager.GameData.Items[items[45]];
                                        Inventory.Data[_slot] = itemDatas[45];

                                        string msg = "{c}" + GetNameColor() + "{/c}" + Name + "{c}0xFFFFFF{/c} has unboxed: {c}" +
                                                    ((Inventory.Data[_slot] != null && Inventory.Data[_slot].NameColor != 0xFFFFFF) ? Inventory.Data[_slot].NameColor.ToString() : "0xFFFF00") + "{/c}" +
                                                    ((Inventory.Data[_slot] != null && Inventory.Data[_slot].NamePrefix != "") ? Inventory.Data[_slot].NamePrefix + " " : "") +
                                                    ((Inventory.Data[_slot] != null && Inventory.Data[_slot].Name != "") ?
                                                        Inventory.Data[_slot].Name :
                                                        Inventory[_slot].DisplayId ?? Inventory[_slot].ObjectId);

                                        Owner.BroadcastPacket(new TextPacket
                                        {
                                            BubbleTime = 0,
                                            Stars = -1,
                                            Name = "",
                                            Text = msg
                                        }, this);

                                        UpdateCount++;
                                        Owner.Timers.Add(new WorldTimer(100, (_w, _rt) =>
                                        {
                                            client.SendPacket(new InvResultPacket { Result = 1 });
                                        }));
                                    }
                                });
                            }
                            catch (Exception e)
                            {
                                Console.WriteLine(e);
                            }
                        }
                        break;
                    case ActivateEffects.RenameItem:
                        {
                            success = false;
                            this.ItemSelect((_item, _data) =>
                                {
                                    return _item != item;
                                }, _slot =>
                                {
                                    client.SendPacket(new GetTextInputPacket
                                    {
                                        Name = "Choose a new item name",
                                        Action = "renameSlot" + _slot.ToString()
                                    });
                                });
                        } break;
                    case ActivateEffects.RemoveSkin:
                        {
                            success = false;
                            if (Skin == -1)
                            {
                                SendError("No skin equipped");
                                break;
                            }
                            if (Manager.GameData.SkinToItem.ContainsKey((ushort)Skin) && !PermaSkin)
                            {
                                Inventory[itemSlot] = Manager.GameData.SkinToItem[(ushort)Skin];
                                Inventory.Data[itemSlot] = null;
                                if (Effect != "")
                                {
                                    string effId = Utils.FromCommaSepString(Effect)[0];
                                    Inventory.Data[itemSlot] = new ItemData()
                                    {
                                        NamePrefix = "Unusual",
                                        NameColor = 0x8000FF,
                                        Effect = effId,
                                        FullEffect = Effect
                                    };
                                }
                            }
                            Damage((int)Math.Ceiling((double)HP / 2), 0, this);
                            Skin = -1;
                            PermaSkin = false;
                            Effect = "";
                            UpdateCount++;
                        } break;
                    case ActivateEffects.BindSkin:
                        {
                            success = false;
                            this.ItemSelect((_item, _data) =>
                            {
                                foreach (var activEff in _item.ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnlockSkin)
                                        return (_data != null) ? !_data.Soulbound : true;
                                return false;
                            }, _slot =>
                            {
                                if(Inventory[_slot] == null)
                                {
                                    SendError("Item no longer exists");
                                    return;
                                }
                                bool isSkin = false;
                                foreach (var activEff in Inventory[_slot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnlockSkin)
                                        isSkin = (Inventory.Data[_slot] != null) ? !Inventory.Data[_slot].Soulbound : true;
                                if (!isSkin)
                                {
                                    SendError("Item is not a valid skin");
                                    return;
                                }
                                if (Inventory[itemSlot] == null)
                                {
                                    SendError("Skin keeper no longer exists");
                                    return;
                                }
                                bool succeeded = false;
                                foreach (var activEff in Inventory[itemSlot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.BindSkin)
                                        succeeded = true;
                                if (!succeeded)
                                {
                                    SendError("Invalid skin keeper");
                                    return;
                                }
                                if (Inventory.Data[_slot] == null)
                                    Inventory.Data[_slot] = new ItemData();
                                Inventory.Data[_slot].Soulbound = true;
                                Inventory.Data[_slot].MultiUse = true;

                                Inventory[itemSlot] = null;
                                Inventory.Data[itemSlot] = null;

                                UpdateCount++;
                            });
                        } break;
                    case ActivateEffects.StrangePart:
                        {
                            success = false;
                            this.ItemSelect((_item, _data) =>
                            {
                                return _item != null && _data != null && _data.Strange && !data.StrangeParts.ContainsKey(data.NamePrefix);
                            }, _slot =>
                            {
                                if (Inventory[_slot] == null || Inventory.Data[_slot] == null)
                                {
                                    SendError("Item no longer exists");
                                    return;
                                }
                                if (Inventory[itemSlot] == null || Inventory.Data[itemSlot] == null)
                                {
                                    SendError("Strange part no longer exists");
                                    return;
                                }
                                bool succeeded = false;
                                foreach (var activEff in Inventory[itemSlot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.StrangePart)
                                        succeeded = true;
                                if (!succeeded || Inventory.Data[itemSlot].NamePrefix == "")
                                {
                                    SendError("Invalid strange part");
                                    return;
                                }
                                Inventory.Data[_slot].StrangeParts.TryAdd(Inventory.Data[itemSlot].NamePrefix, 0);
                                Inventory[itemSlot] = null;
                                Inventory.Data[itemSlot] = null;

                                UpdateCount++;
                            });
                        } break;
                    case ActivateEffects.Strangify:
                        {
                            success = false;
                            if(data.NamePrefix == "")
                                break;
                            this.ItemSelect((_item, _data) =>
                            {
                                return _item != null && _item.ObjectId == data.NamePrefix && ((_data != null && !_data.Strange) || (_data == null));
                            }, _slot =>
                            {
                                if (Inventory[_slot] == null)
                                {
                                    SendError("Item no longer exists");
                                    return;
                                }
                                if (Inventory[itemSlot] == null || Inventory.Data[itemSlot] == null)
                                {
                                    SendError("Strangifier no longer exists");
                                    return;
                                }
                                bool succeeded = false;
                                foreach (var activEff in Inventory[itemSlot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.Strangify)
                                        succeeded = true;
                                if (!succeeded || Inventory.Data[itemSlot].NamePrefix != Inventory[_slot].ObjectId)
                                {
                                    SendError("Invalid strangifier");
                                    return;
                                }
                                if (Inventory.Data[_slot] == null)
                                    Inventory.Data[_slot] = new ItemData();
                                Inventory.Data[_slot].Strange = true;
                                Inventory.Data[_slot].NamePrefix = "Strange";
                                Inventory.Data[_slot].NameColor = 0xFF5A28;
                                Inventory[itemSlot] = null;
                                Inventory.Data[itemSlot] = null;

                                UpdateCount++;
                            });
                        } break;
                    case ActivateEffects.UnbindSkin:
                        {
                            success = false;
                            if (Skin != -1)
                            {
                                SendError("You cannot wear a skin while unbinding a skin item.");
                                break;
                            }
                            this.ItemSelect((_item, _data) =>
                            {
                                foreach (var activEff in _item.ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnlockSkin)
                                        return _data != null && _data.Soulbound && _data.MultiUse;
                                return false;
                            }, _slot =>
                            {
                                if (Skin != -1)
                                {
                                    SendError("You cannot wear a skin while unbinding a skin item.");
                                    return;
                                }
                                if (Inventory[_slot] == null)
                                {
                                    SendError("Item no longer exists");
                                    return;
                                }
                                bool isSkin = false;
                                foreach (var activEff in Inventory[_slot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnlockSkin)
                                        isSkin = Inventory.Data[_slot] != null && Inventory.Data[_slot].Soulbound && Inventory.Data[_slot].MultiUse;
                                if (!isSkin)
                                {
                                    SendError("Item is not a valid skin");
                                    return;
                                }
                                if (Inventory[itemSlot] == null)
                                {
                                    SendError("Skin disowner no longer exists");
                                    return;
                                }
                                bool succeeded = false;
                                foreach (var activEff in Inventory[itemSlot].ActivateEffects)
                                    if (activEff.Effect == ActivateEffects.UnbindSkin)
                                        succeeded = true;
                                if (!succeeded)
                                {
                                    SendError("Invalid skin disowner");
                                    return;
                                }
                                if (Inventory.Data[_slot] != null)
                                {
                                    Inventory.Data[_slot].Soulbound = false;
                                    Inventory.Data[_slot].MultiUse = false;
                                }

                                Inventory[itemSlot] = null;
                                Inventory.Data[itemSlot] = null;

                                UpdateCount++;
                            });
                        } break;
                }
            }
            UpdateCount++;
            return success;
        }
    }
}