---
name: pipeline-proof-review
description: >
  Primary code-review workflow for reachable business, security, and resilience
  defects, with reproducible public-boundary integration tests and scoped re-review.
  Use for code review, ревью кода, pipeline audits, race conditions, duplicate payments,
  authorization, rollback, and regression verification. Rejects manufactured states
  and unbounded test-infrastructure work; produces executable evidence with positive
  controls and a ready-to-forward coder task for confirmed open blockers.
  Not a substitute for visual-only review or a request limited to static analysis.
---

# Pipeline Proof Review

Act as Lead QA Architect / Security Auditor. Discover reachable defects, express the
correct behavior as independent invariants, and test through the actual entrypoint.
Do not assume defects exist because a prompt says so.

Deliver one test file and one reproducible command for a bounded business pipeline.
Reuse or extend an adequate existing test; a review does not require a new harness.
The file may contain multiple isolated cases with a shared runner. Each case must
traverse the relevant pipeline. An early failure must not hide other independent
cases. Do not combine unrelated pipelines into an unmaintainable test. If a literal
single test is requested, use named isolated phases and aggregate their results
without converting failures into passes.

A finite test proves behavior only for its recorded inputs, schedule, environment,
and oracle. Never claim that one test proves the whole system secure or detects
every possible race with 100% probability.

## Scope and mandatory skill use

Read project instructions and global/workspace routing (`~/.codex/routing.md`, `~/.agents/routing.md`, or `routing.md`) when present.
Before designing or implementing tests, consult
[specialist-routing.md](references/specialist-routing.md) under strict Lazy Loading:
never batch-read companion skills upfront and never invoke `view_file` for any skill,
guide, or plan already loaded in the active conversation context. Load a specialist
skill strictly on demand when a concrete assertion requires it.
Reuse unchanged skill content already loaded in this working context. New agents
load applicable skills themselves; do not paste entire skills or conversation history
into their assignments. Delegate only independent, bounded work that earns its cost.

The requested executable proof and narrow scope govern output. Do not inherit
companion skills' finding-list formats, automatic refactors, package updates,
coverage quotas, or unrelated services/migrations.

Test creation authorizes scoped test code and ordinary local fixtures. Respect an
explicit read-only or code-only request. Do not repair the application, commit,
push, deploy, or change shared environments to make a test pass. Any necessary
instrumentation outside test files must be concrete and disclosed; use it only
within existing authorization. Calibrate on a disposable copy, never by modifying
the user's live checkout in place.

## Establish the contract before writing assertions

1. Record a compact, stable review contract: task goal, base/current revision including
   relevant dirty changes, affected business paths, invariants to preserve, exclusions,
   required checks, and completion criteria. If the plan or review packet is already
   present in the conversation history, DO NOT invoke `view_file` to re-read it; extract
   invariants directly from context. Record runtime/DB versions and schema.
   Reuse this contract on subsequent rounds. Resolve ambiguous business semantics
   from project contracts or the user; do not derive expectations solely from the SUT.
2. Trace the reachable path: public HTTP/RPC or documented public method → identity
   and authorization → handler/service → database functions/policies/triggers →
   commit → required outbox/worker/provider effects. When `graphify-out/graph.json`
   exists, run `graphify path "<Entrypoint>" "<Database/Worker>"` or `graphify query "<feature>"`
   first to trace the call graph deterministically in one step before falling back to manual grep.
   Include browser interaction when the claim depends on browser behavior. State the actual tested boundary.
3. Apply the reachability gate below before promoting a hypothesis to a defect or
   building its reproducer. Keep stable IDs per root cause, not per symptom/file.
4. Read [proof-contract.md](references/proof-contract.md) for every proof. For races,
   locks, transactions, retries, or async recovery, also read
   [concurrency-and-failures.md](references/concurrency-and-failures.md).
   Select cases from [extensions.md](references/extensions.md) only when supported
   by the pipeline and requested scope.

Keep a compact claim-to-case map inside the test. Never invent endpoints, fields,
schema, identities, hooks, or an environment. Read
[review-cycle.md](references/review-cycle.md) for a coder handoff, existing review, fix verification,
disputed finding, or a proposed change to test infrastructure.

Discovery is part of a review even when the user supplies no findings. Inspect the
chosen path and derive negative scenarios from its stated contract and reachable
code. For each in-scope ownership, idempotency, or atomicity guarantee, pair the
legitimate flow with a targeted attempt to violate that guarantee. Do not narrow
«review with a normal-flow check» to a happy-path-only test. Marking omitted cases
`UNVERIFIED` is honest reporting, but does not finish feasible, authorized work.
Stop adding cases when the chosen contract is covered, not after the first green case.

## Reachability gate

For each candidate, identify the exposed entrypoint, actual actor capabilities and
effective roles, origin of starting data, permitted operation/failure schedule,
active guards, and the observable contract violation. Support the chain with code,
configuration/schema evidence, or a real trace from the relevant environment.

- A fixture must represent a state the supported system can create or retain. SQL
  acceptance alone proves neither business reachability nor valid history. Cite a
  supported creation path or relevant legacy/import/migration evidence. Privileged
  setup is allowed for equivalent reachable state, not for inventing corrupt history.
- Do not disable constraints, RLS, authorization, locks, triggers, or transaction
  boundaries to establish a defect in the unchanged product. Do not grant the actor
  unavailable privileges. A private helper call bypassing a real guard is not a
  public-path exploit. A changed variant demonstrates only test sensitivity.
- Reachable is broader than normal UI clicks: adversarial requests to exposed APIs,
  known foreign resource IDs, supported admin actions, webhooks, jobs, concurrent
  requests, and supported retries/failures can qualify. Do not require a prior incident
  or dismiss a scenario merely because it is rare. Conversely, do not invent entrypoints,
  failure modes, provider behavior, or impossible visibility between atomic writes.
- Controlled timing/fault injection must realize an allowed execution without removing
  product protection. When reachability depends on live configuration, inspect it
  read-only when authorized; otherwise retain that specific uncertainty.

Also apply a **material impact and acceptable-alternative gate** before confirming
a finding. Name the observable business, security, data, operational, or required-gate
impact and explain why the current tradeoff violates this project's actual contract
or evidenced constraints. A different valid design, preferred abstraction, or imagined
future scale does not establish a defect. Consider the reason for existing behavior
and supported compatibility; accept equivalent solutions that satisfy the same contract.
Do not invent thresholds, require an incident or numerical score, or excuse a proven
security/data-integrity violation because the project is small. A contract-valid
alternative is `REJECTED_NO_VIOLATION`; missing necessary facts remain `UNVERIFIED`.

Classify candidates separately from test execution:

| Candidate | Decision |
| --- | --- |
| `CONFIRMED` | A supported reachable chain violates a named contract with concrete impact and evidence. Eligible for a product blocker; executable proof is still required to claim a reproduced defect. |
| `REJECTED_UNREACHABLE` | A cited active guard or supported-state rule excludes the candidate. Record why; do not manufacture a test or fix. |
| `REJECTED_NO_VIOLATION` | No agreed product/gate contract is violated: e.g. a permitted ID format or an unsupported demand for more mutants. Do not mislabel valid behavior as unreachable. |
| `UNVERIFIED` | A necessary capability/state/configuration/effect is unknown. Identify the missing fact; do not send an assumed product defect for repair. |

Failure to reproduce is not proof of impossibility. An unresolved prerequisite for
the agreed required coverage prevents a complete review. A rejected candidate or
unrelated hypothetical improvement does not enlarge that coverage or keep it open.

## Non-negotiable test properties

- **Real boundary.** Exercise business actions through the highest relevant public
  interface with ordinary valid credentials. Direct SQL is for scoped setup,
  independent observation, and teardown. A lower-level RPC test cannot claim to
  cover a PHP route's authentication or browser CSRF behavior.
- **Real persistence.** Use the project's database engine, migrations, constraints,
  policies, triggers, and transaction boundaries for the behavior under review.
  Never substitute SQLite or a mocked repository for PostgreSQL behavior.
- **Independent oracle.** Assert exact before/after values, allowed transitions,
  conservation equations, identities, ownership, and side effects. Read committed
  results through a fresh observer; the API saying `ok` is insufficient.
  Exactness applies to the contract: do not invent an opaque ID format, ordering,
  timestamp precision, or a winning worker from the current implementation.
- **Positive controls.** A legitimate operation must succeed through the same
  boundary, and a valid operation must still succeed after the fault or attack.
  An implementation that denies everything must fail the test.
- **Exact accounting.** Account for every attempt, logical operation, response,
  terminal outcome, and durable effect. Not every non-2xx is a business rejection;
  not every 2xx replay is a new operation. Keep unknown outcomes in the denominator.
- **Causal negative checks.** Prove that the intended boundary/fault point was
  reached. A login redirect, missing fixture, generic 404, or dead DB is not evidence
  of successful authorization or rollback.
- **Controlled concurrency.** Prove relevant overlap or protected serialization
  with observable synchronization. Simultaneous dispatch, sleeps, more workers,
  or reruns until failure are not a deterministic race reproducer.
- **Complete lifecycle.** Assert rollback/compensation, recovery, settled effects,
  and resource release before cleanup erases evidence of leaked transactions,
  locks, jobs, or partial writes.
- **Non-vacuous execution.** Require an explicit expected case/worker inventory,
  reached assertions, bounded completion, and preserved exit status. No skipped
  required case, empty selection, swallowed exception, early-return success, or
  `xfail`/expected failure may produce a green review verdict.

External providers may use a recording simulator at the network boundary for claims
about local handling. Keep the actual adapter, signature verification, parsing, and
retry path. Bound that claim explicitly. Provider compatibility or actual delivery
requires its authorized sandbox and receipts.

## Execute the bounded proof

Run syntax/type checks appropriate to the existing project, then the scoped proof.
Assert the **correct** behavior: a target defect makes the test fail, not makes an
`expect(vulnerability).toBe(true)` test pass. Expected faults are allowed only when
their exact contract and resulting state are asserted.

For a reproduced defect, preserve the failing case and valid-business controls.
When verifying its fix, use the same regression assertions against before/after
evidence; do not change the oracle just to pass. Follow `review-cycle.md` for closure.

Synthetic calibration is optional unless the user or an existing required gate
explicitly requires it. Prefer an available before/after pair. Read the conditional
calibration section in `proof-contract.md` when needed. Absence of a synthetic mutant
does not make completed ordinary review `UNVERIFIED`. Do not claim sensitivity that
was not established, or silently drop calibration from a contract that requires it.

Do not recursively review tests of tests, build a mutation framework, or add a
meta-test for every assertion. Repair a test only for a demonstrated false green,
false red, or execution problem affecting this proof or a required gate, or when
test-infrastructure work was explicitly requested. Distinguish its defect from a
product defect. A surviving arbitrary/equivalent mutant is not a repair obligation.

Use these semantic results; map them to the runner without hiding them:

| Result | Meaning |
| --- | --- |
| `PASS` | All agreed required cases, controls, and checks completed; invariants hold in the recorded scope. Calibration is included only when required. |
| `FAIL_PRODUCT` | A reached, valid scenario violated a specific product invariant. |
| `FAIL_HARNESS` | Test, fixtures, synchronization, oracle, or cleanup failed. |
| `BLOCKED_ENV` | Required runtime, service, credential, permission, or environment is unavailable. |
| `UNVERIFIED` | Required code/coverage/evidence was not exercised or established, including calibration when explicitly required. |

Only aggregate `PASS` is a successful proof gate. Preserve per-case results when
outcomes coexist. Environment/harness problems must not erase a proven product
failure; a product failure must not conceal a coverage gap. Expected-red control
runs are separate from the reviewed revision.

The **command's final machine-readable verdict and exit status** must agree with
the agreed proof's completeness, not just its happy-path assertions.
Individual cases may pass inside an `UNVERIFIED` run, but the overall proof command
must still return nonzero. Use distinct case-result and aggregate-verdict labels.
If required calibration is separate, provide one aggregate invocation that also
consumes its result. Optional exploration is reported separately and cannot redefine
the gate; any actual product failure it uncovers must still be assessed on evidence.

### Evidence Receipt and Output Hygiene (Observation Boundary)

To prevent context window bloat and prompt cache thrashing (SoL-Pi Evidence-Preserving Reducer & ObservationPack patterns):
- **Bounded terminal output**: The proof command must not dump multi-megabyte payloads, full DB tables, or hundred-line stack traces into stdout.
- **Raw diagnostic archiving**: The complete unedited test log must be archived to an external file (e.g. `tmp/proof_runs/run_<timestamp>_<name>.log` or `.agent/logs/`).
- **Structured Evidence Receipt**: The output returned to the reviewer/coder must format as a concise, self-contained Evidence Receipt:
  1. Target test path and tested public boundary.
  2. Aggregate verdict (`PASS`, `FAIL_PRODUCT`, `FAIL_HARNESS`, `BLOCKED_ENV`, `UNVERIFIED`).
  3. Evaluated Invariant ID(s) (e.g. `INV-CDEK-DEST-01`).
  4. For failures: exact, minimal assertion snippet (expected vs observed) with zero noise.
  5. Positive control confirmation.
  6. Clickable link to the archived raw log on disk for on-demand paging (`obs_recall` pattern).
- Use `python scripts/test_evidence_runner.py <test>` when executing Python/pytest proofs to produce this verified receipt automatically while strictly preserving the real process exit code.

## Output

Default final output: test file code (or a clickable saved file in a repository)
and a short paragraph beginning **«Что именно этот сквозной тест опровергает»**.
State the invariant, actual run result, material unverified boundary, and calibration
result only when performed/required. Use the user's language. On re-review, link the
existing test and give closure status; do not duplicate unchanged code.

When confirmed in-scope blockers remain open, append **«Готовый запрос кодеру»**:
one self-contained, copyable task that explicitly invokes `$pipeline-contract-coder`.
Read [coder-handoff.md](references/coder-handoff.md) to generate it from the actual
review contract, source state, open IDs, and evidence. Include it without waiting
for a separate request; also use that reference when a handoff is explicitly requested.
An explicit output restriction in the current task takes precedence. Do not generate
repair work from rejected hypotheses or missing environment evidence, and do not
execute or dispatch the task merely because you wrote it.

Put the exact command, non-secret prerequisites, claim-to-case map, relevant
deterministic schedule, and any specialist-derived constraint that materially shaped
an assertion in the test comment or existing review artifact. Do not add a rote list
of loaded skills or modify an adequate test solely to duplicate this metadata. Runtime output identifies
failed invariant IDs and sanitized expected/observed values. The coder task states
bounded repair obligations with evidence; do not copy the reviewer's routine PASS
results, run counts, environment versions, timings, or logs into it. Preserve exact
failing-before evidence for open IDs, required reproduction/gate commands, and material
blocked or unverified coverage. Do not add a second prose bug list, unsolicited
micro-patches, or a generic security checklist.

Keep the compact review contract and decisions with the test or in the existing
review artifact; do not introduce a tracking framework. If all proposed defects are
rejected, reuse legitimate-flow coverage and state that no defect was confirmed.
Never fabricate a vulnerability, a failing test, or extra files to satisfy the format.

If runnable code cannot be grounded in the available repository or environment,
state `BLOCKED_ENV`/`UNVERIFIED` and the concrete missing requirement. Deliver a
grounded test if possible, but never disguise placeholders or static checks as an
executed integration test. Disclose a necessary extra resource if the real runner
cannot work with one file; do not silently create a framework to satisfy the format.
