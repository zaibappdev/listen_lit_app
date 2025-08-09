import '../../../app/constant/app_images.dart';

class OnBoarding {
  final String title;
  final String image;

  OnBoarding({required this.title, required this.image});
}

final List<OnBoarding> pageViewList = [
  OnBoarding(
    title:
        'Your Favorite Books. Anytime, Anywhere. Listen and Read with ListenLit.',
    image: AppImagePath.kOnboarding1,
  ),
  OnBoarding(
    title:
        'Experience Your Favorite Audio Books Like Never Before with ListenLit',
    image: AppImagePath.kOnboarding2,
  ),
  OnBoarding(
    title:
        "Immerse Yourself in Your Favorite Books with ListenLit's Premium Audio books",
    image: AppImagePath.kOnboarding3,
  ),
];
