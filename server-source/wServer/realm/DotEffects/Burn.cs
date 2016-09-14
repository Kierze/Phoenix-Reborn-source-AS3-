using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wServer.realm.entities;

namespace wServer.realm
{
    public class Burn
    { 
        public ActivateAbility abil = null;
        public Enemy enemy;
        public int remainingDmg;
        public int perDmg;
        public int count = 0;

        public Burn(Enemy enemy, ActivateAbility abil)
        {
            this.abil = abil;
            this.enemy = enemy;

            remainingDmg = (int)StatsManager.GetEnemyDamage(enemy, abil.TotalDamage, enemy.ObjectDesc.Defense, enemy.ObjectDesc.Resilience, 0);
            perDmg = remainingDmg * 1000 / abil.DurationMS;

        }
    }
}
