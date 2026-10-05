import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../model/transaction_model.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tx = Get.arguments as TransactionModel? ??
        const TransactionModel(
          id: 'TX-101',
          transactionId: 'TXN87629318',
          title: 'ডিপিএস মাসিক কিস্তি জমা',
          amount: 1000.0,
          type: TransactionType.credit,
          createdAt: '01 Oct 2026, 10:30 AM',
          accountNumber: 'DPS-2024-502',
        );

    final isCredit = tx.type == TransactionType.credit;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'passbook_voucher'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCredit ? AppColors.primaryContainer : Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCredit ? Icons.check_circle_outline_rounded : Icons.arrow_outward_rounded,
                      color: isCredit ? AppColors.deposit : AppColors.withdraw,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(tx.title, style: AppTextStyles.h3, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    '${isCredit ? '+' : '-'} ${tx.amount.toCurrency()}',
                    style: AppTextStyles.amountLarge.copyWith(
                      color: isCredit ? AppColors.deposit : AppColors.withdraw,
                    ),
                  ),
                  const Divider(height: 32),
                  _buildDetailRow('ট্রানজেকশন আইডি', tx.transactionId),
                  _buildDetailRow('তারিখ ও সময়', tx.createdAt),
                  _buildDetailRow('হিসাব নম্বর', tx.accountNumber),
                  _buildDetailRow('পেমেন্ট মাধ্যম', tx.paymentMethod),
                  _buildDetailRow('স্ট্যাটাস', tx.status),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton.outlined(
              text: 'ভাউচার শেয়ার করুন',
              prefixIcon: const Icon(Icons.share_rounded, size: 18),
              onPressed: () {
                Get.snackbar('সফল', 'ভাউচার সংরক্ষিত হয়েছে।', backgroundColor: AppColors.primary, colorText: Colors.white);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
