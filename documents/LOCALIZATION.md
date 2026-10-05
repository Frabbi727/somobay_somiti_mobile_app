# Somobay Somiti Mobile App — Localization & Bilingual System

## 1. Localization Strategy

The application provides first-class support for two languages:
1. **Bangla (`bn_BD`)** — Primary default language for cooperative society members in Bangladesh.
2. **English (`en_US`)** — Secondary language.

Translations are managed through GetX `Translations` using strongly typed key constants. Hardcoded strings inside views or widgets are strictly forbidden.

---

## 2. Localization Structure & Key Taxonomy

```text
app/
└── localization/
    ├── app_translations.dart   # Implements GetX Translations
    ├── translation_keys.dart   # Type-safe constant string keys
    ├── en_us.dart              # English Dictionary
    └── bn_bd.dart              # Natural Bangla Dictionary
```

### Key Naming Convention:
`[module]_[category]_[action/item]`

Examples:
- `auth_login_title`
- `savings_account_balance`
- `loans_emi_due_date`
- `common_button_confirm`
- `error_network_unavailable`

---

## 3. Somobay Somiti Domain Terminology (Natural Bangla vs English)

Literal/machine translation creates poor user experience. The following standardized cooperative terms are strictly used:

| Domain Term | English | Natural Bangla (সমবায় পরিভাষা) | Context / Usage |
|---|---|---|---|
| **Cooperative Society** | Cooperative Society | সমবায় সমিতি | Main title & headers |
| **Share Capital** | Share Capital | শেয়ার মূলধন | Member equity shares |
| **Savings** | Regular Savings | সাধারণ সঞ্চয় | Daily/Weekly/Monthly savings |
| **DPS / Fixed Deposit** | Recurring Deposit (DPS) | ডিপিএস সঞ্চয় | Fixed monthly deposit scheme |
| **FDR** | Fixed Deposit Receipt (FDR) | মেয়াদী আমানত (এফডিআর) | Fixed term lump sum deposit |
| **Loan** | Loan / Credit | ঋণ কার্যক্রম | Microcredit / Investment loans |
| **Installment (EMI)** | Monthly Installment | মাসিক কিস্তি | Recurring loan payment |
| **Due Installment** | Overdue Installment | বকেয়া কিস্তি | Late loan repayment |
| **Guarantor** | Guarantor | জামিনদার | Co-signer for loan security |
| **Dividend** | Annual Dividend | বাৎসরিক লভ্যাংশ | Profit distribution on shares |
| **Passbook** | Transaction Passbook / Ledger | লেনদেন বই / হিসাব খতিয়ান | Credit/Debit record |
| **Deposit** | Deposit Money | টাকা জমা | Credit to savings |
| **Withdrawal** | Withdraw Money | টাকা উত্তোলন | Debit from savings |
| **Admission Fee** | Member Admission Fee | ভর্তি ফি | One-time member onboarding fee |
| **Nominee** | Nominee | মনোনীত উত্তরাধিকারী / নমিনি | Nominee for death benefits |
| **Fine / Penalty** | Late Fine | বিলম্ব ফি / জরিমানা | Fee on overdue installment |

---

## 4. Bangla Number & Currency Formatting Extension

Financial amounts and dates are automatically localized according to active locale:

```dart
extension LocalizedNumberExtension on num {
  String toLocalizedCurrency() {
    final isBangla = Get.locale?.languageCode == 'bn';
    final formattedNum = NumberFormat('#,##,##0.00').format(this);
    
    if (isBangla) {
      final banglaDigits = formattedNum
          .replaceAll('0', '০')
          .replaceAll('1', '১')
          .replaceAll('2', '২')
          .replaceAll('3', '৩')
          .replaceAll('4', '৪')
          .replaceAll('5', '৫')
          .replaceAll('6', '৬')
          .replaceAll('7', '৭')
          .replaceAll('8', '৮')
          .replaceAll('9', '৯');
      return '$banglaDigits ৳';
    }
    return '$formattedNum BDT';
  }
}
```
