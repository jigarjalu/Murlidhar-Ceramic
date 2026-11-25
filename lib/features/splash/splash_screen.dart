import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _navigateAfterSplash();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterSplash() async {
    // 2.8s splash duration
    await Future<void>.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final authRepo = ref.read(authRepositoryProvider);
    final user = await authRepo.getCurrentUser();
    final hasOnboarded = await authRepo.hasCompletedOnboarding();

    if (!mounted) return;

    if (user != null) {
      context.go('/home');
    } else if (hasOnboarded) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGu = ref.watch(languageProvider) == 'gu';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background subtle gold marble veins
          const CustomPaint(
            painter: MarbleVeinsPainter(),
            size: Size.infinite,
          ),

          // Dark vignette overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.15,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0B0B0C).withOpacity(0.85),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo with light sweep shine animation
                  Center(
                    child: AnimatedBuilder(
                      animation: _sweepController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft glow behind logo
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldStart.withOpacity(0.35),
                                    blurRadius: 40,
                                    spreadRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            // The logo image
                            Image.asset(
                              AppConfig.logoSplashPath,
                              width: 135,
                              height: 135,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Image.asset(
                                AppConfig.logoPath,
                                width: 135,
                                height: 135,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Light sweep gradient overlay
                            Positioned.fill(
                              child: ClipOval(
                                child: ShaderMask(
                                  shaderCallback: (bounds) {
                                    final double progress = _sweepController.value;
                                    final double startX = (progress * 3.0 - 1.0) * bounds.width;
                                    return LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                      transform: _SlideGradientTransform(startX, 0),
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App Title (Playfair Display)
                  Text(
                    AppConfig.appName,
                    textAlign: TextAlign.center,
                    style: AppTypography.heading(
                      fontSize: 27,
                      color: AppColors.darkTextPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Tagline
                  Text(
                    AppConfig.tagline,
                    style: AppTypography.manrope(
                      fontSize: 14,
                      color: const Color(0xFFE2B755),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Sub-tagline
                  Text(
                    AppConfig.subTagline,
                    style: AppTypography.manrope(
                      fontSize: 12,
                      color: AppColors.darkTextSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const Spacer(),

                  // 4 Value Points (Quality, Durability, Modern Design, Expert Support)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _ValuePointRow(
                          icon: Icons.verified_outlined,
                          labelEn: 'Quality',
                          labelGu: 'શ્રેષ્ઠ ગુણવત્તા',
                          isGu: isGu,
                        ),
                        const SizedBox(height: 10),
                        _ValuePointRow(
                          icon: Icons.shield_outlined,
                          labelEn: 'Durability',
                          labelGu: 'લાંબા સમય સુધી ટકાઉ',
                          isGu: isGu,
                        ),
                        const SizedBox(height: 10),
                        _ValuePointRow(
                          icon: Icons.style_outlined,
                          labelEn: 'Modern Design',
                          labelGu: 'આધુનિક ડિઝાઇન',
                          isGu: isGu,
                        ),
                        const SizedBox(height: 10),
                        _ValuePointRow(
                          icon: Icons.support_agent_outlined,
                          labelEn: 'Expert Support',
                          labelGu: 'નિષ્ણાત માર્ગદર્શન',
                          isGu: isGu,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Gold Loader Ring
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldStart),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuePointRow extends StatelessWidget {
  final IconData icon;
  final String labelEn;
  final String labelGu;
  final bool isGu;

  const _ValuePointRow({
    required this.icon,
    required this.labelEn,
    required this.labelGu,
    required this.isGu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFFD9A441),
        ),
        const SizedBox(width: 8),
        Text(
          isGu ? labelGu : labelEn,
          style: AppTypography.dynamicBody(
            isGu ? labelGu : labelEn,
            fontSize: 13,
            color: const Color(0xFFD4C8B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double dx;
  final double dy;

  const _SlideGradientTransform(this.dx, this.dy);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, dy, 0.0);
  }
}

/// Custom painter to draw elegant subtle gold marble veins
class MarbleVeinsPainter extends CustomPainter {
  const MarbleVeinsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9A441).withOpacity(0.09)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final subtlePaint = Paint()
      ..color = const Color(0xFFF2CE7A).withOpacity(0.05)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Main vein 1 (top-left to bottom-right)
    final path1 = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.28,
        size.width * 0.45,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.58,
        size.width * 0.9,
        size.height * 0.82,
      );
    canvas.drawPath(path1, paint);

    // Branch 1
    final branch1 = Path()
      ..moveTo(size.width * 0.38, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.32,
        size.width,
        size.height * 0.25,
      );
    canvas.drawPath(branch1, subtlePaint);

    // Main vein 2 (right to bottom-center)
    final path2 = Path()
      ..moveTo(size.width, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.55,
        size.width * 0.55,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.85,
        size.width * 0.15,
        size.height,
      );
    canvas.drawPath(path2, paint);

    // Top subtle vein
    final path3 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.08,
        size.width * 0.85,
        0,
      );
    canvas.drawPath(path3, subtlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
