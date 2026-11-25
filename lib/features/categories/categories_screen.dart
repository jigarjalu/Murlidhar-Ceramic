import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/skeleton_loader.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isGu ? 'કેટેગરીઝ' : 'Categories',
          style: AppTypography.heading(
            fontSize: 20,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      body: categoriesAsync.when(
        data: (cats) => GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            final nameGu = cat.nameGujarati;
            final nameEn = cat.nameEnglish;

            return GlassCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 18,
              onTap: () => context.push('/products', extra: cat),
              child: Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'cat_img_${cat.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.goldStart.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: ProductImage(
                            imageUrl: cat.imageUrl,
                            borderRadius: 14,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display category name (dual: Gujarati prominent + English secondary)
                  Text(
                    isGu ? nameGu : nameEn,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.dynamicBody(
                      isGu ? nameGu : nameEn,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGu ? nameEn : nameGu,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: 9,
          itemBuilder: (_, __) => const SkeletonLoader(width: 100, height: 130, borderRadius: 18),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: AppColors.textSecondary),
              const SizedBox(height: 8),
              Text(
                isGu ? 'ડેટા લોડ કરવામાં ક્ષતિ આવી' : 'Failed to load categories',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
