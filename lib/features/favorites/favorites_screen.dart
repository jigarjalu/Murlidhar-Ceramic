import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final favIds = ref.watch(favoritesProvider);
    final allProductsAsync = ref.watch(allProductsProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'પસંદગી / મનપસંદ' : 'Favorites',
          style: AppTypography.heading(fontSize: 20),
        ),
      ),
      body: allProductsAsync.when(
        data: (allProducts) {
          final favProducts =
              allProducts.where((p) => favIds.contains(p.id)).toList();

          if (favProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isGu
                          ? 'તમારું મનપસંદ લિસ્ટ ખાલી છે'
                          : 'No favorites added yet',
                      style: AppTypography.dynamicBody(
                        'No favorites',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGu
                          ? 'કોઈ પણ ટાઈલ પર હાર્ટ આઇકોન દબાવીને મનપસંદમાં ઉમેરો.'
                          : 'Tap the heart icon on any tile to save it here.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GoldButton(
                      text: isGu ? 'ટાઈલ્સ જુઓ' : 'Explore Tiles',
                      onPressed: () => context.go('/categories'),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.70,
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
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: 'product_${item.id}',
                              child: ProductImage(
                                imageUrl: item.images.first,
                                borderRadius: 14,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(item.id),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  size: 16,
                                  color: AppColors.favoriteRed,
                                ).animate().scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1.0, 1.0),
                                      duration: 250.ms,
                                      curve: Curves.elasticOut,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.dynamicBody(
                        name,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.sizes.isNotEmpty ? item.sizes.first : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.showPrice && item.pricePerSqFt != null
                          ? '₹ ${item.pricePerSqFt!.toStringAsFixed(0)} / sqft'
                          : (isGu
                              ? AppConfig.inquiryPriceGujarati
                              : AppConfig.inquiryPriceEnglish),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
