import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../features/common/providers/language_provider.dart';

class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final isGu = lang == 'gu';

    return GestureDetector(
      onTap: () => ref.read(languageProvider.notifier).toggleLanguage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.goldStart.withAlpha(35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.goldStart.withAlpha(120), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.translate_rounded,
              size: 16,
              color: AppColors.goldDark,
            ),
            const SizedBox(width: 5),
            Text(
              isGu ? 'ગુજરાતી' : 'English',
              style: AppTypography.dynamicBody(
                isGu ? 'ગુજરાતી' : 'English',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.goldDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
