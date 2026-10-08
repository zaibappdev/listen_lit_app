import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_images.dart';
import '../../signup/screens/sign_up_screen.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_rich_text.dart';
import '../widgets/divider_row.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_button.dart';
import '../widgets/primary_text_form_field.dart';
import '../widgets/social_login_button.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../../main_navigation/views/main_navigation_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: BackgroundImageContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.25),
                Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: AppColor.kLightAccentColor,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.kSamiDarkColor.withValues(alpha: 0.4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.kSamiDarkColor.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      PrimaryTextFormField(
                        hintText: 'Email',
                        controller: emailController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        width: double.infinity,
                        height: 48,
                        fillColor: AppColor.kLightAccentColor,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        onTap: () async {
                          await authVM.login(emailController.text, 'password');
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainNavigationScreen(),
                            ),
                          );
                        },
                        borderRadius: 8,
                        fontSize: 14,
                        height: 48,
                        width: double.infinity,
                        text: 'Continue',
                        textColor: AppColor.kWhiteColor,
                        bgColor: AppColor.kPrimary,
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextButton(
                        title: 'Forgot password?',
                        fontSize: 14,
                        onPressed: () {},
                        textColor: AppColor.kPrimary,
                      ),
                      const SizedBox(height: 32),
                      const DividerRow(),
                      const SizedBox(height: 32),
                      SocialLoginButton(
                        text: 'Login with Facebook',
                        iconPath: AppImagePath.kLogoFacebook,
                        onTap: () async {
                          await authVM.login('facebook@user.com', 'password');
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainNavigationScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SocialLoginButton(
                        text: 'Login with Google',
                        iconPath: AppImagePath.kGoogleLogo,
                        onTap: () async {
                          await authVM.login('google@user.com', 'password');
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainNavigationScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SocialLoginButton(
                        text: 'Login with Apple',
                        iconPath: AppImagePath.kApple,
                        onTap: () async {
                          await authVM.login('apple@user.com', 'password');
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainNavigationScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomRichText(
                        subtitle: ' Sign up ',
                        title: 'Don’t have an account?',
                        subtitleTextStyle: TextStyle(
                          color: AppColor.kPrimary,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                        onTab: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
