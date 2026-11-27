import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';
import '../common/providers/app_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);
    final enquiriesAsync = ref.watch(myEnquiriesProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
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
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline_rounded),
            activeIcon: Icon(Icons.mark_email_read_rounded),
            label: 'Enquiries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            activeIcon: Icon(Icons.analytics_rounded),
            label: 'Reports',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Store Overview',
                  style: AppTypography.heading(fontSize: 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldStart.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldStart.withOpacity(0.4),
                    ),
                  ),
                  child: const Text(
                    AppConfig.isMockMode ? 'MOCK MODE' : 'FIREBASE LIVE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metrics Cards: Total Products, Total Enquiries (NO SALES FIGURES ANYWHERE)
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.inventory_2_rounded,
                          color: AppColors.goldDark,
                          size: 28,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Total Products',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productsAsync.when(
                            data: (list) => '${list.length}',
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
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppColors.goldDark,
                          size: 28,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Total Enquiries',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          enquiriesAsync.when(
                            data: (list) => '${list.length + 3}',
                            loading: () => '...',
                            error: (_, __) => '3',
                          ),
                          style: AppTypography.heading(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Enquiry Trend Line Chart (NO SALES DATA)
            Text(
              'Enquiry Trend (Last 6 Months)',
              style: AppTypography.dynamicBody(
                'Enquiry Trend',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.fromLTRB(14, 20, 16, 12),
              child: SizedBox(
                height: 170,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, _) {
                            const months = [
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov'
                            ];
                            final idx = val.toInt();
                            if (idx >= 0 && idx < months.length) {
                              return Text(
                                months[idx],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 22),
                          FlSpot(1, 38),
                          FlSpot(2, 45),
                          FlSpot(3, 58),
                          FlSpot(4, 76),
                          FlSpot(5, 95),
                        ],
                        isCurved: true,
                        color: AppColors.goldStart,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.goldStart.withOpacity(0.18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Management Shortcuts
            Text(
              'Management Shortcuts',
              style: AppTypography.dynamicBody(
                'Shortcuts',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: AppColors.goldDark,
                    ),
                    title: const Text('Manage Products / Add New Tile'),
                    subtitle: const Text('Add, edit, remove & toggle prices'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/admin/products'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.mark_chat_unread_outlined,
                      color: AppColors.goldDark,
                    ),
                    title: const Text('Customer WhatsApp Enquiries'),
                    subtitle:
                        const Text('Review Pending, Contacted & Closed status'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/admin/enquiries'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.analytics_outlined,
                      color: AppColors.goldDark,
                    ),
                    title: const Text('Enquiry Reports & Top Tiles'),
                    subtitle:
                        const Text('Monthly volume bar chart & top categories'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
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
