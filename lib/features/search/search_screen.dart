import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String _prefRecentKey = 'mc_recent_searches';

  final _searchController = TextEditingController();
  List<ProductModel> _results = [];
  bool _isSearching = false;
  String? _errorMsg;

  List<String> _recentSearches = [];

  final List<String> _popularSearches = const [
    'Vitrified Tiles',
    'Statuario',
    'Parking Tiles',
    'Bath Accessories',
    '600x1200',
    'Glossy',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefRecentKey);
    if (mounted) {
      setState(() {
        _recentSearches = saved ?? ['Vitrified Tiles', 'Marble Look', '600x1200'];
      });
    }
  }

  Future<void> _saveRecentQuery(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;
    final updated = List<String>.from(_recentSearches);
    updated.removeWhere((e) => e.toLowerCase() == clean.toLowerCase());
    updated.insert(0, clean);
    if (updated.length > 8) {
      updated.removeRange(8, updated.length);
    }
    setState(() => _recentSearches = updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefRecentKey, updated);
  }

  Future<void> _clearRecent() async {
    setState(() => _recentSearches = []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefRecentKey);
  }

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
        _errorMsg = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMsg = null;
    });

    try {
      final results =
          await ref.read(catalogRepositoryProvider).searchProducts(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString();
          _isSearching = false;
        });
      }
    }
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
          textInputAction: TextInputAction.search,
          onSubmitted: (val) {
            _saveRecentQuery(val);
            _onSearch(val);
          },
          decoration: InputDecoration(
            hintText: isGu
                ? 'ટાઈલ્સ, સાઈઝ અથવા કેટેગરી શોધો...'
                : 'Search tiles, size or category...',
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
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recentSearches.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isGu ? 'તાજેતરની શોધ' : 'Recent Searches',
                          style: AppTypography.dynamicBody(
                            'Recent Searches',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: _clearRecent,
                          child: Text(
                            isGu ? 'સાફ કરો' : 'Clear',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.goldDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches.map((s) {
                        return ActionChip(
                          avatar: const Icon(
                            Icons.history_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          label: Text(s),
                          backgroundColor: AppColors.creamCard,
                          side: const BorderSide(color: AppColors.creamCardBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          onPressed: () {
                            _searchController.text = s;
                            _saveRecentQuery(s);
                            _onSearch(s);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    isGu ? 'લોકપ્રિય શોધ' : 'Popular Searches',
                    style: AppTypography.dynamicBody(
                      'Popular Searches',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _popularSearches.map((s) {
                      return ActionChip(
                        avatar: const Icon(
                          Icons.trending_up_rounded,
                          size: 16,
                          color: AppColors.goldDark,
                        ),
                        label: Text(s),
                        backgroundColor: AppColors.goldStart.withOpacity(0.12),
                        side: BorderSide(
                          color: AppColors.goldStart.withOpacity(0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onPressed: () {
                          _searchController.text = s;
                          _saveRecentQuery(s);
                          _onSearch(s);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : _isSearching
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
                  ),
                )
              : _errorMsg != null
                  ? Center(
                      child: Text(
                        isGu ? 'શોધવામાં ક્ષતિ આવી' : 'Search failed: $_errorMsg',
                        style: const TextStyle(color: AppColors.errorRed),
                      ),
                    )
                  : _results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 56,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isGu
                                    ? 'કોઈ પ્રોડક્ટ મળી નથી'
                                    : 'No matching products found',
                                style: AppTypography.dynamicBody(
                                  'No results',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                              onTap: () {
                                _saveRecentQuery(_searchController.text);
                                context.push('/product-detail/${item.id}');
                              },
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
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.dynamicBody(
                                            name,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.sizes.isNotEmpty ? item.sizes.first : '',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isGu
                                              ? AppConfig.inquiryPriceGujarati
                                              : AppConfig.inquiryPriceEnglish,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.goldDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
    );
  }
}
