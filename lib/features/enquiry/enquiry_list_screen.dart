import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _EnquiryListScreenState extends ConsumerState<EnquiryListScreen> with SingleTickerProviderStateMixin {
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

  void _sendItemsEnquiry(List<EnquiryItem> items) async {
    final user = ref.read(authStateProvider);
    final userName = user?.name ?? 'Customer';
    final message = WhatsAppHelper.buildMultiItemMessage(
      userName: userName,
      items: items,
    );

    // Save to sent enquiries
    final enquiry = EnquiryModel(
      id: 'enq_${DateTime.now().millisecondsSinceEpoch}',
      customerName: userName,
      customerPhone: user?.phone ?? '',
      items: items,
      status: EnquiryStatus.pending,
      createdAt: DateTime.now(),
    );
    await ref.read(enquiryRepositoryProvider).recordSentEnquiry(enquiry);

    if (mounted) {
      WhatsAppHelper.launchWhatsApp(context: context, message: message);
    }
  }

  void _sendGeneralEnquiry() async {
    final note = _generalNoteController.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('કૃપા કરીને તમારી પૂછપરછ લખો / Please write your inquiry')),
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

    if (mounted) {
      _generalNoteController.clear();
      WhatsAppHelper.launchWhatsApp(context: context, message: message);
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
          if (enquiryItems.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(enquiryCartProvider.notifier).clearCart(),
              child: Text(
                isGu ? 'બધું સાફ કરો' : 'Clear All',
                style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldDark,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.goldStart,
          tabs: [
            Tab(text: isGu ? 'પસંદ કરેલ આઇટમ્સ (${enquiryItems.length})' : 'Selected Items (${enquiryItems.length})'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.playlist_remove_rounded, size: 64, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      Text(
                        isGu ? 'તમારું પૂછપરછ લિસ્ટ ખાલી છે' : 'No items added to enquiry list',
                        style: AppTypography.dynamicBody('Empty enquiry list', fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isGu ? 'પ્રોડક્ટ્સમાંથી "Add to Enquiry" દબાવો' : 'Tap "Add to Enquiry" on any tile product',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
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

                          return GlassCard(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ProductImage(
                                    imageUrl: item.imageUrl,
                                    width: 70,
                                    height: 70,
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
                                        '${item.selectedSize} • ${item.selectedFinish}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isGu ? AppConfig.inquiryPriceGujarati : AppConfig.inquiryPriceEnglish,
                                        style: const TextStyle(fontSize: 12, color: AppColors.goldDark, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 20),
                                  onPressed: () => ref
                                      .read(enquiryCartProvider.notifier)
                                      .removeItem(item.productId, item.selectedSize, item.selectedFinish),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GoldButton(
                        text: isGu ? 'WhatsApp પર પૂછપરછ મોકલો' : 'Send Enquiry via WhatsApp',
                        icon: Icons.chat_rounded,
                        onPressed: () => _sendItemsEnquiry(enquiryItems),
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),

          // Tab 2: General Inquiry
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGu ? 'સામાન્ય પૂછપરછ / પ્રશ્ન' : 'General Inquiry / Requirement',
                  style: AppTypography.dynamicBody('Inquiry', fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
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
                      borderSide: const BorderSide(color: AppColors.creamCardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GoldButton(
                  text: isGu ? 'WhatsApp પર પૂછપરછ મોકલો' : 'Send via WhatsApp',
                  icon: Icons.send_rounded,
                  onPressed: _sendGeneralEnquiry,
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
