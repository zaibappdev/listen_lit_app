import 'package:flutter/material.dart';
import 'package:listen_lit_app/features/on_boarding/widgets/simple_dots_indicator.dart';
import '../../../app/constant/app_colors.dart';
import 'on_boarding.dart';

class OnboardingCard extends StatelessWidget {
  final OnBoarding item;
  final int index;
  final int total;
  final int currentIndex;
  final ValueChanged<int> onDotTapped;

  const OnboardingCard({
    super.key,
    required this.item,
    required this.index,
    required this.total,
    required this.currentIndex,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.065,
              fontWeight: FontWeight.w600,
              color: AppColor.kLightAccentColor,
              height: 1.15,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 28),
          // custom dots
          SimpleDotsIndicator(
            dotsCount: total,
            position: currentIndex,
            onDotTapped: onDotTapped,
            activeColor: AppColor.kPrimary,
            inactiveColor: Colors.grey.withOpacity(0.45),
          ),
        ],
      ),
    );
  }
}
