import 'package:flutter/material.dart';
import '../../../../app/constant/app_colors.dart';

class DividerRow extends StatelessWidget {
  const DividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: AppColor.kGreyColor,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
