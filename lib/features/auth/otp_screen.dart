import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String name;
  final String phone;

  const OtpScreen({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController(text: '123456');
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() async {
    setState(() => _isLoading = true);
    final success = await ref.read(authStateProvider.notifier).verifyOtp(
          mobile: widget.phone,
          otp: _otpController.text.trim(),
          name: widget.name,
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use 123456 for testing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Enter Verification Code',
                style: AppTypography.heading(
                  fontSize: 22,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Code sent to +91 ${widget.phone} (Mock OTP: 123456)',
                textAlign: TextAlign.center,
                style: AppTypography.manrope(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.creamCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.creamCardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              GoldButton(
                text: 'Verify & Continue',
                onPressed: _onVerify,
                isLoading: _isLoading,
                variant: GoldButtonVariant.gold,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
