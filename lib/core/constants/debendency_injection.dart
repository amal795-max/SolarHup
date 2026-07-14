import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/features/authentication/data/data-source/authentication/authentication_remote_data_source.dart';
import 'package:untitled1/features/authentication/data/repositories/authentication_repo.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:untitled1/features/blog/data/data_source/blog_detail_remote_data_source.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';
import 'package:untitled1/features/blog/data/repositories/blog_detail_repository.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_cubit.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_detail_cubit.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';
import '../network/check_internet.dart';

final getIt= GetIt.instance;


Future<void> init() async {

  getIt.registerLazySingleton<Dio>(() =>Dio());

  getIt.registerLazySingleton<ApiRequest>(() => ApiRequest(dio: getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(getIt()));

  getIt.registerLazySingleton<AuthenticationRepositories>(() => AuthenticationRepositoriesImpl(remoteAuth: getIt(), networkInfo: getIt(),),);

  getIt.registerFactory(() => AuthenticationCubit(getIt()));
  getIt.registerFactory(() => ApplicationCubit());

  getIt.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(remote: getIt(), networkInfo: getIt()),
  );

  getIt.registerFactory(() => BlogCubit(getIt()));

  getIt.registerLazySingleton<BlogDetailRemoteDataSource>(
    () => BlogDetailRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<BlogDetailRepository>(
    () => BlogDetailRepositoryImpl(remote: getIt(), networkInfo: getIt()),
  );

  getIt.registerFactory(() => BlogDetailCubit(getIt()));
}
