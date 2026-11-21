import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeBorder? shapeBorder;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.shapeBorder,
  });

  const SkeletonLoader.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? AppColors.darkShimmerBase
        : AppColors.lightShimmerBase;
    final highlightColor = isDark
        ? AppColors.darkShimmerHighlight
        : AppColors.lightShimmerHighlight;

    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: shapeBorder != null
              ? ShapeDecoration(
                  color: baseColor,
                  shape: shapeBorder!,
                )
              : BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
        ),
      ),
    );
  }
}
