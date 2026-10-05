# Somobay Somiti Mobile App — Error Handling & Resilience Architecture

## 1. Error Handling Philosophy

Raw technical errors (such as `SocketException`, `DioException [bad response: 500]`, `NullPointerException`, or raw stack traces) **must never be exposed** to users. 

Every exception is intercepted at the Repository layer and converted into a strongly typed, localized **`Failure`** object.

```
Low-Level Exception (Dio/Socket/Format) 
        ↓ 
ErrorHandler.handleException(e)
        ↓ 
Domain Failure (NetworkFailure, ServerFailure, AuthFailure, ValidationFailure)
        ↓ 
Controller consumes Failure & sets UI State / triggers User-Friendly Localized Message
```

---

## 2. Failure Class Hierarchy

```dart
abstract class Failure {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;

  const Failure({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String? message,
  }) : super(message: message ?? 'error_no_internet');
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    String? message,
  }) : super(message: message ?? 'error_session_expired', statusCode: 401);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    Map<String, List<String>>? errors,
  }) : super(message: message, statusCode: 422, validationErrors: errors);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
  }) : super(message: message ?? 'error_timeout');
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
  }) : super(message: message ?? 'error_unknown');
}
```

---

## 3. HTTP Status Code Mapping Matrix

| Status Code | Failure Type | English Message | বাংলা অনুবাদ (Natural Bangla) | Action |
|---|---|---|---|---|
| **0 / Socket** | `NetworkFailure` | "No internet connection. Please check your connection and try again." | "ইন্টারনেট সংযোগ পাওয়া যাচ্ছে না। আপনার ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।" | Show Offline Banner / Retry button |
| **400** | `ServerFailure` | "Invalid request. Please verify the information." | "অনুরোধটি সঠিক নয়। অনুগ্রহ করে তথ্য যাচাই করুন।" | Highlight invalid fields |
| **401** | `AuthenticationFailure` | "Session expired. Please log in again." | "আপনার সেশনের মেয়াদ শেষ হয়েছে। অনুগ্রহ করে পুনরায় লগইন করুন।" | Clear storage & navigate to Login |
| **403** | `ServerFailure` | "You do not have permission to perform this action." | "এই কাজটি করার অনুমতি আপনার নেই।" | Show access denied message |
| **404** | `ServerFailure` | "Requested information not found." | "অনুরোধকৃত তথ্যটি পাওয়া যায়নি।" | Show empty/not found state |
| **409** | `ServerFailure` | "Conflict occurred. Record already exists." | "এই তথ্যটি ইতিমধ্যে বিদ্যমান রয়েছে।" | Alert user of existing record |
| **422** | `ValidationFailure` | "Validation failed. Please correct highlighted errors." | "প্রদত্ত তথ্যে ভুল রয়েছে। অনুগ্রহ করে সংশোধন করুন।" | Display inline form errors |
| **429** | `ServerFailure` | "Too many requests. Please wait a moment." | "অতিরিক্ত অনুরোধ করা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।" | Throttle user requests |
| **500, 502, 503**| `ServerFailure` | "Server is temporarily unavailable. Please try again later." | "সার্ভার সাময়িকভাবে অনুপলব্ধ আছে। কিছুক্ষণ পর পুনরায় চেষ্টা করুন।" | Show Server Down retry screen |

---

## 4. Duplicate Dialog & Toast Debouncing

To avoid showing multiple overlapping error dialogs or repeating toasts during network flapping:
- A `GlobalSnackbarService` enforces a minimum 2-second debounce between identical error messages.
- The `NetworkConnectivityService` displays a sticky top banner rather than a blocking modal dialog for connection drops.
