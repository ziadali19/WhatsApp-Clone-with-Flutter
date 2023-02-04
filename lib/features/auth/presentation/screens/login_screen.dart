import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/common/custom_button.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/otb_screen.dart';

import '../../controller/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstants.backgroundColor,
        title: const Text('Enter your phone number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verfiy your phone number.'),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return TextButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (value) {
                            AuthCubit.get(context)
                                .changePhoneCode(value.phoneCode);
                          },
                        );
                      },
                      child: const Text('Pick Country'));
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return Text('+ ${AuthCubit.get(context).phonecode}');
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    AppConstants.showSnackBar(
                        state.errorMsg, context, Colors.red);
                  }
                },
                builder: (context, state) {
                  return state is AuthLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppConstants.tabColor),
                        )
                      : SizedBox(
                          width: 90.w,
                          child: CustomButton(
                            text: 'NEXT',
                            onTap: () {
                              //Navigator.pushNamed(context, OTBScreen.routeName);
                              if (phoneController.text.trim().isNotEmpty) {
                                AuthCubit.get(context).signInWithPhoneNumber(
                                    context,
                                    '+${AuthCubit.get(context).phonecode}${phoneController.text.trim()}');
                              } else {
                                AppConstants.showSnackBar(
                                    'Enter Your Phone Number',
                                    context,
                                    Colors.red);
                              }
                            },
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
