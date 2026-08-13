import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_themes.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/features/authentication/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'core/constants/app_url.dart';
import 'core/constants/debendency_injection.dart' as di;
import 'core/helper/app_bloc_observer.dart';
import 'core/helper/local_storage.dart';
import 'core/routing/router.dart';
import 'features/blog/presentation/bloc/faq_cubit.dart';
import 'features/complaints/presentation/bloc/complaint_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await di.init();
  await LocalStorage().init();
  await EasyLocalization.ensureInitialized();
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
        BlocProvider(create: (_) => di.getIt<ApplicationCubit>()),
        BlocProvider(create: (_) => di.getIt<AuthenticationCubit>()),
        BlocProvider(create: (_) => di.getIt<ResetPasswordCubit>()),
        BlocProvider(create: (_) => di.getIt<ChatBotCubit>()),
        BlocProvider(create: (_) => di.getIt<UsedSystemCubit>()),
        BlocProvider(create: (_) => di.getIt<FavoritesCubit>()),
        BlocProvider(create: (_) => di.getIt<CartCubit>()),
        BlocProvider(create: (_) => di.getIt<OrdersCubit>()),
        BlocProvider(create: (_) => di.getIt<FaqCubit>()),
        BlocProvider(create: (_) => di.getIt<ComplaintCubit>()),
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
                LocalStorage().saveData(key: StorageKeys.langCode, value: locale.languageCode);
              }
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'SolarHub',
                darkTheme: AppThemes.darkTheme,
                theme: AppThemes.lightTheme,
                themeMode: mode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}
