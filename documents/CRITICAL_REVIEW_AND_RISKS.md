# Somobay Somiti Mobile App — Critical Architecture Review & Risk Mitigation

## 1. Architectural Risks & Mitigations

| Category | Potential Risk / Pitfall | Impact | Proposed Mitigation Strategy |
|---|---|---|---|
| **State Management** | **Unbounded Controller Lifecycle / Memory Leaks**<br/>Leaving controllers in memory with `Get.put(permanent: true)` unnecessarily. | High | Use `Get.lazyPut()` in dedicated `Bindings` for each route so controllers are automatically disposed of when pages are popped off the navigation stack. |
| **State Management** | **Over-use of `Rx` Observables**<br/>Making every primitive variable an `.obs` causing excessive stream rebuilds. | Medium | Group related state into atomic models and wrap them in a single `UIState<T>`. Use `GetBuilder()` for largely static page trees. |
| **Network Handling** | **401 Unauthorized Race Conditions (401 Storm)**<br/>Multiple concurrent failed requests trigger simultaneous token refresh calls. | High | Implement `QueuedInterceptor` in Dio to lock pending requests while a single refresh token request executes, then replay queued requests. |
| **Network Handling** | **Repeated Error Dialogs during Flaky Network**<br/>Network drops triggering multiple overlapping error alerts. | Medium | Use a top-bar floating network connectivity banner (`AppNetworkBanner`) rather than modal blocking dialogs; debounce snackbar notifications by 2 seconds. |
| **Localization** | **Bilingual Font Rendering & Layout Overflow**<br/>Bangla text is often 20–30% longer than English words and uses complex glyphs/conjuncts. | High | Specify robust font fallbacks (`Hind Siliguri` / `SolaimanLipi`), set appropriate line-height multipliers (1.4–1.5), and ensure buttons and card titles use `Flexible`/`TextOverflow.ellipsis` with multi-line allowances. |
| **Security** | **Plaintext Token Storage on Compromised Devices**<br/>Storing JWT or refresh tokens in `SharedPreferences`. | Critical | Use `flutter_secure_storage` (Hardware-backed Keystore on Android, Keychain on iOS) and obfuscate release builds (`--obfuscate`). |
| **UX / Usability** | **Financial Anxiety from Indeterminate States**<br/>User submits loan repayment or deposit, but lack of instant feedback or duplicate taps cause double payment. | High | Disable buttons upon first tap (`isLoading: true`), use optimistic UI or immediate progress overlay, and generate a client-side idempotency key for transactions. |
| **Navigation** | **Bottom Navigation Tab State Loss**<br/>Navigating between Home, Savings, and Loans tabs destroying scroll offset and active form input. | Medium | Use `IndexedStack` inside `DashboardPage` combined with `AutomaticKeepAliveClientMixin` for heavy tab views. |
| **Maintainability** | **Massive View / Controller Files ("God Objects")**<br/>A single controller handling all forms, filters, calculations, and network calls. | High | Enforce single-responsibility sub-controllers (e.g., `LoanListController`, `LoanDetailsController`, `LoanRepaymentController`) and extract reusable card widgets. |

---

## 2. Scalability Architecture Checklist

- [x] **Modular Domain Isolation:** Features do not tightly couple with peer feature controllers.
- [x] **Repository Layer Abstraction:** Easy replacement of REST API with GraphQL or offline local SQLite / Isar cache in the future without modifying UI.
- [x] **Environment Flavouring:** Completely separate environments for development, staging, and production.
- [x] **Idempotency on Financial Endpoints:** Client transmits UUID idempotency headers to prevent duplicate financial debit/credit postings.
