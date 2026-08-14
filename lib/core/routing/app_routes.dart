abstract class AppRoutes {
  static const splashScreen = '/';
  static const onboardingScreen = '/onboardingScreen';
  static const loginScreen = '/loginScreen';
  static const registerScreen = '/registerScreen';
  static const authenticationScreen='/serviceAddressScreen';
  static const bottomNavBar = '/bottomNavBar';
  static const homeScreen = '/homeScreen';
  static const verificationScreen = '/verificationScreen';
  static const resetPasswordScreen = '/resetPasswordScreen';
  static const changePasswordScreen = '/changePasswordScreen';
  static const addProductScreen = '/addProductScreen';
  static const usedProductScreen = '/usedProductScreen';
  static const filterProductScreen = '/filterProductScreen';
  static const myListeningScreen = '/myListeningScreen';
  static const storesScreen = '/storesScreen';
  static const storeInfoScreen = '/storeInfoScreen';
  static const storeKitScreen = '/storeKitScreen';
  static const productDetailScreen = '/productDetailScreen';
  static const workshopPickerScreen = '/workshopPickerScreen';
  static const workshopInfoScreen = '/workshopInfoScreen';
  static const cartScreen = '/cartScreen';
  static const shippingInformationScreen = '/shippingInformationScreen';
  static const orderConfirmedScreen = '/orderConfirmedScreen';
  static const orderTrackingScreen = '/orderTrackingScreen';
  static const rateOrderScreen = '/rateOrderScreen';
  static const activityScreen = '/activityScreen';
  static const discountsScreen = '/discountsScreen';
  static const discountedProductsScreen = '/discountedProductsScreen';
  static const bookConsultationScreen = '/bookConsultationScreen';
  static const chatBotScreen = '/chatBotScreen';
  static const settingsScreen = '/settingsScreen';
  static const blogScreen = '/blogScreen';
  static const blogArticleDetailBase = '/blogArticleDetailScreen';

  static String blogArticleDetail(String articleId) => '$blogArticleDetailBase/$articleId';
  static const solarLearningHubScreen = '/solarLearningHubScreen';
  static const allQuestionsScreen = '/allQuestionsScreen';
  static const scheduleServiceBase = '/scheduleServiceScreen';
  static const usedProductDetailScreen = '/usedProductDetailScreen';

  static String scheduleService(String serviceId) =>
      '$scheduleServiceBase/$serviceId';
  static const serviceAddressBase = '/serviceAddressScreen';

  static String serviceAddress(String serviceId) =>
      '$serviceAddressBase/$serviceId';
  static const bookingConfirmationBase = '/bookingConfirmationScreen';

  static String bookingConfirmation(String serviceId) =>
      '$bookingConfirmationBase/$serviceId';
  static const rateServiceBase = '/rateServiceScreen';

  static String rateService(String serviceId) => '$rateServiceBase/$serviceId';
  static const packageComparisonScreen = '/packageComparisonScreen';
  static const favoritesScreen = '/favoritesScreen';
  static const privacyPolicyScreen = '/privacyPolicyScreen';
  static const myComplaintsScreen = '/myComplaintsScreen';
  static const addComplaintScreen = '/addComplaintScreen';
  static const complaintDetailsScreenBase = '/complaintDetailsScreen';
  static String complaintDetails(String id) => '$complaintDetailsScreenBase/$id';
  static const reviewsScreen = '/reviewsScreen';
}
