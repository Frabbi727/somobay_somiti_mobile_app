# Member Business Rules

What a Somobay Somiti **member** can do, and the rules the backend enforces. Everything here comes from
the backend (`/Users/fazlerabbi/Desktop/Projects/tonmoy/somobay-somiti`); each section names its source.
The web member portal (`app/Filament/Member`) is the reference: the app offers the same capabilities.

Terms: **poisha** = 1/100 taka. **Due** = an amount the member owes for a month. **Advance** = money paid
ahead, held for future dues. **Rate plan** = the society's approved prices from a given month.

---

## Sign in with mobile number and password

### Purpose
Let a member into the app with the mobile number the society registered and the password the office gave them.

### Business Rules
- Only a **member's** portal account can sign in; staff accounts cannot (the account is found through the member's mobile number).
- Members with status **active** or **inactive** can sign in. **Exited** members cannot.
- The mobile number may be typed as `01712345678`, `+880 1712-345678`, or in Bangla digits; it is normalised to `01XXXXXXXXX`.
- Passwords are set by society staff ("Set portal password"). Members can change their own password later.
- A successful sign-in returns an **access token (valid 60 minutes)** and a **refresh token (valid 30 days, usable once)**.
- Wrong mobile or wrong password give the same message, so the app cannot tell which was wrong (no account discovery).
- At most **5 attempts per minute** per mobile number and device IP.

### Preconditions
The member exists, is not exited, and staff have set a portal password.

### User Flow
Enter mobile → enter password → Sign in → Home.

### Validation
`mobile` required (max 20 chars); `password` required unless a `code` is sent.

### Success Cases
200 with the token pair.

### Failure Cases
- 422 `errors.mobile` "The mobile number or password is not correct." (wrong mobile, wrong password, exited member, staff account).
- 429 after 5 attempts in a minute.

### Edge Cases
- Inactive member: signs in normally (same as the web portal).
- Several devices: each sign-in is a separate session; signing out one does not sign out the others.

### Backend Source
`app/Domain/Members/Portal/MemberCredentials.php`, `app/Http/Controllers/Api/Member/AuthController.php`,
`app/Domain/Members/Portal/MemberTokens.php`, `app/Providers/AppServiceProvider.php` (rate limits),
`tests/Feature/Api/ApiAuthTest.php`.

---

## Sign in with an SMS code

### Purpose
Sign in without a password, using a 6-digit code sent by SMS — **only when the society has switched this on**.

### Business Rules
- Available only when `config/somiti-info` returns `otp_enabled: true` (backend setting `somiti.portal_otp`). When off, `send-code` answers 404 and a login with `code` answers 422.
- The code is 6 digits, valid **5 minutes**, single use; after **5 wrong tries** it is void.
- Codes can be requested at most **3 times per 10 minutes per mobile** and **10 per 10 minutes per IP**; sending a code also counts against the 5-per-minute sign-in limit.
- For an unknown mobile number, `send-code` still answers 200 but sends nothing.
- Exited members cannot sign in with a code.

### Preconditions
Codes switched on; the member's mobile can receive SMS.

### User Flow
Enter mobile → "Send code" → SMS arrives → enter code → Sign in → Home.

### Validation
`mobile` required; `code` up to 10 characters (digits; Bangla digits are converted by the app before sending).

### Success Cases
`send-code` 200; `login` 200 with tokens.

### Failure Cases
422 `errors.code` with the backend's reason (wrong code, expired code); 422 `errors.mobile` for a bad number on send; 429 when limits are hit; 404 when codes are off.

### Edge Cases
Requesting a new code replaces the old one.

### Backend Source
`app/Domain/Members/Portal/LoginCodes.php`, `AuthController::sendCode`, `tests/Feature/Api/ApiAuthTest.php`, `tests/Feature/Portal/PortalTest.php`.

---

## Staying signed in, signing out

### Purpose
Keep the member signed in without asking for the password every hour, and let them sign out.

### Business Rules
- When the access token expires (60 min), the app calls `auth/refresh-token` with the refresh token and receives a **new pair**; the old refresh token is spent.
- A spent refresh token presented again **more than 30 seconds later** is treated as stolen: **every session of the member is signed out**. Presented again within 30 seconds (lost response, two refreshes at once) it just gets 401. The app must therefore refresh **one at a time**.
- Sign out (`auth/logout`) ends only this device's session.
- The member is signed out of the app **everywhere** when: staff set a new portal password; the member changes the password on the website; the member exits the society (the next request answers 403).
- Changing the password **in the app** signs out every other device but keeps this one signed in.

### Preconditions
A valid token pair.

### User Flow
App start → `auth/me` → valid: Home; invalid: Login. Profile → Sign out → confirm → Login.

### Validation
`refresh_token` required on refresh.

### Success Cases
Refresh 200 with a new pair; logout 200.

### Failure Cases
401 "Please sign in again" (expired, revoked or wrong-type token); 403 for an exited member.

### Edge Cases
A refresh token cannot be used as an access token, and vice versa (both 401).

### Backend Source
`MemberTokens.php`, `EnsureMemberAccess.php`, `ChangeOwnPassword.php`, `SetPortalPassword.php`, `tests/Feature/Api/ApiAuthTest.php`.

---

## Home (dashboard summary)

### Purpose
Show the member's position at a glance — exactly what the web portal's dashboard shows.

### Business Rules
- **Savings** = the member's balance on account 2101 (Member Savings Deposits): every deposit settled so far, from the books.
- **Advance** = money held for future dues (account 2111 sub-ledger).
- **Outstanding** = the sum of everything still owed on open dues.
- **Paid through** = the latest month M for which every due of month ≤ M is settled; `null` when nothing qualifies yet (for example, the oldest due is still open). Calculated by the backend, never stored.
- **Advance covers about N more months** = an estimate at the rate of the month after "paid through"; show it labelled as an estimate.
- **Shares** = the shares the member holds this month.
- **Pay now** is shown when outstanding > 0 (`pay_now_visible`).
- **Recent payments** = the latest 5 payments (any status), newest first.

### Preconditions
Signed in.

### User Flow
Open the app → Home.

### Validation
None (read-only).

### Success Cases
200 with the summary.

### Failure Cases
401 / 403 as in sessions; network errors.

### Edge Cases
New member with no dues: all amounts 0, `paid_through` null, recent payments empty.

### Backend Source
`app/Domain/Members/Portal/MemberSummary.php`, `PaidThroughCalculator.php`, `DashboardController.php`, `app/Filament/Member/Pages/Dashboard.php`.

---

## Dues

### Purpose
List what the member owes and has owed, month by month.

### Business Rules
- Each month's dues are generated on the 1st (00:30) per share lot: a **deposit** due (shares × share unit) and a **service charge** due (shares × service charge, when not zero).
- A **registration** due is charged once per share when the share is acquired, at the fee in force in that month (BR-4).
- A **late fee** due is added when a due is unpaid after `due_day + grace_days` (BR-10/11).
- Each due keeps the rates of its month forever; a later rate change never changes an existing due.
- Status: `open` (something outstanding), `settled`, `waived` (late fee waived by staff), `cancelled`.
- Default list = **open** dues; `status=all` shows every due; `type` filters by kind.
- Ordered newest month first.

### Preconditions
Signed in.

### User Flow
Dues tab → filter by status or type → scroll (20 per page).

### Validation
`status` ∈ {all, open, settled, cancelled, waived}; `type` ∈ {late_fee, service_charge, registration, deposit}; anything else → 422.

### Success Cases
200 with a page of dues and `meta`.

### Failure Cases
422 for an unknown filter.

### Edge Cases
No open dues → empty list (show "nothing due"). Dues of months before go-live may appear as opening arrears in the future (go-live import).

### Backend Source
`GenerateMonthlyDues.php`, `MonthlyDueBuilder.php`, `RegistrationFees.php`, `ApplyLateFees.php`, `DuesController.php`, `app/Filament/Member/Pages/Dues.php`.

---

## Payments and receipts

### Purpose
Show every payment the member made or submitted, how each approved payment was used, and a receipt.

### Business Rules
- Status: `pending` (submitted, waiting for staff), `approved`, `rejected` (with a reason), `cancelled`, `reversed`.
- Only **approved** payments count. On approval the money settles open dues **oldest month first**, and within a month in the plan's order (default late fee → service charge → registration → deposit). Anything left over becomes **advance** (`to_advance`).
- A **receipt** PDF exists only for approved payments; the app gets a signed link valid for a short time.
- A member can only see their own payments; another member's payment id answers 404.

### Preconditions
Signed in.

### User Flow
Payments tab → list (filter by status) → tap → detail with allocations → "Receipt" opens the PDF.

### Validation
`status` filter ∈ payment statuses.

### Success Cases
List 200 with `meta`; detail 200; receipt 200 `{url}`.

### Failure Cases
404 for another member's payment or a receipt of a non-approved payment.

### Edge Cases
Rejected payment shows `rejection_reason`. A reversed payment re-opens the dues it settled (staff action).

### Backend Source
`ApprovePayment.php`, `AllocationEngine.php`, `PaymentsController.php`, `app/Reports/ReceiptDocument.php`, `app/Filament/Member/Pages/Payments.php`.

---

## Pay online (bKash / Nagad)

### Purpose
Let the member report a bKash or Nagad payment so staff can check and approve it.

### Business Rules
- Methods: **bKash** or **Nagad** only (cash and bank are recorded by staff).
- Required: amount (> 0, up to 2 decimals, English or Bangla digits), **TrxID** (6–40 letters/digits, stored upper-case), date received, **proof** (jpeg/png/webp/pdf, at most **2 MB**).
- The payment is **pending** until a staff member approves it; the approver must be a different person from whoever recorded it.
- A TrxID can be used only once per method.
- Each form submission carries an **idempotency key** (UUID). Sending the same key again returns the same payment (no duplicate); the same key with a different amount answers **409**.

### Preconditions
Signed in; the member actually paid via bKash/Nagad.

### User Flow
Pay now / Payments → Pay online → fill → confirm summary → submit → pending payment appears in the list.

### Validation
422 with field errors for each rule above.

### Success Cases
201 with the payment detail (status pending).

### Failure Cases
422 (validation, TrxID already used), 409 (key reused with a different amount).

### Edge Cases
Retry after a timeout must reuse the same key. Submitting twice at the same time is safe (one payment).

### Backend Source
`RecordPayment.php`, `SubmitPaymentRequest.php`, `PaymentsController::store`, `app/Filament/Member/Pages/PayOnline.php`, `tests/Concurrency/PaymentIdempotencyTest.php`.

---

## Statement (passbook)

### Purpose
A running account of charges and payments for a date range, as on the web.

### Business Rules
- Default range = start of the current fiscal year (1 July) to today.
- **Opening** = charges − payments before `from`. Each row is a charge (a due by its due date) or a payment (by its date) with the running **balance**. **Closing** = opening + charges − payments.
- Always the signed-in member's statement; a `member` parameter is ignored.
- PDF: the app asks for a signed link (valid 15 minutes) and opens it.

### Preconditions
Signed in.

### User Flow
Passbook tab → pick dates → view → "Download PDF".

### Validation
`from`, `until` as `YYYY-MM-DD`; `until` ≥ `from`; else 422.

### Success Cases
200 with opening, rows, totals, closing; `pdf-link` 200 `{url}`.

### Failure Cases
422 for bad dates.

### Edge Cases
A range with no activity shows only opening = closing.

### Backend Source
`app/Reports/Definitions/MemberStatementReport.php`, `MemberReports::statement`, `StatementController.php`.

---

## Dividends

### Purpose
Show the member's dividend for each closed fiscal year.

### Business Rules
- Declared at year-end from net profit after the legal appropriations (Cooperative Societies Act 2001, s.34).
- Split by **share-months** (shares held × months held during the year); the lines add up exactly to the dividend pool.
- Status: `unpaid`, `paid` (paid out), `credited` (added to savings).

### Preconditions
Signed in; at least one closed year with a dividend.

### User Flow
Profile → Dividends.

### Success Cases / Failure Cases
200 with a page (often empty for new societies).

### Backend Source
`app/Domain/YearEnd`, `DividendsController.php`, `app/Filament/Member/Pages/Dividends.php`.

---

## Shares and current rates

### Purpose
Show how many shares the member holds, how that changed, and this month's prices.

### Business Rules
- Shares are changed by staff only (increase adds a lot plus a registration due for the new shares; decrease ends lots oldest first). Changes take effect from a stated month and never alter generated months.
- **Rates** come from the single approved rate plan for the current month: share unit (monthly deposit per share), service charge per share, registration fee per share, due day, grace days, late-fee rule. `null` when no plan covers the month.

### User Flow
Home → Shares.

### Backend Source
`ShareChanger.php`, `ShareTransaction`, `RateResolver.php`, `SharesController.php`.

---

## Profile and nominees

### Purpose
Show the member's details as the society holds them.

### Business Rules
- **Read-only** in the app (as in the web portal): member number, name (Bangla and English), mobile, joined date, status, nominees (name, relation, share %; nominee shares add up to 100%).
- Corrections are made by the society office.

### Backend Source
`ProfileController.php`, `resources/views/filament/member/profile.blade.php`.

---

## Change password

### Purpose
Let the member set a new password.

### Business Rules
Current password must be correct; new password at least **6** characters and confirmed. Other devices are signed out; this one stays signed in.

### Failure Cases
422 wrong current password / too short / confirmation mismatch.

### Backend Source
`ChangeOwnPassword.php`, `ChangePasswordRequest.php`.

---

## SMS history (notifications)

### Purpose
Show the SMS messages the society sent the member.

### Business Rules
- Kinds: welcome, dues generated, payment approved. **Login codes are never shown.**
- Read-only, newest first, 20 per page. No read/unread state and no push notifications exist in the backend.

### Backend Source
`app/Domain/Notifications`, `NotificationsController.php`.

---

## Society information

### Purpose
Show the society's name, registration number, address, phone, email and logo; tell the app whether SMS-code sign-in is on.

### Business Rules
No sign-in needed. Name and address follow the request language; the logo link is signed for one hour.

### Backend Source
`app/Domain/Settings/Models/SomitiProfile.php`, `ConfigController.php`.

---

## Not supported (do not show in the app)

| Feature | Why |
|---------|-----|
| Self-registration | Members are created by society staff (`CreateMember`). |
| Forgot / reset password | Staff set member passwords; SMS-code sign-in is the self-service path when enabled. |
| Editing profile, nominees, photo | Office-only in the backend. |
| Loans, savings/DPS products | Do not exist in the backend. |
| Member directory | Members never see other members. |
| Notices / announcements, read/unread, push, device registration | Not implemented in the backend. |
| App version check / force update | No backend endpoint. |
| Cash or bank payments, refunds, reversals | Staff actions; the member only sees their effect. |

## UNKNOWN / REQUIRES BACKEND CLARIFICATION

- Whether societies will switch on SMS-code sign-in in production (`somiti.portal_otp`, off by default).
- App store distribution, minimum app version policy (no backend support today).
