import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/language_toggle_button.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authStateProvider);
    final isGu = lang == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(
          isGu ? 'પ્રોફાઇલ' : 'Profile',
          style: AppTypography.heading(fontSize: 20),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Avatar Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.goldStart.withAlpha(50),
                    child: const Icon(Icons.person_rounded, size: 36, color: AppColors.goldDark),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest User',
                          style: AppTypography.dynamicBody(
                            user?.name ?? 'Guest User',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user != null && user.phone.isNotEmpty
                              ? '+91 ${user.phone}'
                              : (isGu ? 'મહેમાન ગ્રાહક' : 'Guest Customer'),
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Options matching reference Screen 13
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history_rounded, color: AppColors.goldDark),
                    title: Text(isGu ? 'મારી પૂછપરછો' : 'My Enquiries'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/enquiry'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline_rounded, color: AppColors.goldDark),
                    title: Text(isGu ? 'મનપસંદ આઇટમ્સ' : 'Favorites'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/favorites'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.goldDark),
                    title: Text(isGu ? 'ભાષા પસંદગી' : 'Language'),
                    trailing: const LanguageToggleButton(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.goldDark),
                    title: Text(isGu ? 'દુકાન વિશે' : 'About Store'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () => context.push('/about'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout / Sign in Button
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: AppColors.creamCard,
              leading: const Icon(Icons.logout_rounded, color: AppColors.errorRed),
              title: Text(
                user != null && !user.isGuest ? 'Logout' : 'Login / Register',
                style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),

            const SizedBox(height: 16),
            const Text(
              '${AppConfig.appName} v1.0.0',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
