# Optional extensions driven by the pipeline

Core proof requirements apply to every task. Add these when the reviewed change,
incident, or requested scope reaches the risk. Keep related cases in the same run
with isolated fixtures. This table does not mandate a full-system audit.

| When useful | Extension | Avoiding false confidence and false alarms |
| --- | --- | --- |
| Money, quota, inventory, entitlement | Zero, negative, exact limit, one unit over, rounding and overflow | Independent exact arithmetic and transitions; no floating-point tolerance or invented currency scale. |
| Oracle may depend on current implementation details | Contract-preserving positive variation: another valid ID format or allowed result order | Same assertions remain green; separate harmless variation from a targeted defect mutation. |
| Ownership, admin roles, public RPC, SECURITY DEFINER | Owner/stranger/anonymous/admin matrix; genuinely exposed bypass paths | Allowed and forbidden read/write effects; privileged setup credentials never act as attacker. |
| RLS, role changes, pooling, account switching | A→B→A across reused sessions; access after role/ownership change | Check identity and stale privileges/cache; initialization key alone does not prove DB role. |
| Payment/delivery callbacks | Valid/wrong signature, modified signed field, duplicate/delayed event | Real verification/parsing and valid control; signed amount/order/currency and effects reconcile. |
| Final sums can hide impossible concurrent histories | Bounded history/linearizability check with independent sequential model | Respect order of non-overlapping calls and actual consistency contract; no prescribed winner. |
| Expiry, backoff, leases, dedupe windows | Controlled clock boundaries, restart, stale worker, recovery | Compatible clocks and before/at/after checks; no sleeps or artificial instant expiry. |
| Queue, outbox, provider | Lost acknowledgement, duplicates, allowed reordering, consumer restart | Local effects and provider receipts; queue acceptance does not equal delivery. |
| Many valid input combinations | Seeded property-based cases, shrinking, independent model | Save seed/minimal history; exploratory search becomes regression only when pinned. |
| Resource exhaustion/degraded dependency contract | Bounded saturation, pool pressure, timeout/rate-limit recovery | Measure resource and semantic result; healthy baseline calibrates thresholds, not arbitrary milliseconds. |
| Upgrade/migration/backward compatibility | Real supported old state → real migration → public flow | Actual order/constraints; local upgrade evidence is distinct from production state. |

Suggested progression:

1. **Core proof:** reachable state and real boundary/persistence, exact independent
   oracle, positive controls, completed execution, explicit verdict. Use before/after
   evidence for a reproduced fix; synthetic calibration is conditional, not a new gate.
2. **Concurrency/recovery:** controlled schedule, idempotency, fault boundaries,
   committed observations, resource release, legitimate recovery.
3. **Broader assurance when requested:** property-based exploration, bounded history
   checking, resource pressure, and provider-sandbox contracts.

Broader modes increase tested scope. They do not turn a finite suite into a
guarantee of universal security, availability, or production readiness.
