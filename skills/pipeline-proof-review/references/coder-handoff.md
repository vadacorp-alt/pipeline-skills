# Turn the review into a ready-to-forward coder task

Read when a review ends with confirmed open in-scope blockers or the user asks for
a coder handoff. Produce one copyable task in the user's language. The user should
not have to reconstruct the worktree, comparison base, approved plan, or test commands.
Activate `$pipeline-contract-coder` explicitly; reference its verified installed path
when useful. Do not paste either skill's full instructions or require the coder to
run the QA discovery loop. Readiness for handoff does not mean approval of the code.

## Generate from the review you actually performed

- Verify the **absolute worktree path** separately from branch/detached state using
  actual Git metadata. A branch label is not a filesystem path. Record the original
  task `BASE_SHA` when known, the exact comparison base/range actually used for this
  review, and `REVIEWED_HEAD`. If these coincide, say so instead of duplicating data.
  Include relevant reviewed staged/unstaged changes and new source/tests through an
  existing scoped patch/snapshot plus source identities. HEAD alone does not identify
  a dirty review. Exclude reports/logs from their own source identity; never copy secrets.
- Link the exact plan/version and stages, review record, and fix plan used, with
  absolute paths so the receiving agent can locate them. If no separate artifact
  exists, inline the compact accepted contract; do not invent documents or require
  another planning project. Recover missing metadata from available Git/evidence.
  If still unknown, label the specific gap and the read-only step to resolve it.
  Do not substitute current `main` or a guessed merge-base. Missing historic metadata
  need not block a grounded local fix, but it limits claims about the full task delta.
- Include only confirmed **OPEN**, in-scope repair obligations, retaining their stable
  IDs. For each, give the reachable trigger, violated/required observable behavior,
  regression case and failing-before evidence, or the exact reproduction gap when
  confirmation rests on other evidence. Distinguish product failures from demonstrated
  harness failures affecting a required gate. Neither a hypothesis nor `BLOCKED_ENV`
  becomes a product fix. State closed/rejected/deferred exclusions and material coverage
  gaps compactly; do not import unrelated backlog. Deferred blockers remain unresolved.
- Carry over preserved behavior, affected public callers and final effects, exclusions,
  and completion criteria. Separate an approved implementation constraint from a
  reviewer's suggested technique. A fix-plan suggestion is not automatically a frozen
  requirement. Permit a better compatible root-cause fix; do not prescribe a guessed
  micro-patch or weaken the business contract to satisfy one test.
- Copy actual required reproduction/gate commands, working directory, non-secret
  prerequisites, and only the environment facts needed to run them. Map case IDs to
  findings and name the positive and preserved-flow controls the fix must retain.
  Include the precise failing-before outcome for each open repair ID, or its exact
  reproduction gap. Do not copy routine PASS results, passed counts, versions, timings,
  or logs into the coder task; link the review artifact when that history is useful.
  Mark required commands not run as such. A required command absent from the checkout
  is a stated gap, not an invented script. Never turn a skip or a local pass into proof
  of a missing router, deployed schema, cron, or provider boundary.
- Preserve the session's explicit no-touch and commit/push/deploy/shared-state limits
  and already granted permissions. Writing the task grants no additional authority;
  do not automatically send it to another agent/task or execute repairs. The user can
  forward it as the coding instruction. Do not require a new approval for ordinary
  local fixes once the user has assigned them.

Prefer one concise block with paths to existing detailed evidence. Repeat only the
facts needed to start safely and preserve scope; do not copy full plans, logs, history,
specialist checklists, or generic workflow instructions already supplied by the explicit
`$pipeline-contract-coder` invocation. Never command unconditional re-reading of
artifacts that are already present in the active conversation context. Render commands
literally inside the block, without escaped underscores, escaped path punctuation, or
nested code fences. Fill every relevant task-specific field with observed values or a
specific unknown; do not deliver an unfilled template.

The coder task is an implementation contract, not a review run report. Keep evidence
inline only when it changes what must be fixed, preserved, or rerun. A linked review
artifact remains the source for detailed successful runs. WORKTREE, source identity,
open IDs, failing-before evidence, required gates, and material verification gaps are
not optional compression targets because omitting them can redirect the fix or make its
verification non-reproducible.

## Shape of the generated task

Adapt the labels and length to the task. Omit absent optional artifacts and irrelevant
fields; the following placeholders describe authoring, not the delivered task.

```text
Используй $pipeline-contract-coder.

Работай в существующем WORKTREE: <проверенный абсолютный путь>.
BRANCH: <фактическая ветка или detached>.
BASE_SHA задачи: <исходный SHA или конкретный пробел>.
База/диапазон этого ревью: <фактически использованная база и происхождение>.
REVIEWED_HEAD: <полный SHA>.
Проверенное незакоммиченное состояние: <clean либо путь к patch/snapshot и хешам>.

План и ревью: <абсолютные пути к версии плана, ревью и имеющемуся fix plan>.
Контракт/этапы: <цель и согласованный объём, без пересказа всего плана>.

Исправь только: <стабильные ID подтверждённых открытых пунктов>.
<ID: достижимый триггер → требуемое поведение; test case → свидетельство до фикса>.
Сохрани: <затронутые работающие сценарии и инварианты>.
Ограничения реализации: <только реально утверждённые требования, если есть>.
Не входит: <актуальные исключения и решения, без нового backlog>.

Репродьюсеры и обязательные проверки из <cwd>: <точные команды, необходимая
подготовка без секретов и связь с ID; без перечня рутинных PASS ревьювера>.
До исправления: <только существенный FAIL по открытому ID либо точный пробел
BLOCKED_ENV/UNVERIFIED/не запускалось; подробности — в связанном артефакте ревью>.
Остаётся непроверенным: <обязательные границы и необходимые свидетельства либо none>.
Полномочия: <фактические ограничения и разрешённые действия этой задачи>.
```

If no confirmed open repair obligation remains, do not manufacture a coder assignment.
For a requested handoff with only verification gaps, state that distinction and supply
a bounded verification task with the relevant permissions, rather than instructions
to alter product behavior. An explicit code-only response does not trigger extra output.
