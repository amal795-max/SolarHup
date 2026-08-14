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
import 'package:untitled1/features/catalog/presentation/pages/discounted_products_screen.dart';
import 'package:untitled1/features/home/presentation/pages/navigation_bar.dart';
import 'package:untitled1/features/settings/presentation/pages/settings_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/all_questions_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/solar_learning_hub_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/blog_article_detail_screen.dart';
import 'package:untitled1/features/blog/presentation/pages/blog_screen.dart';
import 'package:untitled1/features/product_compare/presentation/pages/product_compare_screen.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/data/models/service_booking_draft.dart';
import 'package:untitled1/features/services/presentation/pages/rate_service_screen.dart';
import 'package:untitled1/features/services/presentation/pages/service_request_detail_screen.dart';
import 'package:untitled1/features/services/presentation/pages/booking_confirmation_screen.dart';
import 'package:untitled1/features/services/presentation/pages/service_address_screen.dart';
import 'package:untitled1/features/services/presentation/pages/schedule_service_screen.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_route_args.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_screen.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_picker_route_args.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_picker_screen.dart';
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
import '../../features/reviews/presentation/pages/reviews_screen.dart';
import '../../features/used_system/presentation/pages/filters_screen.dart';
import '../../features/used_system/presentation/pages/used_product_details_screen.dart';
import '../../features/used_system/presentation/pages/used_products_screen.dart';
import '../../features/favorite/presentation/pages/favorites_screen.dart';
import 'package:untitled1/features/settings/presentation/pages/privacy_policy_screen.dart';
import '../../features/complaints/presentation/pages/my_complaints_screen.dart';
import '../../features/complaints/presentation/pages/complaint_details_screen.dart';
import '../../features/complaints/presentation/pages/add_complaint_screen.dart';
import '../../features/consultation/presentation/pages/ask_expert_screen.dart';
import '../../features/consultation/presentation/pages/my_questions_screen.dart';

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
        final storeId = state.extra as int ;
        return StoreInfoScreen(storeId: storeId);
      },
    ),
    GoRoute(
      path: AppRoutes.storeKitScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as StoreKitRouteArgs?;
        return StoreKitScreen(
          args: args ??
              const StoreKitRouteArgs(storeId: 0, storeName: ''),
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
                businessId: 0,
                productId: '0',
              ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workshopPickerScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as WorkshopPickerRouteArgs?;
        return WorkshopPickerScreen(
          args: args ??
              const WorkshopPickerRouteArgs(
                categoryId: 0,
                categoryName: '',
              ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workshopInfoScreen,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as WorkshopInfoRouteArgs?;
        return WorkshopInfoScreen(
          args: args ??
              const WorkshopInfoRouteArgs(workshopId: '0'),
        );
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
        final draft = state.extra is ServiceBookingDraft
            ? state.extra as ServiceBookingDraft
            : null;
        return ScheduleServiceScreen(
          serviceId: serviceId,
          draft: draft,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.serviceAddressBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'svc-1';
        final draft = state.extra! as ServiceBookingDraft;
        return ServiceAddressScreen(
          serviceId: serviceId,
          draft: draft,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.bookingConfirmationBase}/:serviceId',
      builder: (BuildContext context, GoRouterState state) {
        final booking = state.extra! as BookingConfirmationModel;
        return BookingConfirmationScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '${AppRoutes.serviceRequestDetailBase}/:requestId',
      builder: (BuildContext context, GoRouterState state) {
        final requestId = int.tryParse(state.pathParameters['requestId'] ?? '') ?? 0;
        return ServiceRequestDetailScreen(requestId: requestId);
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
        return const ProductCompareScreen();
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
        final extra = state.extra as Map<String, dynamic>?;
        return RateOrderScreen(
          storeId: extra?['storeId']?.toString(),
          storeName: extra?['storeName'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.activityScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const ActivityScreen();
      },
    ),
       GoRoute(
      path: AppRoutes.discountedProductsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const DiscountedProductsScreen();
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
    GoRoute(
      path: AppRoutes.privacyPolicyScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const PrivacyPolicyScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.myComplaintsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const MyComplaintsScreen();
      },
    ),
    GoRoute(
      path: '${AppRoutes.addComplaintScreen}/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AddComplaintScreen(businessId: id);
      },
    ),


    GoRoute(
      path: '${AppRoutes.complaintDetailsScreenBase}/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return ComplaintDetailsScreen(complaintId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.reviewsScreen,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ReviewsScreen(
          itemType: extra['itemType'] as String,
          itemId: extra['itemId'] as String,
          itemName: extra['itemName'] as String,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.askExpertScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const AskExpertScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.myQuestionsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const MyQuestionsScreen();
      },
    ),
  ],
);
