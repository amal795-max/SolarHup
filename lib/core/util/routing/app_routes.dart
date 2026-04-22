import "package:driver_app/features/screens/home_page/delivery_info.dart";
import "package:driver_app/features/screens/profile/add_vehicle_screen.dart";
import "package:driver_app/features/screens/profile/profile_details_screen.dart";
import "package:driver_app/features/screens/profile/vehicle_screen.dart";
import "package:driver_app/features/screens/tasks/task_details_screen.dart";
import "package:get/get.dart";
import "../../../features/screens/authentication/login_screen.dart";
import "../../../features/screens/authentication/splash_screen.dart";
import "../../../features/screens/home_page/custom_bottom_navbar.dart";
import "../../../features/screens/profile/privacy_policy_screen.dart";
import "../../../features/widgets/no_internet_screen.dart";
import "paths.dart";

List<GetPage<dynamic>> routesApp = [
 GetPage(name: Paths.loginScreen, page: () => const LoginScreen()),
 GetPage(name: Paths.splashScreen, page: () => const SplashScreen()),

 GetPage(name: Paths.profileDetailsScreen, page: () =>  ProfileDetailsScreen()),

];
