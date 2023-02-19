import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../controller/cubit/call_cubit.dart';
import '../../data/model/call_model.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key, required this.scaffold});
  final Widget scaffold;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        CallCubit cubit = CallCubit.get(context);
        return StreamBuilder<CallModel>(
          stream: cubit.callsStream(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.hasCall) {
                return Scaffold(
                  backgroundColor: AppConstants.chatBarMessage,
                  body: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60.r,
                                backgroundImage:
                                    NetworkImage(snapshot.data!.callerPic),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                snapshot.data!.callerName,
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                'WhatsApp voice call',
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.all(40.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RawMaterialButton(
                                      constraints: BoxConstraints(
                                          minWidth: 70.w, minHeight: 70.h),
                                      elevation: 0,
                                      onPressed: () {},
                                      shape: const CircleBorder(),
                                      fillColor: Colors.black38,
                                      child: const Icon(
                                        Icons.call_end_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                    RawMaterialButton(
                                      constraints: BoxConstraints(
                                          minWidth: 70.w, minHeight: 70.h),
                                      elevation: 0,
                                      onPressed: () {},
                                      shape: const CircleBorder(),
                                      fillColor: Colors.green,
                                      child: const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            return scaffold;
          },
        );
      },
    );
  }
}
