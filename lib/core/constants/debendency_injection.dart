import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/features/authentication/data/data-source/authentication/authentication_remote_data_source.dart';
import 'package:untitled1/features/authentication/data/repositories/authentication_repo.dart';
import 'package:untitled1/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';
import '../network/check_internet.dart';

final getIt= GetIt.instance;


Future<void> init() async {

  getIt.registerLazySingleton<Dio>(() =>Dio());

  getIt.registerLazySingleton<ApiRequest>(() => ApiRequest(dio: getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ResetPasswordRepositories>(
        () => ResetPasswordRepositoriesImpl(
      remoteAuth: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerFactory(() => AuthenticationCubit(getIt()));
  getIt.registerFactory(() => ApplicationCubit());
}
