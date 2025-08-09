import 'package:flutter/cupertino.dart';

class BackgroundImageContainer extends StatelessWidget {
  const BackgroundImageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_image.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
