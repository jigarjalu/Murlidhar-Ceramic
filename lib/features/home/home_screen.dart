import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/section_header.dart';
import '../../widgets/skeleton_loader.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _heroPageController;
  int _currentHeroPage = 0;
  Timer? _autoPlayTimer;

  final List<_HeroSlideData> _heroSlides = const [
    _HeroSlideData(
      titleEn: 'Transform Your Space\nwith Premium Tiles',
      titleGu: 'પ્રીમિયમ ટાઈલ્સ સાથે\nતમારા ઘરને આપો નવો લુક',
      subtitleEn: 'Exclusive collection of Glazed & Vitrified Tiles',
      subtitleGu: 'ગ્લેઝ અને વિટ્રીફાઈડ ટાઈલ્સનું ભવ્ય કલેક્શન',
      imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200',
    ),
    _HeroSlideData(
      titleEn: 'Luxury Living with\nItalian Marble Look',
      titleGu: 'ઈટાલિયન માર્બલ લુક\nસાથે લક્ઝુરિયસ લિવિંગ',
      subtitleEn: 'High gloss, stain-resistant & mirror shine',
      subtitleGu: 'હાઈ ગ્લોસ, સ્ટેન-રેઝિસ્ટન્ટ અને કાચ જેવી ચમક',
      imageUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1200',
    ),
    _HeroSlideData(
      titleEn: 'Modern Outdoor &\nParking Solutions',
      titleGu: 'આધુનિક પાર્કિંગ અને\nઆઉટડોર હેવી-ડ્યુટી ટાઈલ્સ',
      subtitleEn: 'Slip resistant, durable & all-weather proof',
      subtitleGu: 'સ્લિપ-રેઝિસ્ટન્ટ અને દરેક ઋતુ માટે મજબૂત',
      imageUrl: 'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1200',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final nextPage = (_currentHeroPage + 1) % _heroSlides.length;
      _heroPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _heroPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authStateProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final popularAsync = ref.watch(popularProductsProvider);
    final favs = ref.watch(favoritesProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Black Header matching Reference UI Screen 4
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                decoration: const BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    // Top App Bar row (Logo, Name, Greeting, Lang, Search)
                    Row(
                      children: [
                        // App Logo
                        Image.asset(
                          AppConfig.logoPath,
                          width: 42,
                          height: 42,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.diamond_outlined,
                            color: AppColors.goldStart,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConfig.appName,
                              style: AppTypography.heading(
                                fontSize: 18,
                                color: AppColors.darkTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              user != null
                                  ? (isGu ? 'નમસ્તે, ${user.name}' : 'Hello, ${user.name}')
                                  : (isGu ? 'નમસ્તે, ગ્રાહક મિત્ર' : 'Welcome to Murlidhar'),
                              style: AppTypography.dynamicBody(
                                user != null ? user.name : 'Welcome',
                                fontSize: 11,
                                color: AppColors.goldAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const LanguageToggleButton(),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white, size: 22),
                          onPressed: () => context.push('/search'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 22),
                          onPressed: () => context.push('/favorites'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
                          onPressed: () => context.push('/profile'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Auto-playing Ken-Burns Hero Carousel
                    SizedBox(
                      height: 190,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: PageView.builder(
                              controller: _heroPageController,
                              itemCount: _heroSlides.length,
                              onPageChanged: (index) {
                                setState(() => _currentHeroPage = index);
                              },
                              itemBuilder: (context, index) {
                                final slide = _heroSlides[index];
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Background image with subtle contrast
                                    ProductImage(
                                      imageUrl: slide.imageUrl,
                                      fit: BoxFit.cover,
                                      borderRadius: 0,
                                    ),
                                    // Dark gradient overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.85),
                                            Colors.black.withOpacity(0.40),
                                            Colors.black.withOpacity(0.80),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isGu ? slide.titleGu : slide.titleEn,
                                            style: AppTypography.heading(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            isGu ? slide.subtitleGu : slide.subtitleEn,
                                            style: AppTypography.dynamicBody(
                                              isGu ? slide.subtitleGu : slide.subtitleEn,
                                              fontSize: 11,
                                              color: const Color(0xFFD4C8B8),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          GoldButton(
                                            text: isGu ? 'કલેક્શન જુઓ →' : 'Explore Collection →',
                                            height: 36,
                                            borderRadius: 18,
                                            onPressed: () => context.go('/categories'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // Carousel page dots indicator
                          Positioned(
                            bottom: 12,
                            right: 18,
                            child: Row(
                              children: List.generate(
                                _heroSlides.length,
                                (idx) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: _currentHeroPage == idx ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: _currentHeroPage == idx
                                        ? AppColors.goldStart
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section Header
            SliverToBoxAdapter(
              child: SectionHeader(
                title: isGu ? 'કેટેગરીઝ' : 'Categories',
                actionLabel: isGu ? 'બધી જુઓ' : 'View All',
                onActionTap: () => context.go('/categories'),
              ),
            ),

            // Horizontal Categories List (Screen 4 row)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 114,
                child: categoriesAsync.when(
                  data: (cats) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: cats.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final cat = cats[index];
                      final catName = cat.localizedName(lang);
                      return GestureDetector(
                        onTap: () => context.push('/products', extra: cat),
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.goldStart.withAlpha(90),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: ProductImage(
                                  imageUrl: cat.imageUrl,
                                  borderRadius: 0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 80,
                              child: Text(
                                catName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.dynamicBody(
                                  catName,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, __) => const SkeletonLoader(width: 68, height: 68, borderRadius: 34),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ),

            // Popular Products Section Header
            SliverToBoxAdapter(
              child: SectionHeader(
                title: isGu ? 'લોકપ્રિય પ્રોડક્ટ્સ' : 'Popular Products',
                actionLabel: isGu ? 'બધી જુઓ' : 'View All',
                onActionTap: () => context.go('/categories'),
              ),
            ),

            // Popular Products Grid
            popularAsync.when(
              data: (products) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.70,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = products[index];
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
                                  // Heart Favorite button
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
                                        padding: const EdgeInsets.all(5),
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
                            // Price policy: Inquiry for best price (or show price if admin enabled)
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
                    childCount: products.length,
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SkeletonLoader(width: double.infinity, height: 180),
                ),
              ),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _HeroSlideData {
  final String titleEn;
  final String titleGu;
  final String subtitleEn;
  final String subtitleGu;
  final String imageUrl;

  const _HeroSlideData({
    required this.titleEn,
    required this.titleGu,
    required this.subtitleEn,
    required this.subtitleGu,
    required this.imageUrl,
  });
}
