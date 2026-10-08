import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColor.kPrimary));
  }
}
