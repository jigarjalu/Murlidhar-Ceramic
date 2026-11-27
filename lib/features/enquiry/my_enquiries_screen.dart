import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/status_chip.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class MyEnquiriesScreen extends ConsumerWidget {
  const MyEnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final isGu = lang == 'gu';
    final enquiriesAsync = ref.watch(myEnquiriesProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isGu ? 'મારી પૂછપરછો' : 'My Enquiries',
          style: AppTypography.heading(fontSize: 20),
        ),
      ),
      body: enquiriesAsync.when(
        data: (enquiries) {
          if (enquiries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isGu
                          ? 'હજુ સુધી કોઈ પૂછપરછ મોકલેલ નથી'
                          : 'No enquiries sent yet',
                      style: AppTypography.dynamicBody(
                        'No enquiries',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGu
                          ? 'તમે WhatsApp દ્વારા મોકલેલી પૂછપરછ અહીં દેખાશે.'
                          : 'Enquiries you send via WhatsApp will appear here.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GoldButton(
                      text: isGu ? 'કેટેગરીઝ જુઓ' : 'Explore Tiles',
                      onPressed: () => context.go('/categories'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.goldStart,
            onRefresh: () async => ref.invalidate(myEnquiriesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: enquiries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final enq = enquiries[index];
                final dateStr = DateFormat('dd MMM yyyy, hh:mm a')
                    .format(enq.createdAt);

                return GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            enq.isGeneralInquiry
                                ? (isGu ? 'સામાન્ય પૂછપરછ' : 'General Inquiry')
                                : (isGu
                                    ? '${enq.items.length} આઇટમ પૂછપરછ'
                                    : '${enq.items.length} Item(s) Enquiry'),
                            style: AppTypography.dynamicBody(
                              'Enquiry Type',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          StatusChip(status: enq.status, isGujarati: isGu),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Divider(height: 18),
                      if (enq.isGeneralInquiry)
                        Text(
                          enq.generalMessage,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        )
                      else
                        ...enq.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: AppColors.goldDark,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${item.localizedProductName(lang)} (${item.selectedSize}, ${item.selectedFinish})',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.chat_outlined,
                            size: 16,
                            color: AppColors.goldDark,
                          ),
                          label: Text(
                            isGu ? 'ફરી WhatsApp કરો' : 'Resend on WhatsApp',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            final msg = enq.isGeneralInquiry
                                ? WhatsAppHelper.buildGeneralInquiryMessage(
                                    userName: enq.customerName,
                                    inquiryDetails: enq.generalMessage,
                                  )
                                : WhatsAppHelper.buildMultiItemMessage(
                                    userName: enq.customerName,
                                    items: enq.items,
                                  );
                            WhatsAppHelper.launchWhatsApp(
                              context: context,
                              message: msg,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
          ),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
