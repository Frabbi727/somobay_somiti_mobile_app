import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_fields.dart';

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final amountController = TextEditingController(text: '50000');
  final monthsController = TextEditingController(text: '12');
  final interestRateController = TextEditingController(text: '10');

  double monthlyEmi = 0.0;
  double totalPayable = 0.0;
  double totalInterest = 0.0;

  @override
  void initState() {
    super.initState();
    calculate();
  }

  void calculate() {
    final principal = double.tryParse(amountController.text) ?? 0.0;
    final months = int.tryParse(monthsController.text) ?? 1;
    final rate = double.tryParse(interestRateController.text) ?? 0.0;

    if (principal > 0 && months > 0) {
      final interest = (principal * (rate / 100) * (months / 12));
      final total = principal + interest;
      setState(() {
        totalInterest = interest;
        totalPayable = total;
        monthlyEmi = total / months;
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    monthsController.dispose();
    interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'ঋণ ক্যালকুলেটর'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppTextField(
              label: 'ঋণের পরিমাণ (BDT)',
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'মেয়াদ (মাস)',
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'মুনাফা হার (%)',
                    controller: interestRateController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppCard(
              backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.5),
              child: Column(
                children: [
                  Text('সম্ভাব্য মাসিক কিস্তি (EMI)', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    monthlyEmi.toCurrency(),
                    style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('মোট মুনাফা/সার্ভিস চার্জ:', style: AppTextStyles.bodySmall),
                      Text(totalInterest.toCurrency(), style: AppTextStyles.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('মোট প্রদেয় টাকা:', style: AppTextStyles.bodySmall),
                      Text(totalPayable.toCurrency(), style: AppTextStyles.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
