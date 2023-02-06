import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/auth/presentation/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/chat/data/repository/chat_repository.dart';

import 'package:whatsapp_clone/features/landing/presentation/screens/landing_screen.dart';
import 'package:whatsapp_clone/features/layout/presentation/screens/layout_screen.dart';
import 'package:whatsapp_clone/firebase_options.dart';

import 'core/services/service_locator.dart';
import 'core/utilis/bloc_observer.dart';
import 'core/utilis/cashe_helper.dart';
import 'core/utilis/constants.dart';
import 'core/utilis/themes.dart';
import 'features/auth/controller/cubit/auth_cubit.dart';
import 'features/auth/controller/cubit/otb_cubit.dart';
import 'features/auth/controller/cubit/user_information_cubit.dart';
import 'features/layout/controller/cubit/layout_cubit.dart';
import 'features/select_contacts/controller/cubit/contacts_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServicesLocator.init();
  await CasheHelper.init();
  AppConstants.uID = CasheHelper.getData('uID') as String?;
  AppConstants.user = CasheHelper.getData('user') as String?;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<OtbCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<UserInformationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<LayoutCubit>(),
        )
        /*  BlocProvider(
          create: (context) => sl<ContactsCubit>()..getContacts(),
        )*/
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) =>
                AppConstants.onGenerateRoute(settings),
            darkTheme: Themes().darkTheme(),
            themeMode: ThemeMode.dark,
            home: AppConstants.uID != null && AppConstants.user == null
                ? const UserInformationScreen()
                : AppConstants.uID != null && AppConstants.user != null
                    ? LayoutScreen(
                        baseChatRepository: sl<BaseChatRepository>(),
                      )
                    : const LandingScreen(),
          );
        },
      ),
    );
  }
}
