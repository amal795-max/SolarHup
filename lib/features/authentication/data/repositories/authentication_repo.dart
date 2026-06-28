import 'package:dartz/dartz.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/network/check_internet.dart';
import '../data-source/authentication/authentication_remote_data_source.dart';

abstract class ResetPasswordRepositories{
  Future<Either<Failure,bool>>checkPhoneNumber(String phoneNumber);
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
      print('');
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


}
