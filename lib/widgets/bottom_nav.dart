import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../features/common/providers/app_providers.dart';
import '../features/common/providers/language_provider.dart';

class BottomNav extends ConsumerWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = ref.watch(languageProvider);
    final enquiryCart = ref.watch(enquiryCartProvider);
    final isGu = lang == 'gu';

    final navItems = [
      const _NavItem(
        index: 0,
        labelGu: 'હોમ',
        labelEn: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        route: '/home',
      ),
      const _NavItem(
        index: 1,
        labelGu: 'પ્રોડક્ટ્સ',
        labelEn: 'Products',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        route: '/categories',
      ),
      const _NavItem(
        index: 2,
        labelGu: 'ગેલેરી',
        labelEn: 'Gallery',
        icon: Icons.photo_library_outlined,
        activeIcon: Icons.photo_library_rounded,
        route: '/gallery',
      ),
      const _NavItem(
        index: 3,
        labelGu: 'અમારા વિશે',
        labelEn: 'About',
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront_rounded,
        route: '/about',
      ),
      _NavItem(
        index: 4,
        labelGu: 'પૂછપરછ',
        labelEn: 'Enquiry',
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
        route: '/enquiry',
        badgeCount: enquiryCart.length,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.creamCard,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.creamCardBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.map((item) {
              final isSelected = item.index == currentIndex;
              final label = isGu ? item.labelGu : item.labelEn;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (item.index != currentIndex) {
                      context.go(item.route);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: label,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark
                                          ? AppColors.goldStart.withAlpha(40)
                                          : AppColors.goldStart.withAlpha(30))
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  size: 22,
                                  color: isSelected
                                      ? AppColors.goldStart
                                      : (isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary),
                                ),
                              ),
                              if (item.badgeCount != null && item.badgeCount! > 0)
                                Positioned(
                                  top: -2,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.goldStart,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${item.badgeCount}',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.goldButtonText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            label,
                            style: AppTypography.dynamicBody(
                              label,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.goldDark
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final int index;
  final String labelGu;
  final String labelEn;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final int? badgeCount;

  const _NavItem({
    required this.index,
    required this.labelGu,
    required this.labelEn,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.badgeCount,
  });
}
