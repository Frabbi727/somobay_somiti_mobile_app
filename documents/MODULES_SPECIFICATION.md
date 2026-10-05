# Somobay Somiti Mobile App — Domain Modules Specification

## 1. Cooperative Society (সমবায় সমিতি) Domain Overview

In a cooperative financial institution, operations center around collective member savings, share capital equity, recurring deposits (DPS), and microcredit / development loans.

---

## 2. Feature Modules Breakdown

### 2.1 Member & Profile Module (`modules/members`, `modules/profile_settings`)
- **Key Capabilities:**
  - Member Unique ID / Account Number (সদস্য নম্বর).
  - NID Verification & Photo KYC.
  - Nominee details with percentage allocation (নমিনি সংক্রান্ত তথ্য).
  - Membership status (সক্রিয় / মুলতুবি / প্রত্যাহারকৃত).

### 2.2 Savings & DPS Module (`modules/savings_dps`)
- **Key Capabilities:**
  - **General Savings (সাধারণ সঞ্চয়):** Liquid account with flexible deposit & withdrawal.
  - **Monthly DPS (ডিপিএস সঞ্চয় স্কিম):** Fixed monthly tenure (3, 5, 10 years) with maturity estimation.
  - **FDR (মেয়াদী আমানত):** Lump-sum fixed deposit with term-end profit payout.
  - Due installment badge and overdue alert.

### 2.3 Loan Management Module (`modules/loans`)
- **Key Capabilities:**
  - Active loan balance, principal vs profit calculation.
  - Installment Calendar: Upcoming due date, paid installments (পরিশোধিত কিস্তি), and overdue fine (বিলম্ব ফি).
  - Loan Repayment gateway (bKash / Nagad / Bank transfer receipt upload).
  - Built-in EMI & Interest Calculator.

### 2.4 Share Capital Module (`modules/share_capital`)
- **Key Capabilities:**
  - Number of owned shares (শেয়ার সংখ্যা) and nominal face value (শেয়ারের অভিহিত মূল্য).
  - Total equity contribution to Somiti.
  - Annual AGM dividend distribution history (বাৎসরিক লভ্যাংশ ইতিহাস).

### 2.5 Digital Passbook / Ledger (`modules/transactions`)
- **Key Capabilities:**
  - Unified chronological ledger of all credits (জমা) and debits (উত্তোলন).
  - Filter by date range, transaction type (Savings, Loan EMI, Share purchase, Fine).
  - Downloadable / shareable digital payment receipt / voucher (ভাউচার).

### 2.6 Notice & Meeting Module (`modules/notifications`)
- **Key Capabilities:**
  - Annual General Meeting (AGM / বার্ষিক সাধারণ সভা) notices.
  - Emergency Somiti resolutions and policy updates.
  - Installment due date automated push alerts.
