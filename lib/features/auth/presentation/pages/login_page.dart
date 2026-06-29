import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) context.go('/home');
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Masuk ke Akun',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text('Masukkan email & kata sandi Anda untuk melanjutkan.',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Email',
                      hint: 'anda@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.textSecondary),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 12),
                    _buildRememberForgot(),
                    const SizedBox(height: 28),
                    PrimaryButton(text: 'Masuk', isLoading: authState.isLoading, onPressed: _handleLogin),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildSocialLogins(),
                    const SizedBox(height: 28),
                    _buildSignUpLink(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF11152A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text('V',
                    style: GoogleFonts.playfairDisplay(
                        color: AppColors.secondary, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text('VELVORIA',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 28),
          Text('Selamat datang\nkembali.',
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 10),
          Text('Lanjutkan pengalaman belanja mewah Anda bersama brand & vendor kelas dunia.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Ingat saya', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Lupa sandi?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.textSecondary.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('atau lanjut dengan',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary.withValues(alpha: 0.6))),
        ),
        Expanded(child: Divider(color: AppColors.textSecondary.withValues(alpha: 0.2))),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      children: [
        _socialBtn(Icons.g_mobiledata),
        const SizedBox(width: 12),
        _socialBtn(Icons.apple),
        const SizedBox(width: 12),
        _socialBtn(Icons.facebook),
      ],
    );
  }

  Widget _socialBtn(IconData icon) {
    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Center(child: Icon(icon, size: 28, color: AppColors.textPrimary)),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Belum punya akun? ',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          GestureDetector(
            onTap: () => context.push('/register'),
            child: const Text('Daftar sekarang',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
