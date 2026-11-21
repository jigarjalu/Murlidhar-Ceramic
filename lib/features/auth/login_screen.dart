import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    context.push(
      '/otp',
      extra: {
        'name': _nameController.text.trim().isEmpty ? 'Customer' : _nameController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty ? '9979079013' : _phoneController.text.trim(),
      },
    );
  }

  void _onGuest() async {
    await ref.read(authStateProvider.notifier).continueAsGuest();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                AppConfig.logoPath,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.diamond_outlined,
                  size: 50,
                  color: AppColors.goldStart,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome Back',
                style: AppTypography.heading(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Login to continue / ચાલુ રાખવા માટે લોગિન કરો',
                style: AppTypography.manrope(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name / પૂરું નામ',
                  filled: true,
                  fillColor: AppColors.creamCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.creamCardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / મોબાઇલ નંબર',
                  prefixText: '+91 ',
                  filled: true,
                  fillColor: AppColors.creamCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.creamCardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GoldButton(
                text: 'Send OTP',
                onPressed: _onSendOtp,
                variant: GoldButtonVariant.black,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _onGuest,
                child: Text(
                  'Continue as Guest / મહેમાન તરીકે આગળ વધો',
                  style: AppTypography.dynamicBody(
                    'Continue as Guest / મહેમાન તરીકે આગળ વધો',
                    fontSize: 14,
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.push('/admin/login'),
                child: const Text(
                  'Admin Login →',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
