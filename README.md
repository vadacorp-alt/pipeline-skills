# Pipeline Skills Bundle

Production-grade AI agent skills for high-reliability software engineering, pairing **executable boundary proof** with **contract-driven implementation**.

---

## 📦 What's Included

This bundle contains the primary review and coding duo, along with essential companion skills:

| Skill | Role | Key Capabilities |
|---|---|---|
| **`/pipeline-proof-review`** | Lead QA Architect / Security Auditor | Real public-boundary integration tests, independent oracles, invariant proof, positive controls, bounded Evidence Receipts. |
| **`/pipeline-contract-coder`** | Precision Contract Coder | Stable contract enforcement, end-to-end impact tracing, YAGNI ladder, minimal diffs, seamless handoff to reviewer. |
| **`/ponytail`** | Senior Pragmatic Developer | YAGNI ladder, code reuse over new code, root-cause fixes, deletion over addition (`lite`, `full`, `ultra`). |
| **`security-review`** | Security Auditor | Trust boundaries, actor capabilities, secrets handling, payment & integration safeguards. |
| **`api-security-review`** | API Security Specialist | OWASP API Top 10 (2023), BOLA/IDOR protection, RBAC checks, mass-assignment guards. |
| **`supabase-postgres-best-practices`** | Database Specialist | PostgreSQL / Supabase, Row-Level Security (RLS), advisory locks, transaction isolation, connection pooling. |
| **`php-pro`** | PHP Lead Engineer | Modern PHP 8.4+, strict typing, test quality patterns, DTOs, and transaction boundaries. |
| **`php-best-practices`** | PHP Quality Gate | Precision money math, type coercion, error/exception hierarchies, Composer compatibility. |

---

## 🚀 Quick Installation

### Method 1: Via Skills CLI (`npx skills`) — Recommended

Install directly into your agent environment (Claude Code, Cursor, Codex, Antigravity, etc.):

```bash
npx skills add vadacorp-alt/pipeline-skills
```

To install all skills non-interactively:
```bash
npx skills add vadacorp-alt/pipeline-skills --all
```

---

### Method 2: One-line Git Clone & Install

Clone the repository and run the installer:

```bash
git clone https://github.com/vadacorp-alt/pipeline-skills.git
cd pipeline-skills
./install.sh
```

#### Custom installation target:
```bash
# Install to global Antigravity/Codex skills:
./install.sh ~/.agents/skills

# Install to Claude Code global skills:
./install.sh ~/.claude/skills

# Install into current project:
./install.sh .agent/skills
```

---

## 🔄 The Pipeline Workflow

The core architecture forms a closed, self-verifying feedback loop:

```
                      +-----------------------------+
                      |   /pipeline-proof-review    |
                      |  (Independent QA Auditor)   |
                      +--------------+--------------+
                                     |
               Generates reproducible evidence test
               & structured "Готовый запрос кодеру"
                                     |
                                     v
                      +-----------------------------+
                      |   /pipeline-contract-coder  |
                      |   (Invariant Implementer)   |
                      +--------------+--------------+
                                     |
               Implements minimal root-cause fix
               & structured "Готовый запрос ревьюеру"
                                     |
                                     +----------------> Back to Reviewer for Verification Gate
```

### 1. `/pipeline-proof-review`
- Discovers reachable business, security, and concurrency defects.
- Writes an **executable test on the real boundary** with an independent oracle (no mocks, no SQLite for Postgres).
- Verifies positive controls (legitimate operations still succeed).
- Formats bounded **Evidence Receipts** to preserve agent context.
- Produces a copy-pasteable task for the coder when blockers are found.

### 2. `/pipeline-contract-coder`
- Follows the Ponytail ladder: reuses existing helpers before writing new code.
- Fixes the root cause at the shared boundary instead of patching individual symptoms.
- Preserves all invariants, authorization gates, and transaction boundaries.
- Formulates a structured handoff back to the reviewer.

---

## 📄 License

MIT License. Free to use, adapt, and share.
