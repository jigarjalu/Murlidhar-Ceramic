import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/language_provider.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  String _selectedSize = 'All';
  String _selectedFinish = 'All';
  String _selectedColor = 'All';

  final List<String> _sizes = const [
    'All',
    '600x600',
    '800x800',
    '600x1200',
    '800x1600',
    '1200x1200',
  ];

  final List<String> _finishes = const [
    'All',
    'Glossy',
    'Matt',
    'High Gloss',
    'Satin',
  ];

  final List<Map<String, dynamic>> _colorSwatches = const [
    {'name': 'All', 'hex': null},
    {'name': 'White', 'hex': 0xFFF7F7F5},
    {'name': 'Beige', 'hex': 0xFFD9C5A3},
    {'name': 'Grey', 'hex': 0xFF8E9196},
    {'name': 'Brown', 'hex': 0xFF8C6239},
    {'name': 'Black', 'hex': 0xFF1F1F1F},
  ];

  void _reset() {
    setState(() {
      _selectedSize = 'All';
      _selectedFinish = 'All';
      _selectedColor = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGu = ref.watch(languageProvider) == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'ફિલ્ટર્સ' : 'Filters',
          style: AppTypography.heading(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: _reset,
            child: Text(
              isGu ? 'રીસેટ' : 'Reset',
              style: const TextStyle(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GoldButton(
          text: isGu ? 'ફિલ્ટર્સ લાગુ કરો →' : 'Apply Filters →',
          onPressed: () {
            Navigator.pop(context, {
              'size': _selectedSize,
              'finish': _selectedFinish,
              'color': _selectedColor,
            });
          },
          width: double.infinity,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGu ? 'સાઈઝ (Size)' : 'Size',
              style: AppTypography.dynamicBody(
                'Size',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sizes.map((s) {
                final isSel = s == _selectedSize;
                return ChoiceChip(
                  label: Text(
                    s,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSel
                          ? AppColors.goldButtonText
                          : AppColors.textPrimary,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppColors.goldStart,
                  backgroundColor: AppColors.creamCard,
                  side: BorderSide(
                    color: isSel
                        ? AppColors.goldStart
                        : AppColors.creamCardBorder,
                  ),
                  onSelected: (_) => setState(() => _selectedSize = s),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              isGu ? 'ફિનિશ (Finish)' : 'Finish',
              style: AppTypography.dynamicBody(
                'Finish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _finishes.map((f) {
                final isSel = f == _selectedFinish;
                return ChoiceChip(
                  label: Text(
                    f,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSel
                          ? AppColors.goldButtonText
                          : AppColors.textPrimary,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppColors.goldStart,
                  backgroundColor: AppColors.creamCard,
                  side: BorderSide(
                    color: isSel
                        ? AppColors.goldStart
                        : AppColors.creamCardBorder,
                  ),
                  onSelected: (_) => setState(() => _selectedFinish = f),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              isGu ? 'રંગ (Color)' : 'Color',
              style: AppTypography.dynamicBody(
                'Color',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 12,
              children: _colorSwatches.map((swatch) {
                final name = swatch['name'] as String;
                final hex = swatch['hex'] as int?;
                final isSel = name == _selectedColor;

                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = name),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: hex != null ? Color(hex) : AppColors.creamCard,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSel
                                ? AppColors.goldStart
                                : AppColors.creamCardBorder,
                            width: isSel ? 3 : 1.2,
                          ),
                        ),
                        child: hex == null
                            ? Center(
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isSel
                                        ? AppColors.goldDark
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              )
                            : isSel
                                ? Icon(
                                    Icons.check,
                                    size: 18,
                                    color: name == 'White' || name == 'Beige'
                                        ? Colors.black
                                        : Colors.white,
                                  )
                                : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel
                              ? AppColors.goldDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
