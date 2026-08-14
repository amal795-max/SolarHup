import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/consultation/data/models/expert_consultation_model.dart';

abstract class ExpertConsultationRemoteDataSource {
  Future<ExpertConsultationModel> sendQuestion(String question);
  Future<List<ExpertConsultationModel>> getMyQuestions();
}

class ExpertConsultationRemoteDataSourceImpl
    implements ExpertConsultationRemoteDataSource {
  final ApiRequest apiRequest;

  ExpertConsultationRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<ExpertConsultationModel> sendQuestion(String question) async {
    try {
      final response = await apiRequest.post(
        EndPoints.expertConsultations,
        body: {'question': question},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }

      return ExpertConsultationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<ExpertConsultationModel>> getMyQuestions() async {
    try {
      final response = await apiRequest.get(EndPoints.myExpertConsultations);

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }

      final List data = response.data['questions'] ?? [];
      return data.map((e) => ExpertConsultationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
