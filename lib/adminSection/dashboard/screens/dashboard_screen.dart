import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/ads_section.dart';
import '../widgets/food_page_body.dart';
import '../widgets/food_page_header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              _buildBackgroundImage(),
              SingleChildScrollView(
                child: Column(
                  children: const [
                    FoodPageHeader(),
                    AdsSection(),
                    FoodPageBody(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/food.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Glass effect
            ),
          ),
        ],
      ),
    );
  }
}
