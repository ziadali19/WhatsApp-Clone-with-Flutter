import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onTap});
  final String text;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.tabColor,
            minimumSize: Size(double.infinity, 50.h)),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(color: AppConstants.blackColor),
        ));
  }
}
