import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Enquiry Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Customer Inquiries',
              style: AppTypography.heading(fontSize: 18),
            ),
            const SizedBox(height: 14),

            // Bar chart using fl_chart (NO SALES FIGURES)
            GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
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
                              getTitlesWidget: (val, _) {
                                const months = [
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ];
                                final idx = val.toInt();
                                if (idx >= 0 && idx < months.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      months[idx],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: idx == 4
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: idx == 4
                                            ? AppColors.goldDark
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          _buildBarGroup(0, 35),
                          _buildBarGroup(1, 58),
                          _buildBarGroup(2, 42),
                          _buildBarGroup(3, 78),
                          _buildBarGroup(4, 95, isCurrent: true),
                          _buildBarGroup(5, 60),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Enquiries This Month:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '95 Enquiries',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Most Enquired Tile Categories',
              style: AppTypography.heading(fontSize: 18),
            ),
            const SizedBox(height: 12),
            const GlassCard(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _CategoryRankRow(
                    rank: 1,
                    name: 'Vitrified Tiles (વિટ્રીફાઈડ ટાઈલ્સ)',
                    count: '48 enquiries',
                  ),
                  Divider(height: 16),
                  _CategoryRankRow(
                    rank: 2,
                    name: 'Glazed Tiles (ગ્લેઝ ટાઈલ્સ)',
                    count: '32 enquiries',
                  ),
                  Divider(height: 16),
                  _CategoryRankRow(
                    rank: 3,
                    name: 'Digital Elevation (ડિજીટલ ટાઈલ્સ)',
                    count: '24 enquiries',
                  ),
                  Divider(height: 16),
                  _CategoryRankRow(
                    rank: 4,
                    name: 'Parking Tiles (પાર્કિંગ ટાઈલ્સ)',
                    count: '18 enquiries',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, {bool isCurrent = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isCurrent ? AppColors.goldStart : const Color(0xFFD9C5A3),
          width: 18,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}

class _CategoryRankRow extends StatelessWidget {
  final int rank;
  final String name;
  final String count;

  const _CategoryRankRow({
    required this.rank,
    required this.name,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: rank == 1
                ? AppColors.goldStart
                : AppColors.creamCardBorder,
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: rank == 1 ? AppColors.goldButtonText : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          count,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
