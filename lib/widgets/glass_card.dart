import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isSelected;
  final Color? backgroundColor;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.isSelected = false,
    this.backgroundColor,
    this.border,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = widget.backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.creamCard);

    final border = widget.border ??
        Border.all(
          color: widget.isSelected
              ? AppColors.goldStart
              : (isDark ? AppColors.darkCardBorder : AppColors.creamCardBorder),
          width: widget.isSelected ? 1.5 : 1.0,
        );

    final shadow = isDark
        ? [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
        : [
            BoxShadow(
              color: const Color(0xFF1B1712).withAlpha(15),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ];

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
        onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
        onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: defaultBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: border,
            boxShadow: shadow,
          ),
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}
