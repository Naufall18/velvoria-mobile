import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// First-run onboarding — floating illustration cards with a parallax page
/// transition, matching the Velvoria luxury identity.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  late final AnimationController _float;
  double _page = 0;
  int _currentPage = 0;

  static const List<_OnbSlide> _slides = [
    _OnbSlide(
      'assets/images/onb_discover.svg',
      Icons.auto_awesome_rounded,
      'Temukan Kemewahan',
      'Jelajahi koleksi pilihan dari brand premium ternama di seluruh dunia — semua dalam satu aplikasi.',
      AppColors.primary,
    ),
    _OnbSlide(
      'assets/images/onb_authentic.svg',
      Icons.workspace_premium_rounded,
      '100% Autentik',
      'Setiap produk melewati verifikasi keaslian dan kontrol kualitas sebelum sampai ke tangan Anda.',
      AppColors.accent,
    ),
    _OnbSlide(
      'assets/images/onb_delivery.svg',
      Icons.bolt_rounded,
      'Cepat & Aman',
      'Pengiriman premium dengan asuransi penuh dan pelacakan real-time hingga depan pintu Anda.',
      AppColors.error,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (!mounted) return;
      setState(() => _page = _controller.page ?? 0);
    });
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _float.dispose();
    super.dispose();
  }

  bool get _isLast => _currentPage == _slides.length - 1;

  void _next() {
    if (_isLast) {
      context.go('/login');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _slides[_currentPage].color;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: _isLast ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: TextButton(
                  onPressed: _isLast ? null : () => context.go('/login'),
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final delta = index - _page;
                  final t = (1 - delta.abs()).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _float,
                          builder: (context, child) {
                            final dy =
                                math.sin(_float.value * math.pi * 2) * 8;
                            return Transform.translate(
                              offset: Offset(delta * 48, dy),
                              child: child,
                            );
                          },
                          child: _illustration(slide),
                        ),
                        const SizedBox(height: 44),
                        Opacity(
                          opacity: t,
                          child: Transform.translate(
                            offset: Offset(0, (1 - t) * 24),
                            child: Column(
                              children: [
                                Text(
                                  slide.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  slide.subtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _bottomBar(activeColor),
          ],
        ),
      ),
    );
  }

  Widget _illustration(_OnbSlide slide) {
    const radius = BorderRadius.only(
      topLeft: Radius.circular(28),
      topRight: Radius.circular(72),
      bottomLeft: Radius.circular(72),
      bottomRight: Radius.circular(28),
    );
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: slide.color.withValues(alpha: 0.10),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: slide.color.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SvgPicture.asset(slide.image, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(slide.badge, color: slide.color, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(Color activeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? activeColor : AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _isLast ? 'Mulai Sekarang' : 'Lanjut',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnbSlide {
  final String image;
  final IconData badge;
  final String title;
  final String subtitle;
  final Color color;
  const _OnbSlide(
      this.image, this.badge, this.title, this.subtitle, this.color);
}
