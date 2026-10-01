# Concurrency, faults, and recovery

Read for races, locking, rollback, retries, workers, or distributed effects. A
concurrent client does not establish concurrent server execution or a DB schedule.

## Make the schedule observable

Use independent clients/processes and application/database sessions where required.
Verify the server and pool allow the relevant overlap; a single-worker dev server
or shared connection can serialize the scenario. Start timestamps are insufficient.

Identify the vulnerable interval and record named events with request/session IDs.
First show why the real workers, transaction boundaries, and isolation permit this
interval. A state visible only after splitting an atomic operation in the test is
not a product execution. A valid simulator may control when an allowed event occurs,
but may not invent impossible dependency behavior or remove a protecting mechanism.
Use existing test hooks, a recording dependency with a controlled barrier, or
observed DB waits. If new instrumentation is needed, identify its exact location
and authorization before changing app code. It must be inert in normal execution,
unavailable to production clients, and alter only scheduling or a named injected
fault, never authorization, transactions, constraints, isolation, or result data.

Prefer synchronization outside the product's mutual-exclusion region, for example:

```text
A reaches the boundary before acquiring the contested product resource
A pauses; B reaches the same boundary; controller records both arrivals
controller releases A into its real critical section and observes progress
controller releases B; observer records its actual wait/rejection or stale progress
controller releases A's remaining pause; reconcile responses and commits
```

Adapt to the actual bug: this alone does not guarantee a stale read. If a lost
update requires pausing after A's read, show that the pause preserves semantics
and observe whether B reads or is correctly prevented. A correct implementation
may serialize B before the vulnerable point. Positively observed protection followed
by correct completion is valid evidence, not failure to reach a buggy schedule.

**Never put a two-party barrier after an exclusive lock both parties must acquire.**
The correct implementation blocks the second party and the harness deadlocks.
Never manufacture a race by removing a product lock in the tested baseline.
Missing arrival/hook/wait evidence means the deterministic claim is unverified;
more concurrency or sleeps do not fix it.

Bound waits and collect an event trace. Controller failure is `FAIL_HARNESS`. A
reached product path missing an established liveness deadline can be `FAIL_PRODUCT`
when healthy controls and traces exclude a harness deadlock/unavailable dependency.
Do not invent a latency SLA to get red.

## Inject failures at meaningful boundaries

Select the smallest fault set covering the reachable claim. Tie each injected failure
to an actual dependency/process failure and a relevant resilience obligation; this
table does not make every fault point mandatory for every review:

| Fault point | Required observations |
| --- | --- |
| Before any write | Exact error/rejection, no forbidden effects, later valid request succeeds. |
| After an intermediate write, before commit | Write/fault point reached, all business writes roll back, no committed downstream effect. |
| After commit, before response delivery | Valid committed state; normal same-key status/retry resolves uncertainty without a second effect. |
| After work publication/provider acceptance, before acknowledgement | Real consumer handles redelivery/restart; receipts and local durable effects reconcile. |

Throwing in the test process does not prove an application rollback. Inject through
an actual dependency/failpoint and verify the correlated event. Observe state before
retry so eventual repair cannot hide a forbidden partial commit. For atomic-visibility
claims, also observe paused intermediate state from another session.

Exercise documented application retry behavior. Disable ordinary client retries
unless the retry protocol is under test; record every attempt. Whole-test reruns
cannot rescue failure. Serialization/deadlock errors may be valid internal outcomes
if handled according to contract. Never require a particular PostgreSQL victim.

For idempotency, select applicable cases: sequential replay, concurrent same-key
replay, distinct keys on one scarce resource, changed payload with the same key,
retry after response loss. Respect the documented key scope/lifetime; do not assume
global uniqueness or eternal deduplication.

## Locks, sessions, and asynchronous effects

Do not require global `pg_locks` to be empty: healthy sessions hold normal locks,
and some locks may outlive transactions. Check this run's blocking relationships,
owned locks, and unexpected open/aborted transactions after work completes.
Distinguish session advisory locks from transaction locks and account for pooling.
Supplement metadata with a bounded legitimate follow-up on the **same contested
resource**, before cleanup closes potentially leaking sessions.

For workers, observe terminal jobs, delivery attempts, deduplication identity,
outbox entries, business effects, and recording-provider receipts. At-least-once
delivery may duplicate deliveries; it need not duplicate business effects. An
outbox row proves local enqueueing, not external delivery. `pending` is not settled
unless deferred work is explicitly the declared tested boundary.

Never claim exactly-once distributed delivery or rollback of an accepted external
charge. Test documented deduplication, reconciliation, or compensation and its final
state. For eventual compensation, use the real deadline and disclose provider limits.

Primary references checked 2026-09-05; use the project's actual server version for
version-sensitive behavior:

- [PostgreSQL isolation, serialization failures, and retries](https://www.postgresql.org/docs/current/transaction-iso.html).
- [PostgreSQL deadlocks and advisory-lock lifetimes](https://www.postgresql.org/docs/current/explicit-locking.html).
