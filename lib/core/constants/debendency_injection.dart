import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/features/authentication/data/data-source/authentication/authentication_remote_data_source.dart';
import 'package:untitled1/features/authentication/data/data-source/reset_password/reset_password_remote_data_source.dart';
import 'package:untitled1/features/authentication/data/repositories/authentication_repo.dart';
import 'package:untitled1/features/authentication/data/repositories/reset_password_repo.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/features/authentication/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'package:untitled1/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:untitled1/features/blog/data/data_source/blog_detail_remote_data_source.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';
import 'package:untitled1/features/blog/data/repositories/blog_detail_repository.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_cubit.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_detail_cubit.dart';
import 'package:untitled1/features/chatbot/data/data_source/chat_bot_remote_data_source.dart';
import 'package:untitled1/features/chatbot/data/repositories/chat_bot-repo.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/features/complaints/data/data_sources/complaint_remote_data_source.dart';
import 'package:untitled1/features/complaints/data/repositories/complaint_repository.dart';
import 'package:untitled1/features/catalog/data/data_source/catalog_remote_data_source.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/catalog/presentation/bloc/discounted_products_cubit/discounted_products_cubit.dart';
import 'package:untitled1/features/home/data/data_source/home_remote_data_source.dart';
import 'package:untitled1/features/home/data/repositories/home_repository.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';
import 'package:untitled1/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:untitled1/features/home/presentation/bloc/top_selling_products_cubit/top_selling_products_cubit.dart';
import 'package:untitled1/features/services/data/data_source/service_requests_remote_data_source.dart';
import 'package:untitled1/features/services/data/data_source/workshops_remote_data_source.dart';
import 'package:untitled1/features/services/data/repositories/service_requests_repository.dart';
import 'package:untitled1/features/services/data/repositories/workshops_repository.dart';
import 'package:untitled1/features/services/presentation/bloc/service_categories_cubit/service_categories_cubit.dart';
import 'package:untitled1/features/services/presentation/bloc/service_requests_cubit/service_requests_cubit.dart';
import 'package:untitled1/features/services/presentation/bloc/workshop_detail_cubit/workshop_detail_cubit.dart';
import 'package:untitled1/features/services/presentation/bloc/workshop_picker_cubit/workshop_picker_cubit.dart';
import 'package:untitled1/features/stores/data/data_source/stores_remote_data_source.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';
import 'package:untitled1/features/stores/data/data_source/product_detail_remote_data_source.dart';
import 'package:untitled1/features/stores/data/repositories/product_detail_repository.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_detail_cubit.dart';
import 'package:untitled1/features/product_compare/data/repositories/product_compare_repository.dart';
import 'package:untitled1/features/product_compare/presentation/cubit/compare_session_cubit.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_cubit.dart';
import 'package:untitled1/features/stores/presentation/bloc/stores_cubit.dart';
import 'package:untitled1/features/used_system/data/data-source/used_system_remote_data_source.dart';
import 'package:untitled1/features/used_system/data/repositories/used_system_repository.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import 'package:untitled1/features/favorite/data/data_sources/favorite_remote_data_source.dart';
import 'package:untitled1/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:untitled1/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/orders/data/datasources/cart_remote_data_source.dart';
import 'package:untitled1/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:untitled1/features/orders/data/repositories/cart_repository.dart';
import 'package:untitled1/features/orders/data/repositories/orders_repository.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:untitled1/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:untitled1/features/settings/data/repositories/settings_repository.dart';
import 'package:untitled1/features/settings/presentation/bloc/settings_cubit.dart';
import '../../features/blog/presentation/bloc/faq_cubit.dart';
import '../../features/complaints/presentation/bloc/complaint_cubit.dart';
import '../../features/consultation/data/data_source/expert_consultation_remote_data_source.dart';
import '../../features/consultation/data/repositories/expert_consultation_repository.dart';
import '../../features/consultation/presentation/bloc/expert_consultation_cubit.dart';
import '../../features/reviews/data/data_sources/reviews_remote_data_source.dart';
import '../../features/reviews/data/repositories/reviews_repository.dart';
import '../../features/reviews/presentation/bloc/reviews_cubit.dart';
import '../network/check_internet.dart';

final getIt= GetIt.instance;


Future<void> init() async {

  getIt.registerLazySingleton<Dio>(() =>Dio());

  getIt.registerLazySingleton<ApiRequest>(() => ApiRequest(dio: getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ResetPasswordRemoteDataSource>(() => ResetPasswordRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ChatBotRemoteDataSource>(() => ChatBotRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(getIt()),);
  getIt.registerLazySingleton<BlogDetailRemoteDataSource>(() => BlogDetailRemoteDataSourceImpl(getIt()),);
  getIt.registerLazySingleton<UsedSystemRemoteDataSource>(() => UsedSystemRemoteDataSourceImpl(getIt()),);
  getIt.registerLazySingleton<FavoriteRemoteDataSource>(() => FavoriteRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(apiRequest: getIt()));
  getIt.registerLazySingleton<OrdersRemoteDataSource>(() => OrdersRemoteDataSourceImpl(apiRequest: getIt()));
  getIt.registerLazySingleton<ComplaintRemoteDataSource>(() => ComplaintRemoteDataSourceImpl( getIt()));
  getIt.registerLazySingleton<ExpertConsultationRemoteDataSource>(() => ExpertConsultationRemoteDataSourceImpl(getIt(),));
  getIt.registerLazySingleton<SettingsRemoteDataSource>(() => SettingsRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<ReviewsRemoteDataSource>(() => ReviewsRemoteDataSourceImpl(apiRequest: getIt()));

  getIt.registerLazySingleton<AuthenticationRepositories>(() => AuthenticationRepositoriesImpl(remoteAuth: getIt(), networkInfo: getIt(),),);
  getIt.registerLazySingleton<ResetPasswordRepository>(() => ResetPasswordRepositoryImpl(networkInfo: getIt(), remoteDataSource:getIt()),);
  getIt.registerLazySingleton<ChatBotRepository>(() => ChatBotRepositoryImpl(networkInfo: getIt(), remoteDataSource:getIt()),);
  getIt.registerLazySingleton<BlogRepository>(() => BlogRepositoryImpl(remote: getIt(), networkInfo: getIt()),);
  getIt.registerLazySingleton<BlogDetailRepository>(() => BlogDetailRepositoryImpl(remote: getIt(), networkInfo: getIt()),);
  getIt.registerLazySingleton<UsedSystemRepository>(() => UsedSystemRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),);
  getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<PromotionEligibilityService>(
    () => PromotionEligibilityService(getIt()),
  );
  getIt.registerLazySingleton<ComplaintRepository>(() => ComplaintRepositoryImpl(remote: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<ExpertConsultationRepository>(() => ExpertConsultationRepositoryImpl(remote: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton<ReviewsRepository>(() => ReviewsRepositoryImpl(remote: getIt(), networkInfo: getIt()));

  getIt.registerFactory(() => AuthenticationCubit(getIt()));
  getIt.registerFactory(() => ResetPasswordCubit(getIt()));
  getIt.registerFactory(() => ApplicationCubit());
  getIt.registerFactory(() => ChatBotCubit(getIt()));
  getIt.registerFactory(() => HomeBloc(getIt()));
  getIt.registerFactory(() => BlogCubit(getIt()));
  getIt.registerFactory(() => StoresCubit(getIt()));
  getIt.registerFactory(() => UsedSystemCubit(getIt()));
  getIt.registerFactory(() => FavoritesCubit(getIt()));
  getIt.registerFactory(() => CartCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => OrdersCubit(getIt(), getIt()));
  getIt.registerFactory(() => FaqCubit(getIt()));
  getIt.registerFactory(() => ComplaintCubit(getIt()));
  getIt.registerFactory(() => ExpertConsultationCubit(getIt()));
  getIt.registerFactory(() => SettingsCubit(getIt()));
  getIt.registerFactory(() => ReviewsCubit(repository: getIt()));

  getIt.registerLazySingleton<StoresRemoteDataSource>(() => StoresRemoteDataSourceImpl(getIt()),);
  getIt.registerLazySingleton<StoresRepository>(() => StoresRepositoryImpl(remote: getIt(), networkInfo: getIt()),);

  getIt.registerLazySingleton<ProductDetailRemoteDataSource>(
    () => ProductDetailRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductDetailRepository>(
    () => ProductDetailRepositoryImpl(
      remote: getIt(),
      catalogRemote: getIt(),
      networkInfo: getIt(),
      promotionEligibility: getIt(),
    ),
  );

  getIt.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(
      remote: getIt(),
      productDetailRemote: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remote: getIt(),
      catalogRepository: getIt(),
      blogRepository: getIt(),
      productDetailRemote: getIt(),
      networkInfo: getIt(),
      promotionEligibility: getIt(),
    ),
  );

  getIt.registerFactory(() => DiscountedProductsCubit(getIt(), getIt()));
  getIt.registerFactory(() => TopSellingProductsCubit(getIt()));

  getIt.registerFactory(() => BlogDetailCubit(getIt()));
  getIt.registerLazySingleton<WorkshopsRemoteDataSource>(
    () => WorkshopsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ServiceRequestsRemoteDataSource>(
    () => ServiceRequestsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<WorkshopsRepository>(
    () => WorkshopsRepositoryImpl(remote: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton<ServiceRequestsRepository>(
    () => ServiceRequestsRepositoryImpl(remote: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<ProductCompareRepository>(
    () => ProductCompareRepositoryImpl(
      storesRepository: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<CompareSessionCubit>(
    () => CompareSessionCubit(
      productDetailRepository: getIt(),
      storesRepository: getIt(),
    ),
  );

  getIt.registerFactory(() => StoreDetailCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => StoreKitCubit(getIt(), getIt()));
  getIt.registerFactory(() => ServiceCategoriesCubit(getIt()));
  getIt.registerFactory(() => WorkshopPickerCubit(getIt()));
  getIt.registerFactory(() => WorkshopDetailCubit(getIt(), getIt()));
  getIt.registerFactory(() => ServiceRequestsCubit(getIt()));

  getIt.registerFactory(() => ProductDetailBloc(getIt()));
}
