import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/utilis/constants.dart';

import '../../../../core/services/service_locator.dart';
import '../../controller/cubit/contacts_cubit.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});
  static const routeName = '/contacts';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactsCubit>()..getContacts(),
      child: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          ContactsCubit cubit = ContactsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Select contact',
              ),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            body: state is GetContactsLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.tabColor,
                    ),
                  )
                : ListView.separated(
                    itemCount: cubit.contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          cubit.selectContact(cubit.contacts[index], context);
                        },
                        child: ListTile(
                          leading: cubit.contacts[index].photo == null
                              ? null
                              : CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage:
                                      MemoryImage(cubit.contacts[index].photo!),
                                ),
                          title: Text(
                            cubit.contacts[index].displayName,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                          color: AppConstants.dividerColor, indent: 0);
                    },
                  ),
          );
        },
      ),
    );
  }
}
