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

## Scope and lazy reference loading (Zero-Cascade Policy)

**Do NOT batch-read `references/*.md` or companion skills upfront.** Everything needed for a standard review is inlined in this `SKILL.md`:
- **Specialist skills** (`supabase-postgres-best-practices`, `security-review`, `api-security-review`, `php-pro`, `php-best-practices`): Load strictly on demand ONLY when a non-trivial domain edge case is in doubt and the skill is not already in context. Never invoke `view_file` on any skill, plan, or guide already present in the conversation transcript.
- **Internal `references/*.md` (Load ONLY when triggered)**:
  - Read [concurrency-and-failures.md](references/concurrency-and-failures.md) ONLY when reviewing race conditions, locking, retries, or distributed outbox recovery.
  - Read [extensions.md](references/extensions.md) ONLY when selecting extended edge-case matrices (clock boundaries, property-based checks, migration compatibility).
  - Read [review-cycle.md](references/review-cycle.md) ONLY on multi-round disputed findings or complex test-harness repairs.
  - Read [coder-handoff.md](references/coder-handoff.md) or [proof-contract.md](references/proof-contract.md) ONLY if an edge case is not covered by the inlined rules below.

The requested executable proof and narrow scope govern output. Do not inherit companion skills' finding-list formats, automatic refactors, package updates, coverage quotas, or unrelated services/migrations.

Test creation authorizes scoped test code and ordinary local fixtures. Respect an explicit read-only or code-only request. Do not repair the application, commit, push, deploy, or change shared environments to make a test pass. Calibrate on a disposable copy, never by modifying the user's live checkout in place.

## Establish the contract before writing assertions

1. Record a compact, stable review contract inline (do NOT create extra `.md` tracking files unless requested): task goal, base/current revision, affected business paths, invariants to preserve (`INV-*`), exclusions, and completion criteria. If the plan, review packet, or git state is already in the conversation history, DO NOT invoke `view_file` or redundant git/version discovery commands; extract invariants directly from context. Do not probe runtime/DB/OS versions (`php -v`, `node -v`, `SELECT version()`) unless a defect specifically depends on engine version semantics.
2. Trace the reachable path: public HTTP/RPC or documented public method → identity and authorization → handler/service → database functions/policies/triggers → commit → required outbox/worker/provider effects. When `graphify-out/graph.json` exists, run `graphify path "<Entrypoint>" "<Database/Worker>"` or `graphify query "<feature>"` first to trace the call graph deterministically in one step before falling back to manual grep. State the actual tested boundary.
3. Apply the reachability gate below before promoting a hypothesis to a defect or building its reproducer. Keep stable IDs per root cause, not per symptom/file.

Keep a compact claim-to-case map inside the test. Never invent endpoints, fields, schema, identities, hooks, or an environment.

Discovery is part of a review even when the user supplies no findings. Inspect the chosen path and derive negative scenarios from its stated contract and reachable code. For each in-scope ownership, idempotency, or atomicity guarantee, pair the legitimate flow with a targeted attempt to violate that guarantee. Stop adding cases when the chosen contract is covered, not after the first green case.

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

**Fast-Path PASS (No Artificial Strawmen)**: When no reachable defect is found and all contract invariants hold, **do NOT invent artificial hypotheses just to populate a `REJECTED_*` table**. Use the classification table only for genuinely disputed claims, user-reported suspects, or confirmed findings.

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

## Execute the bounded proof (Zero-Redundancy & Single-Run Policy)

- **Do NOT rerun static type/syntax checks (`tsc --noEmit`, `php -l`, `phpstan`, `eslint`) on product files**: The implementation agent (`pipeline-contract-coder`) already validates TypeScript compilation and PHP syntax before handoff. Running `tsc --noEmit` or full-repo `php -l` during review wastes tokens and roundtrips. Only syntax-check a test file if you just authored or modified it and the test runner does not already parse it on execution.
- **Single-Run / Zero-Run Proof Execution**:
  1. First, inspect the product code and the coder's existing integration test statically.
  2. **Zero-Run reuse (same session / verified receipt)**: If a valid `Evidence Receipt` for the exact current source state is already present in the conversation context AND your code audit confirms the test already covers the required public boundary, invariants, and negative/positive controls without gaps, **do NOT rerun the test**. Reuse the existing receipt directly.
  3. **Single-Run extension**: If the existing test is missing a reachable negative case or invariant check, **first edit the test to add the missing case(s)**, and then execute the test runner **once** (never run the unmodified test first only to run it a second time after adding your case).

Assert the **correct** behavior: a target defect makes the test fail, not makes an
`expect(vulnerability).toBe(true)` test pass. Expected faults are allowed only when
their exact contract and resulting state are asserted.

For a reproduced defect, preserve the failing case and valid-business controls.
When verifying its fix, use the same regression assertions against before/after
evidence; do not change the oracle just to pass.

Synthetic calibration is optional unless the user or an existing required gate
explicitly requires it. Prefer an available before/after pair. Absence of a synthetic mutant
does not make completed ordinary review `UNVERIFIED`.

Do not recursively review tests of tests, build a mutation framework, or add a
meta-test for every assertion. Repair a test only for a demonstrated false green,
false red, or execution problem affecting this proof or a required gate.

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
failure; a product failure must not conceal a coverage gap.

### Evidence Receipt and Output Hygiene (Observation Boundary)

To prevent context window bloat and prompt cache thrashing:
- **Bounded terminal output**: The proof command must not dump multi-megabyte payloads, full DB tables, or hundred-line stack traces into stdout.
- **Raw diagnostic archiving**: Archive complete unedited test logs to `tmp/proof_runs/run_<timestamp>_<name>.log` or `.agent/logs/`.
- **Standard Runner & Receipt Format**: Execute Python proofs via `python scripts/test_evidence_runner.py <test_file.py>` (strictly via test files, never `python3 -c`). Format terminal receipt as:
  `[RECEIPT:VERDICT] | INVARIANT=<id> | BOUNDARY=<entrypoint> | POSITIVE_CONTROL=<status> | ASSERTION=<quote> | RAW_LOG=<filepath>`

## Output

Default final output:
1. Concise **Evidence Receipt** and clickable link to the test file (on re-review or Zero-Run reuse, link the existing test without duplicating unchanged code).
2. A short paragraph beginning **«Что именно этот сквозной тест опровергает»**: state the evaluated invariant IDs, actual run/reuse result, and any material unverified boundary. Use the user's language.

When confirmed in-scope blockers remain open (`FAIL_PRODUCT`), append **«Готовый запрос кодеру»** inline (no need to read `coder-handoff.md` unless handling complex dirty worktree splits):

```text
Используй $pipeline-contract-coder.
WORKTREE: <абсолютный путь>; BRANCH: <ветка>; BASE_SHA: <база>; REVIEWED_HEAD: <SHA>.
План и контракт: <пути к плану/ревью; цель задачи>.
Исправь только: <ID открытых блокеров: триггер → требуемое поведение; тест-кейс → свидетельство FAIL до фикса>.
Сохрани: <работающие инварианты и позитивные контроли>.
Репродьюсер из <cwd>: <точная команда запуска файла теста и ссылка на RAW_LOG>.
Полномочия: <разрешённые действия>.
```

If all invariants hold (`PASS`), do not generate a coder handoff block or extra files. If runnable code cannot be grounded in the available environment, state `BLOCKED_ENV`/`UNVERIFIED` and the concrete missing requirement.
