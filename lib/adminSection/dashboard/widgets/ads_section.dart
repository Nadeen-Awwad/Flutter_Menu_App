import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/adminSection/utils/colors.dart';

class AdsSection extends StatefulWidget {
  const AdsSection({super.key});

  @override
  _AdsSectionState createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  final PageController _pageController = PageController();
  final List<String> _adsImages = [
    'assets/images/ads/ads.jpg',
    'assets/images/ads/ads2.jpeg',
    'assets/images/ads/ads3.webp',
    'assets/images/ads/ads4.jpg',
  ];
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final nextPage = (_currentPageNotifier.value + 1) % _adsImages.length;
      _currentPageNotifier.value = nextPage;
      _pageController.animateToPage(nextPage, duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAdCarousel(),
        const SizedBox(height: 10),
        _buildDotIndicators(),
      ],
    );
  }

  Widget _buildAdCarousel() {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _adsImages.length,
        onPageChanged: (index) => _currentPageNotifier.value = index,
        itemBuilder: (context, index) => Image.asset(_adsImages[index], fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPageNotifier,
        builder: (context, currentPage, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _adsImages.length,
                  (index) => _buildDot(index, currentPage),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDot(int index, int currentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: index == currentPage ? 12.0 : 8.0,
      height: index == currentPage ? 12.0 : 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentPage ? Palette.appColor : Colors.grey,
      ),
    );
  }
}
