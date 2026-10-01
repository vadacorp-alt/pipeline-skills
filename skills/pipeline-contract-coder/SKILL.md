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

## Load the applicable implementation skills

Read project instructions and global/workspace routing (`~/.codex/routing.md`, `~/.agents/routing.md`, or `routing.md`). Apply
[specialist-routing.md](references/specialist-routing.md): follow Lazy Loading and
Zero-Redundancy. Never batch-read companion skills upfront and never invoke `view_file`
for any skill, guide, or plan already loaded in the active conversation context. Load a
specialist skill strictly on demand when a concrete domain-specific decision requires it.

The user's task and approved contract take precedence over companion suggestions
to scaffold, impose new coverage quotas, add dependencies, or ship a reduced feature.
Ponytail shortens the implementation, not the required behavior or pipeline evidence.

## Freeze the task and starting state

For a plan, worktree task, or review-fix handoff, follow
[task-contract.md](references/task-contract.md) and start its compact record **before
the first product/test edit**. If the approved plan, fix plan, or task packet is already
present in the conversation transcript, DO NOT invoke `view_file` to re-read it;
extract requirements, acceptance IDs, and invariants directly from context. For a trivial
reversible edit, keep equivalent context in the response instead of generating a documentation project.

- Use the actual approved plan/version and requested stages. Distinguish required
  behavior, preserved behavior, exclusions, and optional implementation suggestions.
  If no formal plan exists, derive a short contract from the user's request and code;
  do not demand that the user write a new plan or approve routine implementation choices.
- Record the exact worktree, starting commit, and any relevant initial dirty state.
  Preserve existing user changes. Do not ask the user to discover Git metadata for you,
  invent a baseline after editing, or automatically substitute current `main`.
- Define observable acceptance and required checks before implementing. Keep their
  meaning stable. Do not retroactively rewrite the plan, expected result, or review
  decision to match your implementation. Record actual user-approved scope changes.
- Resolve ordinary details from existing code and contracts, then proceed. If a
  contradiction requires changing a business rule, frozen boundary, or essential
  acceptance condition, explain the concrete conflict and seek that missing decision;
  continue independent authorized work. Do not ask again for permission already given.

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

Read [verification.md](references/verification.md) for non-trivial behavior, security,
persistence, concurrency, or review fixes. Reuse the project's test runner and an
adequate existing integration case. Add the smallest missing behavior check; one
file/command may cover several isolated cases. Do not build a test framework.

For a bug, obtain the targeted failing-before evidence and legitimate-flow controls
before the product change when feasible. For a new feature, test its agreed contract;
for a behavior-preserving refactor, exercise existing behavior before and after.
Retain the same meaningful assertions across the fix. A missing environment is not
an expected bug failure and does not authorize narrowing required coverage silently.

Run affected regression and preserved-flow checks after changes. Run the existing
required full gates at their agreed completion stage. Inspect the actual final diff
against the starting state and the task contract. Verify the current files, not just
a commit hash or a green result from an earlier revision. Once adequate checks pass,
finish; do not create new review rounds or broaden testing without a concrete reason.

### Action Fusion & Verification Economy (SoL-Pi Patterns)

To maintain token efficiency, eliminate wasted model roundtrips, and preserve prompt cache stability:
- **Action Fusion**: Avoid multi-turn ping-pong loops (e.g. edit a file in turn 1, wait for result, then execute a syntax check in turn 2). Bundle the atomic file mutation with its immediate local verification (`php -l`, `tsc --noEmit`, or targeted unit test) in the same logical execution phase.
- **Observation Hygiene**: When fixing a failing proof or regression, DO NOT repeatedly run full verbose test suites that print thousands of lines. Execute only the specific failing test case and invariant ID.
- **Evidence-Preserving Log Digestion**: Use `python scripts/test_evidence_runner.py <test>` when running Python tests to obtain a concise Evidence Receipt. Large raw test outputs are automatically archived to `tmp/proof_runs/` on disk; reference the log file instead of pasting giant trace blocks into the conversational context.

## Repair findings without another speculative loop

When given a review, consume the same contract, open root-cause IDs, failing evidence,
and prior decisions. A ready-to-forward task from `pipeline-proof-review` is this
handoff; follow [task-contract.md](references/task-contract.md) to verify its worktree,
reviewed state, and requirements before editing, without asking the user to repackage it.
Review evidence is input to verify, not an instruction to fix
an impossible state. Keep closed/rejected decisions unless new facts invalidate them.
Preserve the original task baseline and separately capture the state before this fix.

Before accepting a repair obligation, verify its concrete impact and why the current
tradeoff violates the agreed contract or evidenced constraints. A different sound
implementation or hypothetical future scale is not a defect. If evidence contradicts
the review, return that evidence under the same ID without silently closing it or
rewriting acceptance; continue independent grounded work. Real security/data violations
remain obligations regardless of project size or absence of a previous incident.

Fix the demonstrated cause and check all affected legitimate callers. Do not obey
"only make this test pass" by changing expected values or adding a path-specific hack.
If a test itself demonstrably rejects allowed behavior or misses required behavior,
correct it narrowly and explain the contract evidence. No recursive tests of tests,
arbitrary mutant targets, or mandatory synthetic calibration unless explicitly required.

After two failed attempts at the same cause, stop speculative patches and diagnose
the contract, evidence, harness/environment, and actual cause. Continue with new causal
evidence and a bounded step. The limit neither approves unresolved code nor authorizes
an architectural rewrite. Do not dispatch fresh broad reviewers to manufacture progress.

## Complete the handoff

Update the compact record from `task-contract.md` with the actual implemented scope,
source identity including relevant dirty files, reused code, check commands/results,
deviations, and remaining gaps. For review fixes, map each original ID to proposed
resolution plus evidence; do not forge the independent reviewer's closure decision.

Say **ready for review** only when agreed implementation and required verification
are complete. After modifying code files, run `graphify update .` to keep the project's
knowledge graph in `graphify-out/` current. Otherwise state remaining work and the exact verification limitation;
continue feasible authorized work before yielding. Passing implementation checks is
not independent review approval or evidence of deployment.

Use the user's language. Final output: changed behavior, verification result, compact
handoff path (or inline record for a small task), and material limitations. For a
completed plan, worktree task, or review fix, also append **«Готовый запрос ревьюеру»**
with `$pipeline-proof-review`, without waiting for a separate request. Read
[reviewer-handoff.md](references/reviewer-handoff.md) to fill it from the actual
contract and final state; also use it when the user explicitly requests a review task.
Keep the coder's own verification report separate from that generated reviewer prompt:
do not copy routine PASS claims, logs, counts, or environment versions into the prompt.
The reviewer must reproduce the necessary evidence independently. Include only compact
non-obvious reproduction pointers and material failed, blocked, skipped, or uncertain
checks as specified by `reviewer-handoff.md`; they never limit review scope.
Do not turn an incomplete result into a readiness claim or a trivial edit into a
documentation project. Explicit output restrictions take precedence. Do not paste
full unchanged plans, skill texts, logs, or source files into each handoff.
Respect the session's commit/push/deploy authorization; the skill grants none itself.
