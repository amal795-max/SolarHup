import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/authentication/presentation/pages/change_password_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/login_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/register_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/reset_password_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/splash_screen.dart';
import 'package:untitled1/features/authentication/presentation/pages/verification_screen.dart';
import 'package:untitled1/features/chatbot/presentation/pages/chatbot_screen.dart';
import 'package:untitled1/features/home/presentation/pages/home_screen.dart';
import 'package:untitled1/features/settings/presentation/pages/my_discounts_screen.dart';
import 'package:untitled1/features/home/presentation/pages/navigation_bar.dart';
import 'package:untitled1/features/settings/presentation/pages/settings_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/all_questions_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/solar_learning_hub_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/blog_article_detail_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/blog_screen.dart';
import 'package:untitled1/features/consultation/presentation/pages/book_consultation_screen.dart';
import 'package:untitled1/features/package_comparison/presentation/pages/package_comparison_screen.dart';
import 'package:untitled1/features/services/presentation/pages/rate_service_screen.dart';
import 'package:untitled1/features/services/presentation/pages/booking_confirmation_screen.dart';
import 'package:untitled1/features/services/presentation/pages/service_address_screen.dart';
import 'package:untitled1/features/services/presentation/pages/schedule_service_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/stores_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/cart_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/shipping_information.dart';
import 'package:untitled1/features/orders/presentation/pages/order_confirmed_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/order_tracking_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/rate_order_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/activity_screen.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/presentation/pages/add_used_system/add_used_product_screen.dart';
import 'package:untitled1/features/used_system/presentation/pages/my_listinig_screen.dart';
import '../../features/authentication/presentation/pages/authentication_screen.dart';
import '../../features/authentication/presentation/pages/onboarding_screen.dart';
import '../../features/used_system/presentation/pages/filters_screen.dart';
import '../../features/used_system/presentation/pages/used_product_details_screen.dart';
import '../../features/used_system/presentation/pages/used_products_screen.dart';
import '../../features/favorite/presentation/pages/favorites_screen.dart';

import 'package:untitled1/core/routing/router_keys.dart';

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },),
    GoRoute(
      path: AppRoutes.onboardingScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },),
    GoRoute(
      path: AppRoutes.authenticationScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AuthenticationScreen();
      },),
    GoRoute(
      path: AppRoutes.bottomNavBar,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomBottomNavBar();
      },),
    GoRoute(
      path: AppRoutes.homeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },),
    GoRoute(
      path: AppRoutes.bottomNavBar,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomBottomNavBar();
      },),


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
        final isReset = state.extra as bool? ?? false;
        return  VerificationScreen(isResetPassword: isReset);
      },),
    GoRoute(
      path: AppRoutes.resetPasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ResetPasswordScreen();
      },),
    GoRoute(
      path: AppRoutes.changePasswordScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
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
    GoRoute(
      path: AppRoutes.storeInfoScreen,
      builder: (BuildContext context, GoRouterState state) {
        final storeId = state.extra as String? ?? '';
        return StoreInfoScreen(storeId: storeId);
      },
    ),
    GoRoute(
      path: AppRoutes.storeKitScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as StoreKitRouteArgs?;
        return StoreKitScreen(
          args: args ??
              const StoreKitRouteArgs(storeId: '', storeName: ''),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.productDetailScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as ProductDetailRouteArgs?;
        return ProductDetailScreen(
          args: args ??
              const ProductDetailRouteArgs(
                businessId: '0',
                productId: '0',
              ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookConsultationScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const BookConsultationScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.blogScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const BlogScreen();
      },
      routes: [
        GoRoute(
          path: ':articleId',
          builder: (BuildContext context, GoRouterState state) {
            final articleId = state.pathParameters['articleId'] ?? 'blog-2';
            return BlogArticleDetailScreen(articleId: articleId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '${AppRoutes.blogArticleDetailBase}/:articleId',
      builder: (BuildContext context, GoRouterState state) {
        final articleId = state.pathParameters['articleId'] ?? 'blog-2';
        return BlogArticleDetailScreen(articleId: articleId);
      },
    ),
    GoRoute(
      path: AppRoutes.solarLearningHubScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SolarLearningHubScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.allQuestionsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AllQuestionsScreen();
      },
    ),
    GoRoute(
      path: '${AppRoutes.scheduleServiceBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'svc-1';
        return ScheduleServiceScreen(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.serviceAddressBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'svc-1';
        return ServiceAddressScreen(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.bookingConfirmationBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'svc-1';
        return BookingConfirmationScreen(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.rateServiceBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'svc-1';
        return RateServiceScreen(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: AppRoutes.packageComparisonScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const PackageComparisonScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.cartScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const CartScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.shippingInformationScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ShippingInformationScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.orderConfirmedScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const OrderConfirmedScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.orderTrackingScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const OrderTrackingScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.rateOrderScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const RateOrderScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.activityScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ActivityScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.discountsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const MyDiscountsScreen(

        );
      },
    ),
    GoRoute(
      path: AppRoutes.chatBotScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ChatbotScreen();
      },
    ), GoRoute(
      path: AppRoutes.settingsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.usedProductDetailScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as UsedProductModel;
        return  UsedProductDetailsScreen( product: args,);
      },
    ),
    GoRoute(
      path: AppRoutes.favoritesScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const FavoritesScreen();
      },
    ),
  ],
);
