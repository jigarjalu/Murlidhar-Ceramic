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
        title: Text(
          isGu ? 'બધી કેટેગરીઝ' : 'All Categories',
          style: AppTypography.heading(fontSize: 20),
        ),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      body: categoriesAsync.when(
        data: (cats) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.76,
          ),
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            final name = cat.localizedName(lang);
            return GlassCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 16,
              onTap: () => context.push('/products', extra: cat),
              child: Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'cat_img_${cat.id}',
                      child: ProductImage(
                        imageUrl: cat.imageUrl,
                        borderRadius: 12,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.dynamicBody(
                      name,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
            mainAxisSpacing: 14,
            childAspectRatio: 0.76,
          ),
          itemCount: 9,
          itemBuilder: (_, __) => const SkeletonLoader(width: 100, height: 120),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
