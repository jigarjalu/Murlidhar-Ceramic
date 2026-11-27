import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/product_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  void _showProductFormDialog(
    BuildContext context,
    WidgetRef ref, {
    ProductModel? existing,
  }) {
    final guNameController =
        TextEditingController(text: existing?.nameGujarati ?? '');
    final enNameController =
        TextEditingController(text: existing?.nameEnglish ?? '');
    final categoryController =
        TextEditingController(text: existing?.categoryId ?? 'cat_vitrified');
    final sizeController =
        TextEditingController(text: existing?.sizes.join(', ') ?? '600x1200, 800x800');
    final finishController =
        TextEditingController(text: existing?.finishes.join(', ') ?? 'High Gloss, Matt');
    final colorController =
        TextEditingController(text: existing?.colors.join(', ') ?? 'White, Beige');
    final imageController = TextEditingController(
      text: existing?.images.firstOrNull ??
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&q=80',
    );
    bool showPrice = existing?.showPrice ?? false;
    final priceController = TextEditingController(
      text: existing?.pricePerSqFt != null
          ? existing!.pricePerSqFt!.toStringAsFixed(0)
          : '',
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.creamCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existing == null ? '+ Add Product' : 'Edit Product',
            style: AppTypography.heading(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: guNameController,
                  decoration: const InputDecoration(
                    labelText: 'ગુજરાતી નામ (Gujarati Name)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: enNameController,
                  decoration: const InputDecoration(labelText: 'English Name'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: AppConfig.categories.any(
                          (c) => c['id'] == categoryController.text)
                      ? categoryController.text
                      : AppConfig.categories.first['id'],
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: AppConfig.categories.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['id'],
                      child: Text('${c['gu']} (${c['en']})',
                          style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => categoryController.text = val);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Sizes (comma separated: 600x600, 800x800)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: finishController,
                  decoration: const InputDecoration(
                    labelText: 'Finishes (comma separated: Glossy, Matt)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(
                    labelText: 'Colors (comma separated: White, Grey)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show Price to Customers'),
                  subtitle: const Text(
                    'When disabled, customers see "Inquiry for best price"',
                    style: TextStyle(fontSize: 11),
                  ),
                  value: showPrice,
                  activeColor: AppColors.goldStart,
                  onChanged: (v) => setDialogState(() => showPrice = v ?? false),
                ),
                if (showPrice)
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price per Sq Ft (₹)',
                      prefixText: '₹ ',
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldStart,
                foregroundColor: AppColors.goldButtonText,
              ),
              onPressed: () async {
                final product = ProductModel(
                  id: existing?.id ??
                      'prod_custom_${DateTime.now().millisecondsSinceEpoch}',
                  categoryId: categoryController.text.trim(),
                  nameGujarati: guNameController.text.trim().isEmpty
                      ? 'નવી ટાઈલ'
                      : guNameController.text.trim(),
                  nameEnglish: enNameController.text.trim().isEmpty
                      ? 'New Tile'
                      : enNameController.text.trim(),
                  sizes: sizeController.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList(),
                  finishes: finishController.text
                      .split(',')
                      .map((f) => f.trim())
                      .where((f) => f.isNotEmpty)
                      .toList(),
                  colors: colorController.text
                      .split(',')
                      .map((c) => c.trim())
                      .where((c) => c.isNotEmpty)
                      .toList(),
                  images: [
                    imageController.text.trim().isNotEmpty
                        ? imageController.text.trim()
                        : 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&q=80'
                  ],
                  descriptionGujarati: 'પ્રીમિયમ ટાઈલ્સ અને સિરામિક સોલ્યુશન',
                  descriptionEnglish:
                      'Premium quality tiles with unmatched finish.',
                  showPrice: showPrice,
                  pricePerSqFt: double.tryParse(priceController.text.trim()),
                );

                if (existing == null) {
                  await ref
                      .read(catalogRepositoryProvider)
                      .addProduct(product);
                } else {
                  await ref
                      .read(catalogRepositoryProvider)
                      .updateProduct(product);
                }
                ref.invalidate(allProductsProvider);
                ref.invalidate(popularProductsProvider);

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(existing == null
                          ? 'Product added successfully!'
                          : 'Product updated successfully!'),
                    ),
                  );
                }
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ProductModel product) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamCard,
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.nameEnglish}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            onPressed: () async {
              await ref
                  .read(catalogRepositoryProvider)
                  .deleteProduct(product.id);
              ref.invalidate(allProductsProvider);
              ref.invalidate(popularProductsProvider);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: '+ Add Product',
            onPressed: () => _showProductFormDialog(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.goldStart,
        foregroundColor: AppColors.goldButtonText,
        icon: const Icon(Icons.add),
        label: const Text('+ Add Product'),
        onPressed: () => _showProductFormDialog(context, ref),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = products[index];

              return GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ProductImage(
                        imageUrl: item.images.first,
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nameEnglish,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.nameGujarati,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                item.showPrice && item.pricePerSqFt != null
                                    ? '₹ ${item.pricePerSqFt!.toStringAsFixed(0)} / sqft'
                                    : 'Price Hidden (Inquiry)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: item.showPrice
                                      ? AppColors.goldDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showProductFormDialog(
                        context,
                        ref,
                        existing: item,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.errorRed,
                        size: 20,
                      ),
                      onPressed: () => _confirmDelete(context, ref, item),
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
