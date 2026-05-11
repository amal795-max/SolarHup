import 'package:dartz/dartz.dart';
import 'package:kitch_plus/core/errors/failures.dart';
import 'package:kitch_plus/features/authentication/data/data-source/settings/settings_remote_data_source.dart';
import 'package:kitch_plus/features/authentication/data/model/PrivacyPolicyModel.dart';
import 'package:kitch_plus/features/authentication/data/model/TermsOfUseModel.dart';
import 'package:kitch_plus/features/authentication/domain/repositories/settings_repositories.dart';
import '../../../../core/functions/network_info.dart';
import '../../../../core/errors/exceptions.dart';

class SettingsRepositoriesImpl implements SettingsRepositories {
  final TermsAndPrivacyRemoteDataSource termsAndPrivacyRemoteDataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoriesImpl({required this.termsAndPrivacyRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, PrivacyPolicyModel>> privacyPolicy() async{
    if(await networkInfo.isConnected){
      try {
        final privacyPolicy= await termsAndPrivacyRemoteDataSource.privacyPolicy();
        return Right(privacyPolicy);
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
  Future<Either<Failure, TermsOfUseModel>> termsOfUse() async{
    if(await networkInfo.isConnected){
      try {
        final termsOfUse= await termsAndPrivacyRemoteDataSource.termsOfUse();
        return Right(termsOfUse);
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