import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/complaints/data/data_sources/complaint_remote_data_source.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, List<ComplaintModel>>> getMyComplaints();
  Future<Either<Failure, ComplaintModel>> getComplaintDetails(int id);
  Future<Either<Failure, ComplaintModel>> createComplaint({
    required int businessId,
    required String subject,
    required String message,
  });
  Future<Either<Failure, ComplaintMessageModel>> sendMessage({
    required int complaintId,
    required String message,
  });
}

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ComplaintRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ComplaintModel>>> getMyComplaints() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getMyComplaints();
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ComplaintModel>> getComplaintDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getComplaintDetails(id);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ComplaintModel>> createComplaint({
    required int businessId,
    required String subject,
    required String message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.createComplaint(
          businessId: businessId,
          subject: subject,
          message: message,
        );
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ComplaintMessageModel>> sendMessage({
    required int complaintId,
    required String message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.sendMessage(
          complaintId: complaintId,
          message: message,
        );
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
