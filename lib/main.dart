import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/theme.dart';
import 'package:untitled1/core/theme/app_themes.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';

import 'core/helper/local_storage.dart';
import 'core/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalStorage().init();
  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
      path: 'assets/language',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ApplicationCubit())
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ApplicationCubit, ApplicationState>(
            builder: (context, state) {
              ThemeMode mode = ThemeMode.light;
              Locale locale = const Locale('ar');
              if (state is ApplicationMainState) {
                mode = state.themeMode;
                locale = state.locale;
              }
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'SolarHub',
                darkTheme: AppThemes.darkTheme,
                theme: AppThemes.lightTheme,
                themeMode: mode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: locale,
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                  for (var local in supportedLocales) {
                    if (deviceLocal != null && deviceLocal.languageCode == local.languageCode) {
                      return deviceLocal;
                    }
                  }
                  return supportedLocales.first;
                },
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}
