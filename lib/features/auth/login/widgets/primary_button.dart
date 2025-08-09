import 'package:flutter/cupertino.dart';
import '../../../../app/constant/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width, height, borderRadius, fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;

  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    required this.textColor,
    required this.bgColor,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 55,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) ...[
              Icon(iconData, color: AppColor.kWhiteColor),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize ?? 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
