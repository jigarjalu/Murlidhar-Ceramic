import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/language_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.parse(AppConfig.googleMapsQuery);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  Future<void> _callStore(BuildContext context) async {
    final uri = Uri.parse('tel:${AppConfig.storePhone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dialer unavailable. Call +91 9979079013')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'અમારા વિશે & સંપર્ક' : 'About & Contact',
          style: AppTypography.heading(fontSize: 20),
        ),
        actions: [
          IconButton(
            tooltip: isGu ? 'પ્રોફાઇલ' : 'Profile',
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Store Identity Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    AppConfig.logoPath,
                    width: 84,
                    height: 84,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.diamond_outlined,
                      size: 60,
                      color: AppColors.goldStart,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppConfig.appName,
                    style: AppTypography.heading(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppConfig.legalBusinessName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    AppConfig.tagline,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.goldDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Animated Pin Drop + Ripple Card for Store Location & Hours
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Animated Pin Drop + Ripple
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.goldStart.withOpacity(0.25),
                              ),
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .scale(
                                  begin: const Offset(0.6, 0.6),
                                  end: const Offset(1.3, 1.3),
                                  duration: 1600.ms,
                                )
                                .fadeOut(duration: 1600.ms),
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.goldDark,
                              size: 26,
                            )
                                .animate()
                                .slideY(
                                  begin: -0.6,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.bounceOut,
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGu ? 'સરનામું' : 'Store Address',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AppConfig.storeAddress,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const SizedBox(
                        width: 40,
                        child: Icon(
                          Icons.access_time_rounded,
                          color: AppColors.goldDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGu ? 'સમય' : 'Working Hours',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isGu
                                  ? AppConfig.storeHoursGujarati
                                  : AppConfig.storeHoursEnglish,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons: Open Maps, Call, WhatsApp
            GoldButton(
              text: isGu ? 'Google Maps માં જુઓ' : 'Open in Google Maps',
              icon: Icons.map_outlined,
              variant: GoldButtonVariant.black,
              onPressed: () => _openMap(context),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GoldButton(
                    text: isGu ? 'કોલ કરો' : 'Call Store',
                    icon: Icons.phone_outlined,
                    variant: GoldButtonVariant.outline,
                    onPressed: () => _callStore(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GoldButton(
                    text: 'WhatsApp',
                    icon: Icons.chat_outlined,
                    variant: GoldButtonVariant.gold,
                    onPressed: () => WhatsAppHelper.launchWhatsApp(
                      context: context,
                      message: WhatsAppHelper.buildGeneralInquiryMessage(
                        userName: 'Customer',
                        inquiryDetails: isGu
                            ? 'નમસ્તે, મને તમારી દુકાન અને ટાઈલ્સ વિશે માહિતી જોઈએ છે.'
                            : 'Hello, I would like information about your tiles & showroom.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
