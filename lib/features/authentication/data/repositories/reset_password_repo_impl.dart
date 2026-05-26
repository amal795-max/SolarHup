import 'package:dartz/dartz.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failures.dart';
import '../../../../core/constants/user-parameters.dart';
import '../../../../core/network/check_internet.dart';
import '../data-source/authentication/reset_password_remote_data_source.dart';

abstract class ResetPasswordRepositories{
  Future<Either<Failure,Unit>>checkEmail(String email);
}

class ResetPasswordRepositoriesImpl implements ResetPasswordRepositories {
  final ResetPasswordRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ResetPasswordRepositoriesImpl({
    required this.networkInfo,
    required this.remote,
  });

  Future<Either<Failure, Unit>> _handle(Future<void> Function() fn) async {
    if (await networkInfo.isConnected) {
      print('');
      try {
        await fn();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> checkEmail(String email) async {
    return _handle(() => remote.checkEmail(email));
  }

  @override
  Future<Either<Failure, Unit>> verifyCode({required VerifyCodeParams params}) async {
    return _handle(() => remote.verifyCode(params));
  }


}
