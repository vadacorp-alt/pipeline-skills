# Proof contract and calibration

Read for every proof. Adapt assertions to the real business contract; examples
here are candidate invariants, not a schema or new requirements for every app.

## Ground the environment and fixtures

- Record revision plus relevant dirty-source hashes, runner/runtime/DB versions,
  applied schema/migration identity, isolation level, roles, worker/pool mode where
  relevant. Verify requests reach that implementation and database.
- Before writing, verify the database and mutating dependencies are isolated test
  resources. A `staging` or `localhost` hostname is insufficient: local PHP or a
  staging site may still use a production DB. Use effective configuration and a
  dedicated test database/tenant or environment marker. Missing isolation evidence
  blocks writes, not read-only preparation.
- Use a unique namespace per run and independent fixtures per case. Commit setup
  so HTTP workers can see it. Never wrap the whole suite in one rollback transaction
  when the real actions use other sessions and commit.
- Seed reachable state through supported factories or real migrations. Establish
  how the supported system creates or retains that business state; a schema-valid
  row can still encode an impossible history. SQL setup may abbreviate a supported
  path, but cannot establish reachability by itself. Preserve
  constraints, triggers, RLS, and normal defaults. Do not recreate only the tables
  or functions that make the test pass. Assert fixture count, ownership, balances,
  and required preconditions before the attack.
- Separate setup, actor, and observer clients. Privileged setup/read-only observation
  are acceptable; privileged actions cannot prove ordinary-user auth. Use an owner
  control and known same-role second owner; add other actors for relevant claims.

When the change adds or alters configuration handling, include a supported value
different from the default for each independently affected setting or rule. Set it
through the supported configuration source and choose an input whose observable
outcome differs from hard-coding the default. Merely echoing the configured value
does not prove it controls behavior. Keep the relevant default/fallback control and
restore or isolate configuration. Do not alter unrelated settings, invent configurability,
enumerate all combinations, or override private state to bypass the real loading path.
Missing required configuration evidence is a gap, not a default-only pass.

## Independent state oracle

Derive expectations from approved business rules, fixture constants, and a small
independent calculation. Never call the SUT's balance calculator, authorization
helper, or serializer to decide what should have happened.

Assert contractual behavior, not incidental implementation details. An opaque ID
needs its promised type/nonemptiness, identity mapping, and uniqueness—not the current
generator's hex length or prefix unless the public contract specifies that format.
Likewise, do not pin row order, the winning worker, exact timestamps, query counts,
or response prose unless promised. Compare unordered sets as sets. If a concrete
false-red concern warrants checking sensitivity to an incidental detail, use the
smallest contract-preserving variation (for example, another permitted ID format).
Keep it separate from a defect mutation; do not build a variation framework or require
a separate variant for every otherwise adequate assertion.

Take before/after committed snapshots through an independent observer, scoped to
known run IDs. Include nonempty row sets, exact amounts, statuses, row counts,
foreign keys, ownership, operation IDs, ledger entries, reservations, and required
outbox/audit/provider effects. Compare **sets of IDs**, not only counts. Include
protected foreign-owner sentinel rows in negative checks.

Use integer minor units or exact decimals with the actual currency rounding rule.
For a closed transfer without fees:

```text
debit_total = credit_total
balance_after = balance_before + committed_credits - committed_debits
sum(all_account_balances_after) = sum(all_account_balances_before)
ledger_effects = effects expected from distinct committed logical operations
```

Account explicitly for fees, holds, refunds, taxes, minted credits, or external
settlement. Conservation alone misses transfers to the wrong owner, offsetting
double charges/refunds, and shared operation IDs. Assert identity, authorization,
individual balances, and causal effect mapping too.

For rejection, assert the documented HTTP/RPC outcome **and** absence of forbidden
effects. Legitimate audit/rate-limit records may change. Rollback need not restore
sequence counters or erase permitted diagnostic records.

For non-financial pipelines, use equivalent domain invariants: capacity, entitlement,
membership uniqueness, inventory reservations, ownership, allowed transitions, or
publication state. Do not invent balances for an unrelated feature.

## Account for requests and effects separately

Track each dispatched attempt with a request ID and each logical operation with
its business/idempotency key. Response delivery differs from durable execution,
especially after a timeout following commit.

```text
N_dispatched = N_expected_success_responses + N_expected_rejection_responses
             + N_transport_or_unexpected_responses + N_no_response

N_distinct_logical_operations = N_committed + N_terminally_rejected + N_unresolved
```

These sets are disjoint within each equation. Only a completed protocol justifies
`N_unresolved = 0`. No-fault cases also require zero unexpected/missing responses.
For injected response loss, classify that loss exactly and reconcile through the
supported status/retry protocol.

Two successful replay responses may mean one committed operation. Distinct keys
spending insufficient total funds must have the exact contract-defined number of
durable successes and business rejections. Do not require a particular winner unless
the API guarantees ordering. `successes <= limit` alone lets deny-all pass.

A rejected changed-payload replay is an attempt-level rejection; it does not turn
an already committed logical operation into a second terminally rejected operation.
Use the real tenant/actor/key scope when grouping operations.

Check response schemas, stable domain codes, identity, and committed effects.
Disable redirects that could turn login into 200. A 404 is valid denial only when
the fixture and route independently exist. No blanket 4xx/5xx range, generic
exception, or connection failure may count as successful protection.

## Completion, isolation, and diagnostics

- Build explicit case/worker inventories and join every worker with deadlines.
  Require every case to reach its named assertions. Continue independent cases
  after failure with fresh fixtures.
- Observe final state before cleanup. For async work, wait on terminal state/job
  receipts with monotonic deadlines. Do not use fixed sleeps as settlement proof.
  Poll observations, not repeated business writes.
- Check lock/transaction/job ownership and recovery before closing connections or
  deleting rows. Release barriers in `finally`; cancel only this run's workers,
  remove only its fixtures, and retain cleanup failures separately.
- Preserve original errors, child exits, and suite completion in wrappers, pipelines,
  and traps. No `|| true`, pass-after-retry, swallowed exception, expected-failure
  marker, or zero-test success may make the gate green.
- Print invariant ID, case, request IDs, expected/observed values, schedule events,
  and redacted error categories. Never dump credentials or real customer data.
- **Evidence Receipt format**: Format terminal output as a bounded Evidence Receipt:
  `[RECEIPT:VERDICT] | INVARIANT=<id> | BOUNDARY=<entrypoint> | POSITIVE_CONTROL=<status> | ASSERTION=<quote> | RAW_LOG=<filepath>`.
  Keep verbose payload bodies and server traces in the archived raw log file.

## Conditional calibration, without recursive meta-testing

Calibration asks whether the **same test** distinguishes the target invariant
holding from it being broken. It does not establish that the unchanged product is
defective or that an invented fixture is reachable. Ordinary review does not require
synthetic calibration. Perform it for an explicit user/existing-gate requirement or
a concrete sensitivity question about the scoped regression, not as a new objective.

1. Prefer an existing runnable before/after pair with the same contract. Existing
   observed failing-before evidence can serve when its relevant inputs and oracle
   match. Do not repeat calibration whose evidence remains applicable.
2. If needed and authorized, use one narrow behavioral mutation for the identified
   question in a disposable copy. Do not create a mutation runner or add unrelated
   mutations to reach a score. Never remove multiple independent guards merely to
   make the real architecture look vulnerable. An intentionally broader defect
   variant, if specifically requested, still proves only that variant's sensitivity.
3. If an optional probe is inconclusive, record the limit and stop expanding it.
   Missing explicitly required calibration remains `UNVERIFIED`; missing optional
   calibration does not turn otherwise complete review red. A reached real product
   violation remains `FAIL_PRODUCT` even without a correct control. Never invent
   a product repair or a second implementation to manufacture that control.

Keep tests, inputs, schedules, and oracles identical. Verify the executed mutant
builds/starts and reaches the target assertion. Require its exact failure ID and
observed state; syntax errors, missing imports, unrelated assertions, and generic
timeouts are invalid calibration.

Use a separate copy/database per variant. Never mutate shared source, reuse old
variant state, change assertions to get red, or lower timeouts to kill a mutant.
A surviving mutation can mean missing sensitivity, an unexecuted path, or protection
by another guard/equivalence. Inspect the scoped path before drawing a conclusion.
Do not require killing arbitrary or equivalent mutants.

If other guards still prevent the violation, an ineffective mutation is not
automatically a test defect. Record that reason and stop chasing that mutant. Repair
the test only when an identified reachable violation can escape its required check,
or another concrete execution/false-red defect is demonstrated. Do not disable the
remaining protection, invent more state, or add tests of the calibration machinery
just to obtain red. Independent cases/variants keep one early failure from pretending
to prove all claims. Calibration concerns the contract, not coverage or mutant count.

Repeat a bounded, predeclared number of clean runs when useful for state leakage or
schedule stability. All calibrated runs must reach the target events; a contrary
outcome revokes the determinism claim. Repetition supports evidence; it cannot
prove correctness of untested schedules or environments.

Classify fault evidence precisely: deliberately lost response = stimulus;
unintentionally unreachable DB = `BLOCKED_ENV`; observed partial commit after the
reached injected failure = `FAIL_PRODUCT`.
