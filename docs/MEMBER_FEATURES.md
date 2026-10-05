# Member Features

Every feature of the member app. Each maps to a real backend capability (MEMBER_BUSINESS_RULES.md) and
endpoint (MEMBER_API_SPECIFICATION.md). Unsupported features are listed at the end and must not appear.

| Feature | Purpose | Required API | Required Model | User Action | Expected Result | Error Cases |
|---------|---------|--------------|----------------|-------------|-----------------|-------------|
| Society info on start | Show the society's name/logo; know if SMS-code sign-in is on | `GET config/somiti-info` | SomitiInfoModel | Open app | Name on splash/login; code option shown only when `otp_enabled` | Offline → continue with stored name |
| Session check | Skip login when a session is valid | `GET auth/me` | MemberBriefModel | Open app | Valid → Home; 401 after refresh → Login; 403 → Login with message | Offline with a token → Home (screens show offline state) |
| Sign in (password) | Enter the app | `POST auth/login` | LoginRequestModel → AuthTokenModel | Mobile + password → Sign in | Tokens saved securely → Home | 422 wrong details (field message); 429 too many attempts |
| Sign in (SMS code) | Sign in without a password | `POST auth/send-code`, `POST auth/login` | LoginRequestModel → AuthTokenModel | Mobile → Send code → enter code | → Home | 404 codes off; 422 wrong/expired code; 429 |
| Stay signed in | Refresh tokens silently | `POST auth/refresh-token` | AuthTokenModel | (automatic) | New pair saved; request retried once | 401 → Login ("Please sign in again") |
| Sign out | Leave on this device | `POST auth/logout` | — | Profile → Sign out → confirm | Tokens cleared → Login | Network error → still clear tokens locally |
| Home summary | Position at a glance | `GET dashboard/summary` | DashboardSummaryModel | Open Home; pull to refresh | Savings, advance, outstanding, paid-through, estimate, shares, recent payments | Error/empty states |
| Pay now shortcut | Start paying what is owed | (none; navigation) | DashboardSummaryModel.payNowVisible | Tap "Pay now" | Opens Pay online | — |
| Dues | See what is owed by month | `GET dues` | DueModel, PaginationMeta | Dues tab; filter status/type; scroll | Paginated list, open by default | 422 bad filter (bug); empty state "Nothing due" |
| Payments | See payments and their status | `GET payments` | PaymentSummaryModel | Payments tab; filter; scroll | Paginated list | Empty state |
| Payment detail | See what a payment settled | `GET payments/{id}` | PaymentDetailModel | Tap a payment | Allocations by month/type, advance part, rejection reason | 404 (not yours / gone) |
| Receipt | Get the official receipt | `GET payments/{id}/receipt` | url | Tap "Receipt" (approved only) | PDF opens in the browser | 404 when not approved |
| Pay online | Report a bKash/Nagad payment | `POST payments` (multipart) | PayOnlineRequest → PaymentDetailModel | Fill form, attach proof, confirm, submit | Pending payment in the list; success message from the backend | 422 field errors; 409 conflict; file > 2 MB rejected before sending |
| Passbook (statement) | Running account | `GET statement`, `GET statement/pdf-link` | StatementModel | Passbook tab; choose dates; "Download PDF" | Opening, rows, totals, closing; PDF opens | 422 bad range |
| Shares | Shares held and current prices | `GET shares/overview` | SharesOverviewModel | Home → Shares | Current shares, history, this month's rates | "No rate plan for this month" when `rates` null |
| SMS history | See messages the society sent | `GET notifications` | SmsNotificationModel | Home bell / Profile → Messages | Paginated list | Empty state |
| Profile | See own details and nominees | `GET profile` | ProfileModel | Profile tab | Read-only details, nominees with share % | — |
| Dividends | See yearly dividends | `GET dividends` | DividendModel | Profile → Dividends | Paginated list | Empty state "No dividends yet" |
| Society info page | Contact the office | `GET config/somiti-info` | SomitiInfoModel | Profile → About the society | Name, registration, address, phone, email, logo | — |
| Change password | Set a new password | `POST profile/change-password` | ChangePasswordRequest | Profile → Change password | Success; other devices signed out | 422 wrong current / too short / mismatch |
| Language | Bangla or English | (all requests send `Accept-Language`) | — | Profile → Language | UI and server text switch; data re-fetched | — |

## Not in the app (no backend support)

Self-registration · forgot/reset password · editing profile, nominees or photo · loans · savings/DPS
products · member directory · notices/announcements · notification read state · push notifications ·
app version check / force update · cash or bank payments, refunds and reversals (staff only).
