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
  String _selectedSort = 'default'; // 'default', 'nameAsc', 'nameDesc'

  final List<String> _sizes = [
    'All',
    '600x600',
    '800x800',
    '600x1200',
    '800x1600',
    '1200x1200',
    '1200x1800',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: AppTypography.heading(
            fontSize: 18,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textPrimary),
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Size Filter Chips Row (matching reference Screen 6)
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _sizes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final s = _sizes[index];
                final isSelected = s == _selectedSize;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.goldStart : AppColors.creamCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.goldStart : AppColors.creamCardBorder,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.goldStart.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
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
                // Filter by size
                var filtered = _selectedSize == 'All'
                    ? products
                    : products.where((p) => p.sizes.contains(_selectedSize)).toList();

                // Sort logic
                if (_selectedSort == 'nameAsc') {
                  filtered.sort((a, b) => a.localizedName(lang).compareTo(b.localizedName(lang)));
                } else if (_selectedSort == 'nameDesc') {
                  filtered.sort((a, b) => b.localizedName(lang).compareTo(a.localizedName(lang)));
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isGu
                              ? 'આ સાઈઝમાં કોઈ પ્રોડક્ટ્સ મળ્યા નથી'
                              : 'No products available for this size',
                          style: AppTypography.dynamicBody(
                            isGu
                                ? 'આ સાઈઝમાં કોઈ પ્રોડક્ટ્સ મળ્યા નથી'
                                : 'No products available for this size',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 70),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.70,
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
                                // Favorite Heart icon button
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(favoritesProvider.notifier)
                                          .toggleFavorite(item.id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                        size: 16,
                                        color: isFav ? AppColors.favoriteRed : AppColors.textPrimary,
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
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.sizes.isNotEmpty ? item.sizes.first : '',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          // Price policy: Inquiry for best price (or price if admin allowed)
                          Text(
                            item.showPrice && item.pricePerSqFt != null
                                ? '₹ ${item.pricePerSqFt!.toStringAsFixed(0)} / sqft'
                                : (isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.dynamicBody(
                              isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldDark,
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
                  childAspectRatio: 0.70,
                ),
                itemCount: 6,
                itemBuilder: (_, __) => const SkeletonLoader(width: double.infinity, height: 200, borderRadius: 18),
              ),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      // Sticky Filter / Sort Bar at Bottom (Screen 6)
      bottomSheet: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.creamCard,
          border: const Border(
            top: BorderSide(color: AppColors.creamCardBorder),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => context.push('/filters'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.filter_list_rounded, size: 18, color: AppColors.textPrimary),
                    const SizedBox(width: 8),
                    Text(
                      isGu ? 'ફિલ્ટર' : 'Filter',
                      style: AppTypography.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, height: 24, color: AppColors.creamCardBorder),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSortBottomSheet(context, isGu);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sort_rounded, size: 18, color: AppColors.textPrimary),
                    const SizedBox(width: 8),
                    Text(
                      isGu ? 'સૉર્ટ' : 'Sort',
                      style: AppTypography.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, bool isGu) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.creamCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isGu ? 'ક્રમ પસંદ કરો' : 'Sort Products By',
                style: AppTypography.heading(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(isGu ? 'સામાન્ય (Default)' : 'Default'),
                trailing: _selectedSort == 'default' ? const Icon(Icons.check, color: AppColors.goldDark) : null,
                onTap: () {
                  setState(() => _selectedSort = 'default');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(isGu ? 'નામ: A થી Z' : 'Name: A to Z'),
                trailing: _selectedSort == 'nameAsc' ? const Icon(Icons.check, color: AppColors.goldDark) : null,
                onTap: () {
                  setState(() => _selectedSort = 'nameAsc');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(isGu ? 'નામ: Z થી A' : 'Name: Z to A'),
                trailing: _selectedSort == 'nameDesc' ? const Icon(Icons.check, color: AppColors.goldDark) : null,
                onTap: () {
                  setState(() => _selectedSort = 'nameDesc');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
