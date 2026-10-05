# Somobay Somiti Mobile Application — Master Architecture Specification

## 1. Executive Summary & Vision

The **Somobay Somiti Mobile Application** (সমবায় সমিতি মোবাইল অ্যাপ) is designed as an enterprise-grade, highly scalable, and offline-resilient financial and operational management platform for cooperative societies (Somobay Somiti / Multi-Purpose Co-Operative Societies). 

The application adheres to clean architecture principles tailored for Flutter using **MVVM (Model-View-ViewModel)** with **GetX** for reactive state management, centralized routing, and dependency injection, alongside the **Repository Pattern** to completely isolate business logic from data sources.

---

## 2. Core Architectural Pillars

```
+-------------------------------------------------------------------------+
|                              PRESENTATION LAYER                         |
|  [ GetView / GetWidget (UI) ] <---> [ GetxController (ViewModel) ]     |
|                                                     |                   |
+-----------------------------------------------------|-------------------+
                                                      | depends on (DI)
+-----------------------------------------------------v-------------------+
|                              DATA & REPOSITORY LAYER                    |
|  [ Repository Interfaces ] <--- [ Repository Implementation ]           |
|                                       /                     \           |
+--------------------------------------/-----------------------\----------+
                                      /                         \
+------------------------------------v----+      +---------------v--------+
|             REMOTE DATA SOURCE          |      |   LOCAL DATA SOURCE    |
|   [ ApiClient / Dio / Interceptors ]    |      |  [ SecureStorage/Hive ]|
|   [ Network Error & Connectivity ]      |      |  [ Cache & App Config ]|
+-----------------------------------------+      +------------------------+
```

### 2.1 MVVM Layer Responsibilities

| Layer | Component | Allowed Responsibilities | Forbidden Responsibilities |
|---|---|---|---|
| **View** | `*View` / `*Page` | UI Layout, Animations, observing Controller state via `Obx()`, listening to dialog/snackbar events, delegating user actions to Controller. | Direct API calls, Repository access, JSON decoding, business logic, persistent data mutation. |
| **ViewModel** | `*Controller` | Managing View state (`Rx<UIState>`), form validation coordination, orchestrating repository calls, handling navigation triggers, reacting to worker events. | Direct HTTP/Socket calls, direct database access, importing Flutter UI widgets (except for Get snackbar/bottomsheet triggers via service). |
| **Repository** | `*Repository` | Providing a clean, domain-specific API for Controllers; coordinating local cache and remote network calls; parsing API responses into domain Models (`json_serializable`); mapping technical exceptions to localized domain `Failure`s. | Direct UI manipulation, retaining View state. |
| **Data Sources** | `ApiClient`, `StorageService` | Raw HTTP calls (GET, POST, PUT, DELETE), setting headers/interceptors, handling token attachment, encrypted key-value storage. | High-level domain logic. |

---

## 3. SOLID Principles Enforcement

1. **Single Responsibility Principle (SRP):**
   - Each Controller manages the UI state of a single logical module.
   - Each Repository manages domain data operations for a specific domain entity (e.g., `SavingsRepository`, `LoanRepository`, `MemberRepository`).
   - Network layer only handles raw HTTP transmission, serialization, and status code categorization.

2. **Open/Closed Principle (OCP):**
   - Base abstractions for UI components (`AppButton`, `AppTextField`, `BaseController`, `BaseRepository`) allow extension via composition or inheritance without modifying core baseline code.
   - Error handlers and interceptors can be plugged into `ApiClient` without changing existing endpoints.

3. **Liskov Substitution Principle (LSP):**
   - Repositories implement abstract contracts (e.g., `abstract class ISavingsRepository`), allowing mock implementations in unit/widget tests without breaking Controllers.

4. **Interface Segregation Principle (ISP):**
   - Fine-grained interfaces for storage, authentication listeners, and specific feature capabilities instead of a monolithic "God" service.

5. **Dependency Inversion Principle (DIP):**
   - Controllers depend on repository abstractions injected via GetX Bindings (`Get.lazyPut<ISavingsRepository>(() => SavingsRepository(apiClient: Get.find()))`).

---

## 4. Multi-Environment (Flavors) Architecture

The application is structured into 3 distinct environments:

```
lib/
├── main_development.dart   --> Target: Dev API, Debug logging, mock bypass enabled
├── main_staging.dart       --> Target: Staging API, UAT logging, crash reporting
└── main_production.dart    --> Target: Production API, Strict security, ProGuard/R8
```

### Environment Configuration Model
```dart
enum Environment { dev, staging, prod }

class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final Environment environment;
  
  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.environment,
  });
}
```

---

## 5. Security Architecture

1. **Token Storage:** Encrypted SharedPreferences on Android (MasterKey AES-256) and Keychain on iOS via `flutter_secure_storage`.
2. **Network Security:**
   - SSL Pinning capability for production release.
   - Automatic header injection with JWT Bearer Token.
   - Token refresh lock (concurrency queue) to avoid 401 storm / race conditions.
3. **Sensitive Data Protection:**
   - Obfuscation of production release builds using Flutter `--obfuscate --split-debug-info`.
   - No sensitive data (passwords, PINs, auth tokens, NID numbers) output in logs.
