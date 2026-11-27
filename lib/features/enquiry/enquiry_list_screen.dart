import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../data/models/enquiry_model.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/product_image.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class EnquiryListScreen extends ConsumerStatefulWidget {
  const EnquiryListScreen({super.key});

  @override
  ConsumerState<EnquiryListScreen> createState() => _EnquiryListScreenState();
}

class _EnquiryListScreenState extends ConsumerState<EnquiryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _generalNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _generalNoteController.dispose();
    super.dispose();
  }

  Future<void> _sendItemsEnquiry(List<EnquiryItem> items, bool isGu) async {
    final user = ref.read(authStateProvider);
    final userName = user?.name ?? 'Customer';
    final message = WhatsAppHelper.buildMultiItemMessage(
      userName: userName,
      items: items,
    );

    // Save to sent enquiries ("My Enquiries")
    final enquiry = EnquiryModel(
      id: 'enq_${DateTime.now().millisecondsSinceEpoch}',
      customerName: userName,
      customerPhone: user?.phone ?? '',
      items: items,
      status: EnquiryStatus.pending,
      createdAt: DateTime.now(),
    );
    await ref.read(enquiryRepositoryProvider).recordSentEnquiry(enquiry);
    ref.invalidate(myEnquiriesProvider);

    if (mounted) {
      await WhatsAppHelper.launchWhatsApp(context: context, message: message);
    }
  }

  Future<void> _sendGeneralEnquiry(bool isGu) async {
    final note = _generalNoteController.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isGu
                ? 'કૃપા કરીને તમારી પૂછપરછ લખો'
                : 'Please write your inquiry details',
          ),
        ),
      );
      return;
    }

    final user = ref.read(authStateProvider);
    final userName = user?.name ?? 'Customer';
    final message = WhatsAppHelper.buildGeneralInquiryMessage(
      userName: userName,
      inquiryDetails: note,
    );

    final enquiry = EnquiryModel(
      id: 'enq_gen_${DateTime.now().millisecondsSinceEpoch}',
      customerName: userName,
      customerPhone: user?.phone ?? '',
      items: const [],
      generalMessage: note,
      status: EnquiryStatus.pending,
      createdAt: DateTime.now(),
      isGeneralInquiry: true,
    );
    await ref.read(enquiryRepositoryProvider).recordSentEnquiry(enquiry);
    ref.invalidate(myEnquiriesProvider);

    if (mounted) {
      _generalNoteController.clear();
      await WhatsAppHelper.launchWhatsApp(context: context, message: message);
    }
  }

  Future<void> _editItemNote(EnquiryItem item, bool isGu) async {
    final controller = TextEditingController(text: item.note ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isGu ? 'નોંધ ઉમેરો / સુધારો' : 'Add / Edit Note',
          style: AppTypography.heading(fontSize: 18),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            hintText: isGu
                ? 'દા.ત. લિવિંગ રૂમ માટે ૮૦૦ ચો.ફૂટ...'
                : 'e.g. Need ~800 sq.ft for living room...',
            filled: true,
            fillColor: AppColors.creamBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.creamCardBorder),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isGu ? 'રદ કરો' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldStart,
              foregroundColor: AppColors.goldButtonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(isGu ? 'સેવ કરો' : 'Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result != null) {
      await ref.read(enquiryCartProvider.notifier).updateItemNote(
            item.productId,
            item.selectedSize,
            item.selectedFinish,
            result,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final enquiryItems = ref.watch(enquiryCartProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'પૂછપરછ લિસ્ટ' : 'Enquiry List',
          style: AppTypography.heading(fontSize: 20),
        ),
        actions: [
          IconButton(
            tooltip: isGu ? 'મારી પૂછપરછો' : 'My Enquiries',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push('/my-enquiries'),
          ),
          if (enquiryItems.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(enquiryCartProvider.notifier).clearCart(),
              child: Text(
                isGu ? 'બધું સાફ કરો' : 'Clear All',
                style: const TextStyle(
                  color: AppColors.errorRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldDark,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.goldStart,
          tabs: [
            Tab(
              text: isGu
                  ? 'પસંદ કરેલ (${enquiryItems.length})'
                  : 'Enquiry List (${enquiryItems.length})',
            ),
            Tab(text: isGu ? 'સામાન્ય પૂછપરછ' : 'General Inquiry'),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Selected Items Enquiry List
          enquiryItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.playlist_add_check_circle_outlined,
                          size: 68,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isGu
                              ? 'તમારું પૂછપરછ લિસ્ટ ખાલી છે'
                              : 'Your Enquiry List is Empty',
                          style: AppTypography.dynamicBody(
                            'Empty enquiry list',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isGu
                              ? 'પ્રોડક્ટ્સમાંથી "Add to Enquiry" દબાવો અથવા સામાન્ય પૂછપરછ મોકલો'
                              : 'Tap "Add to Enquiry" on any tile or send a General Inquiry.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GoldButton(
                          text: isGu ? 'ટાઈલ્સ જુઓ' : 'Browse Products',
                          icon: Icons.grid_view_rounded,
                          onPressed: () => context.go('/categories'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: enquiryItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = enquiryItems[index];
                          final name = item.localizedProductName(lang);
                          final hasNote =
                              item.note != null && item.note!.trim().isNotEmpty;

                          return GlassCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ProductImage(
                                        imageUrl: item.imageUrl,
                                        width: 72,
                                        height: 72,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.dynamicBody(
                                              name,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${item.selectedSize} • ${item.selectedFinish}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.showPrice &&
                                                    item.pricePerSqFt != null
                                                ? '₹ ${item.pricePerSqFt!.toStringAsFixed(0)} / sqft'
                                                : (isGu
                                                    ? AppConfig
                                                        .inquiryPriceGujarati
                                                    : AppConfig
                                                        .inquiryPriceEnglish),
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              color: AppColors.goldDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: isGu ? 'દૂર કરો' : 'Remove',
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.errorRed,
                                        size: 20,
                                      ),
                                      onPressed: () => ref
                                          .read(enquiryCartProvider.notifier)
                                          .removeItem(
                                            item.productId,
                                            item.selectedSize,
                                            item.selectedFinish,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => _editItemNote(item, isGu),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.creamBackground,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.creamCardBorder,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          hasNote
                                              ? Icons.sticky_note_2_outlined
                                              : Icons.add_comment_outlined,
                                          size: 16,
                                          color: AppColors.goldDark,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            hasNote
                                                ? item.note!
                                                : (isGu
                                                    ? 'વૈકલ્પિક નોંધ ઉમેરો (માપ / જગ્યા)...'
                                                    : 'Add optional note (area / qty)...'),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: hasNote
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.edit_outlined,
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Summary + Send Enquiry Footer (No sales/price totals)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: const BoxDecoration(
                        color: AppColors.creamCard,
                        border: Border(
                          top: BorderSide(color: AppColors.creamCardBorder),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isGu
                                    ? 'કુલ આઇટમ્સ (${enquiryItems.length})'
                                    : 'Total Items (${enquiryItems.length})',
                                style: AppTypography.dynamicBody(
                                  'Total Items',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                isGu
                                    ? 'શ્રેષ્ઠ ભાવ માટે પૂછપરછ'
                                    : 'Best price on enquiry',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.goldDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GoldButton(
                            text: isGu ? 'પૂછપરછ મોકલો' : 'Send Enquiry',
                            icon: Icons.chat_rounded,
                            onPressed: () =>
                                _sendItemsEnquiry(enquiryItems, isGu),
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

          // Tab 2: General Inquiry
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGu
                      ? 'સામાન્ય પૂછપરછ / ખાસ જરૂરિયાત'
                      : 'General Inquiry / Requirement',
                  style: AppTypography.dynamicBody(
                    'Inquiry',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isGu
                      ? 'ઘર, ઓફિસ કે પ્રોજેક્ટ માટે ટાઈલ્સ, બાથ એસેસરીઝ કે કેમિકલ્સ વિશે પૂછો.'
                      : 'Ask about tiles, bath accessories, chemicals, or bulk project quotes.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickPromptChip(
                      label: isGu ? 'હોલસેલ / બલ્ક ભાવ' : 'Bulk / Project Quote',
                      onTap: () => _generalNoteController.text = isGu
                          ? 'મારે નવા મકાન માટે બલ્ક ટાઈલ્સના ભાવ અને કેટલોગ જોઈએ છે.'
                          : 'I need bulk quotation and catalog for a new building project.',
                    ),
                    _QuickPromptChip(
                      label: isGu ? 'શોરૂમ વિઝિટ' : 'Showroom Visit',
                      onTap: () => _generalNoteController.text = isGu
                          ? 'હું તમારા માનવદર શોરૂમની મુલાકાત લેવા માંગુ છું.'
                          : 'I would like to schedule a visit to your Manavadar showroom.',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _generalNoteController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: isGu
                        ? 'તમારી જરૂરિયાત, ટાઈલ્સના કદ અથવા મકાનના માપ વિશે અહીં લખો...'
                        : 'Describe your tiles requirement, room size, or any query...',
                    filled: true,
                    fillColor: AppColors.creamCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.creamCardBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.creamCardBorder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GoldButton(
                  text: isGu
                      ? 'WhatsApp પર પૂછપરછ મોકલો'
                      : 'Send Enquiry via WhatsApp',
                  icon: Icons.send_rounded,
                  onPressed: () => _sendGeneralEnquiry(isGu),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickPromptChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppColors.creamCard,
      side: const BorderSide(color: AppColors.creamCardBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onPressed: onTap,
    );
  }
}
