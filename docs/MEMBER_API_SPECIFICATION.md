# Member API Specification

Base URL: the backend host (dev: `http://10.0.2.2:8000` from the Android emulator, `http://localhost:8000`
from the iOS simulator). All paths below start with `/api/v1`. Source of truth: `routes/api.php` and the
feature tests in `tests/Feature/Api/*` of the backend. **Real responses** captured from the backend are in
[`docs/examples/`](examples/) (`<name>.bn.json` / `<name>.en.json`, each `{status, body}`).

## Conventions

### Headers

| Header | When | Value |
|--------|------|-------|
| `Accept` | always | `application/json` |
| `Accept-Language` | always | `bn` or `en` (anything else → Bangla). Sets the language of every `message`, enum `label` and money `display`. |
| `Authorization` | protected endpoints | `Bearer <access_token>` |
| `Content-Type` | JSON bodies | `application/json`; `multipart/form-data` for `POST /payments` |

### Envelope (every response, success or error)

```json
{ "success": true, "statusCode": 200, "message": "ঠিক আছে", "data": {}, "errors": null, "meta": null }
```

- Errors: `success: false`, `data: null`, localised `message`; `errors` is `{"field": ["message", ...]}` on 422.
- Lists: `data` is an array and `meta` is `{"current_page": 1, "last_page": 3, "per_page": 20, "total": 47}`. Page size is fixed at 20; ask for more with `?page=N`.

### Value formats

| Kind | JSON | Example |
|------|------|---------|
| Money | `{"poisha": int, "display": string}` | `{"poisha": 100525, "display": "৳ ১,০০৫.২৫"}` |
| Enum | `{"value": string, "label": string, "color": string\|null}` | `{"value": "open", "label": "বকেয়া", "color": "warning"}` |
| Date | `"YYYY-MM-DD"` | `"2026-07-20"` |
| Month | `"YYYY-MM"` | `"2026-08"` |
| Timestamp | ISO-8601, Asia/Dhaka | `"2026-08-12T10:00:00+06:00"` |

### Status codes

| Code | Meaning | App behaviour |
|------|---------|---------------|
| 200 / 201 | OK / created | show data |
| 401 | not signed in, token expired, revoked or wrong type | refresh once (single-flight); if that fails → login |
| 403 | not a member any more (exited) — tokens revoked | go to login with the message |
| 403 `member_only` | an applicant token used on a member endpoint | stay on registration status; never shown as an error page |
| 404 | not found or not yours; unknown route | show the message |
| 405 | wrong method | treat as a bug |
| 409 | idempotency conflict (pay online) | show the message |
| 422 | validation or business rule | show field errors / the message |
| 429 | too many attempts | show the message; wait |
| 500 | server error (generic message, no details) | "something went wrong" |

Example 401 ([examples/error_401.en.json](examples/error_401.en.json)):

```json
{ "success": false, "statusCode": 401, "message": "Please sign in again.", "data": null, "errors": null, "meta": null }
```

### Rate limits

| Endpoints | Limit |
|-----------|-------|
| `auth/login`, `auth/send-code` | 5 per minute per mobile + IP (shared bucket) |
| `auth/refresh-token` | 10 per minute per IP |
| everything signed-in | 60 per minute per member |

---

## Sign in

### Endpoint
`POST /api/v1/auth/login`

### Method
POST

### Authentication
None.

### Headers
`Accept`, `Accept-Language`, `Content-Type: application/json`.

### Parameters
None.

### Request

```json
{ "mobile": "01712345678", "password": "secret-123" }
```

or, when `otp_enabled`:

```json
{ "mobile": "01712345678", "code": "482913" }
```

### Response
200 ([examples/auth_login.en.json](examples/auth_login.en.json)):

```json
{
  "success": true, "statusCode": 200, "message": "Signed in.",
  "data": { "access_token": "1|…", "refresh_token": "2|…", "token_type": "Bearer", "expires_in": 3600, "account_type": "member" },
  "errors": null, "meta": null
}
```

`account_type` is `"member"` or `"applicant"` (invited, not yet approved). The same field is returned by `auth/refresh-token` and `auth/me`; the app opens the dashboard for `member` and the registration status for `applicant`.

### Validation
`mobile` required string ≤ 20; `password` required without `code` (≤ 200); `code` required without `password` (≤ 10).

### Error Responses
422 `errors.mobile: ["The mobile number or password is not correct."]` ([examples/error_422_login.en.json](examples/error_422_login.en.json)); 422 `errors.code` (wrong/expired code, or codes switched off); 429.

### Pagination
None.

### Business Rules
Exited members and staff cannot sign in; inactive members can. See MEMBER_BUSINESS_RULES.md → Sign in.

---

## Send SMS code

### Endpoint
`POST /api/v1/auth/send-code`

### Method / Authentication / Headers
POST · none · JSON.

### Request
`{ "mobile": "01712345678" }`

### Response
200 `data: null`, `message` "code sent". Also 200 for an unknown mobile (nothing is sent).

### Validation / Errors
`mobile` required. 404 when codes are switched off; 422 `errors.mobile` (bad number, too many codes — message says how long to wait); 429.

### Business Rules
Code valid 5 minutes, 5 tries; 3 codes per 10 minutes per mobile, 10 per IP.

---

## Refresh tokens

### Endpoint
`POST /api/v1/auth/refresh-token`

### Authentication
None (the refresh token is in the body).

### Request
`{ "refresh_token": "2|…" }`

### Response
200 with a **new** pair (same shape as sign-in). The old refresh token is spent.

### Error Responses
401 for an unknown, expired, spent or wrong-type token. A spent token presented again more than 30 s after use signs the member out everywhere.

### Business Rules
**Refresh single-flight**: when several requests get 401 together, refresh once and retry them all with the new token.

---

## Sign out

`POST /api/v1/auth/logout` · Bearer · no body · 200 `data: null`. Ends this device's session (access + refresh).

---

## Session check

`GET /api/v1/auth/me` · Bearer · 200 ([examples/auth_me.en.json](examples/auth_me.en.json)):

```json
{ "data": { "member_no": "M-0042", "name": "Rahim Uddin", "status": { "value": "active", "label": "Active", "color": "success" } } }
```

401 → refresh/sign in; 403 → exited.

---

## Society information

`GET /api/v1/config/somiti-info` · **no auth** · 200 ([examples/config_somiti_info.bn.json](examples/config_somiti_info.bn.json)):

```json
{
  "data": {
    "name": "সবুজ সমবায় সমিতি লিমিটেড", "name_bn": "সবুজ সমবায় সমিতি লিমিটেড", "name_en": "Sabuj Cooperative Society Ltd",
    "registration_no": "DHK-1234", "address": "মিরপুর, ঢাকা", "phone": "01711000000", "email": "office@sabuj.test",
    "logo_url": null, "otp_enabled": false
  }
}
```

`logo_url` is a signed link valid 1 hour (load it with an image loader; no token needed), or `null`.

---

## Dashboard summary

`GET /api/v1/dashboard/summary` · Bearer · 200 ([examples/dashboard_summary.bn.json](examples/dashboard_summary.bn.json)):

```json
{
  "data": {
    "member": { "member_no": "M-0042", "name": "রহিম উদ্দিন", "status": { "value": "active", "label": "সক্রিয়", "color": "success" } },
    "savings": { "poisha": 200000, "display": "৳ ২,০০০.০০" },
    "advance": { "poisha": 26000, "display": "৳ ২৬০.০০" },
    "outstanding": { "poisha": 0, "display": "৳ ০.০০" },
    "paid_through": "2026-08",
    "advance_months_estimate": 0,
    "shares": 2,
    "pay_now_visible": false,
    "recent_payments": [ { "id": 1, "received_on": "2026-07-20", "method": {…}, "trx_id": null, "amount": {…}, "status": {…} } ]
  }
}
```

**Business rules:** all numbers are calculated by the backend (MEMBER_ACCOUNTING_RULES.md). `paid_through` may be `null`.

---

## Dues

### Endpoint
`GET /api/v1/dues`

### Authentication
Bearer.

### Parameters

| Query | Values | Default |
|-------|--------|---------|
| `status` | `all`, `open`, `settled`, `cancelled`, `waived` | `open` |
| `type` | `deposit`, `service_charge`, `registration`, `late_fee` | (all) |
| `page` | 1… | 1 |

### Response
200, paginated ([examples/dues.en.json](examples/dues.en.json)). Each item:

```json
{
  "id": 3, "month": "2026-07",
  "type": { "value": "deposit", "label": "Monthly deposit", "color": "success" },
  "amount": { "poisha": 100000, "display": "৳ 1,000.00" },
  "paid": { "poisha": 100000, "display": "৳ 1,000.00" },
  "outstanding": { "poisha": 0, "display": "৳ 0.00" },
  "due_date": "2026-07-10",
  "status": { "value": "settled", "label": "Settled", "color": "success" }
}
```

### Validation / Errors
422 `errors.status` / `errors.type` for unknown values ([examples/error_422_dues_status.en.json](examples/error_422_dues_status.en.json)).

### Pagination
Yes. Ordered month newest first, then id.

---

## Payments

### List
`GET /api/v1/payments?status=&page=` · Bearer · paginated ([examples/payments.en.json](examples/payments.en.json)). `status` ∈ `pending`, `approved`, `rejected`, `cancelled`, `reversed`. Ordered received date newest first. Item:

```json
{ "id": 1, "received_on": "2026-07-20", "method": { "value": "cash", "label": "Cash", "color": null }, "trx_id": null,
  "amount": { "poisha": 250000, "display": "৳ 2,500.00" }, "status": { "value": "approved", "label": "Approved", "color": "success" } }
```

### Detail
`GET /api/v1/payments/{id}` · Bearer · 200 ([examples/payment_detail.en.json](examples/payment_detail.en.json)): the list fields plus

```json
{
  "rejection_reason": null,
  "approved_at": "2026-08-12T10:00:00+06:00",
  "receipt_available": true,
  "allocations": [ { "due_id": 1, "month": "2026-07", "type": { "value": "registration", … }, "amount": { "poisha": 20000, … } } ],
  "to_advance": { "poisha": 26000, "display": "৳ 260.00" }
}
```

Σ `allocations[].amount.poisha` + `to_advance.poisha` = `amount.poisha` (backend invariant). 404 for another member's id ([examples/error_404.en.json](examples/error_404.en.json)).

### Receipt
`GET /api/v1/payments/{id}/receipt` · Bearer · 200 `{"url": "https://…/receipts/1?…signature=…"}` ([examples/payment_receipt.en.json](examples/payment_receipt.en.json)). Open the URL in the browser (no token needed; signed). 404 unless approved and the member's.

### Pay online

#### Endpoint
`POST /api/v1/payments`

#### Headers
Bearer, `Accept: application/json`, `Content-Type: multipart/form-data`.

#### Request (form fields)

| Field | Rule |
|-------|------|
| `method` | `bkash` or `nagad` |
| `amount` | taka as text, > 0, ≤ 2 decimals; English or Bangla digits and commas allowed (`"1,000.50"`, `"১০০০"`) |
| `trx_id` | `^[A-Za-z0-9]{6,40}$` (stored upper-case) |
| `received_on` | `YYYY-MM-DD` |
| `proof` | file: jpeg, png, webp or pdf, ≤ 2048 KB |
| `idempotency_key` | UUID; one per form; reuse it on retry |

#### Response
201 with the payment detail (status `pending`) ([examples/payment_submit.bn.json](examples/payment_submit.bn.json)). The same key again → 201 with the same payment.

#### Errors
422 field errors ([examples/error_422_payment.bn.json](examples/error_422_payment.bn.json)); 422 `trx_taken` message (TrxID already used); 409 same key with a different amount ([examples/error_409_payment_conflict.bn.json](examples/error_409_payment_conflict.bn.json)).

---

## Statement

### Data
`GET /api/v1/statement?from=YYYY-MM-DD&until=YYYY-MM-DD` · Bearer · 200 ([examples/statement.en.json](examples/statement.en.json)):

```json
{
  "data": {
    "from": "2026-07-01", "until": "2026-08-31",
    "opening": { "poisha": 0, "display": "৳ 0.00" },
    "rows": [ { "date": "2026-07-01", "description": "Registration fee · July 2026", "charge": {…}, "paid": {…}, "balance": {…} } ],
    "total_charges": {…}, "total_paid": {…}, "closing": {…}
  }
}
```

Each row has both `charge` and `paid` as money (one of them is zero); `balance` is the running balance after the row. Defaults: `from` = 1 July of the current fiscal year, `until` = today. 422 when `until` < `from` or a date is malformed. Any `member` parameter is ignored.

### PDF link
`GET /api/v1/statement/pdf-link?from=&until=` · Bearer · 200 `{"url": "…/api/v1/statement/pdf-signed?…&signature=…"}` ([examples/statement_pdf_link.en.json](examples/statement_pdf_link.en.json)). Valid 15 minutes; open in the browser. The PDF is in the language of the `pdf-link` request (signed into the link), not the browser's. (`GET /statement/pdf` also exists and streams the PDF to a Bearer request.)

---

## Dividends

`GET /api/v1/dividends?page=` · Bearer · paginated ([examples/dividends.en.json](examples/dividends.en.json)). Item:

```json
{ "id": 7, "fiscal_year": "2026-27", "share_months": 24, "amount": { "poisha": 123456, "display": "৳ 1,234.56" },
  "status": { "value": "credited", "label": "Credited to savings", "color": "success" }, "settled_at": "2027-09-10T11:00:00+06:00" }
```

---

## Shares overview

`GET /api/v1/shares/overview` · Bearer · 200 ([examples/shares_overview.en.json](examples/shares_overview.en.json)):

```json
{
  "data": {
    "current_shares": 2,
    "history": [ { "type": { "value": "increase", … }, "shares": 2, "shares_after": 2, "effective_from": "2026-07", "reason": "Joined" } ],
    "rates": {
      "effective_from": "2026-07",
      "share_unit": { "poisha": 50000, … }, "service_charge_per_share": {…}, "registration_fee_per_share": {…},
      "due_day": 10, "grace_days": 5,
      "late_fee": { "mode": { "value": "percent", … }, "fixed": null, "percent": "2.00", "cap": null, "frequency": { "value": "once", … } }
    }
  }
}
```

`rates` is `null` when no approved plan covers the current month. `late_fee.mode` ∈ `none`, `fixed`, `percent`; `frequency` ∈ `once`, `monthly_until_paid` (or null).

---

## Profile

`GET /api/v1/profile` · Bearer · 200 ([examples/profile.en.json](examples/profile.en.json)):

```json
{ "data": { "member_no": "M-0042", "name": "Rahim Uddin", "name_bn": "রহিম উদ্দিন", "name_en": "Rahim Uddin",
  "mobile": "01712345678", "joined_on": "2026-07-01", "status": {…},
  "nominees": [ { "name": "করিমা বেগম", "relation": "স্ত্রী", "share_percent": "100.00", "share_display": "100.00%" } ] } }
```

Read-only.

## Change password

`POST /api/v1/profile/change-password` · Bearer · `{"current_password": "…", "password": "…", "password_confirmation": "…"}` · 200 `data: null`. 422 wrong current password (message) / `errors.password` (min 6, confirmed). Other devices are signed out; this one stays signed in.

---

## Notifications (SMS history)

`GET /api/v1/notifications?page=` · Bearer · paginated ([examples/notifications.en.json](examples/notifications.en.json)). Item:

```json
{ "id": 12, "kind": { "value": "payment_approved", "label": "Payment approved", "color": null },
  "body": "…", "status": { "value": "sent", "label": "Sent", "color": "success" }, "sent_at": "2026-07-20T10:05:00+06:00" }
```

`kind` may be `null` for a message without a template. Login-code SMS are never included.

---

## Self-registration (applicants)

The office invites a mobile + password in the admin; the person signs in with them and gets an `applicant` token (ability `applicant`; `auth/me`, `auth/logout`, `auth/refresh-token` also accept it). Member endpoints answer an applicant token with **403 `api.registration.member_only`**. On approval the applicant token is revoked; the next refresh returns a member token.

### `auth/me` for an applicant
`GET /api/v1/auth/me` · Bearer · 200 `data`:

```json
{ "account_type": "applicant", "mobile": "01712345678",
  "registration": { "status": {"value":"submitted","label":"…","color":"warning"}, "next_action": "wait" } }
```

A member gets the member fields plus `"account_type": "member"`.

### Nominee relations
`GET /api/v1/config/nominee-relations` · public · `data: [{ "id": 1, "key": "father", "label": "পিতা" }]`, active only, ordered by `sort`.

### Get the registration
`GET /api/v1/registration` · Bearer (applicant) · 200 `data`:

```json
{
  "status": {"value":"submitted","label":"অনুমোদনের অপেক্ষায়","color":"warning"},
  "next_action": "wait",
  "can_edit": false,
  "headline": "সভাপতির অনুমোদনের অপেক্ষায়",
  "message": "সম্পাদক আপনার নিবন্ধন যাচাই করেছেন। এখন সভাপতির অনুমোদনের অপেক্ষায়।",
  "timeline": [
    {"key":"submitted","label":"তথ্য জমা","state":"done","acted_at":"2026-10-07T10:00:00+06:00","actor":null,"reason":null},
    {"key":"step_0","label":"সম্পাদকের অনুমোদন","state":"done","acted_at":"…","actor":"…","reason":null},
    {"key":"step_1","label":"সভাপতির অনুমোদন","state":"pending","acted_at":null,"actor":null,"reason":null},
    {"key":"activation","label":"সদস্যপদ চালু","state":"waiting","acted_at":null,"actor":null,"reason":null}
  ],
  "decision": null,
  "data": {
    "name_bn": "…", "name_en": "…", "guardian_name": null, "nid": null, "date_of_birth": null,
    "mobile": "01712345678", "email": null, "address": null, "photo_url": null,
    "requested_shares": 2,
    "nominees": [{"name":"…","relation_id":1,"relation":"পিতা","mobile":null,"nid":"…","share_percent":"100.00"}]
  }
}
```

- `status.value` drives the screen; `next_action` is the one main button: `complete` / `resubmit` open the form, `wait` shows only pull-to-refresh.
- `timeline[].state`: `done | pending | waiting | returned | rejected`. Labels are role labels, already localised; the app never translates roles.
- `decision` (returned or rejected, else `null`): `{ "type": {value,label,color}, "by_role": "সভাপতি", "at": "2026-10-07T12:00:00+06:00", "reason": "…" }`.
- `share_percent` is a decimal string with up to 2 places (`"100.00"`); the app only shows a running total and never computes money.
- `photo_url` is a short-lived signed URL.

### Save the draft
`PUT /api/v1/registration` · Bearer (applicant) · any subset of `name_bn, name_en, guardian_name, nid, date_of_birth, email, address, requested_shares, nominees[]`. `nominees` replaces the whole list; each `{name, relation_id, mobile?, nid, share_percent}`. 200 returns the **Get the registration** shape. 422 field errors; 422 `registration.errors.not_editable` unless the status is `invited` or `returned`.

### Upload the photo
`POST /api/v1/registration/photo` · Bearer (applicant) · `multipart/form-data` field `photo` (jpg/png, ≤ 1 MB). 200 returns the **Get the registration** shape.

### Submit
`POST /api/v1/registration/submit` · Bearer (applicant) · `{ "idempotency_key": "<uuid>" }` (one UUID per attempt; reused on retry). 200 returns the **Get the registration** shape with status `submitted`. 422 field errors (`nominees`, `nominees.0.nid`, …) or a rule message; 409 `registration.errors.idempotency_conflict`; 422 `not_editable`.

---

## Endpoints the existing app referenced that do not exist

`auth/register` (sign-up is by invitation only; see Self-registration), `auth/forgot-password`, `auth/verify-otp`, `auth/reset-password`, `config/version-check`,
`savings/*`, `loans/*`, `members`, `transactions` — **not supported**; remove them from `ApiConstants`.
`shares/overview`, `notifications`, `profile`, `profile/change-password`, `dashboard/summary`, `config/somiti-info`,
`auth/login`, `auth/refresh-token`, `auth/logout` exist with the shapes above.
