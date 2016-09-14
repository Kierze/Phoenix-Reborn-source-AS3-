using wServer.realm;

namespace wServer.logic.behaviors
{
    internal class BackAndForth : CycleBehavior
    {
        //State storage: remaining distance

        private readonly int distance;
        private readonly float speed;

        public BackAndForth(double speed, int distance = 5)
        {
            this.speed = (float) speed;
            this.distance = distance;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            float dist;
            if (state == null) dist = distance;
            else dist = (float) state;
            double effectiveSpeed = speed;

            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffects.Paralyzed)) return;

            if (host.HasConditionEffect(ConditionEffects.Slowed)) effectiveSpeed = speed * 0.5;
            else effectiveSpeed = speed;

            float moveDist = host.GetSpeed((float)effectiveSpeed)*(time.ElaspedMsDelta/1000f);
            if (dist > 0)
            {
                Status = CycleStatus.InProgress;
                host.ValidateAndMove(host.X + moveDist, host.Y);
                host.UpdateCount++;
                dist -= moveDist;
                if (dist <= 0)
                {
                    dist = -distance;
                    Status = CycleStatus.Completed;
                }
            }
            else
            {
                Status = CycleStatus.InProgress;
                host.ValidateAndMove(host.X - moveDist, host.Y);
                host.UpdateCount++;
                dist += moveDist;
                if (dist >= 0)
                {
                    dist = distance;
                    Status = CycleStatus.Completed;
                }
            }

            state = dist;
        }
    }
}