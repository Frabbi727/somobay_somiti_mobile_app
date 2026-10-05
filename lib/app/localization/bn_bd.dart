import 'translation_keys.dart';

const Map<String, String> bnBD = {
  // Common
  TranslationKeys.appName: 'সমবায় সমিতি',
  TranslationKeys.cancel: 'বাতিল',
  TranslationKeys.confirm: 'নিশ্চিত করুন',
  TranslationKeys.retry: 'পুনরায় চেষ্টা করুন',
  TranslationKeys.save: 'সংরক্ষণ',
  TranslationKeys.update: 'আপডেট',
  TranslationKeys.delete: 'মুছে ফেলুন',
  TranslationKeys.seeAll: 'সকল দেখুন',
  TranslationKeys.search: 'অনুসন্ধান করুন...',
  TranslationKeys.filter: 'ফিল্টার',
  TranslationKeys.loading: 'লোড হচ্ছে...',
  TranslationKeys.noDataFound: 'এই মুহূর্তে কোনো তথ্য পাওয়া যায়নি।',

  // Navigation Tabs
  TranslationKeys.tabHome: 'হোম',
  TranslationKeys.tabSavings: 'সঞ্চয় ও ডিপিএস',
  TranslationKeys.tabLoans: 'ঋণ কার্যক্রম',
  TranslationKeys.tabPassbook: 'খতিয়ান বই',
  TranslationKeys.tabProfile: 'প্রোফাইল',

  // Auth & Onboarding
  TranslationKeys.loginTitle: 'স্বাগতম!',
  TranslationKeys.loginSubtitle: 'আপনার সমিতি অ্যাকাউন্টে লগইন করুন',
  TranslationKeys.phoneLabel: 'মোবাইল নম্বর',
  TranslationKeys.phoneHint: '০১XXXXXXXXX',
  TranslationKeys.passwordLabel: 'পাসওয়ার্ড / পিন',
  TranslationKeys.passwordHint: 'পাসওয়ার্ড লিখুন',
  TranslationKeys.rememberMe: 'স্মরণে রাখুন',
  TranslationKeys.forgotPassword: 'পাসওয়ার্ড ভুলে গেছেন?',
  TranslationKeys.loginButton: 'লগইন করুন',
  TranslationKeys.registerPrompt: 'আপনার কি কোনো অ্যাকাউন্ট নেই?',
  TranslationKeys.registerNow: 'সদস্যপদের জন্য আবেদন করুন',
  TranslationKeys.logoutConfirm: 'আপনি কি নিশ্চিত যে লগআউট করতে চান?',
  TranslationKeys.logoutTitle: 'লগআউট',

  // Dashboard & Somiti
  TranslationKeys.totalSavings: 'মোট সঞ্চয় স্থিতি',
  TranslationKeys.activeLoans: 'চলতি ঋণ স্থিতি',
  TranslationKeys.totalShares: 'শেয়ার মূলধন',
  TranslationKeys.memberId: 'সদস্য নং',
  TranslationKeys.quickActions: 'দ্রুত সেবা',
  TranslationKeys.depositMoney: 'টাকা জমা',
  TranslationKeys.payInstallment: 'কিস্তি পরিশোধ',
  TranslationKeys.loanCalculator: 'ঋণ ক্যালকুলেটর',
  TranslationKeys.memberDirectory: 'সদস্য তালিকা',
  TranslationKeys.notices: 'নোটিশ বোর্ড',
  TranslationKeys.recentTransactions: 'সাম্প্রতিক লেনদেন',

  // Savings & DPS
  TranslationKeys.savingsTitle: 'সাধারণ সঞ্চয় হিসাব',
  TranslationKeys.dpsTitle: 'ডিপিএস সঞ্চয় স্কিম',
  TranslationKeys.fdrTitle: 'মেয়াদী আমানত (এফডিআর)',
  TranslationKeys.accountNo: 'হিসাব নম্বর',
  TranslationKeys.maturityDate: 'মেয়াদপূর্তির তারিখ',
  TranslationKeys.monthlyInstallment: 'মাসিক জমা',
  TranslationKeys.depositHistory: 'জমার ইতিহাস',

  // Loans
  TranslationKeys.loanTitle: 'ঋণ পোর্টফোলিও',
  TranslationKeys.loanAmount: 'মঞ্জুরীকৃত ঋণ',
  TranslationKeys.remainingLoan: 'অবশিষ্ট ঋণ',
  TranslationKeys.nextInstallmentDate: 'পরবর্তী কিস্তির তারিখ',
  TranslationKeys.overdueInstallment: 'বকেয়া কিস্তি',
  TranslationKeys.loanRepay: 'কিস্তি প্রদান করুন',

  // Passbook & Transactions
  TranslationKeys.passbookTitle: 'ডিজিটাল পাসবুক',
  TranslationKeys.transactionDetails: 'লেনদেনের বিবরণ',
  TranslationKeys.transactionId: 'ট্রানজেকশন আইডি',
  TranslationKeys.transactionType: 'লেনদেনের ধরন',
  TranslationKeys.transactionDate: 'তারিখ ও সময়',
  TranslationKeys.voucher: 'ডিজিটাল ভাউচার',

  // Profile & Settings
  TranslationKeys.profileTitle: 'সদস্য প্রোফাইল',
  TranslationKeys.personalInfo: 'ব্যক্তিগত তথ্য',
  TranslationKeys.nomineeInfo: 'মনোনীত উত্তরাধিকারী (নমিনি)',
  TranslationKeys.changeLanguage: 'ভাষা পরিবর্তন (Language)',
  TranslationKeys.changePassword: 'পাসওয়ার্ড / পিন পরিবর্তন',
  TranslationKeys.somitiByLaws: 'সমিতির উপ-আইন ও নীতিমালা',
  TranslationKeys.logout: 'লগআউট',

  // Errors & Validations
  TranslationKeys.errorNoInternet: 'ইন্টারনেট সংযোগ পাওয়া যাচ্ছে না। আপনার ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।',
  TranslationKeys.errorServer: 'সার্ভার সাময়িকভাবে অনুপলব্ধ আছে। কিছুক্ষণ পর পুনরায় চেষ্টা করুন।',
  TranslationKeys.errorTimeout: 'অনুরোধের সময় শেষ হয়ে গেছে। পুনরায় চেষ্টা করুন।',
  TranslationKeys.errorSessionExpired: 'আপনার সেশনের মেয়াদ শেষ হয়েছে। অনুগ্রহ করে পুনরায় লগইন করুন।',
  TranslationKeys.errorUnknown: 'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে। পুনরায় চেষ্টা করুন।',
  TranslationKeys.errorCancelled: 'অনুরোধটি বাতিল করা হয়েছে।',
  TranslationKeys.validationPhoneRequired: 'মোবাইল নম্বর প্রদান করা আবশ্যক',
  TranslationKeys.validationPhoneInvalid: 'অনুগ্রহ করে সঠিক ১১ ডিজিটের মোবাইল নম্বর প্রদান করুন',
  TranslationKeys.validationPasswordRequired: 'পাসওয়ার্ড প্রদান করা আবশ্যক',
  TranslationKeys.validationPasswordMinLength: 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
  TranslationKeys.validationRequired: 'এই ঘরটি পূরণ করা আবশ্যক',
  TranslationKeys.validationIsRequired: 'প্রদান করা আবশ্যক',
  TranslationKeys.validationAmountRequired: 'টাকার পরিমাণ আবশ্যক',
  TranslationKeys.validationAmountInvalid: 'সঠিক টাকার পরিমাণ লিখুন',
  TranslationKeys.validationAmountMin: 'সর্বনিম্ন পরিমাণ হলো',
  TranslationKeys.validationAmountMax: 'সর্বোচ্চ পরিমাণ হলো',
  TranslationKeys.validationNidRequired: 'জাতীয় পরিচয়পত্র (NID) নম্বর আবশ্যক',
  TranslationKeys.validationNidInvalid: 'সঠিক জাতীয় পরিচয়পত্র নম্বর দিন (১০, ১৩ বা ১৭ ডিজিট)',

  // Force Update
  TranslationKeys.forceUpdateTitle: 'আপডেট প্রয়োজন',
  TranslationKeys.forceUpdateMessage: 'অ্যাপ্লিকেশনটির একটি নতুন সংস্করণ উপলব্ধ রয়েছে। চালিয়ে যেতে অনুগ্রহ করে অ্যাপ্লিকেশনটি আপডেট করুন।',
  TranslationKeys.updateNow: 'এখনই আপডেট করুন',

  // Member API errors
  TranslationKeys.errorForbidden: 'এটি দেখার অনুমতি নেই। অনুগ্রহ করে আবার লগইন করুন।',
  TranslationKeys.errorNotFound: 'পাওয়া যায়নি।',
  TranslationKeys.errorConflict: 'এটি আগেই অন্য তথ্যসহ জমা হয়েছে।',
  TranslationKeys.errorTooMany: 'অনেকবার চেষ্টা হয়েছে। এক মিনিট পরে আবার চেষ্টা করুন।',

  // Member sign-in
  TranslationKeys.errorTitle: 'ত্রুটি',
  TranslationKeys.successTitle: 'সম্পন্ন',
  TranslationKeys.passwordHelp: 'পাসওয়ার্ড সমিতির অফিস দেয়। পাসওয়ার্ড না থাকলে অফিসে যোগাযোগ করুন।',
  TranslationKeys.usePassword: 'পাসওয়ার্ড',
  TranslationKeys.useCode: 'এসএমএস কোড',
  TranslationKeys.codeLabel: 'এসএমএস কোড',
  TranslationKeys.codeHint: '৬ অঙ্কের কোড',
  TranslationKeys.sendCode: 'কোড পাঠান',
  TranslationKeys.resendIn: '@seconds সেকেন্ড পরে আবার পাঠান',
  TranslationKeys.codeRequired: 'এসএমএসে আসা কোডটি লিখুন।',

  // Member sign-in (code)
  TranslationKeys.codeSent: 'এসএমএসে একটি কোড পাঠানো হয়েছে।',

  // Unsupported
  TranslationKeys.errorNotSupported: 'এটি এখন পাওয়া যায় না। সমিতির অফিসে যোগাযোগ করুন।',
};
