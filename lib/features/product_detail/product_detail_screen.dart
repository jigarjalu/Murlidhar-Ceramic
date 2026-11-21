import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../data/models/enquiry_model.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String _selectedSize = '';
  String _selectedFinish = '';

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authStateProvider);
    final favs = ref.watch(favoritesProvider);
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final isGu = lang == 'gu';

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Product Not Found')),
          );
        }

        if (_selectedSize.isEmpty && product.sizes.isNotEmpty) {
          _selectedSize = product.sizes.first;
        }
        if (_selectedFinish.isEmpty && product.finishes.isNotEmpty) {
          _selectedFinish = product.finishes.first;
        }

        final isFav = favs.contains(product.id);
        final name = product.localizedName(lang);
        final description = product.localizedDescription(lang);

        return Scaffold(
          backgroundColor: AppColors.creamBackground,
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.favoriteRed : AppColors.textPrimary,
                ),
                onPressed: () => ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(product.id),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  WhatsAppHelper.launchWhatsApp(
                    context: context,
                    message: WhatsAppHelper.buildSingleItemMessage(
                      userName: user?.name ?? 'Customer',
                      itemName: '${product.nameGujarati} (${product.nameEnglish})',
                      category: product.categoryId,
                      size: _selectedSize,
                      finish: _selectedFinish,
                    ),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: AppColors.creamCard,
              border: const Border(
                top: BorderSide(color: AppColors.creamCardBorder, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Add to Enquiry Button
                Expanded(
                  child: GoldButton(
                    text: isGu ? 'પૂછપરછ લિસ્ટમાં ઉમેરો' : 'Add to Enquiry',
                    variant: GoldButtonVariant.black,
                    icon: Icons.playlist_add_rounded,
                    height: 48,
                    onPressed: () {
                      final item = EnquiryItem(
                        productId: product.id,
                        productNameGujarati: product.nameGujarati,
                        productNameEnglish: product.nameEnglish,
                        categoryName: product.categoryId,
                        selectedSize: _selectedSize,
                        selectedFinish: _selectedFinish,
                        imageUrl: product.images.first,
                        showPrice: product.showPrice,
                        pricePerSqFt: product.pricePerSqFt,
                      );
                      ref.read(enquiryCartProvider.notifier).addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isGu
                                ? 'પૂછપરછ લિસ્ટમાં ઉમેરાઈ ગયું!'
                                : 'Added to Enquiry List!',
                          ),
                          action: SnackBarAction(
                            label: isGu ? 'જુઓ' : 'View',
                            onPressed: () => context.push('/enquiry'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Direct WhatsApp Enquiry Button
                Expanded(
                  child: GoldButton(
                    text: 'WhatsApp Enquiry',
                    variant: GoldButtonVariant.gold,
                    icon: Icons.chat_outlined,
                    height: 48,
                    onPressed: () {
                      WhatsAppHelper.launchWhatsApp(
                        context: context,
                        message: WhatsAppHelper.buildSingleItemMessage(
                          userName: user?.name ?? 'Customer',
                          itemName: '${product.nameGujarati} (${product.nameEnglish})',
                          category: product.categoryId,
                          size: _selectedSize,
                          finish: _selectedFinish,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gallery Carousel
                SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (i) => setState(() => _currentImageIndex = i),
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: index == 0 ? 'product_${product.id}' : 'img_${product.id}_$index',
                            child: ProductImage(
                              imageUrl: product.images[index],
                              borderRadius: 0,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      // Dots Indicator
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: _currentImageIndex == i ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == i
                                      ? AppColors.goldStart
                                      : Colors.white.withAlpha(150),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        name,
                        style: AppTypography.heading(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isGu ? product.nameEnglish : product.nameGujarati,
                        style: AppTypography.dynamicBody(
                          isGu ? product.nameEnglish : product.nameGujarati,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price Tag (View-only / Best price inquiry)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.goldStart.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.goldStart.withAlpha(100),
                          ),
                        ),
                        child: Text(
                          product.showPrice && product.pricePerSqFt != null
                              ? '₹ ${product.pricePerSqFt!.toStringAsFixed(0)} / sq ft'
                              : (isGu
                                  ? AppConfig.inquiryPriceGujarati
                                  : AppConfig.inquiryPriceEnglish),
                          style: AppTypography.dynamicBody(
                            'Price Text',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sizes
                      Text(
                        isGu ? 'ઉપલબ્ધ સાઈઝ / Available Sizes' : 'Available Sizes',
                        style: AppTypography.dynamicBody(
                          'Available Sizes',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.sizes.map((s) {
                          final isSel = s == _selectedSize;
                          return ChoiceChip(
                            label: Text(s),
                            selected: isSel,
                            onSelected: (_) => setState(() => _selectedSize = s),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Finishes
                      Text(
                        isGu ? 'ફિનિશ / Finishes' : 'Finishes',
                        style: AppTypography.dynamicBody(
                          'Finishes',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.finishes.map((f) {
                          final isSel = f == _selectedFinish;
                          return ChoiceChip(
                            label: Text(f),
                            selected: isSel,
                            onSelected: (_) => setState(() => _selectedFinish = f),
                          );
                        }).toList(),
                      ),

                      if (product.colorHexes.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text(
                          isGu ? 'રંગો / Colors' : 'Color Shades',
                          style: AppTypography.dynamicBody(
                            'Color Shades',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: product.colorHexes.map((hex) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(hex),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Description
                      Text(
                        isGu ? 'વર્ણન / Description' : 'Description',
                        style: AppTypography.dynamicBody(
                          'Description',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: AppTypography.dynamicBody(
                          description,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
