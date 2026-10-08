import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class AppEmptyView extends StatelessWidget {
  final String message;

  const AppEmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: AppColor.kGreyColor),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.kGreyColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
