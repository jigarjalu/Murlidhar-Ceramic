import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/models/enquiry_model.dart';

class StatusChip extends StatelessWidget {
  final EnquiryStatus status;
  final bool isGujarati;

  const StatusChip({
    super.key,
    required this.status,
    this.isGujarati = false,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    String label;

    switch (status) {
      case EnquiryStatus.pending:
        textColor = AppColors.statusPending;
        bgColor = AppColors.statusPendingBg;
        label = isGujarati ? 'બાકી' : 'Pending';
        break;
      case EnquiryStatus.contacted:
        textColor = AppColors.statusContacted;
        bgColor = AppColors.statusContactedBg;
        label = isGujarati ? 'સંપર્ક કર્યો' : 'Contacted';
        break;
      case EnquiryStatus.closed:
        textColor = AppColors.statusClosed;
        bgColor = AppColors.statusClosedBg;
        label = isGujarati ? 'પૂર્ણ' : 'Closed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withAlpha(80), width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.dynamicBody(
          label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
