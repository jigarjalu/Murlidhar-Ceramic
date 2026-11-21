import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/gold_button.dart';
import '../common/providers/app_providers.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController(text: 'admin@murlidhar.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    setState(() => _isLoading = true);
    final ok = await ref.read(authStateProvider.notifier).adminLogin(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    setState(() => _isLoading = false);

    if (ok && mounted) {
      context.go('/admin/dashboard');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid admin credentials. Use admin@murlidhar.com / admin123'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        title: const Text('Admin Portal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                  Icons.admin_panel_settings_outlined,
                  size: 60,
                  color: AppColors.goldStart,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Murlidhar Ceramic',
                style: AppTypography.heading(
                  fontSize: 22,
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Store Administration',
                style: TextStyle(fontSize: 13, color: AppColors.goldAccent),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
                  filled: true,
                  fillColor: AppColors.darkCard,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.goldStart, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.darkCardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
                  filled: true,
                  fillColor: AppColors.darkCard,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.goldStart, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.darkCardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              GoldButton(
                text: 'Login to Admin Dashboard',
                onPressed: _onLogin,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
