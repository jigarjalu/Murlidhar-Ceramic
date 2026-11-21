import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // In Phase 1 foundation: 2.5s timer then navigate to onboarding
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background subtle gold gradient vignette
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF1E1A14),
                  AppColors.darkBackground,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldStart.withAlpha(60),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppConfig.logoPath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.diamond_outlined,
                        size: 70,
                        color: AppColors.goldStart,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Title
                Text(
                  AppConfig.appName,
                  style: AppTypography.heading(
                    fontSize: 28,
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  AppConfig.tagline,
                  style: AppTypography.dynamicBody(
                    AppConfig.tagline,
                    fontSize: 15,
                    color: AppColors.goldAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                // Gold Loading Ring
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
