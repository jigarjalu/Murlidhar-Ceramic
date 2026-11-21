import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/product_image.dart';
import '../common/providers/language_provider.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _interiorImages = [
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
    'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?w=800&q=80',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800&q=80',
    'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
  ];

  final List<String> _bathroomImages = [
    'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800&q=80',
    'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=800&q=80',
  ];

  final List<String> _outdoorImages = [
    'https://images.unsplash.com/photo-1590381105924-c72589b9ef3f?w=800&q=80',
    'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'પ્રેરણા ગેલેરી' : 'Gallery',
          style: AppTypography.heading(fontSize: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldDark,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.goldStart,
          tabs: [
            Tab(text: isGu ? 'ઇન્ટીરીયર' : 'Interior'),
            Tab(text: isGu ? 'બાથરૂમ' : 'Bathroom'),
            Tab(text: isGu ? 'આઉટડોર' : 'Outdoor'),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMasonryGrid(_interiorImages),
          _buildMasonryGrid(_bathroomImages),
          _buildMasonryGrid(_outdoorImages),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid(List<String> images) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ProductImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
