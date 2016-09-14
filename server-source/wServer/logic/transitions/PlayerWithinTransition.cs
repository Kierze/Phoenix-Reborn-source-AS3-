using wServer.realm;

namespace wServer.logic.transitions
{
    internal class PlayerWithinTransition : Transition
    {
        //State storage: none

        private readonly double dist;

        public PlayerWithinTransition(double dist, string targetState)
            : base(targetState)
        {
            this.dist = dist;
        }

        protected override bool TickCore(Entity host, RealmTime time, ref object state)
        {
            return host.GetNearestEntity(dist, null) != null;
        }
    }

    internal class RandomPlayersWithinTransition : Behavior
    {
        private readonly string[] choices;
        private readonly double dist;

        public RandomPlayersWithinTransition(double dist, params string[] choices)
        {
            this.choices = choices;
            this.dist = dist;
        }

        protected override void OnStateEntry(Entity host, RealmTime time, ref object state)
        {
            state = null;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            if (state == null)
                state = (string)choices[Random.Next(0, choices.Length)];
            if (host.GetNearestEntity(dist, null) != null)
                new SimpleTransition((string)state).Tick(host, time);
        }
    }
}