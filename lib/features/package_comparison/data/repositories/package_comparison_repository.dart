import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/package_comparison/data/data_source/package_comparison_remote_data_source.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';

abstract class PackageComparisonRepository {
  Future<Either<Failure, PackageComparisonModel>> getPackageComparison();
  Future<Either<Failure, void>> addPackageToCart(String packageId);
}

class PackageComparisonRepositoryImpl implements PackageComparisonRepository {
  final PackageComparisonRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const PackageComparisonRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, PackageComparisonModel>> getPackageComparison() async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getPackageComparison();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPackageToCart(String packageId) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
