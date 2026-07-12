import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/stores/data/data_source/stores_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';

abstract class StoresRepository {
  Future<Either<Failure, List<StoreModel>>> getStores();
}

class StoresRepositoryImpl implements StoresRepository {
  final StoresRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const StoresRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, List<StoreModel>>> getStores() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return const Left(OfflineFailure());
    }
    try {
      final stores = await remote.getStores();
      return Right(stores);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
