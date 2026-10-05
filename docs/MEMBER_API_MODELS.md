# Member API Models

Dart models for every request and response of the member API (MEMBER_API_SPECIFICATION.md). Every model
uses `@JsonSerializable()` with `@JsonKey(name: …)` for snake_case keys; nested models use
`explicitToJson: true`. Field lists match the backend exactly (checked against `docs/examples/`).

Type rules:
- **Money** is always `MoneyModel` — never `double`. Show `display`; compare with `poisha` (int).
- **Dates** (`YYYY-MM-DD`), **months** (`YYYY-MM`) and **timestamps** (ISO-8601 +06:00) are `String`; format them for display, never do date maths on money.
- **Enums** are `EnumValueModel`; the backend `label` is already in the request language. Known values are listed so the app can choose icons; unknown values must still display (use `label`).

---

## ApiResponse\<T\> (existing `lib/core/models/api_response_model.dart`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| success | success | bool | No | true for 2xx | `true` |
| statusCode | statusCode | int | No | HTTP status repeated | `200` |
| message | message | String | No | Localised message | `"ঠিক আছে"` |
| data | data | T | Yes | Payload; null on errors | — |
| errors | errors | Map\<String, List\<String\>\> | Yes | Field errors on 422 | `{"amount": ["…"]}` |
| meta | meta | PaginationMeta | Yes | Lists only | — |

## PaginationMeta (existing)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| currentPage | current_page | int | No | Page returned | `1` |
| lastPage | last_page | int | No | Last page | `3` |
| perPage | per_page | int | No | Always 20 | `20` |
| total | total | int | No | Total items | `47` |

## MoneyModel (new, `lib/core/models/money_model.dart`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| poisha | poisha | int | No | Exact amount in poisha (1 taka = 100) | `100525` |
| display | display | String | No | Backend-formatted text in the request language | `"৳ ১,০০৫.২৫"` |

Getter: `bool get isPositive => poisha > 0`.

## EnumValueModel (new, `lib/core/models/enum_value_model.dart`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| value | value | String | No | Stable machine value | `"open"` |
| label | label | String | No | Localised label | `"বকেয়া"` |
| color | color | String | Yes | `success`, `warning`, `danger`, `info`, `gray`, `primary` or null | `"warning"` |

Enum values the member API returns:

| Enum | Values |
|------|--------|
| Member status | `active`, `inactive`, `exited` |
| Due type | `deposit`, `service_charge`, `registration`, `late_fee` |
| Due status | `open`, `settled`, `cancelled`, `waived` |
| Payment method | `cash`, `bkash`, `nagad`, `bank` |
| Payment status | `pending`, `approved`, `rejected`, `cancelled`, `reversed` |
| Dividend status | `unpaid`, `paid`, `credited` |
| Share change | `increase`, `decrease` |
| Late fee mode | `none`, `fixed`, `percent` |
| Late fee frequency | `once`, `monthly_until_paid` |
| SMS kind | `welcome`, `dues_generated`, `payment_approved` |
| SMS status | `queued`, `sent`, `failed` |

---

## LoginRequestModel (request, replaces the existing one)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| mobile | mobile | String | No | As typed (Bangla digits converted to English by the app) | `"01712345678"` |
| password | password | String | Yes | Omit when using a code (`includeIfNull: false`) | `"secret-123"` |
| code | code | String | Yes | 6-digit SMS code; omit with a password | `"482913"` |

## AuthTokenModel (existing, unchanged keys)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| accessToken | access_token | String | No | Bearer token, 60 min | `"1|…"` |
| refreshToken | refresh_token | String | No | Single-use, 30 days | `"2|…"` |
| tokenType | token_type | String | No | Always `Bearer` | `"Bearer"` |
| expiresIn | expires_in | int | No | Seconds | `3600` |

## MemberBriefModel (`auth/me`, and `member` inside the dashboard)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| memberNo | member_no | String | No | Member number | `"M-0042"` |
| name | name | String | No | Name in the request language | `"রহিম উদ্দিন"` |
| status | status | EnumValueModel | No | Member status | `{"value": "active", …}` |

## SomitiInfoModel (`config/somiti-info`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| name | name | String | No | Name in the request language | `"সবুজ সমবায় সমিতি লিমিটেড"` |
| nameBn | name_bn | String | No | Bangla name | — |
| nameEn | name_en | String | No | English name | — |
| registrationNo | registration_no | String | Yes | Registration number | `"DHK-1234"` |
| address | address | String | Yes | Address in the request language | `"মিরপুর, ঢাকা"` |
| phone | phone | String | Yes | Office phone | `"01711000000"` |
| email | email | String | Yes | Office email | — |
| logoUrl | logo_url | String | Yes | Signed image URL (1 h) | — |
| otpEnabled | otp_enabled | bool | No | SMS-code sign-in available | `false` |

## DashboardSummaryModel (`dashboard/summary`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| member | member | MemberBriefModel | No | Who is signed in | — |
| savings | savings | MoneyModel | No | Savings balance (2101) | `৳ ২,০০০.০০` |
| advance | advance | MoneyModel | No | Advance held (2111) | `৳ ২৬০.০০` |
| outstanding | outstanding | MoneyModel | No | Owed on open dues | `৳ ০.০০` |
| paidThrough | paid_through | String | Yes | Month `YYYY-MM` | `"2026-08"` |
| advanceMonthsEstimate | advance_months_estimate | int | No | Estimate only | `0` |
| shares | shares | int | No | Shares this month | `2` |
| payNowVisible | pay_now_visible | bool | No | Show "Pay now" | `false` |
| recentPayments | recent_payments | List\<PaymentSummaryModel\> | No | Latest 5 | — |

## DueModel (`dues`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| id | id | int | No | Due id | `4` |
| month | month | String | No | `YYYY-MM` | `"2026-08"` |
| type | type | EnumValueModel | No | Due type | deposit |
| amount | amount | MoneyModel | No | Charged | `৳ 1,000.00` |
| paid | paid | MoneyModel | No | Paid so far | `৳ 1,000.00` |
| outstanding | outstanding | MoneyModel | No | Still owed | `৳ 0.00` |
| dueDate | due_date | String | No | `YYYY-MM-DD` | `"2026-08-10"` |
| status | status | EnumValueModel | No | Due status | settled |

## PaymentSummaryModel (`payments` list, dashboard)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| id | id | int | No | Payment id | `1` |
| receivedOn | received_on | String | No | `YYYY-MM-DD` | `"2026-07-20"` |
| method | method | EnumValueModel | No | Method | cash |
| trxId | trx_id | String | Yes | TrxID (bKash/Nagad/bank) | `"BK8X2LQ91Z"` |
| amount | amount | MoneyModel | No | Amount | `৳ 2,500.00` |
| status | status | EnumValueModel | No | Payment status | approved |

## PaymentDetailModel (`payments/{id}`, `POST payments`)

All PaymentSummaryModel fields, plus:

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| rejectionReason | rejection_reason | String | Yes | Why staff rejected it | `null` |
| approvedAt | approved_at | String | Yes | ISO timestamp | `"2026-08-12T10:00:00+06:00"` |
| receiptAvailable | receipt_available | bool | No | Approved → receipt exists | `true` |
| allocations | allocations | List\<PaymentAllocationModel\> | No | What it settled (empty until approved) | — |
| toAdvance | to_advance | MoneyModel | No | Part kept as advance | `৳ 260.00` |

## PaymentAllocationModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| dueId | due_id | int | No | Due settled | `3` |
| month | month | String | No | `YYYY-MM` | `"2026-07"` |
| type | type | EnumValueModel | No | Due type | service_charge |
| amount | amount | MoneyModel | No | Applied amount | `৳ 20.00` |

## PayOnlineRequest (multipart form, not a JSON model)

| Field | Form key | Dart type | Required | Description | Example |
|-------|----------|-----------|----------|-------------|---------|
| method | method | String | Yes | `bkash` or `nagad` | `"bkash"` |
| amount | amount | String | Yes | Taka as typed | `"1000"` |
| trxId | trx_id | String | Yes | 6–40 letters/digits | `"BK8X2LQ91Z"` |
| receivedOn | received_on | String | Yes | `YYYY-MM-DD` | `"2026-08-12"` |
| proof | proof | MultipartFile | Yes | jpeg/png/webp/pdf ≤ 2 MB | — |
| idempotencyKey | idempotency_key | String | Yes | UUID v4, one per form | — |

## ReceiptLinkModel / PdfLinkModel (`payments/{id}/receipt`, `statement/pdf-link`)

| Field | JSON Key | Type | Nullable | Description |
|-------|----------|------|----------|-------------|
| url | url | String | No | Signed URL to open in the browser |

## StatementModel (`statement`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| from | from | String | No | Range start | `"2026-07-01"` |
| until | until | String | No | Range end | `"2026-08-31"` |
| opening | opening | MoneyModel | No | Balance before `from` | `৳ 0.00` |
| rows | rows | List\<StatementRowModel\> | No | Charges and payments | — |
| totalCharges | total_charges | MoneyModel | No | Σ charges | — |
| totalPaid | total_paid | MoneyModel | No | Σ payments | — |
| closing | closing | MoneyModel | No | Balance at `until` | — |

## StatementRowModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| date | date | String | Yes | `YYYY-MM-DD` | `"2026-07-10"` |
| description | description | String | No | Localised text | `"Deposit · 2026-07"` |
| charge | charge | MoneyModel | Yes | Charged (zero on payment rows) | `৳ 1,000.00` |
| paid | paid | MoneyModel | Yes | Paid (zero on charge rows) | `৳ 0.00` |
| balance | balance | MoneyModel | Yes | Running balance (positive = owed) | `৳ 1,200.00` |

## DividendModel (`dividends`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| id | id | int | No | Line id | `7` |
| fiscalYear | fiscal_year | String | No | Fiscal year code | `"2026-27"` |
| shareMonths | share_months | int | No | Shares × months held | `24` |
| amount | amount | MoneyModel | No | Dividend | — |
| status | status | EnumValueModel | No | unpaid / paid / credited | — |
| settledAt | settled_at | String | Yes | ISO timestamp | — |

## SharesOverviewModel (`shares/overview`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| currentShares | current_shares | int | No | Shares this month | `2` |
| history | history | List\<ShareChangeModel\> | No | Newest first | — |
| rates | rates | RatesModel | Yes | Null when no plan covers this month | — |

## ShareChangeModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| type | type | EnumValueModel | No | increase / decrease | — |
| shares | shares | int | No | Shares changed | `2` |
| sharesAfter | shares_after | int | No | Shares held after | `2` |
| effectiveFrom | effective_from | String | No | `YYYY-MM` | `"2026-07"` |
| reason | reason | String | Yes | Staff note | `"Joined"` |

## RatesModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| effectiveFrom | effective_from | String | No | Plan start month | `"2026-07"` |
| shareUnit | share_unit | MoneyModel | No | Monthly deposit per share | `৳ 500.00` |
| serviceChargePerShare | service_charge_per_share | MoneyModel | No | Monthly service charge per share | `৳ 10.00` |
| registrationFeePerShare | registration_fee_per_share | MoneyModel | No | One-time fee per new share | `৳ 100.00` |
| dueDay | due_day | int | No | Day of month dues fall due | `10` |
| graceDays | grace_days | int | No | Days before a due is late | `5` |
| lateFee | late_fee | LateFeeModel | No | Late-fee rule | — |

## LateFeeModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| mode | mode | EnumValueModel | No | none / fixed / percent | — |
| fixed | fixed | MoneyModel | Yes | When mode = fixed | — |
| percent | percent | String | Yes | When mode = percent, two decimals | `"2.00"` |
| cap | cap | MoneyModel | Yes | Maximum fee | — |
| frequency | frequency | EnumValueModel | Yes | once / monthly_until_paid | — |

## ProfileModel (`profile`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| memberNo | member_no | String | No | Member number | `"M-0042"` |
| name | name | String | No | Name in the request language | — |
| nameBn | name_bn | String | No | Bangla name | `"রহিম উদ্দিন"` |
| nameEn | name_en | String | No | English name | `"Rahim Uddin"` |
| mobile | mobile | String | No | `01XXXXXXXXX` | `"01712345678"` |
| joinedOn | joined_on | String | No | `YYYY-MM-DD` | `"2026-07-01"` |
| status | status | EnumValueModel | No | Member status | — |
| nominees | nominees | List\<NomineeModel\> | No | May be empty | — |

## NomineeModel

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| name | name | String | No | Nominee name | `"করিমা বেগম"` |
| relation | relation | String | No | Relation | `"স্ত্রী"` |
| sharePercent | share_percent | String | No | Two decimals | `"100.00"` |
| shareDisplay | share_display | String | No | Localised with % | `"১০০.০০%"` |

## ChangePasswordRequest

| Field | JSON Key | Type | Required | Rule |
|-------|----------|------|----------|------|
| currentPassword | current_password | String | Yes | — |
| password | password | String | Yes | min 6 |
| passwordConfirmation | password_confirmation | String | Yes | equals password |

## SmsNotificationModel (`notifications`)

| Field | JSON Key | Type | Nullable | Description | Example |
|-------|----------|------|----------|-------------|---------|
| id | id | int | No | Message id | `4` |
| kind | kind | EnumValueModel | Yes | SMS kind | payment_approved |
| body | body | String | No | SMS text as sent (usually Bangla) | — |
| status | status | EnumValueModel | No | queued / sent / failed | — |
| sentAt | sent_at | String | Yes | ISO timestamp | — |

---

## Models removed from the app

`SomitiSummaryModel` (replaced by `DashboardSummaryModel`), `TransactionModel` (replaced by `StatementModel`),
`UserProfileModel` (replaced by `ProfileModel`), `SavingsAccountModel`, `LoanAccountModel`,
`AppVersionModel` usage — no backend counterpart.
