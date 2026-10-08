import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:listen_lit_app/features/auth/login/screens/login_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../../../data/services/storage_service.dart';
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
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndProceed() async {
    PermissionStatus status = await Permission.audio.status;
    if (!mounted) return;
    if (!status.isGranted) {
      status = await Permission.audio.request();
      if (!mounted) return;
    }
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!mounted) return;
    }

    if (status.isGranted) {
      await StorageService.setPermissionHandled(true);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColor.kSamiDarkColor,
          title: Text('Permission Required', style: TextStyle(color: AppColor.kLightAccentColor)),
          content: Text(
            'Storage permission is permanently denied. Please enable it in app settings to play music from your device.',
            style: TextStyle(color: AppColor.kGreyColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColor.kGreyColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: Text('Open Settings', style: TextStyle(color: AppColor.kPrimary)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage access is required to access local device music.')),
      );
      await StorageService.setPermissionHandled(true);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            width * 0.06,
                            cardAreaHeight * 0.02,
                            width * 0.06,
                            cardAreaHeight * 0.04,
                          ),
                          child: PrimaryButton(
                            onTap: () {
                              if (_currentIndex == pageViewList.length - 1) {
                                _requestPermissionAndProceed();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            text: _currentIndex == pageViewList.length - 1
                                ? 'Allow Access & Get Started'
                                : 'Continue',
                            bgColor: AppColor.kPrimary,
                            borderRadius: 10,
                            height: 52,
                            width: double.infinity,
                            textColor: AppColor.kWhiteColor,
                            fontSize: width * 0.042,
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
