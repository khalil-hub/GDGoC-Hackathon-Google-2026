import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  static const _slides = [
    (
      'AI-Powered Perfect Fit',
      'Get personalized recommendations based on your pet\'s measurements.',
      Icons.auto_awesome_rounded,
    ),
    (
      'Virtual Try-On',
      'See how outfits look before you buy.',
      Icons.camera_alt_outlined,
    ),
    (
      'Luxury Brands',
      'Shop premium pet fashion labels.',
      Icons.shopping_bag_outlined,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.petProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          child: Icon(slide.$3, size: 44),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide.$1,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(slide.$2, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final selected = _index == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: selected ? 22 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF14B8A6)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(
                      _index == _slides.length - 1 ? 'Get Started' : 'Next',
                    ),
                  ),
                  if (_index < _slides.length - 1)
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRouter.petProfile,
                      ),
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
