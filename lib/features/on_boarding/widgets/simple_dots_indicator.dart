import 'package:flutter/cupertino.dart';

class SimpleDotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;
  final ValueChanged<int> onDotTapped;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double activeWidth;

  const SimpleDotsIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
    required this.onDotTapped,
    required this.activeColor,
    required this.inactiveColor,
    this.dotSize = 8.0,
    this.activeWidth = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotsCount, (i) {
        final bool isActive = i == position;
        return GestureDetector(
          onTap: () => onDotTapped(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: dotSize * 0.5),
            height: dotSize,
            width: isActive ? activeWidth : dotSize,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}
