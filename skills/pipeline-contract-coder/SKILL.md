---
name: pipeline-contract-coder
description: >
  Execute an approved coding task or review fix with stable scope, end-to-end impact
  tracing, code reuse, regression checks, and a reproducible handoff to
  pipeline-proof-review. Use when implementing a plan, feature, refactor, or bug fix,
  especially in a worktree. Complements applicable language/platform skills and
  ponytail; does not replace independent review or authorize unrequested release work.
---

# Pipeline Contract Coder

Implement the agreed behavior and preserve the affected business contract. Finish
the authorized task with executable evidence and a compact review handoff. A small
diff is useful only when it fixes the cause in the right place. Do not optimize for
making one failing test green while breaking another reachable caller.

This is the implementation workflow. The coder does not need to load the full
`pipeline-proof-review` skill or start a separate QA review loop. Both roles use the
same task contract, source identities, invariant IDs, and test evidence; the reviewer
independently verifies the coder's claims. Instructions cannot guarantee zero defects.

## Lazy skill & reference loading (Zero-Cascade Policy)

**Do NOT batch-read `references/*.md` or companion skills upfront.** Everything needed for standard implementation is inlined in this `SKILL.md`:
- **Specialist skills** (`ponytail`, `supabase-postgres-best-practices`, `security-review`, `api-security-review`, `php-pro`, `php-best-practices`): Load strictly on demand ONLY when a concrete domain-specific edge case requires checking reference text and the skill is not already in the conversation transcript. Never invoke `view_file` on any skill, plan, or guide already in context.
- **Internal `references/*.md` (Load ONLY when triggered)**:
  - Read [verification.md](references/verification.md) ONLY when designing complex concurrency barriers or fault-injection harnesses.
  - Read [task-contract.md](references/task-contract.md) or [reviewer-handoff.md](references/reviewer-handoff.md) ONLY when handling multi-worktree drift or disputed re-review closures not covered by the inlined templates below.

The user's task and approved contract take precedence over companion suggestions to scaffold, impose new coverage quotas, add dependencies, or ship a reduced feature.

## Freeze the task and starting state (Inline Contract — No Extra Files)

Keep the task contract **inline in your working context/response** — do NOT spend `write_to_file` / `replace_file_content` calls creating or updating standalone Markdown tracking files on disk unless the user explicitly asks for a persistent report artifact. If the approved plan, fix plan, or task packet is already present in the conversation transcript, DO NOT invoke `view_file` to re-read it; extract requirements, acceptance IDs, and invariants directly from context.

- Use the actual approved plan/version and requested stages. Distinguish required behavior, preserved behavior, exclusions, and optional implementation suggestions.
- **Minimal Git Discovery**: If `WORKTREE` and `BASE_SHA` are already in the active session context or handoff packet, reuse them without running Git commands. Otherwise, establish them in a single combined read-only call (`git rev-parse --show-toplevel HEAD && git status --short`). Preserve existing user changes.
- Define observable acceptance (`ACC-*`) and preserved invariants (`INV-*`) before implementing. Keep their meaning stable.
- Resolve ordinary details from existing code and contracts, then proceed directly.

## Understand the affected pipeline before choosing the fix

Trace the relevant public/user entrypoint through identity and validation, shared
callers, services, database functions/policies/triggers and commit, to required
workers/provider/UI effects. When `graphify-out/graph.json` exists, use `graphify query "<symbol>"`
and `graphify path "<caller>" "<callee>"` to map callers, handlers, and downstream effects in one
deterministic step; use `rg` for exact text/code pattern matching.
Record a short path with actual files and the invariants crossing its boundaries.

Inspect causally affected callers, including unchanged files and other deployed
components. A module or microservice boundary does not end the business flow. This
does not authorize merging services, crawling unrelated code, or redesigning the
whole system. For a UI-only task, use the real UI lifecycle; do not invent a DB path.

For a reported defect, establish the actual entrypoint, actor capabilities, supported
initial state, allowed failure/schedule, active guards, and concrete violated rule.
An arbitrary privileged SQL edit, removed lock, disabled constraint, or inaccessible
private helper is not evidence of a bug in the unchanged public path. Adversarial
API calls, foreign IDs, real concurrency and retries remain valid when reachable.
Unknown evidence is a verification gap; impossibility requires an identified guard.

## Reuse and implement the smallest complete change

Follow Ponytail after understanding the path: existing compatible helper/pattern,
standard library, native platform capability, installed dependency, then new code.
Check that a reused helper fits authorization, errors, lifetime, and transaction
semantics. Prefer one correction at the shared cause to duplicated caller patches.
Do not force incompatible callers into a new abstraction just to claim reuse.

Every changed file must serve an acceptance item, preserved invariant, demonstrated
root cause, or required check. A necessary related caller change is in scope; an
unrelated cleanup is not. Respect explicit no-touch boundaries and raise a concrete
conflict if they prevent the required behavior. Do not turn a suggested file list
into a reason to leave the same cause broken in another relevant entrypoint.

Avoid unrelated renames, formatting, dependency upgrades, new services, wrappers,
flags, frameworks, and abstractions for future needs. Reuse current extension points.
If an existing mechanism already satisfies a requested item, verify and report it
instead of rewriting it. Explicitly requested functionality is not speculative YAGNI.

Preserve auth/ownership, money calculations, state transitions, API/DB contracts,
idempotency, transaction/error handling, and required downstream effects except for
the specific behavior the task authorizes changing. Do not disable guards, swallow
failures, return artificial success, or weaken tests to reduce the diff.

## Prove the changed and preserved behavior

### Text-only edits: minimal verification

For a typo, single-letter correction, description expansion, or replacement of a
number used only as displayed text, first confirm that the diff changes content
only, without changing executable behavior or a machine-consumed contract.
For these edits, this exception takes precedence over the general pipeline,
regression, and review-fix verification requirements below and in the references:

- Do not add tests or run broad unit, integration, end-to-end suites, or full gates
  merely because text changed. Automated tests may be omitted entirely.
- Inspect the final diff for the requested wording and intact syntax/markup. Check
  rendering only when the text change creates a concrete layout or formatting concern.
- Reuse adequate existing task tests and their prior results when the behavior they
  cover is unaffected; do not rerun them solely for a text edit or claim a fresh run.
  Run only a useful existing focused check if there is a concrete relevant concern.
- Explicitly requested checks or mandatory repository/release gates still apply at
  their required stage; a text-only edit does not itself trigger a release gate.
- Report the minimal validation performed and, when applicable, that automated tests
  were not run because only text changed. No separate test plan or review loop is needed.

Classify by impact, not diff size: a changed digit in a calculation, price setting,
limit, or configuration, or a changed string used as an ID, route, query, or protocol
value is a behavior/contract change and follows the normal verification rules.

### Behavior changes and other required checks

Reuse the project's test runner and an adequate existing integration case. Add the smallest missing behavior check; one file/command may cover several isolated cases. Do not build a test framework. Ensure integration checks hit the real public boundary and persistence engine with an independent state oracle and positive control.

For a bug, obtain the targeted failing-before evidence and legitimate-flow controls before the product change when feasible. For a new feature, test its agreed contract; for a behavior-preserving refactor, exercise existing behavior before and after. Retain the same meaningful assertions across the fix.

Run affected regression and preserved-flow checks after changes. Inspect the actual final diff against the starting state and the task contract. Once adequate checks pass, finish; do not create new review rounds or broaden testing without a concrete reason.

### Action Fusion & Scoped Verification Economy (SoL-Pi Patterns)

To maintain token efficiency, eliminate wasted model roundtrips, and preserve prompt cache stability:
- **File-Extension Scoped Static Checks**:
  - Touched `.php` files ONLY → run `php -l <only_modified_files.php>` (do NOT run `find public/api ...` across all untouched PHP files, and do NOT run `npx tsc --noEmit`).
  - Touched `.ts` / `.tsx` files ONLY → run `npx tsc --noEmit` (do NOT run `php -l`).
  - Touched both → run `php -l <modified.php>` and `npx tsc --noEmit`.
- **Action Fusion**: Bundle the atomic file mutation with its immediate scoped syntax check or targeted test in the same logical execution phase rather than multi-turn ping-pong loops.
- **Observation Hygiene & Evidence Receipt**: Execute only the specific failing/targeted test file via `python scripts/test_evidence_runner.py <test_file.py>` (strictly via test files, never `python3 -c`). Large raw outputs are archived to `tmp/proof_runs/`; emit the concise `[RECEIPT:VERDICT] | INVARIANT=<id> | BOUNDARY=<entrypoint> | POSITIVE_CONTROL=<status> | ASSERTION=<quote> | RAW_LOG=<filepath>` receipt.

## Repair findings without another speculative loop

When given a review (`pipeline-proof-review` handoff), consume the same contract, open root-cause IDs, failing evidence, and prior decisions directly from the handoff packet. Keep closed/rejected decisions unless new facts invalidate them.

Fix the demonstrated cause and check all affected legitimate callers. Do not obey "only make this test pass" by changing expected values or adding a path-specific hack. After two failed attempts at the same cause, stop speculative patches and diagnose the contract, evidence, harness/environment, and actual cause.

## Complete the handoff

Say **ready for review** only when agreed implementation and required verification are complete.
- **Conditional `graphify update .`**: Run `graphify update .` ONLY when you added/deleted/renamed files, functions, classes, or module imports/exports (AST graph changes). Skip `graphify update .` for internal line edits that do not alter call-graph symbols.

Use the user's language. Final output:
1. Summary of changed behavior, touched files, and verification result (`Evidence Receipt`).
2. For a completed plan, worktree task, or review fix, append **«Готовый запрос ревьюеру»** inline (no need to read `reviewer-handoff.md`):

```text
Используй $pipeline-proof-review.
Режим: <первичное ревью или проверка исправлений>.
WORKTREE: <абсолютный путь>; BRANCH: <ветка>; BASE_SHA: <исходный SHA>; RESULT_SHA: <текущий SHA и список изменённых файлов>.
Основа и контракт: <путь к плану (не перечитывать через view_file в той же сессии); цель, инварианты INV-*, исключения>.
Статические проверки (выполнены кодером, повторно НЕ запускать): <PASS: php -l <файлы> / npx tsc --noEmit>.
Ориентиры воспроизведения и Evidence Receipt из <cwd>: <команда запуска теста и путь к RAW_LOG / строке [RECEIPT:PASS]>. (Если ревью идёт в той же сессии и аудит кода подтверждает полноту теста — прими этот Evidence Receipt без холостого перезапуска; если нужны новые негативные кейсы — сначала допиши их в тест и запусти 1 раз).
Остаётся непроверенным: <пробелы либо none>.
Полномочия: <действующие границы>.
```

Respect the session's commit/push/deploy authorization; the skill grants none itself.
