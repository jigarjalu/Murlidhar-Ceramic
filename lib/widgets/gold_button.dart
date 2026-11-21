import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

enum GoldButtonVariant {
  gold,
  black,
  outline,
}

class GoldButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final GoldButtonVariant variant;
  final double borderRadius;

  const GoldButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52,
    this.variant = GoldButtonVariant.gold,
    this.borderRadius = 26,
  });

  @override
  State<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    BoxDecoration decoration;
    Color textColor;

    switch (widget.variant) {
      case GoldButtonVariant.gold:
        decoration = BoxDecoration(
          gradient: isDisabled
              ? null
              : AppColors.goldGradient,
          color: isDisabled ? Colors.grey.shade400 : null,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.goldStart.withAlpha(70),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        );
        textColor = AppColors.goldButtonText;
        break;

      case GoldButtonVariant.black:
        decoration = BoxDecoration(
          color: isDisabled ? Colors.grey.shade400 : AppColors.darkButtonBackground,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
        );
        textColor = Colors.white;
        break;

      case GoldButtonVariant.outline:
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: isDisabled ? Colors.grey.shade400 : AppColors.goldStart,
            width: 1.5,
          ),
        );
        textColor = isDisabled ? Colors.grey.shade500 : AppColors.goldDark;
        break;
    }

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: textColor),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.text,
              style: AppTypography.dynamicBody(
                widget.text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: Semantics(
          button: true,
          label: widget.text,
          child: Container(
            width: widget.width,
            height: widget.height,
            constraints: const BoxConstraints(minHeight: 48), // 48dp target
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: decoration,
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
