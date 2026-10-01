# One task contract for implementation and review

Use an existing plan/task artifact when practical. If the plan/contract or task packet
is already in the conversation context, DO NOT invoke `view_file` to re-read it; extract
requirements and invariants directly. For a planned worktree task or
handoff to another agent, save one compact Markdown record. Fill the starting-state
and acceptance portions before the first product/test edit; update only results as
work progresses. Do not build a schema validator, snapshot framework, or meta-tests
for this record. Empty fields cannot stand in for unknown evidence.

## What to record

```text
Task / requested stages:
Approved plan: path or supplied text; version/commit/content hash
Goal and allowed behavior changes:
Acceptance IDs -> observable expected outcomes:
Preserved invariant IDs -> existing behavior and affected callers:
Exclusions / explicit no-touch boundaries:
Required checks and relevant environment:

WORKTREE: absolute path
BRANCH: actual branch or detached state
BASE_SHA: commit at task start
INITIAL_DIRTY: clean, or scoped starting patch + relevant untracked-source snapshot
RESULT_SHA: current commit; relevant final dirty-source identity
FIX_BASE: actual source state immediately before this fix, when applicable

Affected pipeline: entrypoint -> shared logic -> commit -> required effects
Reuse / change map: acceptance or finding ID -> existing mechanism / changed files
Evidence: invariant ID -> command, source identity, environment, actual result/log
Review IDs: prior decision -> proposed resolution -> evidence
Deviations and actual authorized decisions:
Remaining implementation or verification gaps:
Readiness: ready for review, or specific incomplete work
```

Use only relevant fields; omit `FIX_BASE` before any review fix. An existing issue or
plan is the source of requirements, not something to silently simplify after coding.
Full approved context must be accessible to the reviewer, but large transcripts and
unexecuted plan stages do not need to be copied into every assignment.

## Establish the baseline yourself

- Inspect the actual target using `git rev-parse --show-toplevel`, branch/HEAD, and
  status. For a clean task start, `git rev-parse HEAD` supplies `BASE_SHA`; record the
  resolved commit rather than only a moving branch name. Do not infer the worktree
  from the UI title or accidentally edit the main checkout.
- Existing staged/unstaged changes and relevant untracked source are part of starting
  state. Preserve a scoped patch/snapshot and their source identities so the review
  can distinguish your work. A filename list or HEAD alone cannot reconstruct dirty
  input. Do not reset, stash, commit, or discard someone else's work as bookkeeping.
  Do not copy credentials, environment secrets, generated output, or unrelated files.
- A later `RESULT_SHA` can equal `BASE_SHA` when nothing was committed; final diff and
  relevant dirty-source hashes identify the result. Include new source/tests. Exclude
  the handoff/logs themselves from their own source identity to avoid recursive work.
- For an already-started task, recover the actual start from reliable history/context
  when possible and record uncertainty when it is not. A guessed merge-base or current
  `main` is not automatically the task's exact starting state. Non-Git work records
  actual before/after source snapshots rather than fabricated commit IDs.
- If history or checkout changes during authorized work, record the transition and
  preserve the origin of task changes. Do not silently replace the baseline with a
  convenient new revision. A baseline identifies change origin; it is not necessarily
  a known-correct calibration control.

## Receive the reviewer's ready-to-forward task

The explicit `$pipeline-contract-coder` invocation selects this implementation
workflow. Use the packet's plan, review/fix-plan paths, open IDs, preserved behavior,
checks, and permissions as the task input; load applicable specialist skills normally.
Do not load the full reviewer skill or create another broad review before fixing.

- Verify the supplied absolute worktree, actual branch/detached state, reviewed HEAD,
  and relevant dirty snapshot before product/test edits. Read the referenced contract
  and evidence; the packet does not make their factual claims automatically correct.
  Resolve a branch-only label through available Git worktree metadata. Do not guess
  a checkout when multiple locations remain plausible.
- Keep original `BASE_SHA`, the actual review comparison base/range, and
  `REVIEWED_HEAD` distinct from **FIX_BASE**, the actual state immediately before this
  fix including dirty source. When relevant source matches, FIX_BASE can refer to the
  reviewed snapshot. Preserve that reviewed evidence if the current state differs.
  Do not replace an unknown task origin with the present HEAD and call it historical.
- If code, tests, plan, or environment drifted since review, inspect the relevant delta
  and rerun affected evidence as needed. Preserve unrelated edits and proceed with
  compatible work; do not checkout/reset the old revision, declare stale tests current,
  or automatically restart all discovery. A material conflict in contract, target, or
  fix ownership needs the missing decision before dependent edits. Missing historical
  evidence is an explicit limitation, not a reason to invent it or halt every local fix.
- Distinguish approved implementation constraints from the reviewer's suggested
  technique. Fix confirmed open obligations at their cause, preserving exclusions and
  valid assertions. A counterexample to a proposed fix does not justify weakening the
  agreed outcome. Required environment gaps remain visible; do not fabricate product
  changes or change local tests merely to label those gaps closed.

After work, return the same IDs with proposed resolution, actual before/after evidence,
required check results, final source state, and remaining gaps. Independent closure
belongs to the reviewer. Do not ask the user to reconstruct metadata already available.

## Keep acceptance and evidence separate

Each acceptance item states a user/business outcome, valid initial state and actor,
observable result, and what must remain unchanged. A finding additionally needs its
reachable trigger and concrete impact. Implementation details become mandatory only
when the approved task/architecture actually requires them.

Tests derive expected behavior from these rules. Updating a result, adding a newly
needed implementation detail, or correcting a false assertion does not silently
change the contract. Keep the reason and any required actual user decision visible.

The reviewer uses the full initial task delta for first review, then the previous
review state plus causal fix changes for re-review. The same IDs, exclusions, and
preserved invariants remain active. An executor's "addressed" is a claim to verify,
not automatic `CLOSED`. A test report is evidence only for the source/environment
that actually produced it; the reviewer checks it against the current state.
