# Somobay Somiti Mobile App — State Management Strategy

## 1. GetX State Management Principles

GetX is used in a clean, structured manner to avoid common anti-patterns (such as anti-pattern state sprawl or memory leaks).

```
+-------------------------------------------------------------+
|                          UI View                            |
|             GetView<SavingsController>                      |
+-------------------------------------------------------------+
               | listens to state via Obx()
+--------------v----------------------------------------------+
|                     Controller / ViewModel                  |
|  - state = Rx<UIState<List<SavingsAccountModel>>>           |
|  - handles user actions & coordinates repository            |
|  - cleans up streams in onClose()                           |
+-------------------------------------------------------------+
```

---

## 2. Standardized UI State Wrapper

To replace scattered boolean flags (`isLoading`, `isSaving`, `hasError`, `isSuccess`), a sealed/generic UI State container is used across all feature controllers:

```dart
enum Status { initial, loading, success, empty, error }

class UIState<T> {
  final Status status;
  final T? data;
  final String? errorMessage;
  final Failure? failure;

  const UIState._({
    required this.status,
    this.data,
    this.errorMessage,
    this.failure,
  });

  factory UIState.initial() => const UIState._(status: Status.initial);
  factory UIState.loading() => const UIState._(status: Status.loading);
  factory UIState.success(T data) => UIState._(status: Status.success, data: data);
  factory UIState.empty() => const UIState._(status: Status.empty);
  factory UIState.error(Failure failure) => UIState._(
        status: Status.error,
        errorMessage: failure.message,
        failure: failure,
      );

  bool get isInitial => status == Status.initial;
  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isEmpty => status == Status.empty;
  bool get isError => status == Status.error;
}
```

---

## 3. When to use `Obx()` vs `GetBuilder()`

| Mechanism | Use Case | Rationale |
|---|---|---|
| **`Obx()` (Reactive)** | Small, discrete UI widgets that change frequently (e.g., active filter chip, password visibility toggle, balance hide/unhide, button loading spinner). | Granular widget-level rebuilding with minimal overhead. |
| **`GetBuilder()` (Simple State)** | Complex page structures containing large static widget trees where a full page refresh occurs explicitly upon API fetch completion. | Extremely fast memory footprint and no stream subscription overhead. |

---

## 4. Reactive Workers & Form Debouncing

For search inputs and live filters, GetX `debounce` is used to prevent rapid duplicate API calls:

```dart
class MemberController extends GetxController {
  final MemberRepository repository;
  MemberController({required this.repository});

  final searchQuery = ''.obs;
  final memberState = UIState<List<MemberModel>>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    // Debounce search input by 400 milliseconds
    debounce(searchQuery, (query) => fetchMembers(query: query), time: const Duration(milliseconds: 400));
    fetchMembers();
  }

  Future<void> fetchMembers({String query = ''}) async {
    memberState.value = UIState.loading();
    final result = await repository.getMembers(search: query);
    result.fold(
      (failure) => memberState.value = UIState.error(failure),
      (members) => memberState.value = members.isEmpty ? UIState.empty() : UIState.success(members),
    );
  }
}
```
