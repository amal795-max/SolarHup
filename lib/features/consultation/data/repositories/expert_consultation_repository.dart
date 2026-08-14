import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/consultation/data/data_source/expert_consultation_remote_data_source.dart';
import 'package:untitled1/features/consultation/data/models/expert_consultation_model.dart';

abstract class ExpertConsultationRepository {
  Future<Either<Failure, ExpertConsultationModel>> sendQuestion(String question);
  Future<Either<Failure, List<ExpertConsultationModel>>> getMyQuestions();
}

class ExpertConsultationRepositoryImpl implements ExpertConsultationRepository {
  final ExpertConsultationRemoteDataSource remote;
  final NetworkInfo networkInfo;

  ExpertConsultationRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ExpertConsultationModel>> sendQuestion(String question) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.sendQuestion(question);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExpertConsultationModel>>> getMyQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remote.getMyQuestions();
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
