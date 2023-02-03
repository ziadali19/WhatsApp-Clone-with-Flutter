import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/common/custom_button.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.h,
              ),
              Text(
                'Welcome to WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 33.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 80.sp,
              ),
              Image.asset(
                'assets/images/landingimg.png',
                height: 340.h,
                width: 340.w,
                color: AppConstants.tabColor,
              ),
              SizedBox(
                height: 100.sp,
              ),
              Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: AppConstants.greyColor,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onTap: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
