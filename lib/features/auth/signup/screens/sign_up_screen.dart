import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listen_lit_app/features/auth/login/screens/login_screen.dart';
import '../../../../core/constant/app_colors.dart';
import '../../login/widgets/background_image_container.dart';
import '../../login/widgets/custom_rich_text.dart';
import '../../login/widgets/primary_button.dart';
import '../../login/widgets/primary_text_form_field.dart';
import '../widgets/password_text_field.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../../main_navigation/views/main_navigation_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();

    return BackgroundImageContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColor.kLightAccentColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
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
                      const SizedBox(height: 12),
                      CustomRichText(
                        title: 'Looks like you don’t have an account.',
                        subtitle: 'Let’s create a new account for you.',
                        subtitleTextStyle: TextStyle(
                          color: AppColor.kLightAccentColor,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onTab: () {},
                      ),
                      const SizedBox(height: 24),
                      PrimaryTextFormField(
                        hintText: 'Name',
                        controller: nameController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        height: 48,
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextFormField(
                        hintText: 'Email',
                        controller: emailController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        height: 48,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        hintText: 'Password',
                        controller: passController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        height: 48,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        onTap: () async {
                          await authVM.signup(
                            nameController.text.isEmpty
                                ? 'New User'
                                : nameController.text,
                            emailController.text,
                            passController.text,
                          );
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
                        text: 'Create Account',
                        textColor: AppColor.kWhiteColor,
                        bgColor: AppColor.kPrimary,
                      ),
                      const SizedBox(height: 24),
                      CustomRichText(
                        subtitle: ' Log in',
                        title: 'Already have an account?',
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
                              builder: (context) => LoginScreen(),
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
