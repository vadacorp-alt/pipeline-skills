# Checks that the independent reviewer can reuse

Use for non-trivial changed behavior and review fixes. Start from existing adequate
tests and the task contract. Spend effort on the behavior at risk, not on more test
files, higher arbitrary coverage, or proving the test framework itself.

## Select evidence by the change

| Change | Necessary evidence |
| --- | --- |
| Reported defect | Reachable trigger, targeted failing-before assertion when feasible, same assertion passing after, and legitimate-flow controls. A missing runtime or generic crash is not the target failure. |
| New behavior | Agreed acceptance through the actual relevant entrypoint, plus preservation of affected existing behavior. A feature absent in the baseline is not automatically an old product defect. |
| Refactor without behavior change | Existing contract checks before/after, including affected callers of moved/shared logic. Do not preserve incidental bugs by declaring all current output correct. |
| Money, authorization, persistent state, retries/transactions | Integration proof from the real public boundary to committed state and required downstream effects; isolated module mocks alone are insufficient. |
| UI interaction/layout | Relevant actual interaction/rendering and its state transitions using the existing tools. Do not invent backend requirements for a visual change. |
| Text-only edit (typo, description, display-only number) | Follow the text-only exception in [SKILL.md](../SKILL.md#text-only-edits-minimal-verification): inspect the diff; automated tests may be omitted. Reuse unaffected existing evidence; no new tests or broad reruns solely for copy changes. Check rendering only for a concrete layout/formatting concern. |
| Trivial reversible edit | Existing focused validation when useful; no artificial unit suite or integration framework merely to touch every line. |

Trace the complete relevant business flow before choosing the smallest sufficient
check. Pure-function tests can complement integration proof; a mock repository,
direct private call, or local demo cannot claim to cover omitted authentication,
database rules, worker effects, or provider behavior.

For added or changed configuration handling, exercise a supported non-default value
for each independently affected setting or rule through its real configuration source.
Choose an input whose outcome would differ if production code ignored that value and
used the default. Assert the resulting behavior, not just that the setting can be read;
retain relevant default/fallback behavior and isolate or restore configuration. This
does not require a matrix of unrelated settings, all value combinations, new knobs,
or synthetic mutations. An unavailable required configuration path stays unverified.

## Preserve the reviewer's proof properties

- Use the project's actual public interface, real persistence engine, normal schema,
  constraints, policies, triggers and transactions. PostgreSQL behavior is not proved
  with SQLite. Source-verified legitimate fixture setup may abbreviate real creation
  paths; schema acceptance alone does not prove a reachable business state.
- Verify effective isolated test configuration before database/provider mutations.
  `localhost` or `staging` alone is insufficient. Separate privileged setup/observer
  from ordinary actor requests; do not turn an admin fixture client into the attacker.
- Derive expected amounts, ownership, states and effects independently from the
  contract and known inputs. Inspect before/after committed state through an
  independent observer. Compare exact counts/IDs/values relevant to the invariant;
  do not pin incidental ID encoding, result order, worker winner or response prose.
  Reuse a production helper in the implementation, not as the expected-value oracle
  for that same helper's result. Calling it on an observer connection still shares
  its logic; derive the expectation from independent raw state/contract constants.
- Pair denial/failure cases with successful legitimate operations, including recovery
  when relevant. Deny-all, empty selections, missing fixtures, skipped cases and a
  generic non-2xx must not masquerade as protection. Prove the targeted path was reached.
- Account for all dispatched attempts separately from distinct logical operations and
  durable effects. Retries can produce several success responses for one effect;
  a lost response can follow a committed operation. Preserve unknown outcomes until
  the supported protocol resolves them; do not hide them among business rejections.
- Execute all named independent cases and join required workers. Preserve assertions,
  unexpected errors and exit codes; no swallowed exceptions, early success, `xfail`,
  zero-test success or rerun-until-green to satisfy a required gate.
- Observe required rollback, compensation, settled state and resource release before
  cleanup erases evidence. Use scoped cleanup; deleting rows or closing a leaked
  connection is not proof that the product recovered on its own.

For one bounded pipeline, prefer an existing integration file/command or a narrow
extension. Several isolated cases in one file are fine. Keep existing useful test
organization; do not merge unrelated suites or add an umbrella runner solely for
formatting. Cover required new behavior and preservation, not every conceivable state.

## Concurrency and faults, only when causally relevant

Use real independent server/database execution and observable synchronization at
allowed scheduling points. Parallel dispatch and sleeps do not establish deterministic
overlap. Do not manufacture a race by removing an active lock or splitting an atomic
operation. Correct protected serialization must remain a valid result.

Never place a barrier requiring both parties after the exclusive lock they both
need: that creates a test deadlock. Observe lock waits/events and allow correct
completion. A fault must represent a real dependency/process failure at a reachable
boundary; throwing inside the test is not an application rollback test. Keep any
necessary test hook inert in normal execution and unavailable to production callers.

Use the real retry, deduplication, key lifetime, reconciliation and recovery contract.
Check the final effects and resource release before teardown. Queue acceptance is
not delivery; provider simulation proves bounded local handling, not live settlement.
Do not invent an SLA, failpoint, corruption history or network guarantee to get red.
An unobserved required schedule remains unverified even when a serial case passes.

## Stop at adequate evidence

Keep before/after inputs and meaningful assertions stable. Change an assertion only
with a demonstrated contract error, and record why. If another actual guard prevents
a mutation's effect, do not dismantle it, require every mutant to die, or build tests
of tests. Synthetic calibration is optional unless the user/existing gate requires it.
An optional sensitivity probe cannot silently become a new acceptance condition.

Use the same check result meanings as `pipeline-proof-review`: `PASS` (required case
completed correctly), `FAIL_PRODUCT` (reached supported behavior violates the rule),
`FAIL_HARNESS` (test/fixture/controller/observer failure), `BLOCKED_ENV` (required
environment missing), `UNVERIFIED` (required evidence not obtained). Optional checks
are distinct; skipped mandatory coverage prevents a complete verification verdict.
Mixed results retain both the demonstrated failure and the remaining coverage gap.

Record commands, case/invariant IDs, source identity including relevant dirty state,
environment, and actual outcome. Reuse results only while their relevant assumptions
remain unchanged. Missing infrastructure does not justify weakening the proof or
claiming readiness; complete feasible implementation and state what still needs a run.

## Evidence Receipts and Observation Boundary

To keep context windows clean and avoid polluting prompt cache prefixes:
- Format verification output as a clean Evidence Receipt (`[RECEIPT:VERDICT] | INVARIANT=<id> | ASSERTION=<quote> | RAW_LOG=<filepath>`).
- Direct heavy raw stdout/stderr to `tmp/proof_runs/` or test log files.
- Prefer `python scripts/test_evidence_runner.py <test_file>` for automated extraction of failed invariants and positive controls.
