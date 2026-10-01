# Skills that govern implementation

Read on first use in a working context. Inspect the actual task and stack.

### Lazy Loading & Zero-Redundancy Policy (Strict)
1. **Never batch-load companion skills upfront.** Do NOT call `view_file` on all skills below at the start of a task.
2. **Never re-read content already in context.** If a skill, plan, or guideline is already present in the active conversation transcript, invoking `view_file` on it is strictly prohibited.
3. **Load strictly on demand (Lazy Load).** If you already know the project rules and standards from project instructions (`AGENTS.md`, `GEMINI.md`), proceed directly. Only call `view_file` on a specialist skill if a concrete, domain-specific rule or syntax edge case requires checking its reference text.
4. **Scope strictly by touched code:** Load PHP skills only when writing PHP code; load Supabase skills only when modifying SQL/RLS/migrations. Do not load irrelevant skills.

| Applies when | Required skill / source | Use it for |
| --- | --- | --- |
| Coding under this workflow, unless the user turns Ponytail off | `ponytail` (`ponytail/SKILL.md`) | Understand callers, reuse compatible code, minimize the complete root-cause change. Default full; preserve the user's selected level. |
| PostgreSQL/Supabase SQL, schema, RPC, RLS, triggers, pooling, locks, transactions | `supabase-postgres-best-practices` (`supabase-postgres-best-practices/SKILL.md`) | Existing schema, effective roles, constraints, isolation and transaction semantics. |
| Auth, untrusted input, sensitive data, money, secrets, uploads, integrations | `security-review` (`security-review/SKILL.md`) | Trust-boundary implementation and relevant regression cases. |
| API, ownership, RBAC, user resources, webhook, privileged server query | `api-security-review` (`api-security-review/SKILL.md`) | Real identity and authorization, allowed/denied effects, payload and webhook contracts. |
| PHP production code or PHP tests | `php-pro` (`php-pro/SKILL.md`) | Existing PHP/framework patterns, runtime, exceptions, transactions; testing-quality reference. |
| PHP production code or PHP tests | `php-best-practices` (`php-best-practices/SKILL.md`) | Types/coercion, error and security rules, exact amounts, Composer compatibility. |

Resolve installed entrypoints through standard skill roots in order:
1. Workspace-level: `.agent/skills/<name>/SKILL.md` or `.claude/skills/<name>/SKILL.md`
2. User-global: `~/.agents/skills/<name>/SKILL.md`, `~/.claude/skills/<name>/SKILL.md`, or `~/.codex/skills/<name>/SKILL.md`

For React/Next, mobile, NestJS or another domain, use the applicable installed skill
identified by routing/catalog and read its entrypoint before implementation. Scope
selection follows actual changed behavior, not a keyword or an unrelated file nearby.
Add a second specialty when the causal pipeline crosses it; do not replace the user's
stack or add technology just because a skill contains an example.

Record the applicable loaded paths and their implementation/check decisions in the task
record. A brief note of applicable standards suffices; do not manufacture a justification
ritual or read skills simply to satisfy a checklist. Reuse unchanged loaded content on subsequent rounds.

If a named path is stale, resolve that exact skill through the catalog/known roots;
Ponytail's current catalog alias may resolve through `~/.agents/skills/ponytail` or `~/.claude/skills/ponytail`.
Do not silently substitute a similar skill. If an applicable required source remains
missing, do unaffected work and identify the dependent implementation/verification
gap; do not claim full skill compliance or silently install/modify other skills.

## Interpret companion instructions within the task

- Ponytail does not authorize omitting approved behavior, security, required rollback,
  or preservation checks. A shared causal fix can need multiple files. A tiny patch
  in the wrong layer is not the preferred solution.
- Its smallest runnable check can be the existing integration invocation with several
  isolated cases. Use the real required engine and necessary isolated fixtures for
  pipeline proof. A demo of a helper cannot replace required API-to-DB verification.
  Do not add a new framework when the installed runner suffices.
- Security companion audit formats do not turn implementation into repeated broad
  review. Apply the relevant rules to the actual code and tests; unrelated findings
  do not expand the task. Full `pipeline-proof-review` loading is not a prerequisite.
- Global coverage quotas, PHPStan levels, scaffolding, preferred DTOs or dependencies
  from examples do not become new gates. Follow the project's actual supported gates
  and explicitly requested standards; optional tool absence is not a product defect.
- Verify version-sensitive technical details against the installed version and primary
  documentation when needed. Skill examples do not override real runtime, schema,
  authorization, or provider contracts.
