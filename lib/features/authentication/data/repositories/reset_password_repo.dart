import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/network/check_internet.dart';
import '../data-source/reset_password/reset_password_remote_data_source.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, Unit>> setNewPassword(ResetPasswordParams body);

  Future<Either<Failure, Unit>> changePassword(ChangePasswordParams body);
  Future<Either<Failure, Unit>> otpVerification(OtpParams body);
  Future<Either<Failure, Unit>> confirmOtp(ConfirmOtpParams body);
}

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ResetPasswordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> setNewPassword(ResetPasswordParams body)
    => _handleRequest(() => remoteDataSource.setNewPassword(body));


  @override
  Future<Either<Failure, Unit>> changePassword(ChangePasswordParams body)
  => _handleRequest(() => remoteDataSource.changePassword(body));


  Future<Either<Failure, Unit>> _handleRequest(Future<Unit> Function() request) async {
    if (await networkInfo.isConnected) {
      try {
        await request();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
  @override
  Future<Either<Failure, Unit>> otpVerification(OtpParams body) async{
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.otpVerification(body);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmOtp(ConfirmOtpParams body) async{
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.confirmOtp(body);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}

