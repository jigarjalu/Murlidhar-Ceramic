import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _phoneError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validate(bool isGu) {
    setState(() {
      _nameError = null;
      _phoneError = null;
    });

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');

    bool valid = true;
    if (name.isEmpty) {
      setState(() {
        _nameError = isGu
            ? 'કૃપા કરીને તમારું પૂરું નામ દાખલ કરો'
            : 'Please enter your full name';
      });
      valid = false;
    }

    if (phone.length < 10) {
      setState(() {
        _phoneError = isGu
            ? 'કૃપા કરીને માન્ય 10 અંકનો મોબાઇલ નંબર દાખલ કરો'
            : 'Please enter a valid 10-digit mobile number';
      });
      valid = false;
    }

    return valid;
  }

  Future<void> _onSendOtp(bool isGu) async {
    if (!_validate(isGu)) return;

    setState(() => _isLoading = true);
    final phone = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    final name = _nameController.text.trim();

    final success =
        await ref.read(authStateProvider.notifier).sendOtp(phone);
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.push(
        '/otp',
        extra: {
          'name': name,
          'phone': phone,
        },
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isGu
                ? 'OTP મોકલવામાં નિષ્ફળતા. ફરી પ્રયાસ કરો.'
                : 'Failed to send OTP. Please check your number.',
          ),
        ),
      );
    }
  }

  void _onGuest() async {
    setState(() => _isLoading = true);
    await ref.read(authStateProvider.notifier).continueAsGuest();
    setState(() => _isLoading = false);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGu = ref.watch(languageProvider) == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top language switch
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: () {
                      ref.read(languageProvider.notifier).toggleLanguage();
                    },
                    icon: const Icon(Icons.language, size: 16, color: AppColors.textPrimary),
                    label: Text(
                      isGu ? 'English' : 'ગુજરાતી',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Logo Container
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    AppConfig.logoLoginPath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppConfig.logoPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // App Name
                Text(
                  AppConfig.appName,
                  style: AppTypography.heading(
                    fontSize: 22,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                // Tagline
                Text(
                  AppConfig.tagline,
                  style: AppTypography.manrope(
                    fontSize: 13,
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 28),

                // Card container (Cream card matching reference screen 3)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.creamCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.creamCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isGu ? 'સ્વાગત છે' : 'Welcome Back',
                            style: AppTypography.heading(
                              fontSize: 20,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('👋', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isGu
                            ? 'ચાલુ રાખવા માટે લોગિન કરો'
                            : 'Login to continue with Murlidhar Ceramic',
                        style: AppTypography.manrope(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name Field
                      Text(
                        isGu ? 'પૂરું નામ' : 'Full Name',
                        style: AppTypography.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        style: AppTypography.manrope(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: isGu ? 'દા.ત. રાહુલ પટેલ' : 'e.g. Rahul Patel',
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                          errorText: _nameError,
                          filled: true,
                          fillColor: const Color(0xFFFBF6EE),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.creamCardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.creamCardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.goldDark, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mobile Number Field
                      Text(
                        isGu ? 'મોબાઇલ નંબર' : 'Mobile Number',
                        style: AppTypography.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: AppTypography.manrope(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '98765 43210',
                          prefixIcon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: AppColors.creamCardBorder),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  '+91',
                                  style: AppTypography.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          errorText: _phoneError,
                          filled: true,
                          fillColor: const Color(0xFFFBF6EE),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.creamCardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.creamCardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.goldDark, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Black Button: Send OTP
                      GoldButton(
                        text: isGu ? 'OTP મોકલો' : 'Send OTP',
                        onPressed: _isLoading ? null : () => _onSendOtp(isGu),
                        variant: GoldButtonVariant.black,
                        icon: Icons.arrow_forward_rounded,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Divider: "or continue with"
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.creamCardBorder),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        isGu ? 'અથવા અન્ય વિકલ્પ' : 'or continue with',
                        style: AppTypography.manrope(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.creamCardBorder),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Continue as Guest Button
                OutlinedButton(
                  onPressed: _isLoading ? null : _onGuest,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.creamCardBorder, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isGu ? 'મહેમાન તરીકે આગળ વધો' : 'Continue as Guest',
                        style: AppTypography.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Admin Login footer
                TextButton(
                  onPressed: () => context.push('/admin/login'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isGu ? 'એડમિન પોર્ટલ →' : 'Admin Portal →',
                        style: AppTypography.manrope(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
