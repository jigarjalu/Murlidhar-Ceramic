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

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showMyProfileDialog(
    BuildContext context,
    bool isGu,
    String name,
    String phone,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isGu ? 'મારી પ્રોફાઇલ' : 'My Profile',
          style: AppTypography.heading(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${isGu ? "નામ" : "Name"}: $name',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${isGu ? "મોબાઇલ" : "Mobile"}: ${phone.isEmpty ? (isGu ? "મહેમાન" : "Guest") : "+91 $phone"}',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isGu ? 'બંધ કરો' : 'Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, bool isGu) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.creamCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGu ? 'સેટિંગ્સ' : 'Settings',
              style: AppTypography.heading(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.storefront_outlined, color: AppColors.goldDark),
              title: Text(isGu ? 'દુકાન વિશે અને સરનામું' : 'About Murlidhar Ceramic'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.goldDark),
              title: Text(isGu ? 'એડમિન પોર્ટલ' : 'Admin Portal'),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/admin/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authStateProvider);
    final isGu = lang == 'gu';

    final userName = user?.name ?? (isGu ? 'મહેમાન ગ્રાહક' : 'Guest User');
    final userPhone = user?.phone ?? '';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        title: Text(
          isGu ? 'પ્રોફાઇલ' : 'Profile',
          style: AppTypography.heading(fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => _showSettingsSheet(context, isGu),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark header avatar banner matching Screen 13
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
              decoration: const BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.goldStart.withOpacity(0.2),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 42,
                      color: AppColors.goldAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: AppTypography.dynamicBody(
                      userName,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userPhone.isNotEmpty
                        ? '+91 $userPhone'
                        : (isGu ? 'મહેમાન ગ્રાહક' : 'Guest Customer'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.goldAccent,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Options matching reference Screen 13 (with My Enquiries)
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.history_rounded, color: AppColors.goldDark),
                          title: Text(isGu ? 'મારી પૂછપરછો' : 'My Enquiries'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () => context.push('/my-enquiries'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded, color: AppColors.goldDark),
                          title: Text(isGu ? 'મારી પ્રોફાઇલ' : 'My Profile'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () => _showMyProfileDialog(
                            context,
                            isGu,
                            userName,
                            userPhone,
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.favorite_outline_rounded, color: AppColors.goldDark),
                          title: Text(isGu ? 'મનપસંદ આઇટમ્સ' : 'Favorites'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () => context.push('/favorites'),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_none_rounded, color: AppColors.goldDark),
                          title: Text(isGu ? 'નોટિફિકેશન' : 'Notifications'),
                          value: _notificationsEnabled,
                          activeColor: AppColors.goldStart,
                          onChanged: (val) => setState(() => _notificationsEnabled = val),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.language_rounded, color: AppColors.goldDark),
                          title: Text(isGu ? 'ભાષા પસંદગી' : 'Language'),
                          trailing: const LanguageToggleButton(),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.settings_outlined, color: AppColors.goldDark),
                          title: Text(isGu ? 'સેટિંગ્સ' : 'Settings'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () => _showSettingsSheet(context, isGu),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Logout / Sign in Button
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.creamCardBorder),
                    ),
                    tileColor: AppColors.creamCard,
                    leading: const Icon(Icons.logout_rounded, color: AppColors.errorRed),
                    title: Text(
                      user != null && !user.isGuest
                          ? (isGu ? 'લોગઆઉટ' : 'Logout')
                          : (isGu ? 'લોગિન / રજીસ્ટર' : 'Login / Register'),
                      style: const TextStyle(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
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
          ],
        ),
      ),
    );
  }
}
