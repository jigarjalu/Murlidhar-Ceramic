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
  int _selectedColorIndex = 0;

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
          return Scaffold(
            backgroundColor: AppColors.creamBackground,
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Text(
                isGu ? 'પ્રોડક્ટ મળી નથી' : 'Product Not Found',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.favoriteRed : AppColors.textPrimary,
                ),
                onPressed: () => ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(product.id),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
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
                top: BorderSide(color: AppColors.creamCardBorder, width: 1.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Add to Enquiry Button (Black Variant)
                Expanded(
                  child: GoldButton(
                    text: isGu ? 'પૂછપરછ લિસ્ટ' : 'Add to Enquiry',
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
                            textColor: AppColors.goldAccent,
                            onPressed: () => context.push('/enquiry'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Direct WhatsApp Enquiry Button (Gold Variant)
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Swipeable Gallery Carousel (Screen 7)
                SizedBox(
                  height: 330,
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
                      // Carousel Dots Indicator
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 14,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: _currentImageIndex == i ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == i
                                      ? AppColors.goldStart
                                      : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Details Card container
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: AppColors.creamCard,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        name,
                        style: AppTypography.heading(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
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
                      const SizedBox(height: 14),

                      // Price Tag (View-only policy: Best Price on Inquiry)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.goldStart.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.goldStart.withOpacity(0.4),
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

                      const SizedBox(height: 22),

                      // Available Sizes
                      Text(
                        isGu ? 'ઉપલબ્ધ સાઈઝ' : 'Available Sizes',
                        style: AppTypography.dynamicBody(
                          'Available Sizes',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.sizes.map((s) {
                          final isSel = s == _selectedSize;
                          return ChoiceChip(
                            label: Text(
                              s,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel ? AppColors.goldButtonText : AppColors.textPrimary,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: AppColors.goldStart,
                            backgroundColor: const Color(0xFFFBF6EE),
                            side: BorderSide(
                              color: isSel ? AppColors.goldStart : AppColors.creamCardBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (_) => setState(() => _selectedSize = s),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Finishes
                      Text(
                        isGu ? 'ફિનિશ પ્રકાર' : 'Surface Finish',
                        style: AppTypography.dynamicBody(
                          'Surface Finish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.finishes.map((f) {
                          final isSel = f == _selectedFinish;
                          return ChoiceChip(
                            label: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel ? AppColors.goldButtonText : AppColors.textPrimary,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: AppColors.goldStart,
                            backgroundColor: const Color(0xFFFBF6EE),
                            side: BorderSide(
                              color: isSel ? AppColors.goldStart : AppColors.creamCardBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (_) => setState(() => _selectedFinish = f),
                          );
                        }).toList(),
                      ),

                      // Color Swatches Viewer (Special for Colors/Decor category & multi-shade tiles)
                      if (product.colorHexes.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text(
                          isGu ? 'કલર શેડ્સ (Color Swatches)' : 'Color Shade Swatches',
                          style: AppTypography.dynamicBody(
                            'Color Shade Swatches',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: List.generate(product.colorHexes.length, (idx) {
                            final hex = product.colorHexes[idx];
                            final isSel = _selectedColorIndex == idx;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColorIndex = idx),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Color(hex),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSel ? AppColors.goldStart : Colors.black12,
                                    width: isSel ? 3.0 : 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSel
                                    ? const Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ],

                      const SizedBox(height: 22),

                      // Description Section
                      Text(
                        isGu ? 'વિશેષતા અને વર્ણન' : 'Description & Specifications',
                        style: AppTypography.dynamicBody(
                          'Description & Specifications',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: AppTypography.dynamicBody(
                          description,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.creamBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.creamBackground,
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
