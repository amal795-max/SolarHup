
import 'package:dartz/dartz.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kitch_plus/features/authentication/data/model/login_model/login_model.dart';

import '../../../../core/constants/user-parameters.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/functions/network_info.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../data-source/authentication/auth_local_data_source.dart';
import '../data-source/authentication/auth_remote_data_source.dart';
import '../model/register_Model/register_model.dart';

class AuthRepositoriesImpl implements AuthRepositories{
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoriesImpl({required this.authRemoteDataSource, required this.authLocalDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, RegisterModel>> register({required RegisterParams params}) async{
    if(await networkInfo.isConnected){
      try{
        final remoteRegister = await authRemoteDataSource.register(params);
        return Right(remoteRegister);

      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    else {
      return Left(OfflineFailure());
    }}

  @override
  Future<Either<Failure, LoginModel>> login({required LoginParams params}) async{
  if(await networkInfo.isConnected){
    try{
     final remoteLogin =await authRemoteDataSource.login(params);
     authLocalDataSource.cacheUser(remoteLogin);
     return Right(remoteLogin);
    }
    on ServerException catch (e) {
      return Left(ServerFailure(e.message));

    }
  }
  else{
    return Left(OfflineFailure());
  }
  }

  @override
  Future<Either<Failure, Unit>> logout() async{
    if(await networkInfo.isConnected){
      try{
        final remoteLogout =await authRemoteDataSource.logout();
        return Right(unit);
      }
      on ServerException catch (e) {
        return Left(ServerFailure(e.message));

      }
    }
    else{
      return Left(OfflineFailure());
    }

  }}
