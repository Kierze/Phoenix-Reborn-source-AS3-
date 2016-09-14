using Mono.Game;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.logic.behaviors
{
    internal class StayBack : CycleBehavior
    {
        //State storage: cooldown timer

        private readonly float distance;
        private readonly float speed;

        public StayBack(double speed, double distance = 8)
        {
            this.speed = (float) speed;
            this.distance = (float) distance;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            double effectiveSpeed;
            int cooldown;
            if (state == null) cooldown = 1000;
            else cooldown = (int) state;

            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffects.Paralyzed)) return;

            if (host.HasConditionEffect(ConditionEffects.Slowed)) effectiveSpeed = speed * 0.5;
            else effectiveSpeed = speed;

            var player = host.GetNearestEntity(distance, null);
            if (player != null)
            {
                Vector2 vect;
                vect = new Vector2(player.X - host.X, player.Y - host.Y);
                vect.Normalize();
                float dist = host.GetSpeed((float)effectiveSpeed)*(time.ElaspedMsDelta/1000f);
                host.ValidateAndMove(host.X + (-vect.X)*dist, host.Y + (-vect.Y)*dist);
                host.UpdateCount++;

                if (cooldown <= 0)
                {
                    Status = CycleStatus.Completed;
                    cooldown = 1000;
                }
                else
                {
                    Status = CycleStatus.InProgress;
                    cooldown -= time.ElaspedMsDelta;
                }
            }

            state = cooldown;
        }
    }
}