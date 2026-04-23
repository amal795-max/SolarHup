import "dart:async";
import "dart:developer";
import "package:driver_app/features/screens/authentication/splash_screen.dart";
import "package:driver_app/features/screens/home_page/controller/socket_controller.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "core/constants/app_themes.dart";
import "core/translation/translation.dart";
import "core/util/helper/loader_controller.dart";
import "core/util/network/check_internet.dart";
import "core/util/routing/app_routes.dart";
import "core/util/routing/paths.dart";
import "core/util/routing/route_controller.dart";
import "data/data_sources/api_provider.dart";

Future<void> main() async {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      Get.put(RouteController());
      Get.put(LoaderController());
      Get.put(SocketController());

      await GetStorage.init();
      ApiProvider.initialize();
      runApp(const MyApp());
    },
        (dynamic error, StackTrace stackTrace) {
      log("=================== $error ===================");
      log("=================== $stackTrace ===================");
      routeController.enable = false;
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  // Future<dynamic> getCurrentUser() async {
  //   await localStorageServices.getCurrentUser();
  // }
  //
  Future<dynamic> checkInternet() async {
    bool isConnected = await CheckInternet.checkConnect();
    // print(isConnected);
    if (!isConnected) {
      await routeController.goNamedAndRemoveUntil(
        Paths.noInternetScreen,
        arguments: <dynamic>[],
      );
      routeController.enable = false;
    }
  }

  @override
  void initState() {
    getConfiguration();

    super.initState();
  }

  Future<dynamic> getConfiguration() async {
    await checkInternet();
    // await getCurrentUser();
    // await settingsController.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: (context, child) {
            return MediaQuery.withNoTextScaling(child: child!);
          },
          debugShowCheckedModeBanner: false,
          getPages: routesApp,
          theme: AppThemes.lightTheme,
          //        darkTheme: AppThemes.darkTheme,
          defaultTransition: Transition.cupertino,
          locale: Locale("en"),
          fallbackLocale: Locale("en"),
          translations: Messages(),
          //   themeMode:
          // settingsController.selectedTheme == Brightness.dark
          //     ? ThemeMode.dark
          //     : settingsController.selectedTheme == Brightness.light
          //     ? ThemeMode.light
          //     : ThemeMode.system,system
          home: SplashScreen(),
        );
      },
    );
  }
}
