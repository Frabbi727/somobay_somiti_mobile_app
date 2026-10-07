# Member Navigation

Uses the app's existing navigation exactly: GetX named routes (`lib/app/routes`), the `DashboardPage`
with a Material `NavigationBar` + `IndexedStack`, and bindings per route. Only the tab contents and the
route list change.

## Start-up

```
Splash ── config/somiti-info ──┬─ no token ─────────────────────────▶ Login
                               └─ token ── auth/me ──┬─ 200 ─────────▶ Dashboard (Home tab)
                                                     ├─ 401/403 ─────▶ Login (tokens cleared)
                                                     └─ offline ─────▶ Dashboard (screens show offline)
Login ── password or SMS code ──▶ Dashboard
```

Rule for start-up and login: `account_type` `applicant` → registration status (`/registration`); `member` → Dashboard.
When an applicant is approved the access token is rejected (401); the refresh returns a member token and the
app opens the Dashboard without asking for a sign-in.

## Bottom navigation (5 tabs, same widget as today)

| # | Tab | Was | Page | Content |
|---|-----|-----|------|---------|
| 1 | Home (হোম) | Home | `HomePage` | Summary cards, Pay now, recent payments, links to Shares and Messages |
| 2 | Dues (বকেয়া) | Savings & DPS | `DuesPage` (new) | Dues list with status/type filters |
| 3 | Payments (পরিশোধ) | Loans | `PaymentsPage` (new) | Payments list, "Pay online" button |
| 4 | Passbook (খতিয়ান বই) | Passbook | `TransactionHistoryPage` (now the statement) | Statement for a date range, PDF |
| 5 | Profile (প্রোফাইল) | Profile | `ProfilePage` | Details, nominees, links below |

## Secondary pages (pushed with `Get.toNamed`)

| Route | Page | From |
|-------|------|------|
| `/payments/detail` | Payment detail (allocations, receipt button) | Payments list, Home recent payments |
| `/payments/pay-online` | Pay online form | Home "Pay now", Payments tab |
| `/shares` | Shares overview and current rates | Home |
| `/notifications` | SMS history | Home app-bar bell, Profile |
| `/profile/dividends` | Dividends | Profile |
| `/profile/somiti-info` | About the society | Profile |
| `/profile/change-password` | Change password | Profile |
| `/profile/language` | Language | Profile |
| `/registration` | Registration status (headline, timeline, one button per `next_action`, pull to refresh, sign out) | Start-up / login for applicants |
| `/registration/form` | Five-step registration form (draft saved on Next; review → confirm → submit) | Registration status |

Receipts and the statement PDF open **outside** the app (browser / PDF viewer) via `url_launcher` with
signed links; there is no in-app PDF route.

Navigation arguments carry only ids of the member's own records (e.g. a payment id). The backend
re-checks ownership on every request, so a wrong id shows "not found", never another member's data.

## Routes removed from `AppRoutes`/`AppPages` (files kept)

`/register` (the old open sign-up; registration is now invite-only at `/registration`), `/forgot-password`, `/otp-verification`, `/force-update`, `/savings/details`,
`/savings/deposit`, `/loans/details`, `/loans/calculator`, `/loans/repay`, `/members`,
`/members/details`, `/transactions/details` — no backend support (MEMBER_FEATURES.md).

## Running against a local backend

```bash
# backend
php artisan serve --host=0.0.0.0 --port=8000
# app (Android emulator reaches the host at 10.0.2.2)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
# iOS simulator
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

Signed links (receipt, statement PDF, logo) are built from the backend's `APP_URL`; for device testing set
`APP_URL` to the address the phone uses (e.g. `http://10.0.2.2:8000`).
