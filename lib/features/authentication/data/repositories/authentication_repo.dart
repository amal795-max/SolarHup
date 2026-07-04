import 'package:dartz/dartz.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/authentication/data/model/register_model.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/network/check_internet.dart';
import '../data-source/authentication/authentication_remote_data_source.dart';

abstract class ResetPasswordRepositories{
  Future<Either<Failure,bool>>checkPhoneNumber(String phoneNumber);
  Future<Either<Failure,RegisterModel>>register(RegisterParams body);
}

class ResetPasswordRepositoriesImpl implements ResetPasswordRepositories {
  final AuthenticationRemoteDataSource remoteAuth;
  final NetworkInfo networkInfo;

  ResetPasswordRepositoriesImpl({
    required this.networkInfo,
    required this.remoteAuth,
  });

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
      final response =await remoteAuth.checkPhoneNumber(phoneNumber);
        return  Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, RegisterModel>> register(RegisterParams body) async{
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteAuth.register(body);
        return  Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }


}
