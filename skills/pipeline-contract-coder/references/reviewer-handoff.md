# Give the user a ready-to-forward review task

Read when completing a plan, worktree task, or review fix, or when asked for a review
handoff. Append one filled, self-contained block in the user's language that invokes
`$pipeline-proof-review`. Generate it from [task-contract.md](task-contract.md) and
observed final evidence; do not ask the user to supply facts already available to you.
The coder prepares the review input without loading the full QA workflow, performing
another independent review, dispatching another task, or granting release permission.

## Carry the same contract into the correct review mode

- **Initial review:** request the whole delivered portion of the approved task and its
  causal business paths, including preserved behavior and missing required coverage.
  Do not restrict discovery to the coder's selected files or passing tests.
- **Fix verification:** when a prior completed review belongs to this same task and
  scope, include its report, reviewed source state, open IDs and prior decisions.
  Request closure evidence plus regressions caused by the fix, including unchanged
  callers and downstream effects it can affect. Do not restart a broad audit or reopen
  closed/rejected items without new relevant evidence. A materially changed task or
  missing authoritative prior review must be disclosed, not disguised as a narrow
  follow-up that exempts unreviewed behavior.

Use the actual absolute WORKTREE, branch/detached state, original BASE_SHA and initial
dirty evidence, RESULT_SHA and final relevant dirty-source identity. For a fix retain
REVIEWED_HEAD with its reviewed snapshot and the actual FIX_BASE; do not replace the
original baseline with either. Include the exact comparison base/range and its origin
when different. Link existing scoped patches/source hashes, including new source/tests;
exclude reports/logs from their own identity. Unknown history remains a named gap.

Link absolute paths to the approved plan/version and requested stages, compact coder
report, and prior review/fix plan when present. Inline a short accepted contract when
no document exists; do not invent files, SHAs, commands, or requirements. Carry the
observable acceptance, preserved invariants, exclusions, actual permissions, working
directory, non-secret prerequisites, and remaining gaps. Link detailed evidence
instead of copying full plans, logs or skills. Never prompt the reviewer to re-read
plans or companion skills already loaded in the active conversation context. State proposed fixes
under existing IDs; the reviewer determines their closure independently.

## Pass static check status & Evidence Receipt pointers to avoid redundant runs

The coder is responsible for running static syntax/type checks (`tsc --noEmit`, `php -l`)
on touched files once before handoff. Record a compact `Статические проверки: PASS (tsc --noEmit, php -l)`
line in **«Готовый запрос ревьюеру»** so the reviewer knows static compilation is already
clean and does NOT re-run TypeScript or PHP syntax checks.

Do not paste verbose test logs, passed-test counts, environment versions, or timings into
**«Готовый запрос ревьюеру»**. Instead, include a compact **reproduction & receipt pointers**
line with the test command and the path to the archived `Evidence Receipt` / log file.
If the reviewer runs in the same session or verifies that the source state matches and
the test code already covers all required positive/negative invariants, the reviewer can
verify the test code statically and reuse the receipt without re-executing the runner.
If the reviewer adds new negative cases, they will edit the test first and run it once.

Always surface material negative verification state: FAIL, BLOCKED_ENV, skipped or
flaky required coverage, unavailable prerequisites, stale evidence, and checks that
were not run. State the limitation and where its evidence lives without pasting logs.

## Shape of the generated task

Fill all relevant fields with observed facts or a specific unknown. Omit irrelevant
optional fields and keep commands literal. These placeholders are authoring guidance;
the user receives a completed copyable task, never a form to fill in.

```text
Используй $pipeline-proof-review.
Режим: <первичное ревью или проверка исправлений, с основанием выбора>.
WORKTREE: <абсолютный путь>; BRANCH: <ветка или detached>.
BASE_SHA и исходное dirty-состояние: <исходная база и свидетельства>.
RESULT_SHA и итоговое dirty-состояние: <текущий SHA и свидетельства>.
Для исправлений: <прежний отчёт, REVIEWED_HEAD/снимок, FIX_BASE и прежние ID>.

Основа: <абсолютные пути к версии плана, выполненные этапы, отчёт кодера> (Используй view_file ТОЛЬКО если это чистый запуск новой сессии без контекста. В текущей сессии повторное чтение плана строго запрещено).
Контракт и сохранение: <наблюдаемый результат, инварианты, исключения>.
Статические проверки (уже выполнены кодером, повторно НЕ запускать): <tsc --noEmit / php -l статус>.
<Для первичного прохода: проверить весь согласованный результат и причинные пути>.
<Для повторного: прежние открытые ID и регрессии от фикса; закрытые/отклонённые
не переоткрывать без новых фактов; учитывать затронутые неизменённые участки>.

Ориентиры воспроизведения и Evidence Receipt из <cwd>: <команда теста и путь к логу/receipt;
если код теста уже покрывает все позитивные/негативные инварианты, не перезапускай тест вхолостую —
сначала допиши недостающие кейсы (если они нужны) и запусти тест ровно 1 раз>.
Остаётся непроверенным: <конкретные пробелы и необходимые свидетельства либо none>.
Сверь код и тест с контрактом. Выдай вердикт и решения по прежним ID, если они есть.
Полномочия: <действующие границы проверок и изменений; никаких новых разрешений>.
```

Do not add this block to an explicit code-only response or require an artifact for a
trivial task. If required work remains, continue feasible authorized work first; a
requested early handoff must say **incomplete** and name what can actually be reviewed.
Missing environments cannot silently become closed items or a claim of full readiness.
Writing or forwarding a prompt is not review approval and never starts an automatic
coder/reviewer loop. Preserve existing authorization; do not infer product repair,
commit, push, deployment, or shared-state changes from a review request alone.
