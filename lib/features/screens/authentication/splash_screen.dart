
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/asset_path.dart';
import '../../../core/util/routing/paths.dart';
import '../../../core/util/routing/route_controller.dart';
import '../../../services/driver/location_services.dart';
import '../../../services/local_storage_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async{
      bool ok = await LocationService.requestPermission();
      if (ok) {
        await localStorageServices.isFirstOpen()
            ? routeController.goReplacementNamed(Paths.bottomNavbarScreens)
            : routeController.goReplacementNamed(Paths.loginScreen);
      } else {
        Get.defaultDialog(
          title: "Location Required",
          middleText: "Please enable location to continue",
        );
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: SvgPicture.asset(ImagesPaths.splashLogo)),
          ).animate().fade().scale().move(delay: 300.ms, duration: 600.ms),
          Image.asset(ImagesPaths.bottomImage),
        ],
      ),
    );
  }
}
