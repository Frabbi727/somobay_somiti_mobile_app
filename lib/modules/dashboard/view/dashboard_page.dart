import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../controller/dashboard_controller.dart';
import '../../home/view/home_page.dart';
import '../../dues/view/dues_page.dart';
import '../../payments/view/payments_page.dart';
import '../../transactions/view/transaction_history_page.dart';
import '../../profile_settings/view/profile_page.dart';
import '../../../core/widgets/app_network_banner.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({Key? key}) : super(key: key);

  static const List<Widget> _pages = [
    HomePage(),
    DuesPage(),
    PaymentsPage(),
    TransactionHistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppNetworkBanner(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: _pages,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          backgroundColor: AppColors.surface,
          elevation: 8,
          indicatorColor: AppColors.primaryContainer,
          height: AppDimensions.bottomNavHeight,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'tab_home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.event_note_outlined),
              selectedIcon: const Icon(Icons.event_note_rounded, color: AppColors.primary),
              label: 'tab_dues'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.payments_outlined),
              selectedIcon: const Icon(Icons.payments_rounded, color: AppColors.primary),
              label: 'tab_payments'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
              label: 'tab_passbook'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'tab_profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
