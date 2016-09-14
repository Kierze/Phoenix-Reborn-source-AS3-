using System;

namespace wServer.realm.entities
{
    partial class Player
    {
        private int CanTPCooldownTime;
        private float bleeding;
        private int healCount;
        private float healing;
        private int EntryInvincibleTime;

        public bool IsVisibleToEnemy()
        {
            if (HasConditionEffect(ConditionEffects.Paused))
                return false;
            if (HasConditionEffect(ConditionEffects.Invisible))
                return false;
            if (EntryInvincibleTime > 0)
                return false;
            return true;
        }

        private void HandleEffects(RealmTime time)
        {
            if (HasConditionEffect(ConditionEffects.Healing))
            {
                if (healing > 1)
                {
                    HP = Math.Min(Stats[0] + Boost[0], HP + (int) healing);
                    healing -= (int) healing;
                    UpdateCount++;
                    healCount++;
                }
                healing += 28*(time.ElaspedMsDelta/1000f);
            }
            if (HasConditionEffect(ConditionEffects.Quiet) &&
                MP > 0)
            {
                MP = 0;
                UpdateCount++;
            }
            if (HasConditionEffect(ConditionEffects.Bleeding) &&
                HP > 1)
            {
                if (bleeding > 1)
                {
                    HP -= (int) bleeding;
                    bleeding -= (int) bleeding;
                    UpdateCount++;
                }
                bleeding += 28*(time.ElaspedMsDelta/1000f);
            }

            if (EntryInvincibleTime > 0)
            {
                EntryInvincibleTime -= time.ElaspedMsDelta;
                if (EntryInvincibleTime < 0)
                    EntryInvincibleTime = 0;
            }
            if (CanTPCooldownTime > 0)
            {
                CanTPCooldownTime -= time.ElaspedMsDelta;
                if (CanTPCooldownTime < 0)
                    CanTPCooldownTime = 0;
            }
        }

        private bool CanHPRegen()
        {
            if (HasConditionEffect(ConditionEffects.Sick))
                return false;
            if (HasConditionEffect(ConditionEffects.Bleeding))
                return false;
            return true;
        }

        private bool CanMPRegen()
        {
            if (HasConditionEffect(ConditionEffects.Quiet))
                return false;
            return true;
        }

        internal void SetInvinciblePeriod()
        {
            EntryInvincibleTime = 5*1000; //5 seconds
        }

        internal void SetTPDisabledPeriod()
        {
            CanTPCooldownTime = 10*1000; // 10 seconds
        }

        public bool TPCooledDown()
        {
            if (CanTPCooldownTime > 0)
                return false;
            return true;
        }
    }
}