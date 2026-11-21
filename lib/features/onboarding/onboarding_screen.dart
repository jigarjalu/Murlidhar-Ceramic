import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: AppColors.goldAccent, fontSize: 15),
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.holiday_village_outlined,
                size: 80,
                color: AppColors.goldStart,
              ),
              const SizedBox(height: 24),
              Text(
                'Premium Tiles for Premium Living',
                textAlign: TextAlign.center,
                style: AppTypography.heading(
                  fontSize: 26,
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Discover unmatched craftsmanship, luxury finishes and enduring durability for every space.',
                textAlign: TextAlign.center,
                style: AppTypography.manrope(
                  fontSize: 14,
                  color: AppColors.darkTextSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              GoldButton(
                text: 'Next',
                onPressed: () => context.go('/login'),
                icon: Icons.arrow_forward_rounded,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
