import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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

class _GalleryScreenState extends ConsumerState<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_GalleryItem> _interiorImages = const [
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
      titleEn: 'Luxury Living Room Marble',
      titleGu: 'લક્ઝરી લિવિંગ રૂમ માર્બલ',
      aspectRatio: 0.78,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?w=800&q=80',
      titleEn: 'Modern Dining Glossy Floor',
      titleGu: 'મોડર્ન ડાઇનિંગ ગ્લોસી ફ્લોર',
      aspectRatio: 1.05,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800&q=80',
      titleEn: 'Minimalist Vitrified Lounge',
      titleGu: 'મિનિમલિસ્ટ વિટ્રીફાઈડ લાઉન્જ',
      aspectRatio: 0.82,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
      titleEn: 'Warm Wood Plank Interior',
      titleGu: 'વુડન પ્લેન્ક ઇન્ટીરીયર',
      aspectRatio: 0.75,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=800&q=80',
      titleEn: 'Designer Feature Wall',
      titleGu: 'ડિઝાઇનર ફીચર વોલ',
      aspectRatio: 1.0,
    ),
  ];

  final List<_GalleryItem> _bathroomImages = const [
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800&q=80',
      titleEn: 'Spa Statuario Bath Suite',
      titleGu: 'સ્પા સ્ટેચ્યુઆરીયો બાથ સ્યુટ',
      aspectRatio: 0.8,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=800&q=80',
      titleEn: 'Matt Stone Vanity Wall',
      titleGu: 'મેટ સ્ટોન વેનિટી વોલ',
      aspectRatio: 1.1,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800&q=80',
      titleEn: 'Digital Ceramic Shower',
      titleGu: 'ડિજીટલ સિરામિક શાવર',
      aspectRatio: 0.78,
    ),
  ];

  final List<_GalleryItem> _outdoorImages = const [
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1590381105924-c72589b9ef3f?w=800&q=80',
      titleEn: 'Heavy Duty Parking Courtyard',
      titleGu: 'હેવી ડ્યુટી પાર્કિંગ કોર્ટયાર્ડ',
      aspectRatio: 0.85,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      titleEn: 'Natural Stone Elevation',
      titleGu: 'નેચરલ સ્ટોન એલિવેશન',
      aspectRatio: 1.05,
    ),
    _GalleryItem(
      url: 'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=800&q=80',
      titleEn: 'Terrace Anti-Skid Deck',
      titleGu: 'ટેરેસ એન્ટી-સ્કિડ ડેક',
      aspectRatio: 0.8,
    ),
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

  void _openPinchZoomViewer(
    BuildContext context,
    List<_GalleryItem> items,
    int initialIndex,
    bool isGu,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _GalleryZoomViewer(
          items: items,
          initialIndex: initialIndex,
          isGu: isGu,
        ),
      ),
    );
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
          _buildMasonryGrid(_interiorImages, isGu),
          _buildMasonryGrid(_bathroomImages, isGu),
          _buildMasonryGrid(_outdoorImages, isGu),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid(List<_GalleryItem> items, bool isGu) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          isGu ? 'કોઈ ફોટા ઉપલબ્ધ નથી' : 'No gallery images available',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _openPinchZoomViewer(context, items, index, isGu),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: item.aspectRatio,
                  child: Hero(
                    tag: 'gallery_${item.url}',
                    child: ProductImage(
                      imageUrl: item.url,
                      fit: BoxFit.cover,
                      borderRadius: 0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.72),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            isGu ? item.titleGu : item.titleEn,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.zoom_in_rounded,
                          size: 16,
                          color: AppColors.goldAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GalleryItem {
  final String url;
  final String titleEn;
  final String titleGu;
  final double aspectRatio;

  const _GalleryItem({
    required this.url,
    required this.titleEn,
    required this.titleGu,
    required this.aspectRatio,
  });
}

class _GalleryZoomViewer extends StatefulWidget {
  final List<_GalleryItem> items;
  final int initialIndex;
  final bool isGu;

  const _GalleryZoomViewer({
    required this.items,
    required this.initialIndex,
    required this.isGu,
  });

  @override
  State<_GalleryZoomViewer> createState() => _GalleryZoomViewerState();
}

class _GalleryZoomViewerState extends State<_GalleryZoomViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.isGu ? currentItem.titleGu : currentItem.titleEn,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1} / ${widget.items.length}',
                style: const TextStyle(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (idx) => setState(() => _currentIndex = idx),
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: AppColors.darkBackground,
        ),
        builder: (context, index) {
          final item = widget.items[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(item.url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            heroAttributes: PhotoViewHeroAttributes(tag: 'gallery_${item.url}'),
          );
        },
        loadingBuilder: (_, __) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
          ),
        ),
      ),
    );
  }
}
