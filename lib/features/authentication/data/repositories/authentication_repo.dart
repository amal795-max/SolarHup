import 'package:dartz/dartz.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/features/authentication/data/model/register_model.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/network/check_internet.dart';
import '../data-source/authentication/authentication_remote_data_source.dart';
import '../model/login_model.dart';

abstract class AuthenticationRepositories {
  Future<Either<Failure, bool>> checkPhoneNumber(String phoneNumber);

  Future<Either<Failure, RegisterModel>> register(RegisterParams body);

  Future<Either<Failure, LoginModel>> login(LoginParams body);
}

class AuthenticationRepositoriesImpl implements AuthenticationRepositories {
  final AuthenticationRemoteDataSource remoteAuth;
  final NetworkInfo networkInfo;

  AuthenticationRepositoriesImpl({
    required this.networkInfo,
    required this.remoteAuth,
  });

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteAuth.checkPhoneNumber(phoneNumber);
        LocalStorage().saveData(key: ApiKeys.phoneNumber, value: phoneNumber);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> register(RegisterParams body) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteAuth.register(body);
        LocalStorage().saveData(key: ApiKeys.token, value: response.accessToken,);
        LocalStorage().saveData(key: ApiKeys.securityCode, value: response.securityCode,);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, LoginModel>> login(LoginParams body) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteAuth.login(body);
        LocalStorage().saveData(key: ApiKeys.token, value: response.accessToken,);
        LocalStorage().saveData(key: ApiKeys.userIsLogin, value: true);
        if (response.securityCode != null) {
          LocalStorage().saveData(key: ApiKeys.securityCode, value: response.securityCode,);
        }
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }


}
