import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../config/theme/app_color.dart';
import 'custom_text.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    this.icon,
    this.onTap,
    this.borderColor,
    this.buttonColor = AppColor.primaryColor,
    this.textColor = Colors.white,
  });

  final double height;
  final double width;
  final String text;
  final String? icon;
  final void Function()? onTap;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: buttonColor,
            border: Border.all(color: borderColor ?? Colors.transparent)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon ?? "",
              height: 24.h,
              width: 24.w,
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: text,
              size: 16.sp,
              weight: FontWeight.w700,
              color: textColor,
            )
          ],
        ),
      ),
    );
  }
}
