import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/services/data/data_source/workshops_remote_data_source.dart';
import 'package:untitled1/features/services/data/models/schedule_service_model.dart';
import 'package:untitled1/features/services/data/models/workshop_availability_model.dart';

abstract class ScheduleServiceRepository {
  Future<Either<Failure, ScheduleServiceModel>> getScheduleService({
    required String serviceId,
    int? businessId,
    String? title,
    String? subtitle,
  });
}

class ScheduleServiceRepositoryImpl implements ScheduleServiceRepository {
  final WorkshopsRemoteDataSource workshopsRemote;
  final NetworkInfo networkInfo;

  const ScheduleServiceRepositoryImpl({
    required this.workshopsRemote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ScheduleServiceModel>> getScheduleService({
    required String serviceId,
    int? businessId,
    String? title,
    String? subtitle,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }

    WorkshopAvailabilityModel? availability;
    if (businessId != null) {
      try {
        availability = await workshopsRemote.getWorkshopAvailability(businessId);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }

    final now = DateTime.now();
    return Right(
      ScheduleServiceModel(
        serviceId: serviceId,
        title: title ?? 'Service Booking',
        subtitle: subtitle ?? 'Choose your preferred date and time',
        heroColorValue: 0xFF1A3A5C,
        appointmentSummaryTitle: title ?? 'Service Visit',
        availability: availability,
        calendarYear: now.year,
        calendarMonth: now.month,
      ),
    );
  }
}
