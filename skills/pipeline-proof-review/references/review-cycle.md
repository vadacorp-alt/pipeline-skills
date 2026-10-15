# Complete a review without expanding it

Read for repeated review, fix verification, disputed findings, or test-infrastructure
changes. The root owns scope and adjudication; more reviewers are not a default step.

## Keep one contract and a small decision record

When receiving a `pipeline-contract-coder` handoff, consume its original approved
plan/stages, acceptance and preserved invariants, worktree, `BASE_SHA`, initial dirty
state, result identity and evidence. Verify these against actual Git/files and
execution; the executor's readiness or "addressed" label is not review approval.
The baseline identifies task changes, not a necessarily correct test control. Keep
it stable and use the separately recorded `FIX_BASE`/last reviewed state for fix deltas.
Do not require the coder to load the QA skill or reproduce its full discovery loop.
If the handoff is a ready-to-forward review task, verify its proposed initial/fix mode
against the actual prior report and scope. The coder cannot narrow an initial review
to its own passing checks or turn a materially different task into closure of old IDs.

For the return handoff after review, use [coder-handoff.md](coder-handoff.md). Generate
the ready-to-forward coding task from this same record and the verified reviewed state;
do not make the user restate the baseline, plan, or findings, or add another scope.

Use an existing review artifact or a compact test comment. Record:

```text
contract: goal; base/current source identity; affected paths; preserved invariants;
          exclusions; required checks; completion criteria
finding: stable root-cause ID; contract violation; reachability/effect evidence;
         material impact and why current tradeoff is unacceptable;
         status; regression case; last reviewed source identity
decision: rejected/closed/deferred reason; evidence that would justify reopening
```

Keep candidate classification (`CONFIRMED`, `REJECTED_*`, `UNVERIFIED`)
separate from a confirmed finding's lifecycle (`OPEN`, `CLOSED`, `DEFERRED`). A deferred
confirmed blocker remains unresolved; accepted risk requires an actual authorized
decision. Do not relabel it rejected or silently count it as fixed.

First review: inspect the full agreed causal path and consolidate reachable defects
by root cause. Include legitimate flows and preservation of existing contracts.
Structural preferences, unrelated old debt, and unsupported candidate states do not
become repair requirements. Do not schedule one micro-patch or agent per symptom.

## Verify fixes against stable obligations

Review by itself does not authorize product edits. When repairs are authorized,
prefer a coherent fix at the demonstrated shared cause, preserving the approved
contract. Minimal means limited behavioral scope, not the fewest lines at any cost.
Use an existing adequate regression and legitimate-flow controls before adding tests.

For a reproduced finding, retain failing-before evidence and run the same relevant
assertions after the fix. Where before evidence is missing, inspect the actual prior
source and run it when available within scope. Never manufacture a defective baseline
to claim the historical bug was reproduced. If necessary evidence remains unavailable,
state the verification gap; do not close the issue solely on a mutant or an agent's
claim that the tests passed. Preserve valid old behavior, not incidental broken behavior.

Re-review consumes the same contract, open IDs, source identity at the previous review,
current changes, and test evidence. Verify each open ID and regressions caused by the
fix. Include unchanged callers, shared state, policies, and downstream effects when
the fix can affect them: a diff line boundary is not a behavioral boundary.

Reopen a closed/rejected item only with new relevant evidence: changed guard, newly
shown route/state, invalidated result, or a new contract violation. A renamed hypothesis,
different coding preference, or another reviewer's assertion is not new evidence.
Record unrelated observations separately; they do not silently extend this fix round.
An independently confirmed serious out-of-scope defect needs an explicit scope/release
decision; never downgrade its severity merely because its file is outside the diff.

Target one complete initial review, a coherent fix batch, and closure verification.
After two failed fix attempts at the same root cause, stop dispatching speculative
patches or restarting broad review. Diagnose the specific contract, hypothesis, failing
assertion, environment, and actual cause. Continue only with new causal evidence and a
bounded next step; ask only for a genuinely missing decision. This stop rule is neither
automatic approval nor permission for an unrelated architectural rewrite.

## Bound work on the evidence itself

Changing a test requires a concrete reason: it rejects a contract-valid implementation,
misses a specified reachable regression, cannot execute required coverage, or the user
explicitly requested test-infrastructure work. Identify the affected product invariant
or required gate before making the change. A parser/wrapper issue can matter when it
really masks the required runner's failure; a theoretical parser corner case alone
does not justify a new blocker or a generalized parser project.

Use the smallest correction and a focused check. Do not weaken correct assertions,
skip cases, suppress exits, or lower declared acceptance criteria to make code pass.
Do not demand a separate mutation per assertion, recursive validation of validators,
exhaustive fault injection, or killing equivalent/guarded mutants. Stop once the
specific execution or false-result problem is resolved and the required proof works.

Reuse observed evidence when the relevant code, tests, configuration, schema,
and environment assumptions still match; account for dirty files, not just commit SHA.
- **Static checks (`tsc --noEmit`, `php -l`)**: Trust the coder's static check status when the source state matches; never re-run TypeScript or PHP syntax checks in the reviewer.
- **Integration proof reuse**: If the coder already executed the integration test on the exact current source state and produced an `Evidence Receipt` in the active context, first audit the test code statically. If the test already enforces all required invariants, positive controls, and negative boundaries, accept the receipt without re-running the test command. If additional test cases are needed, add them to the test file first and run the test suite **once**.
- **Git metadata**: If `WORKTREE`, `BASE_SHA`, and `RESULT_SHA` are already established in the active session or handoff and no external commits occurred, do not run redundant sequences of `git rev-parse` / `git status` commands.
Do not reread unchanged skills or resend full histories in the same context; hand off compact decisions and paths.

Finish when confirmed in-scope blockers are closed, preserved contracts and required
checks pass for the reviewed source, and no required coverage is unresolved. Report
remaining gaps without converting them into invented product defects or a green verdict.
