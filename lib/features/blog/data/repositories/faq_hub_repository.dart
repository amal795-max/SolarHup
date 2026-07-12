import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/blog/data/data_source/faq_hub_remote_data_source.dart';
import 'package:untitled1/features/blog/data/models/faq_hub_model.dart';

abstract class FaqHubRepository {
  Future<Either<Failure, FaqHubModel>> getFaqHub();
}

class FaqHubRepositoryImpl implements FaqHubRepository {
  final FaqHubRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const FaqHubRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, FaqHubModel>> getFaqHub() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Left(OfflineFailure());
    }
    try {
      final data = await remote.getFaqHub();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
