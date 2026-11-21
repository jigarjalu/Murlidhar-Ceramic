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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authStateProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final popularAsync = ref.watch(popularProductsProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Black Header matching Reference UI Screen 4
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: const BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // App Logo
                        Image.asset(
                          AppConfig.logoPath,
                          width: 38,
                          height: 38,
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
                                fontSize: 17,
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
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const LanguageToggleButton(),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white, size: 22),
                          onPressed: () => context.push('/search'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Hero Banner matching Screen 4
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF242220), Color(0xFF141312)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppColors.goldStart.withAlpha(50),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGu
                                ? 'તમારા ઘરને આપો પ્રીમિયમ ટાઈલ્સનો ભવ્ય ટચ'
                                : 'Transform Your Space with Premium Tiles',
                            style: AppTypography.heading(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isGu
                                ? 'ગુજરાતનું ભરોસાપાત્ર સિરામિક અને ટાઈલ્સ કલેક્શન'
                                : 'Largest collection of vitrified, glazed & digital tiles',
                            style: AppTypography.dynamicBody(
                              'Largest collection of vitrified, glazed & digital tiles',
                              fontSize: 12,
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GoldButton(
                            text: isGu ? 'કલેક્શન જુઓ →' : 'Explore Collection →',
                            height: 42,
                            borderRadius: 21,
                            onPressed: () => context.go('/categories'),
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

            // Horizontal Categories List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: categoriesAsync.when(
                  data: (cats) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: cats.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                                  color: AppColors.goldStart.withAlpha(80),
                                  width: 1.5,
                                ),
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
                              width: 76,
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
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = products[index];
                      final name = item.localizedName(lang);
                      return GlassCard(
                        padding: const EdgeInsets.all(10),
                        borderRadius: 18,
                        onTap: () => context.push('/product-detail/${item.id}'),
                        child: Column(
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
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.sizes.isNotEmpty ? item.sizes.first : '',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish,
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
