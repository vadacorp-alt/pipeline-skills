---
name: api-security-review
description: >
  Reviews REST/API endpoints for authorization and access-control flaws — Broken Object
  Level Authorization (BOLA/IDOR), broken function-level authorization, mass assignment,
  excessive data exposure, broken authentication, and missing rate limiting. Maps to OWASP
  API Security Top 10 2023. Use when adding or changing an API endpoint, a handler, an auth
  gate, an RBAC check, or any server route that returns/mutates user-owned resources (orders,
  profiles, addresses, payments). Tailored to a PHP api.php router + handlers/ + self-hosted
  Supabase (RLS + service_role) stack. Triggers on: new endpoint, IDOR, BOLA, "can user A read
  user B's data", object-level authorization, mass assignment, API access control.
license: Apache-2.0
---

# API Security Review

Defensive review skill for server-side API changes. The #1 real risk for an e-commerce API
is **a user reading or mutating another user's resource** (orders, addresses, payment data).
Run this whenever an endpoint is added or its auth/ownership logic changes.

> **Authorization required for active testing.** The PoC requests in Verification touch
> "other user" resources. On this codebase that means a local/staging instance with two seeded
> test accounts — never probe production data without explicit written authorization.

## When to Use

- A new route is added to `$handlerMap` in `public/api.php`, or an existing handler gains a new action.
- An endpoint returns or mutates a resource keyed by an ID the client supplies (`order_id`, `profile_id`, `address_id`, `reshipment_id`, `id`).
- Auth classification changes: something moves into/out of `$publicEndpoints`, `$partnerProtectedEndpoints`, or `$selfAuthEndpoints`.
- A Supabase query uses the **service_role** key (which bypasses RLS) inside a handler.
- Any change to `enforceCsrfIfCookieAuth()`, token validation, or RBAC role checks.

## Prerequisites

- The handler file(s) under `public/api/handlers/` and the relevant routing block in `public/api.php`.
- Knowledge of which auth class the endpoint falls into (public / partner / self / admin).
- For active PoC: a local or staging deploy with **two** seeded accounts (User A, User B) of the same role, plus one admin.

## Workflow

### Step 1 — Map the endpoint and its object IDs
For every changed route, write down: HTTP method, `type=` value, auth class, and **every client-supplied identifier**. Classify ID predictability:

| ID type | Example | BOLA risk |
|---|---|---|
| Sequential int | `order_id=1042` | Critical — trivially enumerable |
| UUID | `id=550e8400-…` | Medium — only safe if never leaked in responses/logs |
| Composite | `/users/42/orders/1042` | Critical — multiple IDs to swap |
| Slug/phone/email | `profile?phone=...` | High — guessable + takeover vector |

### Step 2 — Verify object-level authorization (BOLA / API1:2023)
The check that must exist: **does the server confirm the authenticated user owns the requested object?** Look for one of:
- An explicit ownership filter in the Supabase query: `&user_id=eq.{verified_user_id}` (or `profile_id=eq.`), where `verified_user_id` comes from the **validated token / `$verified`**, never from the request body or a query param.
- RLS doing the enforcement — but only if the query uses the **anon/user JWT**, not `service_role`. ⚠️ A `service_role` query bypasses RLS, so ownership must then be enforced in PHP.

🚩 Red flags:
- `supabaseRequest('GET'|'PATCH'|'DELETE', "orders?id=eq.{$input['id']}")` with no `user_id` constraint and a service_role key.
- Ownership taken from `$input['user_id']` / request body instead of the verified identity.
- Raw `supabaseRequest('PATCH', 'order_reshipments?...')` inside CDEK flow — **forbidden** by the identity boundary; must go through `reshipment_cdek_state.php` with `$verified`.

### Step 3 — Function-level authorization (API5:2023)
Admin/partner-only actions must re-check the role server-side, not rely on the UI hiding a button. Confirm admin endpoints validate the admin role inside the handler, and that a regular `self`-auth token cannot reach an admin `type=`.

### Step 4 — Mass assignment (API6:2023)
When a handler builds a Supabase write from `$input`, check it **allowlists** updatable fields. A client must not be able to set `role`, `is_admin`, `balance`, `payment_status`, `wholesale_approved`, `commission_rate`, etc. by adding them to the JSON body.
🚩 `supabaseRequest('PATCH', "profiles?id=eq.$id", $input)` — passing the whole body through is a mass-assignment hole.

### Step 5 — Excessive data exposure (API3:2023)
The response must not include fields the client shouldn't see: password hashes (never — see CLAUDE.md), other users' PII, internal flags, full payment data, other partners' commissions. Filter server-side; don't rely on the frontend to hide.

### Step 6 — Auth & rate limiting (API2 / API4)
- New `public` endpoints: confirm they truly need to be public and were added to `$publicEndpoints` intentionally. Cron endpoints must check `CRON_SECRET`.
- Login/OTP/refund and other sensitive actions: confirm server-side rate limiting (CLAUDE.md mandates it on login).
- Identity linking (MAX `customer_messenger_contacts.profile_id`) must only be written with `profile_link_verified_at` — auto-linking from order phone/email is a takeover vuln; use `maxDialogFindProfileId()` only with a verified channel.

### Step 7 — Webhook / callback authenticity
Payment & delivery callbacks (`payment.php?action=callback`, Robokassa ResultURL, CDEK webhook) must verify a signature before trusting the payload or marking an order paid:
- VTB: HMAC checksum via `VTB_CALLBACK_SECRET`.
- Robokassa ResultURL: `md5(OutSum:InvId:Password2)`; mismatch ⇒ HTTP 403, never mark paid.
- CDEK: `CDEK_WEBHOOK_SECRET`.

## Verification (local/staging, two accounts)

```python
import requests
BASE = "http://localhost:8000/api.php"
a = {"Cookie": "<User A session>"}; b_id = "<User B's order id>"

# BOLA read: A tries to read B's order
r = requests.get(f"{BASE}?type=order_detail&id={b_id}", headers=a)
print("READ other-user:", r.status_code, "VULN" if r.status_code == 200 else "ok")

# BOLA write: A tries to mutate B's order
r = requests.patch(f"{BASE}?type=order_update&id={b_id}", headers=a, json={"status": "cancelled"})
print("WRITE other-user:", r.status_code, "VULN" if r.status_code in (200, 204) else "ok")

# Mass assignment: self-update tries to escalate
r = requests.patch(f"{BASE}?type=profile_update", headers=a, json={"role": "admin", "is_admin": True})
# then re-read profile and assert role unchanged
```
Also enumerate ±N around your own sequential IDs and assert every other-owner object returns 403/404, not 200.

## Output Format
```
## Finding: <BOLA | Mass assignment | Excessive exposure | Broken func-auth> in <endpoint>
**Severity**: Critical/High/Medium
**OWASP API**: APIx:2023
**Endpoint(s)**: <method> api.php?type=...  (handler: handlers/xxx.php:LINE)
**PoC**: <request + observed status/data>
**Impact**: <what data/action is exposed across users>
**Remediation**: <ownership filter on verified id / field allowlist / role recheck / signature verify>
```

## Key references in this repo
- `public/api.php` — `$handlerMap`, `$publicEndpoints`, `$partnerProtectedEndpoints`, `$selfAuthEndpoints`, auth gate.
- `public/api/handlers/*.php` — per-domain logic; check ownership filters here.
- `public/api/helpers.php` — `enforceCsrfIfCookieAuth()`, cookies, CSRF.
- `public/api/auth.php` — token validation → the trusted identity source.
- CLAUDE.md pitfalls: *CDEK identity boundary*, *MAX profile linking*, *VTB/Robokassa callback secret*.
