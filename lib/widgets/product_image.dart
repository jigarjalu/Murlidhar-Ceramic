import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'skeleton_loader.dart';

/// Shared image widget providing ceramic/tile colour-grading:
/// enhanced contrast, subtle warm highlights, and subtle vignette.
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool enableGrade;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 16,
    this.enableGrade = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Base cached image with colour grading colorFilter
          enableGrade
              ? ColorFiltered(
                  // Matrix for contrast boost (+10%) and warm golden tint (+5% red, +3% green)
                  colorFilter: const ColorFilter.matrix([
                    1.10, 0.00, 0.00, 0.00, 6.0,  // R
                    0.00, 1.05, 0.00, 0.00, 4.0,  // G
                    0.00, 0.00, 0.98, 0.00, -2.0, // B
                    0.00, 0.00, 0.00, 1.00, 0.0,  // A
                  ]),
                  child: _buildCachedImage(),
                )
              : _buildCachedImage(),

          // Soft warm highlight & subtle vignette overlay
          if (enableGrade)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.1,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(20),
                      Colors.black.withAlpha(55),
                    ],
                    stops: const [0.55, 0.85, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCachedImage() {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => SkeletonLoader(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        borderRadius: borderRadius,
      ),
      errorWidget: (context, url, error) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.creamCard,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textMuted,
          size: 32,
        ),
      ),
    );
  }
}
