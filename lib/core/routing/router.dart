import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/authentication/presentation/pages/authentication_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/login_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/register_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/reset_password_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/verification_screen.dart';
import 'package:untitled1/features/home/presentation/pages/home_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/stores_screen.dart';
import 'package:untitled1/features/used_system/presentation/pages/add_used_system/add_used_product_screen.dart';
import 'package:untitled1/features/used_system/presentation/pages/my_listinig_screen.dart';

import '../../features/authentication/presentation/pages/check_email.dart';
import '../../features/used_system/presentation/pages/filters_screen.dart';
import '../../features/used_system/presentation/pages/used_products_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthenticationScreen();
      },),
    GoRoute(
      path: AppRoutes.homeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },),
    
    GoRoute(
      path: AppRoutes.splashScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const CheckEmailPage();
      },) ,
    GoRoute(
      path: AppRoutes.loginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },),
    GoRoute(
      path: AppRoutes.registerScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },),
   GoRoute(
      path: AppRoutes.verificationScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const VerificationScreen();
      },),
    GoRoute(
      path: AppRoutes.resetPasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ResetPasswordScreen();
      },),
    GoRoute(
      path: AppRoutes.addProductScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AddUsedProductScreen();
      },),
    GoRoute(
      path: AppRoutes.usedProductScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const UsedProductsScreen();
      },),
    GoRoute(
      path: AppRoutes.filterProductScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const FiltersScreen();
      },),
    GoRoute(
      path: AppRoutes.myListeningScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const MyListingScreen();
      },),
    GoRoute(
      path: AppRoutes.storesScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const StoresScreen();
      },),

  ],

);