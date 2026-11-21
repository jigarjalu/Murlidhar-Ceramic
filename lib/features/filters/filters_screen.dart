import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedSize = 'All';
  String _selectedFinish = 'All';

  final List<String> _sizes = ['All', '600x600', '800x800', '600x1200', '800x1600'];
  final List<String> _finishes = ['All', 'Glossy', 'Matt', 'High Gloss', 'Satin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Filters / ફિલ્ટર્સ'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GoldButton(
          text: 'Apply Filters',
          onPressed: () => Navigator.pop(context),
          width: double.infinity,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Size',
              style: AppTypography.dynamicBody('Size', fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _sizes.map((s) {
                final isSel = s == _selectedSize;
                return ChoiceChip(
                  label: Text(s),
                  selected: isSel,
                  onSelected: (_) => setState(() => _selectedSize = s),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Finish',
              style: AppTypography.dynamicBody('Finish', fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _finishes.map((f) {
                final isSel = f == _selectedFinish;
                return ChoiceChip(
                  label: Text(f),
                  selected: isSel,
                  onSelected: (_) => setState(() => _selectedFinish = f),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
