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

            // Visual Monthly Inquiry Volume Chart (Bars)
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildMonthBar('Jul', 35),
                      _buildMonthBar('Aug', 58),
                      _buildMonthBar('Sep', 42),
                      _buildMonthBar('Oct', 78),
                      _buildMonthBar('Nov', 95, isCurrent: true),
                      _buildMonthBar('Dec', 60),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Total Enquiries This Month: 95',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldDark),
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
                  _CategoryRankRow(rank: 1, name: 'Vitrified Tiles (વિટ્રીફાઈડ ટાઈલ્સ)', count: '48 enquiries'),
                  Divider(height: 16),
                  _CategoryRankRow(rank: 2, name: 'Glazed Tiles (ગ્લેઝ ટાઈલ્સ)', count: '32 enquiries'),
                  Divider(height: 16),
                  _CategoryRankRow(rank: 3, name: 'Digital Elevation (ડિજીટલ ટાઈલ્સ)', count: '24 enquiries'),
                  Divider(height: 16),
                  _CategoryRankRow(rank: 4, name: 'Parking Tiles (પાર્કિંગ ટાઈલ્સ)', count: '18 enquiries'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthBar(String month, double heightPct, {bool isCurrent = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: heightPct * 1.2,
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.goldStart : AppColors.goldStart.withAlpha(80),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.creamBackground,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$rank',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldDark),
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
