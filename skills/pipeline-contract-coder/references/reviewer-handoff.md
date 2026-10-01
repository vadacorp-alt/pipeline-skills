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

## Keep coder results out of the reviewer prompt

The coder's report may retain exact commands and results for the user, diagnosis, and
historical source/environment identity. Do not duplicate routine successful outcomes
in **«Готовый запрос ревьюеру»**. In particular, omit PASS labels, passed-test counts,
environment versions, timings, and copied output: they consume context and are claims
the independent reviewer must verify rather than trust.

Include a compact **reproduction pointers** line only when it materially saves
rediscovery: contract-mandated gates, a non-obvious regression/reproducer command, or
the path to a dedicated test/evidence artifact. Prefer paths or grouped literal
commands over a narrated result list. These are candidates for independent execution,
not proof and not an exhaustive review checklist. Explicitly leave check selection and
additional causal coverage to the reviewer.

Always surface material negative verification state: FAIL, BLOCKED_ENV, skipped or
flaky required coverage, unavailable prerequisites, stale evidence, and checks that
were not run. State the limitation and where its evidence lives without pasting logs.
If all coder checks succeeded and no reproduction pointer is non-obvious, omit the
checks field entirely; the linked coder report remains the record of coder-side runs.

Require the reviewer to compare the packet with actual Git/files/environment and
verify claims independently. Reuse trustworthy evidence only while its relevant
assumptions still hold; the coder's PASS does not settle the review. Source, test or
environment drift requires the affected delta/checks, not an automatic full restart.

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
<Для первичного прохода: проверить весь согласованный результат и причинные пути>.
<Для повторного: прежние открытые ID и регрессии от фикса; закрытые/отклонённые
не переоткрывать без новых фактов; учитывать затронутые неизменённые участки>.

Ориентиры воспроизведения из <cwd>: <только неочевидные или обязательные команды/пути;
без результатов кодера; не ограничивают выбор проверок ревьюером>. <Поле можно убрать>.
Остаётся непроверенным: <конкретные пробелы и необходимые свидетельства либо none>.
Сверь переданные данные с Git и файлами; самостоятельно выбери и выполни достаточные
проверки соответствия контракту, не полагаясь на результаты кодера и не ограничиваясь
его ориентирами. Выдай вердикт и решения по прежним ID, если они есть.
Полномочия: <действующие границы проверок и изменений; никаких новых разрешений>.
```

Do not add this block to an explicit code-only response or require an artifact for a
trivial task. If required work remains, continue feasible authorized work first; a
requested early handoff must say **incomplete** and name what can actually be reviewed.
Missing environments cannot silently become closed items or a claim of full readiness.
Writing or forwarding a prompt is not review approval and never starts an automatic
coder/reviewer loop. Preserve existing authorization; do not infer product repair,
commit, push, deployment, or shared-state changes from a review request alone.
