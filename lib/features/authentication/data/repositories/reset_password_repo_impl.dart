import 'package:dartz/dartz.dart';
import 'package:kitch_plus/core/constants/user-parameters.dart';
import 'package:kitch_plus/core/errors/exceptions.dart';
import 'package:kitch_plus/core/errors/failures.dart';
import 'package:kitch_plus/core/functions/network_info.dart';
import 'package:kitch_plus/features/authentication/data/data-source/authentication/reset_password_remote_data_source.dart';
import 'package:kitch_plus/features/authentication/domain/repositories/reset-password-repositories.dart';

class ResetPasswordRepositoriesImpl implements ResetPasswordRepositories{
  final ResetPasswordRemoteDataSource resetPasswordRemoteDataSource;
  final NetworkInfo networkInfo;

  ResetPasswordRepositoriesImpl( {required this.networkInfo, required this.resetPasswordRemoteDataSource,});
  @override
  Future<Either<Failure, Unit>> checkEmail(String email) async{
    if(await networkInfo.isConnected){
      try {
     await resetPasswordRemoteDataSource.checkEmail(email);
        return Right(unit);
      }
          on ServerException catch(e){
          return Left(ServerFailure(e.message));
          }
    }
    else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({required UpdatePasswordParams params}) async{
    if(await networkInfo.isConnected){
      try {
         await resetPasswordRemoteDataSource.updatePassword(params);
        return Right(unit);
      }
      on ServerException catch(e){
        return Left(ServerFailure(e.message));
      }
    }
    else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyCode({required VerifyCodeParams params}) async{
    if(await networkInfo.isConnected){
      try {
         await resetPasswordRemoteDataSource.verifyCode(params);
        return Right(unit);
      }
      on ServerException catch(e){
        return Left(ServerFailure(e.message));
      }
    }
    else{
      return Left(OfflineFailure());
    }
  }
  }

