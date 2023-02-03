import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../controller/cubit/otb_cubit.dart';

class OTBScreen extends StatelessWidget {
  final String? verficationId;
  static const routeName = '/otp';
  const OTBScreen({super.key, required this.verficationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              Text(
                'We have sent an SMS with a code.',
                style: TextStyle(fontSize: 15.sp),
              ),
              BlocBuilder<OtbCubit, OtbState>(
                builder: (context, state) {
                  return Center(
                    child: Column(
                      children: [
                        state is OtbLoading
                            ? const LinearProgressIndicator(
                                color: AppConstants.tabColor,
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.trim().length == 6) {
                                      OtbCubit.get(context).verifyOTB(
                                          context, verficationId!, value);
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      hintText: '- - - - - -',
                                      hintStyle: TextStyle(fontSize: 30.sp)),
                                ),
                              ),
                      ],
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
