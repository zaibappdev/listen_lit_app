import 'package:flutter/material.dart';
import 'package:listen_lit_app/features/auth/login/screens/login_Screen.dart';
import '../../../app/constant/app_colors.dart';
import '../../auth/login/widgets/primary_button.dart';
import '../widgets/on_boarding.dart';
import '../widgets/on_boarding_card.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose(); // <- important: dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxH = constraints.maxHeight;
            final imageAreaHeight = maxH * 0.50;
            final cardAreaHeight = maxH - imageAreaHeight;

            return Column(
              children: [
                // Top Image area (updates with current page)
                SizedBox(
                  height: imageAreaHeight,
                  width: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Image.asset(
                        pageViewList[_currentIndex].image,
                        fit: BoxFit.contain,
                        width: width * 0.7,
                        height: imageAreaHeight * 0.85,
                      ),
                    ),
                  ),
                ),

                // Bottom sliding card with PageView
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.kGrey3Color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        // PageView (titles / descriptions)
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: pageViewList.length,
                            onPageChanged: (idx) {
                              setState(() {
                                _currentIndex = idx;
                              });
                            },
                            itemBuilder: (context, index) {
                              final item = pageViewList[index];
                              return OnboardingCard(
                                item: item,
                                index: index,
                                total: pageViewList.length,
                                currentIndex: _currentIndex,
                                onDotTapped: (i) {
                                  _pageController.animateToPage(
                                    i,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // Bottom button area (responsive padding)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            width * 0.06,
                            cardAreaHeight * 0.02,
                            width * 0.06,
                            cardAreaHeight * 0.04,
                          ),
                          child: PrimaryButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            text: _currentIndex == pageViewList.length - 1
                                ? 'Get Started'
                                : 'Continue',
                            bgColor: AppColor.kPrimary,
                            borderRadius: 10,
                            height: 52,
                            width: double.infinity,
                            textColor: AppColor.kWhiteColor,
                            fontSize: width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
