import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/authentication/presentation/pages/authentication_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/login_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/register_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/reset_password_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/verification_screen.dart';

import '../../features/authentication/presentation/pages/check_email.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthenticationScreen();
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

  ],

);