import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final favIds = ref.watch(favoritesProvider);
    final popularAsync = ref.watch(popularProductsProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'પસંદગી / મનપસંદ' : 'Favorites',
          style: AppTypography.heading(fontSize: 20),
        ),
      ),
      body: popularAsync.when(
        data: (allProducts) {
          final favProducts = allProducts.where((p) => favIds.contains(p.id)).toList();

          if (favProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    isGu ? 'તમારું મનપસંદ લિસ્ટ ખાલી છે' : 'No favorites added yet',
                    style: AppTypography.dynamicBody('No favorites', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: favProducts.length,
            itemBuilder: (context, index) {
              final item = favProducts[index];
              final name = item.localizedName(lang);

              return GlassCard(
                padding: const EdgeInsets.all(10),
                borderRadius: 18,
                onTap: () => context.push('/product-detail/${item.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ProductImage(
                        imageUrl: item.images.first,
                        borderRadius: 14,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.dynamicBody(name, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish,
                      style: const TextStyle(fontSize: 11, color: AppColors.goldDark, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
