import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/consultation/data/data_source/consultation_remote_data_source.dart';
import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';

abstract class ConsultationRepository {
  Future<Either<Failure, ConsultationBookingModel>> getBookingData({
    int weekOffset = 0,
  });
}

class ConsultationRepositoryImpl implements ConsultationRepository {
  final ConsultationRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const ConsultationRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, ConsultationBookingModel>> getBookingData({
    int weekOffset = 0,
  }) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getBookingData(weekOffset: weekOffset);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
