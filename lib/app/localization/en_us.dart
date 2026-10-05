import 'translation_keys.dart';

const Map<String, String> enUS = {
  // Common
  TranslationKeys.appName: 'Somobay Somiti',
  TranslationKeys.cancel: 'Cancel',
  TranslationKeys.confirm: 'Confirm',
  TranslationKeys.retry: 'Retry',
  TranslationKeys.save: 'Save',
  TranslationKeys.update: 'Update',
  TranslationKeys.delete: 'Delete',
  TranslationKeys.seeAll: 'See All',
  TranslationKeys.search: 'Search...',
  TranslationKeys.filter: 'Filter',
  TranslationKeys.loading: 'Loading...',
  TranslationKeys.noDataFound: 'No data available at the moment.',

  // Navigation Tabs
  TranslationKeys.tabHome: 'Home',
  TranslationKeys.tabSavings: 'Savings & DPS',
  TranslationKeys.tabLoans: 'Loans',
  TranslationKeys.tabPassbook: 'Passbook',
  TranslationKeys.tabProfile: 'Profile',

  // Auth & Onboarding
  TranslationKeys.loginTitle: 'Welcome Back!',
  TranslationKeys.loginSubtitle: 'Sign in to access your Somiti account',
  TranslationKeys.phoneLabel: 'Mobile Number',
  TranslationKeys.phoneHint: '01XXXXXXXXX',
  TranslationKeys.passwordLabel: 'Password / PIN',
  TranslationKeys.passwordHint: 'Enter your password',
  TranslationKeys.rememberMe: 'Remember me',
  TranslationKeys.forgotPassword: 'Forgot Password?',
  TranslationKeys.loginButton: 'Sign In',
  TranslationKeys.registerPrompt: "Don't have an account?",
  TranslationKeys.registerNow: 'Apply for Membership',
  TranslationKeys.logoutConfirm: 'Are you sure you want to log out?',
  TranslationKeys.logoutTitle: 'Logout',

  // Dashboard & Somiti
  TranslationKeys.totalSavings: 'Total Savings',
  TranslationKeys.activeLoans: 'Active Loan',
  TranslationKeys.totalShares: 'Total Shares',
  TranslationKeys.memberId: 'Member ID',
  TranslationKeys.quickActions: 'Quick Services',
  TranslationKeys.depositMoney: 'Deposit',
  TranslationKeys.payInstallment: 'Pay Loan EMI',
  TranslationKeys.loanCalculator: 'Calculator',
  TranslationKeys.memberDirectory: 'Members',
  TranslationKeys.notices: 'Notice Board',
  TranslationKeys.recentTransactions: 'Recent Transactions',

  // Savings & DPS
  TranslationKeys.savingsTitle: 'Savings Accounts',
  TranslationKeys.dpsTitle: 'DPS Schemes',
  TranslationKeys.fdrTitle: 'FDR Term Deposits',
  TranslationKeys.accountNo: 'Account No',
  TranslationKeys.maturityDate: 'Maturity Date',
  TranslationKeys.monthlyInstallment: 'Monthly Deposit',
  TranslationKeys.depositHistory: 'Deposit History',

  // Loans
  TranslationKeys.loanTitle: 'Loan Portfolio',
  TranslationKeys.loanAmount: 'Sanctioned Loan',
  TranslationKeys.remainingLoan: 'Remaining Balance',
  TranslationKeys.nextInstallmentDate: 'Next Installment',
  TranslationKeys.overdueInstallment: 'Overdue Installment',
  TranslationKeys.loanRepay: 'Repay Installment',

  // Passbook & Transactions
  TranslationKeys.passbookTitle: 'Digital Passbook',
  TranslationKeys.transactionDetails: 'Transaction Details',
  TranslationKeys.transactionId: 'Tx ID',
  TranslationKeys.transactionType: 'Type',
  TranslationKeys.transactionDate: 'Date & Time',
  TranslationKeys.voucher: 'Digital Voucher',

  // Profile & Settings
  TranslationKeys.profileTitle: 'Member Profile',
  TranslationKeys.personalInfo: 'Personal Information',
  TranslationKeys.nomineeInfo: 'Nominee Information',
  TranslationKeys.changeLanguage: 'Language / ভাষা',
  TranslationKeys.changePassword: 'Change Password / PIN',
  TranslationKeys.somitiByLaws: 'Somiti By-Laws & Rules',
  TranslationKeys.logout: 'Log Out',

  // Errors & Validations
  TranslationKeys.errorNoInternet: 'No internet connection. Please check your connection and try again.',
  TranslationKeys.errorServer: 'Server is temporarily unavailable. Please try again later.',
  TranslationKeys.errorTimeout: 'Request timed out. Please try again.',
  TranslationKeys.errorSessionExpired: 'Your session has expired. Please log in again.',
  TranslationKeys.errorUnknown: 'An unexpected error occurred. Please try again.',
  TranslationKeys.errorCancelled: 'Request was cancelled.',
  TranslationKeys.validationPhoneRequired: 'Mobile number is required',
  TranslationKeys.validationPhoneInvalid: 'Please enter a valid 11-digit Bangladeshi mobile number',
  TranslationKeys.validationPasswordRequired: 'Password is required',
  TranslationKeys.validationPasswordMinLength: 'Password must be at least 6 characters',
  TranslationKeys.validationRequired: 'This field is required',
  TranslationKeys.validationIsRequired: 'is required',
  TranslationKeys.validationAmountRequired: 'Amount is required',
  TranslationKeys.validationAmountInvalid: 'Please enter a valid amount',
  TranslationKeys.validationAmountMin: 'Minimum amount is',
  TranslationKeys.validationAmountMax: 'Maximum amount is',
  TranslationKeys.validationNidRequired: 'National ID (NID) is required',
  TranslationKeys.validationNidInvalid: 'Please enter a valid NID (10, 13, or 17 digits)',

  // Force Update
  TranslationKeys.forceUpdateTitle: 'Update Required',
  TranslationKeys.forceUpdateMessage: 'A new version of the application is available. Please update the application to continue.',
  TranslationKeys.updateNow: 'Update Now',

  // Member API errors
  TranslationKeys.errorForbidden: 'You do not have access to this. Please sign in again.',
  TranslationKeys.errorNotFound: 'Not found.',
  TranslationKeys.errorConflict: 'This was already submitted with different details.',
  TranslationKeys.errorTooMany: 'Too many attempts. Please wait a minute and try again.',

  // Member sign-in
  TranslationKeys.errorTitle: 'Something went wrong',
  TranslationKeys.successTitle: 'Done',
  TranslationKeys.passwordHelp: 'Your password is set by the society office. Ask them if you do not have one.',
  TranslationKeys.usePassword: 'Password',
  TranslationKeys.useCode: 'SMS code',
  TranslationKeys.codeLabel: 'SMS code',
  TranslationKeys.codeHint: '6-digit code',
  TranslationKeys.sendCode: 'Send code',
  TranslationKeys.resendIn: 'Resend in @seconds s',
  TranslationKeys.codeRequired: 'Enter the code from the SMS.',

  // Member sign-in (code)
  TranslationKeys.codeSent: 'A code has been sent by SMS.',

  // Unsupported
  TranslationKeys.errorNotSupported: 'This is not available. Please contact the society office.',

  // Month names
  TranslationKeys.month1: 'January',
  TranslationKeys.month2: 'February',
  TranslationKeys.month3: 'March',
  TranslationKeys.month4: 'April',
  TranslationKeys.month5: 'May',
  TranslationKeys.month6: 'June',
  TranslationKeys.month7: 'July',
  TranslationKeys.month8: 'August',
  TranslationKeys.month9: 'September',
  TranslationKeys.month10: 'October',
  TranslationKeys.month11: 'November',
  TranslationKeys.month12: 'December',

  // Home
  TranslationKeys.homeSavings: 'Savings',
  TranslationKeys.homeAdvance: 'Advance',
  TranslationKeys.homeOutstanding: 'Outstanding',
  TranslationKeys.homePaidThrough: 'Paid through',
  TranslationKeys.homePaidThroughNone: 'No month fully paid yet',
  TranslationKeys.homeAdvanceEstimate: 'Advance covers about @months more months (estimate, at current rates)',
  TranslationKeys.homeShares: 'Shares',
  TranslationKeys.homeSharesCount: '@count shares',
  TranslationKeys.homePayNow: 'Pay now',
  TranslationKeys.homeRecentPayments: 'Recent payments',
  TranslationKeys.homeNoPayments: 'No payments yet.',
  TranslationKeys.memberNo: 'Member no.',

  // Notifications
  TranslationKeys.notificationsTitle: 'Messages',
};
