import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';
import '../common/providers/app_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(popularProductsProvider);
    final enquiryCart = ref.watch(enquiryCartProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.go('/home'),
            tooltip: 'View Customer Catalog',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.goldDark,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/admin/products');
              break;
            case 2:
              context.push('/admin/enquiries');
              break;
            case 3:
              context.push('/admin/reports');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline_rounded), label: 'Enquiries'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Overview',
              style: AppTypography.heading(fontSize: 20),
            ),
            const SizedBox(height: 16),

            // Metrics Cards: Total Products, Total Enquiries (NO SALES FIGURES)
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.inventory_2_rounded, color: AppColors.goldDark, size: 28),
                        const SizedBox(height: 12),
                        const Text(
                          'Total Products',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productsAsync.when(
                            data: (_) => '54+',
                            loading: () => '...',
                            error: (_, __) => '0',
                          ),
                          style: AppTypography.heading(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.goldDark, size: 28),
                        const SizedBox(height: 12),
                        const Text(
                          'Active Enquiries',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${enquiryCart.length + 3}',
                          style: AppTypography.heading(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Nav Cards
            Text(
              'Management Shortcuts',
              style: AppTypography.dynamicBody('Shortcuts', fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline_rounded, color: AppColors.goldDark),
                    title: const Text('Manage Products / Add New Tile'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/admin/products'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.mark_chat_unread_outlined, color: AppColors.goldDark),
                    title: const Text('Customer WhatsApp Enquiries'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/admin/enquiries'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.analytics_outlined, color: AppColors.goldDark),
                    title: const Text('Enquiry Reports & Popular Tiles'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/admin/reports'),
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
