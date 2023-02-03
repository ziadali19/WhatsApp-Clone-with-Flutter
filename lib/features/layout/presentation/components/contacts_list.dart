import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utilis/constants.dart';
import '../screens/chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ChatScreen.routeName);
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: ListTile(
                    title: Text(
                      info[index]['name'].toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6.0.h),
                      child: Text(
                        info[index]['message'].toString(),
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        info[index]['profilePic'].toString(),
                      ),
                      radius: 30.r,
                    ),
                    trailing: Text(
                      info[index]['time'].toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: AppConstants.dividerColor, indent: 85.w),
            ],
          );
        },
      ),
    );
  }
}
