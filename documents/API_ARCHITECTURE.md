# Somobay Somiti Mobile App — API & Network Architecture

## 1. Network Layer Architecture

The networking layer is encapsulated inside `core/network/` and is built on top of `Dio`, providing high configurability, interceptor chaining, request cancellation via `CancelToken`, and unified error mapping.

```
+-------------------------------------------------------------+
|                         ViewModel / Controller              |
+-------------------------------------------------------------+
                              | calls domain methods
+-----------------------------v-------------------------------+
|                       Repository Layer                      |
| (Catches network exceptions & transforms to Domain Failures)|
+-------------------------------------------------------------+
                              | calls ApiClient
+-----------------------------v-------------------------------+
|                    ApiClient (Dio Wrapper)                  |
|  - Request Interceptors (Auth Token, Headers, App Info)     |
|  - Response Interceptors (Logging, Timing)                  |
|  - Error Interceptors (Token Refresh, Global 401/503 Handle)|
+-------------------------------------------------------------+
                              | executes HTTP
+-----------------------------v-------------------------------+
|                       Backend REST API                      |
+-------------------------------------------------------------+
```

---

## 2. API Response Envelope

Every standard API response follows a consistent JSON contract:

```json
{
  "success": true,
  "statusCode": 200,
  "message": "Data retrieved successfully",
  "data": { ... },
  "errors": null,
  "meta": {
    "currentPage": 1,
    "lastPage": 5,
    "perPage": 15,
    "total": 72
  }
}
```

### Generic Dart Representation:
```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, List<String>>? errors;
  final PaginationMeta? meta;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
```

---

## 3. Token Refresh Interceptor & 401 Concurrency Queue

To prevent race conditions when multiple API requests fail simultaneously with `401 Unauthorized`, an atomic lock / queue mechanism handles token refresh:

```dart
class AuthInterceptor extends QueuedInterceptor {
  final StorageService storageService;
  final Dio dio;

  AuthInterceptor({required this.storageService, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept-Language'] = Get.locale?.languageCode ?? 'bn';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storageService.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Atomic token renewal
          final newTokens = await _performTokenRefresh(refreshToken);
          await storageService.saveTokens(
            access: newTokens.accessToken,
            refresh: newTokens.refreshToken,
          );
          
          // Retry original request with new access token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (refreshErr) {
          // Refresh failed -> Force clean logout
          await storageService.clearAuthData();
          Get.offAllNamed(AppRoutes.login);
          return handler.reject(err);
        }
      } else {
        await storageService.clearAuthData();
        Get.offAllNamed(AppRoutes.login);
      }
    }
    handler.next(err);
  }
}
```

---

## 4. Complete REST API Endpoints Registry

```text
Authentication:
POST   /api/v1/auth/login                  # User Login (Phone + Password/PIN)
POST   /api/v1/auth/register               # Member admission request
POST   /api/v1/auth/forgot-password        # Trigger reset OTP
POST   /api/v1/auth/verify-otp             # Verify SMS OTP
POST   /api/v1/auth/reset-password         # Complete password reset
POST   /api/v1/auth/refresh-token          # Renew access token
POST   /api/v1/auth/logout                 # Invalidate session

App Configuration:
GET    /api/v1/config/version-check        # Force update and minimum version check
GET    /api/v1/config/somiti-info          # Somiti registration & bylaws info

Dashboard & Overview:
GET    /api/v1/dashboard/summary           # Member balance, active loans, total savings

Savings & DPS:
GET    /api/v1/savings/accounts            # List all savings/DPS/FDR accounts
GET    /api/v1/savings/accounts/{id}       # Savings details & deposit history
POST   /api/v1/savings/deposit             # Submit deposit payment

Loans:
GET    /api/v1/loans/accounts              # List active and completed loans
GET    /api/v1/loans/accounts/{id}         # Loan breakdown & schedule
POST   /api/v1/loans/repay                 # Submit loan installment repayment
POST   /api/v1/loans/calculate             # Loan EMI simulator

Share Capital:
GET    /api/v1/shares/overview             # Total shares, nominal value & certificates

Members:
GET    /api/v1/members                     # Member directory (searchable & paginated)
GET    /api/v1/members/{id}                # Member detail & standing

Transactions (Passbook):
GET    /api/v1/transactions               # Passbook ledger with date range & type filters
GET    /api/v1/transactions/{id}           # Single transaction voucher

Notifications:
GET    /api/v1/notifications               # Somiti announcements & payment alerts
PUT    /api/v1/notifications/{id}/read     # Mark notification as read

Profile:
GET    /api/v1/profile                     # Current user profile & nominee details
PUT    /api/v1/profile                     # Update profile information
PUT    /api/v1/profile/change-password     # Change account password
```
