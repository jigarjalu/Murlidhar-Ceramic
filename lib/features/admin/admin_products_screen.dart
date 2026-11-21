import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/product_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  void _showAddProductDialog(BuildContext context, WidgetRef ref) {
    final guNameController = TextEditingController();
    final enNameController = TextEditingController();
    final sizeController = TextEditingController(text: '600x1200');
    final finishController = TextEditingController(text: 'High Gloss');
    bool showPrice = false;
    final priceController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: guNameController,
                  decoration: const InputDecoration(labelText: 'ગુજરાતી નામ / Gujarati Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: enNameController,
                  decoration: const InputDecoration(labelText: 'English Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(labelText: 'Sizes (e.g. 600x1200, 800x800)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: finishController,
                  decoration: const InputDecoration(labelText: 'Finish (e.g. Glossy, Matt)'),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show Price to Customers'),
                  value: showPrice,
                  onChanged: (v) => setDialogState(() => showPrice = v ?? false),
                ),
                if (showPrice)
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price per Sq Ft (₹)'),
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
              onPressed: () async {
                final newProduct = ProductModel(
                  id: 'prod_custom_${DateTime.now().millisecondsSinceEpoch}',
                  categoryId: 'cat_vitrified',
                  nameGujarati: guNameController.text.trim().isEmpty ? 'નવી ટાઈલ' : guNameController.text.trim(),
                  nameEnglish: enNameController.text.trim().isEmpty ? 'New Tile' : enNameController.text.trim(),
                  sizes: sizeController.text.split(',').map((s) => s.trim()).toList(),
                  finishes: finishController.text.split(',').map((f) => f.trim()).toList(),
                  colors: ['White'],
                  images: ['https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&q=80'],
                  descriptionGujarati: 'પ્રીમિયમ ટાઈલ્સ',
                  descriptionEnglish: 'Premium quality ceramic tiles',
                  showPrice: showPrice,
                  pricePerSqFt: double.tryParse(priceController.text.trim()),
                );
                await ref.read(catalogRepositoryProvider).addProduct(newProduct);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product added successfully!')),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(popularProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GoldButton(
          text: '+ Add Product / નવી પ્રોડક્ટ ઉમેરો',
          icon: Icons.add,
          onPressed: () => _showAddProductDialog(context, ref),
          width: double.infinity,
        ),
      ),
      body: productsAsync.when(
        data: (products) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = products[index];
            return GlassCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ProductImage(
                      imageUrl: p.images.first,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${p.nameEnglish} / ${p.nameGujarati}',
                          style: AppTypography.dynamicBody(p.nameEnglish, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sizes: ${p.sizes.join(", ")}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.showPrice && p.pricePerSqFt != null
                              ? '₹ ${p.pricePerSqFt}/sq ft (Visible)'
                              : AppConfig.inquiryPriceEnglish,
                          style: const TextStyle(fontSize: 11, color: AppColors.goldDark, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 20),
                    onPressed: () async {
                      await ref.read(catalogRepositoryProvider).deleteProduct(p.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product deleted')),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
