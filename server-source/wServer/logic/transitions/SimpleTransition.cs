using wServer.realm;

namespace wServer.logic.transitions
{
    internal class SimpleTransition : Transition
    {
        private readonly string targetState;
        public SimpleTransition(string targetState)
            : base(targetState)
        {
            this.targetState = targetState;
        }

        protected override bool TickCore(Entity host, RealmTime time, ref object state)
        {
            return true;
        }
    }

    internal class ChangeState : Behavior
    {
        private readonly string target;

        public ChangeState(string targetState)
        {
            this.target = targetState;
        }

        protected override void OnStateEntry(Entity host, RealmTime time, ref object state)
        {
            state = null;
        }

        protected override void TickCore(Entity host, RealmTime time, ref object state)
        {
            new SimpleTransition(target).Tick(host, time);
        }
    }
}