import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:untitled1/features/settings/data/models/privacy_policy_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, PrivacyPolicyModel>> getPrivacyPolicy();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PrivacyPolicyModel>> getPrivacyPolicy() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPrivacyPolicy();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
