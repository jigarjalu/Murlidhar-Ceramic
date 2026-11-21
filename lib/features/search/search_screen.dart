import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/product_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<ProductModel> _results = [];
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Vitrified Tiles',
    'Marble Look',
    'Parking Tiles',
    '600x1200',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final results = await ref.read(catalogRepositoryProvider).searchProducts(query);
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: isGu ? 'ટાઈલ્સ, સાઈઝ અથવા કેટેગરી શોધો...' : 'Search tiles, size or category...',
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: _searchController.text.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGu ? 'તાજેતરની શોધ / Recent Searches' : 'Recent Searches',
                    style: AppTypography.dynamicBody('Recent Searches', fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((s) {
                      return ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _searchController.text = s;
                          _onSearch(s);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty
                  ? Center(
                      child: Text(
                        isGu ? 'કોઈ પ્રોડક્ટ મળી નથી' : 'No products found',
                        style: AppTypography.dynamicBody('No results', fontSize: 14),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        final name = item.localizedName(lang);
                        return GlassCard(
                          padding: const EdgeInsets.all(10),
                          onTap: () => context.push('/product-detail/${item.id}'),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ProductImage(
                                  imageUrl: item.images.first,
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
                                      name,
                                      style: AppTypography.dynamicBody(name, fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish,
                                      style: const TextStyle(fontSize: 12, color: AppColors.goldDark, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
