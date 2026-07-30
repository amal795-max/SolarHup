import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/stores/data/data_source/stores_remote_data_source.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';

abstract class StoresRepository {
  Future<Either<Failure, List<StoreModel>>> getStores({String? region});
}

class StoresRepositoryImpl implements StoresRepository {
  final StoresRemoteDataSource remote;
  final NetworkInfo networkInfo;

  StoresRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StoreModel>>> getStores({String? region}) async {
    if (await networkInfo.isConnected) {
      try {
        final stores = await remote.getStores(region: region);
        return Right(stores);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
