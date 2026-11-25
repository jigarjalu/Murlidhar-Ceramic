import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';
import '../common/providers/language_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingSlideData> _slides = const [
    OnboardingSlideData(
      titleEn: 'Premium Tiles for Premium Living',
      titleGu: 'પ્રીમિયમ જીવનશૈલી માટે ઉત્તમ ટાઈલ્સ',
      subtitleEn:
          'Explore an exclusive curation of glazed, vitrified, and digital tiles crafted to redefine elegance in your living spaces.',
      subtitleGu:
          'તમારા ઘર અને ઓફિસને ભવ્ય દેખાવ આપવા માટે ખાસ ગ્લેઝ, વિટ્રીફાઈડ અને ડિજીટલ ટાઈલ્સનું શ્રેષ્ઠ કલેક્શન.',
      icon: Icons.holiday_village_outlined,
      taglineEn: 'Luxury Living',
      taglineGu: 'લક્ઝરી લિવિંગ',
    ),
    OnboardingSlideData(
      titleEn: 'Craftsmanship & Lasting Durability',
      titleGu: 'ઉચ્ચ ગુણવત્તા અને લાંબા સમય સુધી ટકાઉ',
      subtitleEn:
          'Engineered for endurance with superior finishes, slip resistance, and stain protection for both indoor and outdoor architecture.',
      subtitleGu:
          'ઇન્ડોર અને આઉટડોર બંને જગ્યાઓ માટે મજબૂત બનાવટ, સ્ટેન-રેઝિસ્ટન્ટ અને આકર્ષક ફિનિશ.',
      icon: Icons.architecture_outlined,
      taglineEn: 'Enduring Quality',
      taglineGu: 'અજોડ ટકાઉપણું',
    ),
    OnboardingSlideData(
      titleEn: 'Personalized WhatsApp Enquiry',
      titleGu: 'સીધું વોટ્સએપ પર પૂછપરછ અને માર્ગદર્શન',
      subtitleEn:
          'Directly connect with Murlidhar Ceramic experts on WhatsApp for instant best prices, availability, and tailored recommendations.',
      subtitleGu:
          'શ્રેષ્ઠ ભાવ, સાઈઝ અને ઉપલબ્ધતા વિશે સીધી વોટ્સએપ દ્વારા મુરલીધર સિરામિકના નિષ્ણાતો પાસેથી માહિતી મેળવો.',
      icon: Icons.chat_bubble_outline_rounded,
      taglineEn: 'Direct Enquiry',
      taglineGu: 'ઝડપી પૂછપરછ',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.setOnboardingCompleted();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGu = ref.watch(languageProvider) == 'gu';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldStart.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldDark.withOpacity(0.06),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Skip Bar & Language switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Language indicator chip
                      GestureDetector(
                        onTap: () {
                          ref.read(languageProvider.notifier).toggleLanguage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1712),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.goldStart.withOpacity(0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.language,
                                size: 14,
                                color: AppColors.goldStart,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isGu ? 'ગુજરાતી' : 'English',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFF2CE7A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Skip button
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          isGu ? 'છોડો' : 'Skip',
                          style: const TextStyle(
                            color: AppColors.goldAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page slider
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 1),

                            // Hero visual container
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.goldStart.withOpacity(0.25),
                                    AppColors.goldDark.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.goldStart.withOpacity(0.35),
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  slide.icon,
                                  size: 60,
                                  color: const Color(0xFFF2CE7A),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Tagline badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.goldStart.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                isGu ? slide.taglineGu : slide.taglineEn,
                                style: const TextStyle(
                                  color: Color(0xFFF2CE7A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Slide Title
                            Text(
                              isGu ? slide.titleGu : slide.titleEn,
                              textAlign: TextAlign.center,
                              style: AppTypography.heading(
                                fontSize: 24,
                                color: AppColors.darkTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Slide Description
                            Text(
                              isGu ? slide.subtitleGu : slide.subtitleEn,
                              textAlign: TextAlign.center,
                              style: AppTypography.dynamicBody(
                                isGu ? slide.subtitleGu : slide.subtitleEn,
                                fontSize: 14,
                                color: AppColors.darkTextSecondary,
                                height: 1.55,
                              ),
                            ),

                            const Spacer(flex: 2),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentIndex == index
                            ? AppColors.goldStart
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Bottom Gold Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: GoldButton(
                    text: _currentIndex == _slides.length - 1
                        ? (isGu ? 'શરૂ કરો' : 'Get Started')
                        : (isGu ? 'આગળ' : 'Next'),
                    onPressed: _onNext,
                    icon: Icons.arrow_forward_rounded,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlideData {
  final String titleEn;
  final String titleGu;
  final String subtitleEn;
  final String subtitleGu;
  final IconData icon;
  final String taglineEn;
  final String taglineGu;

  const OnboardingSlideData({
    required this.titleEn,
    required this.titleGu,
    required this.subtitleEn,
    required this.subtitleGu,
    required this.icon,
    required this.taglineEn,
    required this.taglineGu,
  });
}
