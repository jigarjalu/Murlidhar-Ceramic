import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/category_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/product_image.dart';
import '../../widgets/skeleton_loader.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const ProductListScreen({super.key, this.category});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _selectedSize = 'All';

  final List<String> _sizes = [
    'All',
    '600x600',
    '800x800',
    '600x1200',
    '800x1600',
  ];

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final favs = ref.watch(favoritesProvider);
    final isGu = lang == 'gu';

    final categoryId = widget.category?.id ?? 'cat_vitrified';
    final title = widget.category?.localizedName(lang) ??
        (isGu ? 'વિટ્રીફાઈડ ટાઈલ્સ' : 'Vitrified Tiles');

    final productsAsync = ref.watch(productsByCategoryProvider(categoryId));

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(title, style: AppTypography.heading(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push('/filters'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Size Filter Chips Row
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: _sizes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final s = _sizes[index];
                final isSelected = s == _selectedSize;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.goldStart : AppColors.creamCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.goldStart : AppColors.creamCardBorder,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.goldButtonText : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Product Grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = _selectedSize == 'All'
                    ? products
                    : products.where((p) => p.sizes.contains(_selectedSize)).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      isGu ? 'આ સાઈઝમાં કોઈ પ્રોડક્ટ મળી નથી' : 'No products found in this size',
                      style: AppTypography.dynamicBody('No products found', fontSize: 14),
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
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final name = item.localizedName(lang);
                    final isFav = favs.contains(item.id);

                    return GlassCard(
                      padding: const EdgeInsets.all(10),
                      borderRadius: 18,
                      onTap: () => context.push('/product-detail/${item.id}'),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Hero(
                                  tag: 'product_${item.id}',
                                  child: ProductImage(
                                    imageUrl: item.images.first,
                                    borderRadius: 14,
                                    width: double.infinity,
                                  ),
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
                                isGu
                                    ? AppConfig.inquiryPriceGujarati
                                    : AppConfig.inquiryPriceEnglish,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.dynamicBody(
                                  isGu
                                      ? AppConfig.inquiryPriceGujarati
                                      : AppConfig.inquiryPriceEnglish,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.goldDark,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(item.id),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(220),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? AppColors.favoriteRed : AppColors.textSecondary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: 6,
                itemBuilder: (_, __) => const SkeletonLoader(width: 140, height: 180),
              ),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
