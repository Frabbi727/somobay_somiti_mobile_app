# Somobay Somiti Mobile App — Project & Folder Structure

This document details the exact directory and file organization of the application.

```text
somobay_somiti_mobile_app/
├── android/
├── ios/
├── documents/                       # Comprehensive architectural & design documentation
│   ├── ARCHITECTURE.md
│   ├── PROJECT_STRUCTURE.md
│   ├── NAVIGATION.md
│   ├── API_ARCHITECTURE.md
│   ├── LOCALIZATION.md
│   ├── ERROR_HANDLING.md
│   ├── STATE_MANAGEMENT.md
│   ├── COMPONENTS_DESIGN.md
│   ├── MODULES_SPECIFICATION.md
│   └── CRITICAL_REVIEW_AND_RISKS.md
│
├── assets/
│   ├── icons/                       # SVG and PNG icons
│   │   ├── ic_app_logo.svg
│   │   ├── ic_savings.svg
│   │   ├── ic_loan.svg
│   │   ├── ic_share.svg
│   │   ├── ic_member.svg
│   │   └── ic_report.svg
│   ├── images/                      # Illustrations and branding images
│   │   ├── img_splash_logo.png
│   │   ├── img_empty_box.svg
│   │   ├── img_network_error.svg
│   │   └── img_access_denied.svg
│   └── fonts/                       # Custom Bangla (e.g., Kalpurush / SolaimanLipi / Hind Siliguri) & English (Inter / Roboto)
│
├── lib/
│   ├── app/                         # App-wide foundational modules & configurations
│   │   ├── bindings/
│   │   │   └── initial_binding.dart # Global singleton injections (Storage, Connectivity, ApiClient)
│   │   ├── localization/
│   │   │   ├── app_translations.dart# GetX Translations registry
│   │   │   ├── en_us.dart           # English string dictionary
│   │   │   └── bn_bd.dart           # Bangla string dictionary
│   │   ├── routes/
│   │   │   ├── app_pages.dart       # GetPage route declarations & bindings mapping
│   │   │   └── app_routes.dart      # Static route name constants
│   │   ├── theme/
│   │   │   ├── app_theme.dart       # ThemeData definitions (Light & Dark)
│   │   │   ├── app_colors.dart      # Color palette constants
│   │   │   ├── app_text_styles.dart # Typography styles (Bilingual font size scaling)
│   │   │   ├── app_shadows.dart     # Elevation and shadow tokens
│   │   │   └── app_dimensions.dart  # Spacing, padding, radius, and elevation tokens
│   │   └── app.dart                 # Root GetMaterialApp widget definition
│   │
│   ├── core/                        # Shared framework components, engines, and utilities
│   │   ├── config/
│   │   │   ├── app_config.dart      # Environment configuration (Base URL, Timeout, etc.)
│   │   │   └── flavor_manager.dart  # Active flavor singleton
│   │   ├── constants/
│   │   │   ├── api_constants.dart   # Endpoint paths, query param keys
│   │   │   ├── storage_keys.dart    # Keys for secure storage and preferences
│   │   │   └── app_constants.dart   # Regex, pagination limits, date formats
│   │   ├── errors/
│   │   │   ├── exceptions.dart      # Low-level infrastructure exceptions
│   │   │   ├── failures.dart        # Domain level failure classes
│   │   │   └── error_handler.dart   # Exception-to-Failure translator
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   ├── string_extensions.dart
│   │   │   ├── number_extensions.dart # Currency formatting (BDT/৳) & Bangla number converter
│   │   │   ├── date_extensions.dart   # Date formatting (Bangla & English calendars)
│   │   │   └── widget_extensions.dart
│   │   ├── models/
│   │   │   ├── api_response_model.dart# Generic API envelope (status, message, data, errors)
│   │   │   ├── pagination_model.dart  # Paginated meta container
│   │   │   └── app_version_model.dart # Force update check response model
│   │   ├── network/
│   │   │   ├── api_client.dart        # HTTP engine (Dio wrapper with timeout & error mapping)
│   │   │   ├── network_connectivity.dart# Continuous connectivity watcher
│   │   │   └── interceptors/
│   │   │       ├── auth_interceptor.dart     # JWT attachment & 401 refresh handler
│   │   │       ├── logging_interceptor.dart  # Sanitized console request/response logger
│   │   │       └── header_interceptor.dart   # Language, OS, App Version headers
│   │   ├── services/
│   │   │   ├── storage_service.dart   # Secure & fast key-value storage wrapper
│   │   │   ├── log_service.dart       # Safe multi-level logger (debug, info, error)
│   │   │   └── notification_service.dart # Local/Push notifications wrapper
│   │   ├── utils/
│   │   │   ├── app_validator.dart     # Form input validators (Bangla phone, NID, Email, Password)
│   │   │   ├── bangla_number_util.dart# Digit converter (12345 <-> ১২৩৪৫)
│   │   │   └── currency_formatter.dart# BDT ৳ currency formatters
│   │   └── widgets/                   # Reusable atomic & composite UI widgets
│   │       ├── app_app_bar.dart
│   │       ├── app_buttons.dart       # AppPrimaryButton, AppSecondaryButton, AppOutlinedButton, AppDangerButton
│   │       ├── app_text_fields.dart   # AppTextField, AppSearchField, AppDropdownField
│   │       ├── app_dialogs.dart       # AppConfirmationDialog, AppForceUpdateDialog
│   │       ├── app_bottom_sheets.dart # Selection & Filter bottom sheets
│   │       ├── app_loading.dart       # AppLoading, AppShimmer, AppProgressIndicator
│   │       ├── app_empty_state.dart   # Meaningful empty list view
│   │       ├── app_error_state.dart   # Error state view with retry trigger
│   │       ├── app_network_banner.dart# Offline detection banner
│   │       ├── app_pagination_view.dart# Reusable pull-to-refresh & infinite scroll list
│   │       └── app_card.dart          # Consistent styled cards for financial items
│   │
│   ├── modules/                       # Feature modules (isolated domain/UI units)
│   │   ├── splash/                    # Startup, migration & force-update check
│   │   │   ├── bindings/splash_binding.dart
│   │   │   ├── controller/splash_controller.dart
│   │   │   ├── model/splash_model.dart
│   │   │   ├── repository/splash_repository.dart
│   │   │   └── view/splash_page.dart
│   │   │
│   │   ├── authentication/            # Authentication & Onboarding
│   │   │   ├── login/
│   │   │   │   ├── bindings/login_binding.dart
│   │   │   │   ├── controller/login_controller.dart
│   │   │   │   ├── model/login_request_model.dart
│   │   │   │   ├── model/auth_token_model.dart
│   │   │   │   ├── repository/auth_repository.dart
│   │   │   │   └── view/login_page.dart
│   │   │   ├── register/
│   │   │   │   ├── bindings/register_binding.dart
│   │   │   │   ├── controller/register_controller.dart
│   │   │   │   └── view/register_page.dart
│   │   │   ├── forgot_password/
│   │   │   │   ├── bindings/forgot_password_binding.dart
│   │   │   │   ├── controller/forgot_password_controller.dart
│   │   │   │   └── view/forgot_password_page.dart
│   │   │   └── otp_verification/
│   │   │       ├── bindings/otp_binding.dart
│   │   │       ├── controller/otp_controller.dart
│   │   │       └── view/otp_verification_page.dart
│   │   │
│   │   ├── dashboard/                 # Bottom navigation shell
│   │   │   ├── bindings/dashboard_binding.dart
│   │   │   ├── controller/dashboard_controller.dart
│   │   │   └── view/dashboard_page.dart
│   │   │
│   │   ├── home/                      # Overview, summary cards, quick actions
│   │   │   ├── bindings/home_binding.dart
│   │   │   ├── controller/home_controller.dart
│   │   │   ├── model/somiti_summary_model.dart
│   │   │   ├── repository/home_repository.dart
│   │   │   └── view/home_page.dart
│   │   │
│   │   ├── savings_dps/               # Monthly Savings, DPS, FDR accounts & deposits
│   │   │   ├── bindings/savings_binding.dart
│   │   │   ├── controller/savings_controller.dart
│   │   │   ├── model/savings_account_model.dart
│   │   │   ├── model/savings_deposit_model.dart
│   │   │   ├── repository/savings_repository.dart
│   │   │   └── view/
│   │   │       ├── savings_list_page.dart
│   │   │       ├── savings_details_page.dart
│   │   │       └── new_deposit_page.dart
│   │   │
│   │   ├── loans/                     # Loan applications, repayments, schedule & status
│   │   │   ├── bindings/loan_binding.dart
│   │   │   ├── controller/loan_controller.dart
│   │   │   ├── model/loan_account_model.dart
│   │   │   ├── model/loan_installment_model.dart
│   │   │   ├── repository/loan_repository.dart
│   │   │   └── view/
│   │   │       ├── loan_list_page.dart
│   │   │       ├── loan_details_page.dart
│   │   │       ├── loan_calculator_page.dart
│   │   │       └── loan_repayment_page.dart
│   │   │
│   │   ├── share_capital/             # Share certificates, dividend records & purchase
│   │   │   ├── bindings/share_binding.dart
│   │   │   ├── controller/share_controller.dart
│   │   │   ├── model/share_account_model.dart
│   │   │   ├── repository/share_repository.dart
│   │   │   └── view/
│   │   │       ├── share_overview_page.dart
│   │   │       └── share_transactions_page.dart
│   │   │
│   │   ├── members/                   # Member directory, profiles & KYC
│   │   │   ├── bindings/member_binding.dart
│   │   │   ├── controller/member_controller.dart
│   │   │   ├── model/member_model.dart
│   │   │   ├── repository/member_repository.dart
│   │   │   └── view/
│   │   │       ├── member_list_page.dart
│   │   │       └── member_details_page.dart
│   │   │
│   │   ├── transactions/              # Passbook ledger, deposit/withdrawal history
│   │   │   ├── bindings/transaction_binding.dart
│   │   │   ├── controller/transaction_controller.dart
│   │   │   ├── model/transaction_model.dart
│   │   │   ├── repository/transaction_repository.dart
│   │   │   └── view/
│   │   │       ├── transaction_history_page.dart
│   │   │       ├── transaction_details_page.dart
│   │   │       └── transaction_filter_sheet.dart
│   │   │
│   │   ├── notifications/             # Notices, payment reminders & announcements
│   │   │   ├── bindings/notification_binding.dart
│   │   │   ├── controller/notification_controller.dart
│   │   │   ├── model/notification_item_model.dart
│   │   │   ├── repository/notification_repository.dart
│   │   │   └── view/notification_page.dart
│   │   │
│   │   └── profile_settings/          # User profile, Somiti rules, Language & Security
│   │       ├── bindings/profile_binding.dart
│   │       ├── controller/profile_controller.dart
│   │       ├── model/user_profile_model.dart
│   │       ├── repository/profile_repository.dart
│   │       └── view/
│   │           ├── profile_page.dart
│   │           ├── edit_profile_page.dart
│   │           ├── language_selection_page.dart
│   │           ├── change_password_page.dart
│   │           └── somiti_info_page.dart
│   │
│   ├── main.dart                      # Default entry point (points to dev or prod)
│   ├── main_development.dart          # Dev flavor entry point
│   ├── main_staging.dart              # Staging flavor entry point
│   └── main_production.dart           # Production flavor entry point
│
├── test/                              # Unit & Controller tests
│   ├── core/
│   ├── modules/
│   └── mocks/
│
└── pubspec.yaml
```
