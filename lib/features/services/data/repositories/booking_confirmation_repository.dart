import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/booking_confirmation_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';

abstract class BookingConfirmationRepository {
  Future<Either<Failure, BookingConfirmationModel>> getBookingConfirmation(
    String serviceId,
  );
  Future<Either<Failure, void>> downloadReceipt(String bookingId);
}

class BookingConfirmationRepositoryImpl implements BookingConfirmationRepository {
  final BookingConfirmationRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final bool useNetworkCheck;

  const BookingConfirmationRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    this.useNetworkCheck = false,
  });

  @override
  Future<Either<Failure, BookingConfirmationModel>> getBookingConfirmation(
    String serviceId,
  ) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      final data = await remote.getBookingConfirmation(serviceId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> downloadReceipt(String bookingId) async {
    if (useNetworkCheck) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) return Left(OfflineFailure());
    }
    try {
      await remote.downloadReceipt(bookingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
