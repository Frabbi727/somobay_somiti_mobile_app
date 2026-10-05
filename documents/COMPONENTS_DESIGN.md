# Somobay Somiti Mobile App — Reusable UI Components Design

## 1. Reusable Component Catalog

All components are centralized inside `core/widgets/` to eliminate duplicate UI code and enforce theme consistency.

---

## 2. Button System (`core/widgets/app_buttons.dart`)

```dart
enum ButtonVariant { primary, secondary, outlined, danger, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double height;
  final ButtonVariant variant;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 48.0,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);
  
  // Renders styled button with loading spinner, touch targets >= 48dp, and theme colors
}
```

### Variants:
1. `AppPrimaryButton` — Deep Forest Green (`#1B5E20`) for primary financial actions.
2. `AppSecondaryButton` — Subtle Mint Green / Light Accent for secondary options.
3. `AppOutlinedButton` — Bordered for non-destructive selections (e.g., "View Statement").
4. `AppDangerButton` — Crimson Red (`#D32F2F`) for destructive actions (e.g., "Cancel DPS", "Delete Nominee").

---

## 3. Input Fields (`core/widgets/app_text_fields.dart`)

- **`AppTextField`**: Floating label, clear button, obscure toggle for passwords/PINs, inline error text, custom input formatters (e.g., Bangla phone number `+880 1XXX-XXXXXX`, NID 10/17 digit limit).
- **`AppSearchField`**: Rounded search bar with debounced reactive search hook and clear action.
- **`AppDropdownField<T>`**: Accessible modal bottom-sheet or dropdown for Somiti schemes selection.

---

## 4. Modal Dialogs & Sheets (`core/widgets/app_dialogs.dart`)

### 4.1 Destructive Confirmation Dialog
```dart
class AppConfirmationDialog {
  static Future<bool?> show({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: AppTextStyles.dialogTitle),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          AppOutlinedButton(
            text: cancelText ?? 'common_cancel'.tr,
            onPressed: () => Get.back(result: false),
          ),
          AppButton(
            text: confirmText ?? 'common_confirm'.tr,
            variant: isDestructive ? ButtonVariant.danger : ButtonVariant.primary,
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
  }
}
```

### 4.2 Force-Update Dialog
Blocks navigation and user interaction when `min_supported_version` from API is greater than local app version.

---

## 5. State Handling Widgets

- **`AppLoading`**: Centered circular progress with cooperative branded styling.
- **`AppShimmer`**: Placeholder shimmer effect for list items (Member card, Savings balance card, Loan schedule table).
- **`AppEmptyState`**: Displays an intuitive empty icon, title, description, and optional action button (e.g., "No Active Loans Found — Apply for a Loan").
- **`AppErrorState`**: Displays network or server error illustration with a localized "Try Again" (`পুনরায় চেষ্টা করুন`) button.
- **`AppPaginationListView`**: Built-in pull-to-refresh (`RefreshIndicator`) + bottom scroll listener for pagination loading triggers.
