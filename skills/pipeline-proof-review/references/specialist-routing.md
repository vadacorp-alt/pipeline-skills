# Mandatory specialist routing

Read when first applying this skill in a working context. Inspect the pipeline.

### Lazy Loading & Zero-Redundancy Policy (Strict)
1. **Never batch-load companion skills upfront.** Do NOT call `view_file` on all companion skills below at the start of a review.
2. **Never re-read content already in context.** If a skill, plan, or test harness is already present in the active conversation transcript, invoking `view_file` on it is strictly prohibited.
3. **Load strictly on demand (Lazy Load).** If you already understand the relevant security/persistence/language invariants from project rules, proceed directly. Only call `view_file` on a specialist skill if a specific subtle rule or boundary is in doubt.
4. **Scope strictly by touched code:** Load PHP skills only when reviewing PHP handlers; load Supabase skills only when reviewing SQL/RLS/migrations.

| Signal | Required skill and installed entrypoint | Decisions to extract |
| --- | --- | --- |
| PostgreSQL/Supabase SQL, schema, RPC, RLS, pooling, locks, triggers, or transactions | `supabase-postgres-best-practices` (`supabase-postgres-best-practices/SKILL.md`) | Effective role; migrations; isolation and connections; reachable locking/RLS invariants. |
| Auth, untrusted inputs, secrets, payments, sensitive data, uploads, integrations | `security-review` (`security-review/SKILL.md`) | Trust boundaries; actor capabilities; sensitive outputs; negative cases and recovery. |
| API route, handler, ownership, RBAC, user resources, webhook, privileged server query | `api-security-review` (`api-security-review/SKILL.md`) | Owner access plus cross-owner denial; role gates; protected properties; webhook authenticity; response/state contract. |
| PHP production code or PHP tests | `php-pro` (`php-pro/SKILL.md`) | Existing runner/framework, PHP version, transaction/error paths, typed helpers. Read its testing reference. |
| PHP production code or PHP tests | `php-best-practices` (`php-best-practices/SKILL.md`) | Composer/runtime compatibility, coercion, exceptions, money precision, relevant type/security rules. |

Resolve installed entrypoints from standard skill roots in order:
1. Workspace-level: `.agent/skills/<name>/SKILL.md` or `.claude/skills/<name>/SKILL.md`
2. User-global: `~/.agents/skills/<name>/SKILL.md`, `~/.claude/skills/<name>/SKILL.md`, or `~/.codex/skills/<name>/SKILL.md`
If a path moved, resolve the exact name from the installed-skill catalog and read
that file. Search known skill roots if necessary; do not silently substitute a
similar skill. If an applicable dependency is still missing, continue unaffected
discovery and mark dependent proof `UNVERIFIED` with the missing entrypoint.
Do not install or rewrite other skills implicitly.

Do not edit test files just to record loaded skill paths in opening comments, and do
not read skills simply to satisfy a checklist ritual. Reuse unchanged loaded content on later rounds.

Read relevant references selectively:

- Postgres races: `references/lock-deadlock-prevention.md`, `lock-advisory.md`,
  `lock-short-transactions.md`, and the relevant `conn-*` rule.
- Postgres auth: `references/security-rls-basics.md` and `security-privileges.md`;
  inspect real policies, grants, owners, and function execution context.
- PHP tests: `php-pro/references/testing-quality.md`; read type/error/security
  rule files from `php-best-practices` when they affect the proof.

## Scope and technical interpretation

The user's proof request takes precedence over companion output templates. Do not
emit their finding lists, scaffold DTO/service/controller layers, rewrite production
code, add frameworks, auto-update dependencies, or impose global 80% coverage merely
because a companion describes a full implementation. Do not run static analyzers or type
checkers (`tsc --noEmit`, `php -l`, `phpstan`) during review unless you modified a test
file that requires a syntax check. Missing optional
tooling is a validation limit, not a product defect or reason to skip E2E execution.

Examples are aids, not authoritative contracts:

- Prints, status-only checks, mocked repositories, SQLite `:memory:` examples, and
  broad exception assertions cannot prove a PostgreSQL pipeline.
- UUIDs never make ownership checks optional. Use a valid known other-owner fixture,
  independent of how difficult its ID is to guess.
- Inspect the **effective request identity and database role**, not only the client
  initialization key. A user token can affect which policies a Supabase request
  runs under. Privileged setup/observation must not contaminate the attacker client.
- Neither one multi-row SQL statement nor `FORCE ROW LEVEL SECURITY` universally
  prevents deadlocks or privileged bypass. Verify actual roles and lock semantics.
- Cookie storage, SameSite, CSRF, rate limits, and performance thresholds depend on
  the real authentication/transport/business contract. Generic example settings
  cannot justify failing a different valid architecture.
- Use current OWASP labels when needed: property overexposure and mass assignment
  are API3:2023. A category label never substitutes for a concrete assertion.

Verify version-sensitive details against primary documentation. Sources checked
while authoring this skill (2026-09-05):

- [Supabase RLS and effective request identity](https://supabase.com/docs/guides/database/postgres/row-level-security#bypassing-row-level-security).
- [PostgreSQL locks and deadlocks](https://www.postgresql.org/docs/current/explicit-locking.html).
- [OWASP API3:2023 property-level authorization](https://owasp.org/API-Security/editions/2023/en/0xa3-broken-object-property-level-authorization/).
