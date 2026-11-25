import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

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
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify(bool isGu) async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() {
        _errorMessage = isGu
            ? 'કૃપા કરીને 6 અંકનો OTP દાખલ કરો'
            : 'Please enter a 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authStateProvider.notifier).verifyOtp(
          mobile: widget.phone,
          otp: otp,
          name: widget.name,
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      setState(() {
        _errorMessage = isGu
            ? 'અમાન્ય OTP. ટેસ્ટિંગ માટે 123456 નો ઉપયોગ કરો.'
            : 'Invalid OTP. Use 123456 for testing.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGu = ref.watch(languageProvider) == 'gu';

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isGu ? 'OTP ચકાસણી' : 'OTP Verification',
          style: AppTypography.heading(
            fontSize: 18,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Shield Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldStart.withOpacity(0.12),
                  border: Border.all(
                    color: AppColors.goldStart.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: 34,
                    color: AppColors.goldDark,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                isGu ? 'ચકાસણી કોડ દાખલ કરો' : 'Enter Verification Code',
                style: AppTypography.heading(
                  fontSize: 22,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isGu
                    ? '+91 ${widget.phone} પર કોડ મોકલ્યો છે\n(ટેસ્ટિંગ OTP: 123456)'
                    : 'Code sent to +91 ${widget.phone}\n(Testing OTP: 123456)',
                textAlign: TextAlign.center,
                style: AppTypography.manrope(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // OTP input card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.creamCardBorder),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(
                        fontSize: 26,
                        letterSpacing: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '123456',
                        errorText: _errorMessage,
                        filled: true,
                        fillColor: const Color(0xFFFBF6EE),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.creamCardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.goldDark, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isGu ? 'કોડ નથી મળ્યો? ' : "Didn't receive code? ",
                          style: AppTypography.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(authStateProvider.notifier)
                                .sendOtp(widget.phone);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isGu
                                      ? 'OTP ફરીથી મોકલાયો: 123456'
                                      : 'OTP re-sent: 123456',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            isGu ? 'ફરી મોકલો' : 'Resend',
                            style: AppTypography.manrope(
                              fontSize: 12,
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              GoldButton(
                text: isGu ? 'ચકાસો અને આગળ વધો' : 'Verify & Continue',
                onPressed: _isLoading ? null : () => _onVerify(isGu),
                variant: GoldButtonVariant.black,
                icon: Icons.check_circle_outline_rounded,
                width: double.infinity,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
